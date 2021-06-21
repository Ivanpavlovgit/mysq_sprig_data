/*
2.	Insert
You will have to insert records of data into the products_stores table, based on the products table. 
Find all products that are not offered in any stores
 (don’t have a relation with stores) and insert data in the products_stores. 
For every product saved -> product_id and 1(one) as a store_id. And now this product will be offered in store with name Wrapsafe and id 1.
•	product_id – id of product
•	store_id – set it to be 1 for all products.
*/

INSERT INTO `products_stores` (`product_id`,`store_id`)
(
SELECT p.`id`, 1 
FROM `products` AS p 
WHERE p.`id` NOT IN (
SELECT `product_id` 
FROM`products_stores`)
);


/*
3.	Update
Update all employees that hire after 2003(exclusive) year and not work in store Cardguard and Veribet. 
Set their manager to be Carolyn Q Dyett (with id 3) and decrease salary with 500.
*/
UPDATE `employees` AS e 
SET 
    e.`manager_id` = 3,
    e.`salary` = e.`salary` - 500
WHERE
    YEAR(`hire_date`) > 2003
        AND e.`store_id` NOT IN (5 , 14);


/*
4.	Delete
It is time for the stores to start working. All good employees already are in their stores.
But some of the employers are too expensive and we need to cut them, because of finances restrictions.
Be careful not to delete managers they are also employees.
Delete only those employees that have managers and a salary is more than 6000(inclusive)
*/

DELETE FROM `employees` AS e
WHERE e.`manager_id` IS NOT NULL AND e.`salary`>=6000;

#5.	Employees 
#Extract from the SoftUni Stores System database, info about all of the employees. 
#Order the results by employees hire date in descending order.
#Required Columns
#•	first_name
#•	middle_name
#•	last_name
#•	salary
#•	hire_date

SELECT 
    e.`first_name`,
    e.`middle_name`,
    e.`last_name`,
    e.`salary`,
    e.`hire_date`
FROM
    `employees` AS e
ORDER BY e.`hire_date` DESC;

#6.	Products with old pictures
#A photographer wants to take pictures of products that have old pictures. 
#You must select all of the products that have a description more than 100 characters long description, 
#and a picture that is made before 2019 (exclusive) and the product price being more than 20. 
#Select a short description column that consists of first 10 characters of the picture's description plus '…'. 
#Order the results by product price in descending order.

#Required Columns
#•	name (product)
#•	price 
#•	best_before
#•	short_description  
#o	only first 10 characters of product description + '...'
#•	url 

SELECT 
    p.`name`,
    p.`price`,
    p.`best_before`,
    CONCAT(LEFT(p.`description`, 10), '...') AS `short_description`,
    pic.`url`
FROM
    `products` AS p
        JOIN
    `pictures` AS pic ON p.`picture_id` = pic.`id`
WHERE
    CHAR_LENGTH(p.`description`) > 100
        AND YEAR(pic.`added_on`) <= 2018
        AND p.`price` > 20
ORDER BY p.`price` DESC;

#7.	Counts of products in stores and their average 
#The managers needs to know in which stores sell different products and their average price.
#Extract from the database all of the stores (with or without products) and the count of the products that they have. 
#Also you can show the average price of all products (rounded to the second digit after decimal point) that sells in store.
#Order the results descending by count of products in store, then by average price in descending order and finally by store id. 
#Required Columns
#•	Name (store)
#•	product_count
#•	avg

SELECT 
    s.`name`,
    COUNT(p.`id`) AS `product_count`,
    ROUND(AVG(p.`price`), 2) AS `avg`
FROM
    `stores` AS s
        LEFT JOIN
    `products_stores` AS ps ON s.`id` = ps.`store_id`
        LEFT JOIN
    `products` AS p ON ps.`product_id` = p.`id`
GROUP BY s.`id`
ORDER BY `product_count` DESC , `avg` DESC , s.`id`;

