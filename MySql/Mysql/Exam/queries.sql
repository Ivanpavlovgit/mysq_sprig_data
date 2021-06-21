/*
2.	Insert
When drivers are not working and need a taxi to transport them, they will also be registered 
at the database as customers.
You will have to insert records of data into the clients table, based on the drivers table. 
For all drivers with an id between 10 and 20 (both inclusive), insert data in the clients table with the following values:
•	full_name – get first and last name of the driver separated by single space
•	phone_number – set it to start with (088) 9999 and the driver_id multiplied by 2
o	 Example – the phone_number of the driver with id = 10 is (088) 999920
																				*/
INSERT INTO `clients`(`full_name`,`phone_number`)
    SELECT concat_ws(' ',d.`first_name`,d.`last_name`),concat('(088) 9999',d.`id`*2)
FROM
    `drivers` AS d
WHERE
    d.`id` BETWEEN 10 AND 20;        
/*
3.	Update
After many kilometers and over the years, the condition of cars is expected to deteriorate.
Update all cars and set the condition to be 'C'. 
The cars  must have a mileage greater than 800000 (inclusive) or NULL and must be older than 2010(inclusive).
Skip the cars that contain a make value of Mercedes-Benz. They can work for many more years.
																							*/
UPDATE `cars` 
SET 
    `condition` = 'C'
WHERE
    `mileage` >= 800000
        OR `mileage` IS NULL AND `year` < 2010
        AND `make` != 'Mercedes-Benz';
        
/*
4.	Delete
Some of the clients have not used the services of our company recently, so we need to remove them 
from the database.	
Delete all clients from clients table, that do not have any courses and the count of the characters in the full_name is more than 3 characters. 
																																					*/
DELETE FROM `clients` 
WHERE
    NOT EXISTS( SELECT 
        *
    FROM
        `courses`
    
    WHERE
        clients.`id` = courses.`client_id`);
 
   SELECT 
    *
FROM
    courses AS c
		right JOIN
    clients AS cl ON cl.`id` = c.`client_id`
    WHERE c.`id` is null;
    
/*
5.	Cars
Extract the info about all the cars. 
Order the results by car’s id.
Required Columns
•	make
•	model
•	condition
*/
SELECT c.`make`,c.`model`,c.`condition` FROM `cars` AS c ORDER BY c.`id`;

/*

6.	Drivers and Cars
Now, we need a more detailed information about drivers and their cars.
Select all drivers and cars that they drive. 
Extract the driver’s first and last name from the drivers table and the make, the model and the mileage from the cars table. 
Order the result by the mileage in descending order, then by the first name alphabetically. 
Skip all cars that have NULL as a value for the mileage.
Required Columns
•	first_name
•	last_name 
•	make
•	model
•	mileage
*/
SELECT 
    d.`first_name`,
    d.`last_name`,
    c.`make`,
    c.`model`,
    c.`mileage`
FROM
    `drivers` AS d
        JOIN
    `cars_drivers` AS cd ON d.`id` = cd.`driver_id`
        JOIN
    `cars` AS c ON cd.`car_id` = c.`id`
WHERE
    c.`mileage` IS NOT NULL
ORDER BY c.`mileage` DESC,d.`first_name`;

/*
7.	Number of courses for each car
Extract from the database all the cars and the count of their courses.
Also display the average bill of each course by the car, rounded to the second digit.
Order the results descending by the count of courses, then by the car’s id. 
Skip the cars with exactly 2 courses.
Required Columns
•	car_id
•	make
•	mileage
•	count_of_courses
•	avg_bill
*/
SELECT 
    c.`id`,
    c.`make`,
    c.`mileage`,
    COUNT(crs.`id`) AS `count_of_courses`,
   ROUND( AVG(crs.`bill`) ,2)AS `avg_bill`
FROM
    `cars` AS c
   LEFT     JOIN
    `courses` AS crs ON c.`id` = crs.`car_id`
GROUP BY c.`id`
HAVING  `count_of_courses` != 2
ORDER BY `count_of_courses` DESC,c.`id`;

