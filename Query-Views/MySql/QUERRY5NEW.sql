-- Lakes shared by at least 2 NATO countries
SELECT 
    'Lake' AS WaterType,
    gl.Lake AS WaterBody,
    c.Name AS Country
FROM (
    SELECT DISTINCT gl.Lake, gl.Country
    FROM geo_lake gl
    JOIN isMember m ON gl.Country = m.Country
    JOIN organization o ON m.Organization = o.Abbreviation
    WHERE o.Name = 'North Atlantic Treaty Organization'
) gl
JOIN (
    SELECT Lake
    FROM geo_lake gl
    JOIN isMember m ON gl.Country = m.Country
    JOIN organization o ON m.Organization = o.Abbreviation
    WHERE o.Name = 'North Atlantic Treaty Organization'
    GROUP BY Lake
    HAVING COUNT(DISTINCT gl.Country) >= 2
) shared_lakes ON gl.Lake = shared_lakes.Lake
JOIN country c ON gl.Country = c.Code

UNION

-- Seas shared by at least 2 NATO countries
SELECT 
    'Sea' AS WaterType,
    gs.Sea AS WaterBody,
    c.Name AS Country
FROM (
    SELECT DISTINCT gs.Sea, gs.Country
    FROM geo_sea gs
    JOIN isMember m ON gs.Country = m.Country
    JOIN organization o ON m.Organization = o.Abbreviation
    WHERE o.Name = 'North Atlantic Treaty Organization'
) gs
JOIN (
    SELECT Sea
    FROM geo_sea gs
    JOIN isMember m ON gs.Country = m.Country
    JOIN organization o ON m.Organization = o.Abbreviation
    WHERE o.Name = 'North Atlantic Treaty Organization'
    GROUP BY Sea
    HAVING COUNT(DISTINCT gs.Country) >= 2
) shared_seas ON gs.Sea = shared_seas.Sea
JOIN country c ON gs.Country = c.Code
ORDER BY WaterType, WaterBody, Country;

CREATE OR REPLACE VIEW NATO_Shared_Lake_Sea_Countries AS

-- Lakes shared by at least 2 NATO countries
SELECT 
    'Lake' AS WaterType,
    gl.Lake AS WaterBody,
    c.Name AS Country
FROM (
    SELECT DISTINCT gl.Lake, gl.Country
    FROM geo_lake gl
    JOIN isMember m ON gl.Country = m.Country
    JOIN organization o ON m.Organization = o.Abbreviation
    WHERE o.Name = 'North Atlantic Treaty Organization'
) gl
JOIN (
    SELECT Lake
    FROM geo_lake gl
    JOIN isMember m ON gl.Country = m.Country
    JOIN organization o ON m.Organization = o.Abbreviation
    WHERE o.Name = 'North Atlantic Treaty Organization'
    GROUP BY Lake
    HAVING COUNT(DISTINCT gl.Country) >= 2
) shared_lakes ON gl.Lake = shared_lakes.Lake
JOIN country c ON gl.Country = c.Code

UNION

-- Seas shared by at least 2 NATO countries
SELECT 
    'Sea' AS WaterType,
    gs.Sea AS WaterBody,
    c.Name AS Country
FROM (
    SELECT DISTINCT gs.Sea, gs.Country
    FROM geo_sea gs
    JOIN isMember m ON gs.Country = m.Country
    JOIN organization o ON m.Organization = o.Abbreviation
    WHERE o.Name = 'North Atlantic Treaty Organization'
) gs
JOIN (
    SELECT Sea
    FROM geo_sea gs
    JOIN isMember m ON gs.Country = m.Country
    JOIN organization o ON m.Organization = o.Abbreviation
    WHERE o.Name = 'North Atlantic Treaty Organization'
    GROUP BY Sea
    HAVING COUNT(DISTINCT gs.Country) >= 2
) shared_seas ON gs.Sea = shared_seas.Sea
JOIN country c ON gs.Country = c.Code;