/*
8.	Specific employee
There are many employees in our shop system, but we need to find only the one that passes some specific criteria. 
Extract from the database,
 the full name of employee, 
 name of store that he works,
 address of store,
 and salary. 
 The employee's salary must be lower than 4000,
 the address of the store must contain '5' somewhere,
 the length of the store name needs to be more than 8 characters and the employee’s last name must end with an 'n'.
Required Columns
•	Full name (employee)
•	Store name 
•	Address
•	Salary
*/

SELECT 
    CONCAT_WS(' ', e.`first_name`, e.`last_name`) AS `full_name`,
    s.`name`,
    a.`name`,
    e.`salary`
FROM
    `employees` AS e
        JOIN
    `stores` AS s ON e.`store_id` = s.`id`
        JOIN
    `addresses` AS a ON s.`address_id` = a.`id`
WHERE
    e.`salary` < 4000
        AND a.`name` LIKE '%5%'
        AND CHAR_LENGTH(a.`name` > 8)
        AND e.`last_name` LIKE '%n';
 /*
 9.	Find all information of stores
The managers always want to know how the business goes. Now, they want from us to show all store names, 
but for security, the name and must be in the reversed order.
Select the name of stores (in reverse order). 
After that, the full_address in format: {town name in upper case}-{address name}.
The next info is the count of employees, that work in the store.
Filter only the stores that have a more than one employee.
Order the results by the full_address in ascending order.

Required Columns
•	reversed_name (store name) 
•	full_address (full_address)
•	employees_count
*/

SELECT 
    REVERSE(s.`name`),
    CONCAT_WS('-', UPPER(t.name), a.`name`) AS `full_address`,
    COUNT(e.`id`) AS `employees_count`
FROM
    `stores` AS s
        JOIN
    `addresses` AS a ON s.`address_id` = a.`id`
        JOIN
    `employees` AS e ON e.`store_id` = s.`id`
        JOIN
    `towns` AS t ON a.`town_id` = t.`id`
GROUP BY s.`id`
HAVING COUNT(e.`id`) >= 1
ORDER BY `full_address` ASC;

#10.Find full name of top paid employee by store name
#Create a user defined function with the name udf_top_paid_employee_by_store(store_name VARCHAR(50)) that receives a store name and returns the full name of top paid employee. 
#Full info must be in format:
 #	{first_name} {middle_name}. {last_name} works in store for {years of experience} years
#The years of experience is the difference when they were hired and 2020-10-18
DELIMITER $$
CREATE FUNCTION `udf_top_paid_employee_by_store`(`store_name` VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
RETURN (SELECT CONCAT(e.`first_name`,' ',e.`middle_name`,'. ',e.`last_name`,' works in store for ',2020-YEAR(e.`hire_date`),' years')
FROM
    `employees` AS e
        JOIN
    `stores` AS s ON e.`store_id` = s.`id`
WHERE s.`name`=`store_name`
ORDER BY e.`salary` DESC
	LIMIT 1);
END $$
#SELECT UDF_TOP_PAID_EMPLOYEE_BY_STORE('Stronghold') AS 'full_info';
DELIMITER $$
CREATE PROCEDURE udp_update_product_price (`address_name` VARCHAR (50)) 
BEGIN
UPDATE `products` AS p
        JOIN
    `products_stores` AS ps ON p.`id` = ps.`product_id`
        JOIN
    `stores` AS s ON ps.`store_id` = s.`id`
        JOIN
    `addresses` AS a ON s.`address_id` = a.`id` 
SET 
    p.`price` = (CASE
        WHEN `address_name` LIKE '0%' THEN (p.`price` + 100)
        ELSE (p.`price` + 200)
    END)
WHERE
    a.`name` = `address_name`;
   END$$
   
   CALL udp_update_product_price('1 Cody Pass');
   SELECT name, price FROM products WHERE id = 17;