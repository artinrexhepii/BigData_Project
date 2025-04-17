WITH HighestMountains AS (
    SELECT 
        gm.Country,
        m.Name AS Mountain,
        m.Elevation,
        RANK() OVER (PARTITION BY gm.Country ORDER BY m.Elevation DESC) AS rank
    FROM 
        geo_mountain gm
    JOIN mountain m ON m.Name = gm.Mountain
)

SELECT 
    c.Name AS Country,
    c.Capital AS CapitalCity,
    hm.Mountain,
    hm.Elevation
FROM 
    HighestMountains hm
JOIN country c ON c.Code = hm.Country
JOIN encompasses e ON e.Country = c.Code
WHERE 
    e.Continent IN ('North America', 'South America')
    AND hm.rank = 1;


CREATE VIEW Highest_Mountains_Americas AS
WITH HighestMountains AS (
    SELECT 
        gm.Country,
        m.Name AS Mountain,
        m.Elevation,
        RANK() OVER (PARTITION BY gm.Country ORDER BY m.Elevation DESC) AS rank
    FROM 
        geo_mountain gm
    JOIN mountain m ON m.Name = gm.Mountain
)

SELECT 
    c.Name AS Country,
    c.Capital AS CapitalCity,
    hm.Mountain,
    hm.Elevation
FROM 
    HighestMountains hm
JOIN country c ON c.Code = hm.Country
JOIN encompasses e ON e.Country = c.Code
WHERE 
    e.Continent IN ('North America', 'South America')
    AND hm.rank = 1;

SELECT * FROM Highest_Mountains_Americas;

