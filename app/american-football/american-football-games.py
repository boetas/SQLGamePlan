import requests
import pyodbc
import json

# Set your API key and endpoint
api_key = 'abf1780c03074ff13a235b48f7f660a2'
url = 'https://v1.american-football.api-sports.io/games?league=1&season=2023'

# Set headers
headers = {
    'x-apisports-key': api_key
}

# Make the API request
response = requests.get(url, headers=headers)
data = response.json()['response']

# Connect to SQL Server
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost\\bits;'
    'DATABASE=SGP;'
    'Trusted_Connection=yes;'
)

cursor = conn.cursor()

# Create table (optional — run once)
cursor.execute('''
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AmericanFootballGames' AND xtype='U')
CREATE TABLE AmericanFootballGames (
    GameID INT PRIMARY KEY,
    GameDate DATETIME,
    Status NVARCHAR(50),
    HomeTeam NVARCHAR(100),
    AwayTeam NVARCHAR(100),
    HomeScore INT,
    AwayScore INT
)
''')
conn.commit()


print(f"American Football Games returned: {len(data)}")

# Insert data
def extract_total_score(score_data):
    if isinstance(score_data, dict):
        return score_data.get('total') or 0
    return 0

for game in data:
    try:
        game_id = game['game']['id']
        game_date = game['game']['date']['date'] + ' ' + game['game']['date']['time']
        status = game['game']['status']['long']
        home_team = game['teams']['home']['name']
        away_team = game['teams']['away']['name']
        home_score = extract_total_score(game['scores'].get('home'))
        away_score = extract_total_score(game['scores'].get('away'))

        cursor.execute('''
            MERGE INTO AmericanFootballGames AS target
            USING (SELECT ? AS GameID) AS source
            ON target.GameID = source.GameID
            WHEN MATCHED THEN
                UPDATE SET GameDate = ?, Status = ?, HomeTeam = ?, AwayTeam = ?, HomeScore = ?, AwayScore = ?
            WHEN NOT MATCHED THEN
                INSERT (GameID, GameDate, Status, HomeTeam, AwayTeam, HomeScore, AwayScore)
                VALUES (?, ?, ?, ?, ?, ?, ?);
        ''', game_id, game_date, status, home_team, away_team, home_score, away_score,
             game_id, game_date, status, home_team, away_team, home_score, away_score)

    except Exception as e:
        print(f"❌ Error inserting game ID {game_id}: {e}")


conn.commit()
cursor.close()
conn.close()

print("✅ Game data loaded into SQL Server.")
