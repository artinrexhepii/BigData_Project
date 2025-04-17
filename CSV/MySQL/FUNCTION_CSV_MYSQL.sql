DELIMITER $$

CREATE FUNCTION calculate_life_expectancy_average(
    country_name VARCHAR(100),
    start_year INT,
    end_year INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_life_expectancy DECIMAL(10,2);

    -- Select the average life expectancy into the variable
    SELECT AVG(life_expectancy_total) 
    INTO avg_life_expectancy
    FROM country_data
    WHERE country = country_name
    AND year BETWEEN start_year AND end_year;

    -- Return the average life expectancy
    RETURN avg_life_expectancy;
END $$

DELIMITER ;
