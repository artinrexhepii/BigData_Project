DELIMITER //

CREATE PROCEDURE SearchAmericanMountains (
    IN minHeight INT,
    IN countryName VARCHAR(100),
    IN provinceName VARCHAR(100),
    IN partialMatch BOOLEAN
)
BEGIN
    SELECT 
        Country,
        Mountain,
        Height,
        Province
    FROM 
        American_Countries_Highest_Mountains
    WHERE 
        Height >= minHeight
        AND (
            (partialMatch = TRUE AND Country LIKE CONCAT('%', countryName, '%'))
            OR
            (partialMatch = FALSE AND Country = countryName)
            OR
            countryName = ''  -- If left empty, ignore filter
        )
        AND (
            (partialMatch = TRUE AND Province LIKE CONCAT('%', provinceName, '%'))
            OR
            (partialMatch = FALSE AND Province = provinceName)
            OR
            provinceName = ''  -- If left empty, ignore filter
        );
END //

DELIMITER ;


-- All mountains over 5000m regardless of country/province
CALL SearchAmericanMountains(5000, '', '', FALSE);

-- All mountains over 4000m in any province that contains "Andes"
CALL SearchAmericanMountains(4000, '', 'Andes', TRUE);

-- All mountains over 6000m in Argentina and province "Cuyo"
CALL SearchAmericanMountains(6000, 'Argentina', 'Cuyo', FALSE);
