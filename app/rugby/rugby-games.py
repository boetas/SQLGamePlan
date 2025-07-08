import requests
import pyodbc
import json
from dateutil.parser import parse

API_KEY = 'abf1780c03074ff13a235b48f7f660a2'
API_URL = 'https://v1.rugby.api-sports.io/games'
PARAMS = {
    "league": 76,
    "season": 2023
}
HEADERS = {
    'x-apisports-key': API_KEY
}

# Connect to SQL Server
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost\\bits;DATABASE=SGP;Trusted_Connection=yes;'
)
cursor = conn.cursor()

# Create table if not exists
cursor.execute("""
IF OBJECT_ID('dbo.RugbyGames', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RugbyGames (
        game_id INT PRIMARY KEY,
        game_date DATETIME,
        status NVARCHAR(50),
        home_team NVARCHAR(100),
        away_team NVARCHAR(100),
        home_score INT NULL,
        away_score INT NULL
    )
END
""")
conn.commit()

print("📡 Fetching rugby fixtures from API...")
response = requests.get(API_URL, headers=HEADERS, params=PARAMS)

if response.status_code != 200:
    print(f"❌ API request failed: {response.status_code} {response.text}")
    conn.close()
    exit()

data = response.json()
games = data.get("response", [])

print(f"🏉 Rugby games returned: {len(games)}")

if not games:
    print("⚠️ No data returned in 'response'.")
    conn.close()
    exit()

# Debug: show first game structure
print("\n🔍 Inspecting first item structure:\n")
print(json.dumps(games[0], indent=2))

inserted = 0
skipped = 0

for idx, match in enumerate(games):
    try:
        game_id = match['id']
        game_date = parse(match['date'])  # Parse ISO8601 string to datetime
        status = match.get('status', {}).get('long', 'Unknown')
        home_team = match['teams']['home']['name']
        away_team = match['teams']['away']['name']

        # Scores may be None if not started; allow NULL in DB
        home_score = match['scores']['home']
        away_score = match['scores']['away']

        # Check if game_id exists
        cursor.execute("SELECT 1 FROM dbo.RugbyGames WHERE game_id = ?", game_id)
        if cursor.fetchone() is None:
            cursor.execute("""
                INSERT INTO dbo.RugbyGames (game_id, game_date, status, home_team, away_team, home_score, away_score)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """, game_id, game_date, status, home_team, away_team, home_score, away_score)
            inserted += 1
        else:
            skipped += 1

    except Exception as e:
        print(f"⚠️ Skipping entry at index {idx}: {e}")
        skipped += 1

conn.commit()
conn.close()

print(f"\n✅ Inserted {inserted} new games into SQL Server.")
print(f"⚠️ Skipped {skipped} entries (existing or errors).")
