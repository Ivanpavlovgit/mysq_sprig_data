#1.	Managers
#Write a query to retrieve information about the managers – id, full_name, deparment_id and department_name. 
#Select the first 5 departments ordered by employee_id. 
#Submit your queries using the "MySQL prepare DB and Run Queries" strategy. 

SELECT 
    e.`employee_id`,
    CONCAT_WS(' ', e.`first_name`, e.`last_name`) AS `full_name`,
    d.`department_id`,
    d.`name`
FROM
    `employees` AS e
        RIGHT JOIN
    `departments` AS d ON d.`manager_id` = e.`employee_id`
ORDER BY e.employee_id
LIMIT 5;


#2.	Towns Addresses
#Write a query to get information about the addresses in the database, which are in San Francisco, Sofia or Carnation.
#Retrieve town_id, town_name, address_text. Order the result by town_id, then by address_id. 
#Submit your queries using the "MySQL prepare DB and Run Queries" strategy. 
SELECT * FROM `addresses`;
SELECT * FROM `towns`;

SELECT 
    a.`town_id`, t.`name` AS town_name, a.`address_text`
FROM
    `addresses` AS a
        LEFT JOIN
    `towns` AS t ON a.`town_id` = t.`town_id`
WHERE
    t.`name` IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY t.`town_id` , a.`address_id`;

#3.	Employees Without Managers
#Write a query to get information about 
#employee_id, first_name, last_name, department_id and salary for all employees who don't have a manager. 
#Submit your queries using the "MySQL prepare DB and Run Queries" strategy.
SELECT 
    `employee_id`,
    `first_name`,
    `last_name`,
    `department_id`,
    ROUND(`salary`, 2)
FROM
    `employees`
WHERE
    `manager_id` IS NULL;


#4 
SELECT 
    COUNT(e.`employee_id`) AS 'COUNT'
FROM
    `employees` AS e
WHERE
    e.`salary` > (SELECT 
            AVG(`salary`)
        FROM
            `employees`);