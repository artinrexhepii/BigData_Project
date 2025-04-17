import mysql.connector
from datetime import datetime
import os

# Get script directory for relative paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(os.path.dirname(SCRIPT_DIR))  # Up two levels from scripts/

# CONFIG
config = {
    "host": "localhost",
    "user": "root",
    "password": "root1234",
    "database_mondial": "Mondial",
    "database_dwh": "DWH_Mondial",
    "log_file": os.path.join(PROJECT_ROOT, "logs", "etl_log.txt")
}

# Create logs directory if it doesn't exist
os.makedirs(os.path.dirname(config["log_file"]), exist_ok=True)

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

# Helper for logging
def log_message(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_entry = f"[{timestamp}] {message}"
    print(log_entry)
    with open(config["log_file"], "a") as f:
        f.write(log_entry + "\n")

# Step 1: Sync Country → Dim_Country
log_message("Starting ETL process")
use_db(config["database_dwh"])
cursor.execute("""
INSERT IGNORE INTO Dim_Country (CountryCode, CountryName, Government)
SELECT c.Code, c.Name, p.Government
FROM Mondial.country c
LEFT JOIN Mondial.politics p ON c.Code = p.Country;
""")
log_message(f"Synced Country data - {cursor.rowcount} rows affected")

# Step 2: Sync Organization → Dim_Organization
cursor.execute("""
INSERT IGNORE INTO Dim_Organization (OrgCode, OrgName, City, CountryCode)
SELECT Abbreviation, Name, City, Country
FROM Mondial.organization
WHERE Country IS NOT NULL;
""")
log_message(f"Synced Organization data - {cursor.rowcount} rows affected")

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
log_message(f"Synced Independence dates - {cursor.rowcount} rows affected")

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
log_message(f"Synced Organization dates - {cursor.rowcount} rows affected")

# Step 5: Insert into Fact Table - Independence Events
cursor.execute("""
INSERT IGNORE INTO Facts_GeopoliticalEvents (CountryCode, DateID, EventType)
SELECT p.Country, p.Independence, 'Independence'
FROM Mondial.politics p
WHERE p.Independence IS NOT NULL;
""")
log_message(f"Added Independence events - {cursor.rowcount} rows affected")

# Step 6: Insert into Fact Table - Organization Founded
cursor.execute("""
INSERT IGNORE INTO Facts_GeopoliticalEvents (OrgCode, CountryCode, DateID, EventType)
SELECT o.Abbreviation, o.Country, o.Established, 'Organization Founded'
FROM Mondial.organization o
WHERE o.Established IS NOT NULL AND o.Country IS NOT NULL;
""")
log_message(f"Added Organization events - {cursor.rowcount} rows affected")

conn.commit()
cursor.close()
conn.close()

log_message("ETL run completed successfully.")