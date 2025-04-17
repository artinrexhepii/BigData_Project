CREATE OR REPLACE VIEW country_life_expectancy_nato_view AS
SELECT 
    cd.country,
    calculate_life_expectancy_average(cd.country, 1980, 2020) AS avg_life_expectancy,
    AVG(cd.total_population) AS avg_population,
    AVG(cd.surface_area) AS avg_surface_area
FROM 
    country_data cd
JOIN 
    country c ON cd.country = c.Name
JOIN 
    isMember im ON c.Code = im.Country
JOIN 
    organization o ON im.Organization = o.Abbreviation
WHERE 
    o.Name = 'North Atlantic Treaty Organization'
GROUP BY
    cd.country
ORDER BY
    avg_life_expectancy DESC;


SELECT * FROM country_life_expectancy_nato_view;

