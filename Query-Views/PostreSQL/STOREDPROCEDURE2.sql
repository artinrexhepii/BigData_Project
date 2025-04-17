CREATE OR REPLACE FUNCTION get_nato_landlocked_countries(
    min_population DECIMAL,
    max_population DECIMAL,
    include_landlocked BOOLEAN,
    include_sea_access BOOLEAN,
    name_filter TEXT
)
RETURNS TABLE (
    Country VARCHAR(50),
    Capital VARCHAR(50),
    Population DECIMAL
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        co.Name,
        co.Capital,
        co.Population
    FROM 
        country co
    JOIN isMember m ON co.Code = m.Country
    LEFT JOIN geo_sea gs ON gs.Country = co.Code
    WHERE 
        m.Organization = 'NATO'
        AND co.Population BETWEEN min_population AND max_population
        AND (
            (include_landlocked AND gs.Country IS NULL) OR
            (include_sea_access AND gs.Country IS NOT NULL) OR
            (NOT include_landlocked AND NOT include_sea_access)
        )
        AND (
            name_filter IS NULL OR
            co.Name ILIKE '%' || name_filter || '%'
        );
END;
$$ LANGUAGE plpgsql;





-- Landlocked NATO countries with pop between 1M–50M and name contains "land"
SELECT * FROM get_nato_landlocked_countries(1000000, 50000000, TRUE, FALSE, 'land');

-- All NATO countries (ignore sea/landlocked), between 10M and 100M pop
SELECT * FROM get_nato_landlocked_countries(10000000, 100000000, FALSE, FALSE, NULL);

-- NATO countries with sea access only, name containing "a"
SELECT * FROM get_nato_landlocked_countries(0, 1000000000, FALSE, TRUE, 'a');
