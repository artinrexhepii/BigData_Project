SELECT DISTINCT
    c1.Name AS Country1,
    c2.Name AS Country2,
    gs1.Sea AS SharedSea,
    gl1.Lake AS SharedLake
FROM 
    isMember m1
JOIN 
    isMember m2 ON m1.Organization = m2.Organization AND m1.Organization = 'NATO' AND m1.Country < m2.Country
JOIN 
    country c1 ON c1.Code = m1.Country
JOIN 
    country c2 ON c2.Code = m2.Country
JOIN 
    geo_sea gs1 ON gs1.Country = c1.Code
JOIN 
    geo_sea gs2 ON gs2.Country = c2.Code AND gs1.Sea = gs2.Sea
JOIN 
    geo_lake gl1 ON gl1.Country = c1.Code
JOIN 
    geo_lake gl2 ON gl2.Country = c2.Code AND gl1.Lake = gl2.Lake;

CREATE VIEW NATO_Countries_Sharing_Sea_And_Lake AS
SELECT DISTINCT
    c1.Name AS Country1,
    c2.Name AS Country2,
    gs1.Sea AS SharedSea,
    gl1.Lake AS SharedLake
FROM 
    isMember m1
JOIN 
    isMember m2 ON m1.Organization = m2.Organization AND m1.Organization = 'NATO' AND m1.Country < m2.Country
JOIN 
    country c1 ON c1.Code = m1.Country
JOIN 
    country c2 ON c2.Code = m2.Country
JOIN 
    geo_sea gs1 ON gs1.Country = c1.Code
JOIN 
    geo_sea gs2 ON gs2.Country = c2.Code AND gs1.Sea = gs2.Sea
JOIN 
    geo_lake gl1 ON gl1.Country = c1.Code
JOIN 
    geo_lake gl2 ON gl2.Country = c2.Code AND gl1.Lake = gl2.Lake;

SELECT * FROM NATO_Countries_Sharing_Sea_And_Lake;

    
SELECT DISTINCT
    c1.Name AS Country1,
    c2.Name AS Country2,
    COALESCE(gs1.Sea, 'N/A') AS SharedSea,
    COALESCE(gl1.Lake, 'N/A') AS SharedLake
FROM 
    isMember m1
JOIN 
    isMember m2 ON m1.Organization = 'NATO' AND m2.Organization = 'NATO' AND m1.Country < m2.Country
JOIN 
    country c1 ON c1.Code = m1.Country
JOIN 
    country c2 ON c2.Code = m2.Country
LEFT JOIN 
    geo_sea gs1 ON gs1.Country = c1.Code
LEFT JOIN 
    geo_sea gs2 ON gs2.Country = c2.Code AND gs1.Sea = gs2.Sea
LEFT JOIN 
    geo_lake gl1 ON gl1.Country = c1.Code
LEFT JOIN 
    geo_lake gl2 ON gl2.Country = c2.Code AND gl1.Lake = gl2.Lake
WHERE 
    (gs1.Sea IS NOT NULL AND gs2.Sea IS NOT NULL)
    OR (gl1.Lake IS NOT NULL AND gl2.Lake IS NOT NULL);

CREATE VIEW NATO_Countries_Sharing_Sea_Or_Lake AS
SELECT DISTINCT
    c1.Name AS Country1,
    c2.Name AS Country2,
    COALESCE(gs1.Sea, 'N/A') AS SharedSea,
    COALESCE(gl1.Lake, 'N/A') AS SharedLake
FROM 
    isMember m1
JOIN 
    isMember m2 ON m1.Organization = 'NATO' AND m2.Organization = 'NATO' AND m1.Country < m2.Country
JOIN 
    country c1 ON c1.Code = m1.Country
JOIN 
    country c2 ON c2.Code = m2.Country
LEFT JOIN 
    geo_sea gs1 ON gs1.Country = c1.Code
LEFT JOIN 
    geo_sea gs2 ON gs2.Country = c2.Code AND gs1.Sea = gs2.Sea
LEFT JOIN 
    geo_lake gl1 ON gl1.Country = c1.Code
LEFT JOIN 
    geo_lake gl2 ON gl2.Country = c2.Code AND gl1.Lake = gl2.Lake
WHERE 
    (gs1.Sea IS NOT NULL AND gs2.Sea IS NOT NULL)
    OR (gl1.Lake IS NOT NULL AND gl2.Lake IS NOT NULL);

SELECT * FROM NATO_Countries_Sharing_Sea_Or_Lake;