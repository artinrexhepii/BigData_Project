-- Create the country_data table
CREATE TABLE country_data (
    country VARCHAR(255),
    year INT,
    birth_rate NUMERIC(5,2),
    death_rate NUMERIC(5,2),
    fertility_rate NUMERIC(5,2),
    life_expectancy_female NUMERIC(5,2),
    life_expectancy_male NUMERIC(5,2),
    life_expectancy_total NUMERIC(5,2),
    population_growth NUMERIC(5,2),
    total_population NUMERIC(15,2),
    mobile_subscriptions NUMERIC(15,2),
    mobile_subscriptions_per_100_people NUMERIC(5,2),
    telephone_lines NUMERIC(15,2),
    telephone_lines_per_100_people NUMERIC(5,2),
    agricultural_land NUMERIC(15,2),
    agricultural_land_percent NUMERIC(5,2),
    arable_land NUMERIC(15,2),
    arable_land_percent NUMERIC(5,2),
    land_area NUMERIC(15,2),
    rural_population NUMERIC(15,2),
    rural_population_growth NUMERIC(5,2),
    surface_area NUMERIC(15,2),
    population_density NUMERIC(10,2),
    urban_population_percent NUMERIC(5,2),
    urban_population_growth NUMERIC(5,2)
);


-- Load data into the country_data table from a CSV file
COPY country_data (country, year, birth_rate, death_rate, fertility_rate, life_expectancy_female, life_expectancy_male, life_expectancy_total, population_growth, total_population, mobile_subscriptions, mobile_subscriptions_per_100_people, telephone_lines, telephone_lines_per_100_people, agricultural_land, agricultural_land_percent, arable_land, arable_land_percent, land_area, rural_population, rural_population_growth, surface_area, population_density, urban_population_percent, urban_population_growth)
FROM 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/global_development.csv'
DELIMITER ','
CSV HEADER;


