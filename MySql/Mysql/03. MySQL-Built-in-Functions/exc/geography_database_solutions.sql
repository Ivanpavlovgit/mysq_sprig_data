#10.	Countries Holding 'A' 3 or More Times
#Find all countries that hold the letter 'A' in their name at least 3 times (case insensitively), sorted by ISO code. 
#Display the country name and the ISO code. Submit your query statements as Prepare DB & run queries.
SELECT 
    `country_name`, `iso_code`
FROM
    `countries`
WHERE
    `country_name` LIKE '%A%A%A%'
ORDER BY `iso_code`;

#11.	 Mix of Peak and River Names
#Combine all peak names with all river names, so that the last letter of each peak name is the same as the first letter of its corresponding river name. 
#Display the peak name, the river name, and the obtained mix(converted to lower case). 
#Sort the results by the obtained mix alphabetically. 
#Submit your query statements as Prepare DB & run queries.
SELECT * FROM `peaks`;
SELECT * FROM `rivers`;

SELECT 
    `peak_name`,
    `river_name`,
    LOWER(CONCAT(`peak_name`, SUBSTRING(`river_name`, 2))) AS `peak_river_lower`
FROM
    `peaks`,
    `rivers`
WHERE
    RIGHT(`peak_name`, 1) = LEFT(`river_name`, 1)
ORDER BY `peak_river_lower`;