SELECT * FROM NATO_Shared_Lake_Sea_Countries
ORDER BY WaterType, WaterBody, Country;

SELECT DISTINCT
    c.Name AS Country,
    gl.Lake AS SharedLake,
    gs.Sea AS SharedSea
FROM
    -- Get NATO countries with distinct lake
    (
        SELECT DISTINCT gl.Country, gl.Lake
        FROM geo_lake gl
        JOIN isMember m ON gl.Country = m.Country
        JOIN organization o ON m.Organization = o.Abbreviation
        WHERE o.Name = 'North Atlantic Treaty Organization'
          AND gl.Lake IN (
              SELECT Lake
              FROM geo_lake gl2
              JOIN isMember m2 ON gl2.Country = m2.Country
              JOIN organization o2 ON m2.Organization = o2.Abbreviation
              WHERE o2.Name = 'North Atlantic Treaty Organization'
              GROUP BY Lake
              HAVING COUNT(DISTINCT gl2.Country) >= 2
          )
    ) AS gl
    
JOIN
    -- Get NATO countries with distinct sea
    (
        SELECT DISTINCT gs.Country, gs.Sea
        FROM geo_sea gs
        JOIN isMember m ON gs.Country = m.Country
        JOIN organization o ON m.Organization = o.Abbreviation
        WHERE o.Name = 'North Atlantic Treaty Organization'
          AND gs.Sea IN (
              SELECT Sea
              FROM geo_sea gs2
              JOIN isMember m2 ON gs2.Country = m2.Country
              JOIN organization o2 ON m2.Organization = o2.Abbreviation
              WHERE o2.Name = 'North Atlantic Treaty Organization'
              GROUP BY Sea
              HAVING COUNT(DISTINCT gs2.Country) >= 2
          )
    ) AS gs
    
ON gl.Country = gs.Country

JOIN country c ON gl.Country = c.Code

ORDER BY SharedLake, SharedSea, Country;


CREATE OR REPLACE VIEW NATO_Countries_Shared_Lake_And_Sea AS
SELECT DISTINCT
    c.Name AS Country,
    gl.Lake AS SharedLake,
    gs.Sea AS SharedSea
FROM
    (
        SELECT DISTINCT gl.Country, gl.Lake
        FROM geo_lake gl
        JOIN isMember m ON gl.Country = m.Country
        JOIN organization o ON m.Organization = o.Abbreviation
        WHERE o.Name = 'North Atlantic Treaty Organization'
          AND gl.Lake IN (
              SELECT Lake
              FROM geo_lake gl2
              JOIN isMember m2 ON gl2.Country = m2.Country
              JOIN organization o2 ON m2.Organization = o2.Abbreviation
              WHERE o2.Name = 'North Atlantic Treaty Organization'
              GROUP BY Lake
              HAVING COUNT(DISTINCT gl2.Country) >= 2
          )
    ) AS gl

JOIN
    (
        SELECT DISTINCT gs.Country, gs.Sea
        FROM geo_sea gs
        JOIN isMember m ON gs.Country = m.Country
        JOIN organization o ON m.Organization = o.Abbreviation
        WHERE o.Name = 'North Atlantic Treaty Organization'
          AND gs.Sea IN (
              SELECT Sea
              FROM geo_sea gs2
              JOIN isMember m2 ON gs2.Country = m2.Country
              JOIN organization o2 ON m2.Organization = o2.Abbreviation
              WHERE o2.Name = 'North Atlantic Treaty Organization'
              GROUP BY Sea
              HAVING COUNT(DISTINCT gs2.Country) >= 2
          )
    ) AS gs

ON gl.Country = gs.Country

JOIN country c ON gl.Country = c.Code;

SELECT * FROM NATO_Countries_Shared_Lake_And_Sea
ORDER BY SharedLake, SharedSea, Country;