/*
8.	Regular clients
Extract the regular clients, who have ridden in more than one car. The second letter of the customer's full name must be 'a'. 
Select the full name, the count of cars that he ridden and total sum of all courses.
Order clients by their full_name.
Required Columns
•	full_name
•	count_of_cars
•	total_sum
*/
SELECT 
   cl.`full_name`,COUNT(crs.`car_id`) AS `count_of_cars`,SUM(crs.`bill`) AS `total_sum`
FROM
    `clients` AS cl
        JOIN
    `courses` AS crs ON cl.`id` = crs.`client_id`
WHERE
    cl.`full_name` LIKE '_a%'
GROUP BY cl.`id`
HAVING `count_of_cars`>1
ORDER BY cl.`full_name`;

/*
 9.	Full information of courses
 The information that they need is the address, 
 if the course is made in the Day (between 6 and 20(inclusive both)) 
 or in the Night (between 21 and 5(inclusive both)), the bill of the course, 
 the full name of the client, the car maker, 
 the model and the name of the category.
#Order the results by course id.
Required Columns
•	name (address)
•	day_time
•	bill
•	full_name (client)
•	make
•	model
•	category_name (category)
*/
SELECT 
    a.`name`,
    CASE
        WHEN EXTRACT(HOUR FROM crs.`start`) BETWEEN 6 AND 20 THEN 'Day'
        ELSE 'Night'
    END AS `day_time`,
    crs.`bill`,
    cl.`full_name`,
    c.`make`,
    c.`model`,
    ctg.`name`
FROM
    `courses` AS crs
        JOIN
    `addresses` AS a ON crs.`from_address_id` = a.`id`
        JOIN
    `clients` AS cl ON crs.`client_id` = cl.`id`
        JOIN
    `cars` AS c ON crs.`car_id` = c.`id`
        JOIN
    `categories` AS ctg ON c.`category_id` = ctg.`id`
ORDER BY crs.`id`;

/*
10.	Find all courses by client’s phone number
Create a user defined function with the name udf_courses_by_client (phone_num VARCHAR (20)) 
that receives a client’s phone number and returns the number of courses that clients have in database.
*/
DELIMITER $$
CREATE FUNCTION `udf_courses_by_client`(`phone_num` VARCHAR (20))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN(
SELECT 
    COUNT(crs.`id`) AS count
FROM
    `courses` AS crs
        JOIN
    `clients` AS cl ON crs.`client_id` = cl.`id`
WHERE
    cl.`phone_number` = `phone_num`);
    END$$


/*
11.	Full info for address
Create a stored procedure udp_courses_by_address which accepts the following parameters:
•	address_name (with max length 100)
Extract data about the addresses with the given address_name. 
The needed data is the name of the address, full name of the client, 
level of bill (depends of course bill – Low – lower than 20(inclusive), 
Medium – lower than 30(inclusive), and High), make and condition of the car and the name of the category.
 Order addresses by make, then by client’s full name.
Required Columns
•	name (address)
•	full_name
•	level_of_bill
•	full_name (client)
•	make
•	condition
•	cat_name (category)
*/    
DELIMITER $$
CREATE PROCEDURE `udp_courses_by_address`(`address_name` VARCHAR(100))
BEGIN
SELECT 
    a.`name` AS name,
    cl.`full_name`,
    CASE
    WHEN crs.`bill`<=20 THEN 'Low'
    WHEN crs.`bill` >21 AND crs.`bill`<=30 THEN 'Medium'
    ELSE 'High'
    END
    AS `level_of_bill`,
    cars.`make`,
    cars.`condition`,
    ctg.`name` AS `cat_name`
FROM
    `courses` AS crs
        JOIN
    `addresses` AS a ON crs.`from_address_id` = a.`id`
        JOIN
    `clients` AS cl ON crs.`client_id` = cl.`id`
        JOIN
    `cars` ON crs.`car_id` = cars.`id`
        JOIN
    `categories` AS ctg ON cars.`category_id` = ctg.`id`
    WHERE a.`name`=`address_name`
    ORDER BY cars.`make`,cl.`full_name`;
    END$$