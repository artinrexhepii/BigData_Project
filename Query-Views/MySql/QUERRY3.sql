SELECT 
    co.Name AS Country,
    m.Name AS Mountain,
    m.Height AS Height,
    gm.Province AS Province
FROM 
    country co
JOIN 
    encompasses e ON co.Code = e.Country
JOIN 
    geo_mountain gm ON gm.Country = co.Code
JOIN 
    mountain m ON m.Name = gm.Mountain
WHERE 
    e.Continent = 'America'
    AND m.Height = (
        SELECT MAX(m2.Height)
        FROM geo_mountain gm2
        JOIN mountain m2 ON m2.Name = gm2.Mountain
        WHERE gm2.Country = co.Code
    );
    
CREATE VIEW American_Countries_Highest_Mountains AS
SELECT 
    co.Name AS Country,
    m.Name AS Mountain,
    m.Height AS Height,
    gm.Province AS Province
FROM 
    country co
JOIN 
    encompasses e ON co.Code = e.Country
JOIN 
    geo_mountain gm ON gm.Country = co.Code
JOIN 
    mountain m ON m.Name = gm.Mountain
WHERE 
    e.Continent = 'America'
    AND m.Height = (
        SELECT MAX(m2.Height)
        FROM geo_mountain gm2
        JOIN mountain m2 ON m2.Name = gm2.Mountain
        WHERE gm2.Country = co.Code
    );

SELECT * FROM American_Countries_Highest_Mountains;
