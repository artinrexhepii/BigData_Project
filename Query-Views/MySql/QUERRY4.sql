SELECT 
    Name AS Country,
    Capital AS CapitalCity,
    Population
FROM 
    country;

CREATE VIEW All_Countries_Basic_Info AS
SELECT 
    Name AS Country,
    Capital AS CapitalCity,
    Population
FROM 
    country;
    
SELECT * FROM All_Countries_Basic_Info;
