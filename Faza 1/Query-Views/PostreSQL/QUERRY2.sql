SELECT 
    co.Name AS Country,
    co.Capital,
    co.Population
FROM 
    country co
JOIN 
    isMember m ON co.Code = m.Country
WHERE 
    m.Organization = 'NATO'
    AND co.Population >= 1000000
    AND co.Code NOT IN (
        SELECT DISTINCT Country FROM geo_sea
    );

CREATE VIEW NATO_Landlocked_MillionPlus AS
SELECT 
    co.Name AS Country,
    co.Capital,
    co.Population
FROM 
    country co
JOIN 
    isMember m ON co.Code = m.Country
WHERE 
    m.Organization = 'NATO'
    AND co.Population >= 1000000
    AND co.Code NOT IN (
        SELECT DISTINCT Country FROM geo_sea
    );

SELECT * FROM NATO_Landlocked_MillionPlus;