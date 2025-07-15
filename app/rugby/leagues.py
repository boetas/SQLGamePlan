import http.client
import json

conn = http.client.HTTPSConnection("v1.rugby.api-sports.io")

headers = {
    'x-apisports-key': "abf1780c03074ff13a235b48f7f660a2"
}

conn.request("GET", "/leagues", headers=headers)
res = conn.getresponse()
data = res.read()

leagues_data = json.loads(data.decode("utf-8"))

for league in leagues_data.get("response", []):
    league_id = league.get("id")
    league_name = league.get("name")
    print(f"ID: {league_id}, Name: {league_name}")
