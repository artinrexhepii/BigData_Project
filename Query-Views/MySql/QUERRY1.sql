
SELECT 
    co.Name AS Country,
    co.Capital AS CapitalCity,
    maxcity.Name AS LargestCity,
    maxcity.Population AS LargestCityPopulation
FROM 
    country co
JOIN 
    isMember m ON co.Code = m.Country
JOIN 
    city maxcity ON maxcity.Country = co.Code
WHERE 
    m.Organization = 'NATO'
    AND maxcity.Population = (
        SELECT MAX(c2.Population)
        FROM city c2
        WHERE c2.Country = co.Code
    );


CREATE VIEW NATO_Largest_Cities AS
SELECT 
    co.Name AS Country,
    co.Capital AS CapitalCity,
    maxcity.Name AS LargestCity,
    maxcity.Population AS LargestCityPopulation
FROM 
    country co
JOIN 
    isMember m ON co.Code = m.Country
JOIN 
    city maxcity ON maxcity.Country = co.Code
WHERE 
    m.Organization = 'NATO'
    AND maxcity.Population = (
        SELECT MAX(c2.Population)
        FROM city c2
        WHERE c2.Country = co.Code
    );

SELECT * FROM NATO_Largest_Cities;