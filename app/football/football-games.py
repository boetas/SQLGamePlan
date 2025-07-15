import requests
import pyodbc
from datetime import datetime

# Set your API key and endpoint
api_key = 'abf1780c03074ff13a235b48f7f660a2'
url = 'https://v3.football.api-sports.io/fixtures?league=39&season=2023'

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
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Games' AND xtype='U')
CREATE TABLE FootballGames (
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

print(f"Football Games returned: {len(data)}")

def parse_api_datetime(dt_str):
    """
    Parses ISO8601 datetime string from API and returns a naive datetime object
    compatible with SQL Server datetime.
    """
    # Handle Zulu 'Z' timezone by replacing with +00:00
    if dt_str.endswith('Z'):
        dt_str = dt_str[:-1] + '+00:00'
    # Parse using fromisoformat (Python 3.7+)
    dt_obj = datetime.fromisoformat(dt_str)
    # Remove timezone info to get naive datetime
    return dt_obj.replace(tzinfo=None)

# Insert or update data
for game in data:
    try:
        game_id = game['fixture']['id']
        game_date = parse_api_datetime(game['fixture']['date'])
        status = game['fixture']['status']['long']
        home_team = game['teams']['home']['name']
        away_team = game['teams']['away']['name']
        home_score = game['goals']['home'] if game['goals']['home'] is not None else 0
        away_score = game['goals']['away'] if game['goals']['away'] is not None else 0

        cursor.execute('''
            MERGE INTO FootballGames AS target
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
        print(f"❌ Error inserting game ID {game.get('fixture', {}).get('id', 'unknown')}: {e}")

conn.commit()
cursor.close()
conn.close()

print("✅ Game data loaded into SQL Server.")
