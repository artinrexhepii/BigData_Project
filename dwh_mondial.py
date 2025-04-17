import mysql.connector
from datetime import datetime

# CONFIG
config = {
    "host": "localhost",
    "user": "root",
    "password": "root1234",
    "database_mondial": "Mondial",
    "database_dwh": "DWH_Mondial"
}

# Connect to MySQL
conn = mysql.connector.connect(
    host=config["host"],
    user=config["user"],
    password=config["password"]
)
cursor = conn.cursor()

# Helper to switch databases
def use_db(db_name):
    cursor.execute(f"USE {db_name}")

# Step 1: Sync Country → Dim_Country
use_db(config["database_dwh"])
cursor.execute("""
INSERT IGNORE INTO Dim_Country (CountryCode, CountryName, Government)
SELECT c.Code, c.Name, p.Government
FROM Mondial.country c
LEFT JOIN Mondial.politics p ON c.Code = p.Country;
""")

# Step 2: Sync Organization → Dim_Organization
cursor.execute("""
INSERT IGNORE INTO Dim_Organization (OrgCode, OrgName, City, CountryCode)
SELECT Abbreviation, Name, City, Country
FROM Mondial.organization
WHERE Country IS NOT NULL;
""")

# Step 3: Sync Dates from Politics (Independence)
cursor.execute("""
INSERT IGNORE INTO Dim_Date (DateID, Year, Month, Day)
SELECT DISTINCT Independence, 
       YEAR(Independence), 
       MONTH(Independence), 
       DAY(Independence)
FROM Mondial.politics
WHERE Independence IS NOT NULL;
""")

# Step 4: Sync Dates from Organization (Established)
cursor.execute("""
INSERT IGNORE INTO Dim_Date (DateID, Year, Month, Day)
SELECT DISTINCT Established,
       YEAR(Established),
       MONTH(Established),
       DAY(Established)
FROM Mondial.organization
WHERE Established IS NOT NULL;
""")

# Step 5: Insert into Fact Table - Independence Events
cursor.execute("""
INSERT IGNORE INTO Facts_GeopoliticalEvents (CountryCode, DateID, EventType)
SELECT p.Country, p.Independence, 'Independence'
FROM Mondial.politics p
WHERE p.Independence IS NOT NULL;
""")

# Step 6: Insert into Fact Table - Organization Founded
cursor.execute("""
INSERT IGNORE INTO Facts_GeopoliticalEvents (OrgCode, CountryCode, DateID, EventType)
SELECT o.Abbreviation, o.Country, o.Established, 'Organization Founded'
FROM Mondial.organization o
WHERE o.Established IS NOT NULL AND o.Country IS NOT NULL;
""")

conn.commit()
cursor.close()
conn.close()

print(f"[{datetime.now()}] ETL run completed successfully.")