-- krijon databazen ne baze te kerkesave
CREATE DATABASE BigData_Datasets;
USE BigData_Datasets;

-- krijon tabelen country_data per te ruajtur te dhenat nga CSV
CREATE TABLE country_data (
    country VARCHAR(255),
    year INT,
    birth_rate DECIMAL(5,2),
    death_rate DECIMAL(5,2),
    fertility_rate DECIMAL(5,2),
    life_expectancy_female DECIMAL(5,2),
    life_expectancy_male DECIMAL(5,2),
    life_expectancy_total DECIMAL(5,2),
    population_growth DECIMAL(5,2),
    total_population DECIMAL(15,2),
    mobile_subscriptions DECIMAL(15,2),
    mobile_subscriptions_per_100_people DECIMAL(5,2),
    telephone_lines DECIMAL(15,2),
    telephone_lines_per_100_people DECIMAL(5,2),
    agricultural_land DECIMAL(15,2),
    agricultural_land_percent DECIMAL(5,2),
    arable_land DECIMAL(15,2),
    arable_land_percent DECIMAL(5,2),
    land_area DECIMAL(15,2),
    rural_population DECIMAL(15,2),
    rural_population_growth DECIMAL(5,2),
    surface_area DECIMAL(15,2),
    population_density DECIMAL(10,2),
    urban_population_percent DECIMAL(5,2),
    urban_population_growth DECIMAL(5,2)
);

-- ngarkon te dhenat nga CSV ne tabelen country_data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/global_development.csv'
INTO TABLE country_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(country, year, birth_rate, death_rate, fertility_rate, life_expectancy_female, life_expectancy_male, life_expectancy_total, population_growth, total_population, mobile_subscriptions, mobile_subscriptions_per_100_people, telephone_lines, telephone_lines_per_100_people, agricultural_land, agricultural_land_percent, arable_land, arable_land_percent, land_area, rural_population, rural_population_growth, surface_area, population_density, urban_population_percent, urban_population_growth);
