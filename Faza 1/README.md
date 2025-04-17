# Mondial Data Warehouse ETL

This project implements an ETL (Extract, Transform, Load) process that pulls data from the Mondial database into a dimensional data warehouse model.

## Project Structure

The project is organized into the following directory structure:

```
Faza 1/
├── CSV/                          # CSV data and related import scripts
│   ├── global_development.csv    # CSV dataset
│   ├── MySQL/                    # MySQL-specific CSV import scripts
│   └── POSTGRE/                  # PostgreSQL-specific CSV import scripts
├── Data-Warehouse/               # Data warehouse implementation
│   ├── cron/                     # Automation scripts
│   ├── scripts/                  # ETL Python scripts
│   ├── sql/                      # SQL schema definitions
│   └── requirements.txt          # Python dependencies
├── Query-Views/                  # SQL queries and views
│   ├── MySql/                    # MySQL queries
│   └── PostreSQL/                # PostgreSQL queries
├── Dokumentimi Faza 1.docx       # Project documentation
└── README.md                     # This readme file
```

## Project Overview

This ETL pipeline extracts data from the Mondial database (a database containing global geographical and political data) and loads it into a star schema data warehouse with dimension and fact tables. It focuses on geopolitical events such as country independence dates and organization establishments.

## Schema Design

### Dimension Tables

- **Dim_Country**: Contains country information
  - CountryCode (PK)
  - CountryName
  - Government

- **Dim_Organization**: Contains organization information
  - OrgCode (PK)
  - OrgName
  - City
  - CountryCode

- **Dim_Date**: Contains date information
  - DateID (PK)
  - Year
  - Month
  - Day

### Fact Table

- **Facts_GeopoliticalEvents**: Contains facts about geopolitical events
  - EventID (PK)
  - CountryCode (FK)
  - OrgCode (FK)
  - DateID (FK)
  - EventType

## Setup Instructions

### Prerequisites

- Python 3.x
- MySQL Server
- Mondial database imported into MySQL

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/data_warehouse.git
   cd data_warehouse
   ```

2. Create and activate a virtual environment:
   ```
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install the required packages:
   ```
   pip install -r "Faza 1/Data-Warehouse/requirements.txt"
   ```

4. Configure database settings:
   Edit the `config` dictionary in `Faza 1/Data-Warehouse/scripts/dwh_mondial.py` if your database credentials differ.

### Running the ETL

Run the ETL script manually:
```
cd "Faza 1/Data-Warehouse/scripts"
python dwh_mondial.py
```

### Automated Execution (Cron Job)

A script is included to set up a cron job that runs the ETL process every 5 minutes:

1. Make the script executable:
   ```
   chmod +x "Faza 1/Data-Warehouse/cron/setup_cron.sh"
   ```

2. Run the setup script:
   ```
   cd "Faza 1/Data-Warehouse/cron"
   ./setup_cron.sh
   ```

This will:
- Add the ETL job to your crontab
- Set it to run every 5 minutes
- Create a virtual environment if it doesn't exist
- Log output to the `logs/etl_cron.log` file

To view the logs:
```
cat "logs/etl_cron.log"
```

## Files

- `dwh_mondial.py`: Main ETL script that transfers data from Mondial to the data warehouse
- `requirements.txt`: Python dependencies
- `setup_cron.sh`: Script to set up the cron job for automated ETL runs
- `.gitignore`: Specifies files that Git should ignore
- `README.md`: This documentation file

## Notes

- The script uses `INSERT IGNORE` to prevent duplicate entries
- The ETL process will run incrementally, only adding new data
- All output is logged both to the console and to log files