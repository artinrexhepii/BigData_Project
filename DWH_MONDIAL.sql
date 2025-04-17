DROP DATABASE IF EXISTS DWH_Mondial;
CREATE DATABASE DWH_Mondial;
USE DWH_Mondial;

-- Dimension Tables

CREATE TABLE Dim_Country (
    CountryCode VARCHAR(4) PRIMARY KEY,
    CountryName VARCHAR(35),
    Government VARCHAR(120)
);

CREATE TABLE Dim_Organization (
    OrgCode VARCHAR(12) PRIMARY KEY,
    OrgName VARCHAR(80),
    City VARCHAR(35),
    CountryCode VARCHAR(4),
    FOREIGN KEY (CountryCode) REFERENCES Dim_Country(CountryCode)
);

CREATE TABLE Dim_Date (
    DateID DATE PRIMARY KEY,
    Year INT,
    Month INT,
    Day INT
);

-- Fact Table with unique key to prevent duplicates
CREATE TABLE Facts_GeopoliticalEvents (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    CountryCode VARCHAR(4),
    OrgCode VARCHAR(12),
    DateID DATE,
    EventType VARCHAR(50),
    FOREIGN KEY (CountryCode) REFERENCES Dim_Country(CountryCode),
    FOREIGN KEY (OrgCode) REFERENCES Dim_Organization(OrgCode),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID),
    UNIQUE KEY unique_event (CountryCode, OrgCode, DateID, EventType)
);

-- Sync Dimension Tables with upsert

INSERT INTO Dim_Country (CountryCode, CountryName, Government)
SELECT c.Code, c.Name, p.Government
FROM Mondial.country c
LEFT JOIN Mondial.politics p ON c.Code = p.Country
ON DUPLICATE KEY UPDATE
    CountryName = VALUES(CountryName),
    Government = VALUES(Government);

INSERT INTO Dim_Organization (OrgCode, OrgName, City, CountryCode)
SELECT Abbreviation, Name, City, Country
FROM Mondial.organization
WHERE Country IS NOT NULL
ON DUPLICATE KEY UPDATE
    OrgName = VALUES(OrgName),
    City = VALUES(City),
    CountryCode = VALUES(CountryCode);

INSERT INTO Dim_Date (DateID, Year, Month, Day)
SELECT DISTINCT Independence,
       YEAR(Independence),
       MONTH(Independence),
       DAY(Independence)
FROM Mondial.politics
WHERE Independence IS NOT NULL
ON DUPLICATE KEY UPDATE
    Year = VALUES(Year),
    Month = VALUES(Month),
    Day = VALUES(Day);

INSERT INTO Dim_Date (DateID, Year, Month, Day)
SELECT DISTINCT Established,
       YEAR(Established),
       MONTH(Established),
       DAY(Established)
FROM Mondial.organization
WHERE Established IS NOT NULL
ON DUPLICATE KEY UPDATE
    Year = VALUES(Year),
    Month = VALUES(Month),
    Day = VALUES(Day);

-- Sync Fact Table with duplicate protection

INSERT INTO Facts_GeopoliticalEvents (CountryCode, DateID, EventType)
SELECT p.Country, p.Independence, 'Independence'
FROM Mondial.politics p
WHERE p.Independence IS NOT NULL
ON DUPLICATE KEY UPDATE
    EventType = VALUES(EventType);

INSERT INTO Facts_GeopoliticalEvents (OrgCode, CountryCode, DateID, EventType)
SELECT o.Abbreviation, o.Country, o.Established, 'Organization Founded'
FROM Mondial.organization o
WHERE o.Established IS NOT NULL AND o.Country IS NOT NULL
ON DUPLICATE KEY UPDATE
    EventType = VALUES(EventType);

-- Indexes for faster querying

CREATE INDEX idx_date ON Dim_Date(DateID);
CREATE INDEX idx_event_country ON Facts_GeopoliticalEvents(CountryCode);
CREATE INDEX idx_event_org ON Facts_GeopoliticalEvents(OrgCode);