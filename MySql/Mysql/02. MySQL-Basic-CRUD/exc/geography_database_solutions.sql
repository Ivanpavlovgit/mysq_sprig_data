#21.  All Mountain Peaks 
#Display all mountain peaks in alphabetical order.
# Submit your query statements as Prepare DB & run queries. 
SELECT * FROM `peaks`;

#22 Biggest Countries by Population 
#Find the 30 biggest countries by population from Europe. 
#Display the country name and population. Sort the results by population (from biggest to smallest),
# then by country alphabetically. Submit your query statements as Prepare DB & run queries. 
SELECT 
    `country_name`, `population`
FROM
    `countries`
WHERE
    `continent_code` = 'EU'
    ORDER BY `population` DESC LIMIT 10;
    
#23.Countries and Currency (Euro / Not Euro) 
#Find all countries along with information about their currency.
#Display the country name, country code and information about its currency: either "Euro" or "Not Euro".
#Sort the results by country name alphabetically. Submit your query statements as Prepare DB & run queries. 
SELECT 
    `country_name`,
    `country_code`,
    IF(`currency_code` = 'EUR',
        'Euro',
        'Not Euro') AS `currency`
FROM
    `countries`
ORDER BY `country_name`;



