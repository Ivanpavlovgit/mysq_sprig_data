#12.	Highest Peaks in Bulgaria
#Write a query that selects:
#•	country_code	
#	mountain_range
#•	peak_name
#•	elevation
#Filter all peaks in Bulgaria with elevation over 2835. 
#Return all rows sorted by elevation in descending order.

SELECT 
    c.`country_code`,
    m.`mountain_range`,
    p.`peak_name`,
    p.`elevation`
FROM
    `countries` AS c
        JOIN
    `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
        JOIN
    `mountains` AS m ON mc.`mountain_id` = m.`id`
        JOIN
    `peaks` AS p ON p.`mountain_id` = m.`id`
WHERE
    c.`country_code` = 'BG'
        AND p.`elevation` > 2835
GROUP BY m.`mountain_range`
ORDER BY p.`elevation` DESC;

#13.	Count Mountain Ranges
Write a query that selects:
#•	country_code
#•	mountain_range
#Filter the count of the mountain ranges in the United States, Russia and Bulgaria. Sort result by mountain_range count in decreasing order.

SELECT 
    c.`country_code`,
    COUNT(m.`mountain_range`) AS `mountain_range`
FROM
    `countries` AS c
        JOIN
    `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
        JOIN
    `mountains` AS m ON mc.`mountain_id` = m.`id`
WHERE
    c.`country_name` IN ('United States' , 'Russia', 'Bulgaria')
GROUP BY c.`country_code`
ORDER BY `mountain_range` DESC;

#14.	Countries with Rivers
#Write a query that selects:
#•	country_name
#•	river_name
#Find the first 5 countries with or without rivers in Africa. Sort them by country_name in ascending order.

SELECT 
    c.`country_name`, r.`river_name`
FROM
    `countries` AS c
        LEFT JOIN
    `countries_rivers` AS cr ON c.`country_code` = cr.`country_code`
        LEFT JOIN
    `rivers` AS r ON r.`id` = cr.`river_id`
WHERE
    c.`continent_code` = 'AF'
ORDER BY c.`country_name`
LIMIT 5;

#15.	*Continents and Currencies
Write a query that selects:
#•	continent_code
#•	currency_code
#•	currency_usage
#Find all continents and their most used currency. Filter any currency that is used in only one country. Sort the result by continent_code and currency_code.

SELECT 
    `continent_code`,
    `currency_code`,
    COUNT(`country_name`) AS `currency_usage`
FROM
    `countries` AS c
GROUP BY `continent_code` , `currency_code`
HAVING `currency_usage` = (SELECT 
        COUNT(`country_code`) AS `coun`
    FROM
        countries AS c1
    WHERE
        c1.`continent_code` = c.`continent_code`
    GROUP BY `currency_code`
    ORDER BY coun DESC
    LIMIT 1)
    AND currency_usage > 1
ORDER BY c.`continent_code` , c.`currency_code`;

#16 Countries Without Any Mountains
#Find the count of all countries which dont have a mountain.

SELECT COUNT(country_name) AS country_count FROM countries
WHERE country_code NOT IN (SELECT country_code FROM mountains_countries);



#17Highest Peak and Longest River by Country
#For each country, find the elevation of the highest peak and the length of the longest river, sorted by the highest peak_elevation (from highest to lowest), then by the longest river_length (from longest to smallest), then by country_name (alphabetically). Display NULL when no data is available in some of the columns. Limit only the first 5 rows.

SELECT 
    c.`country_name`,
    MAX(p.`elevation`) AS `m_elevation`,
    MAX(r.`length`) AS `m_length`
FROM
    `countries` AS c
        JOIN
    `countries_rivers` AS cr ON cr.`country_code` = c.`country_code`
        JOIN
    `rivers` AS r ON r.`id` = cr.`river_id`
        JOIN
    `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
        JOIN
    `mountains` AS m ON mc.`mountain_id` = m.`id`
        JOIN
    `peaks` AS p ON p.`mountain_id` = m.`id`
GROUP BY c.`country_code`
ORDER BY `m_elevation` DESC , `m_length` DESC , c.`country_name`
LIMIT 5;