#1.	Employee Address
#Write a query that selects:
#•	employee_id
#•	job_title
#•	address_id
#•	address_text
#Return the first 5 rows sorted by address_id in ascending order.
SELECT 
    e.`employee_id`,
    e.`job_title`,
    e.`address_id`,
    a.`address_text`
FROM
    `employees` AS `e`
        JOIN
    `addresses` AS `a` ON e.`address_id` = a.`address_id`
ORDER BY `address_id`
LIMIT 5;


#2.	Addresses with Towns
#Write a query that selects:
#•	first_name
#•	last_name
#•	town
#•	address_text
#Sort the result by first_name in ascending order then by last_name. Select first 5 employees.

SELECT 
    e.`first_name`,
    e.`last_name`,
    t.`name` AS `town`,
    a.`address_text`
FROM
    `employees` AS `e`
        JOIN
    `addresses` AS `a` ON e.`address_id` = a.`address_id`
        JOIN
    `towns` AS `t` ON a.`town_id` = t.`town_id`
ORDER BY e.`first_name`, e.`last_name`
LIMIT 5;

#3.	Sales Employee
#Write a query that selects:
#•	employee_id
#•	first_name
#•	last_name
#•	department_name
#Sort the result by employee_id in descending order. 
#Select only employees from the "Sales" department.

SELECT 
    e.`employee_id`, e.`first_name`, e.`last_name`, d.`name`
FROM
    `employees` AS `e`
        JOIN
    `departments` AS `d` ON e.`department_id` = d.`department_id`
WHERE
    d.`name` = 'Sales'
ORDER BY e.`employee_id` DESC;

#4.	Employee Departments
#Write a query that selects:
#•	employee_id
#•	first_name
#•	salary
#•	department_name
#Filter only employees with salary higher than 15000. 
#Return the first 5 rows sorted by department_id in descending order.

SELECT 
    e.`employee_id`, e.`first_name`, e.`salary`, d.`name`
FROM
    `employees` AS `e`
        JOIN
    `departments` AS `d` ON e.`department_id` = d.`department_id`
WHERE
    e.`salary` >15000
ORDER BY d.`department_id` DESC LIMIT 5;

#5.	Employees Without Project
#Write a query that selects:
#•	employee_id
#•	first_name
#Filter only employees without a project. 
#Return the first 3 rows sorted by employee_id in descending order.

SELECT 
    e.`employee_id`, e.`first_name`
FROM
    `employees` AS e
        LEFT JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
WHERE
    ep.`project_id` IS NULL
ORDER BY e.`employee_id` DESC
LIMIT 3;

#6.	Employees Hired After
#Write a query that selects:
#•	first_name
#•	last_name
#•	hire_date
#•	dept_name
#Filter only employees hired after 1/1/1999 and from either the "Sales" or the "Finance" departments. 
#Sort the result by hire_date (ascending).

 SELECT 
    e.`first_name`, e.`last_name`, e.`hire_date`, d.`name`
FROM
    `employees` AS e
        JOIN
    `departments` AS `d` ON e.`department_id` = d.`department_id`
WHERE
    d.`name` IN ('Sales' , 'Finance')
        AND YEAR(e.`hire_date`) > '1998'
ORDER BY e.`hire_date` ASC;

#7.	Employees with Project
#Write a query that selects:
#•	employee_id
#•	first_name
#•	project_name
#Filter only employees with a project, which has started after 13.08.2002 and it is still ongoing (no end date). 
#Return the first 5 rows sorted by first_name then by project_name both in ascending order.

SELECT 
    e.`employee_id`, e.`first_name`, p.`name`
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
        JOIN
    `projects` AS p ON p.`project_id` = ep.`project_id`
WHERE
    DATE(p.`start_date`) > '2002-08-13'
        AND p.`end_date` IS NULL
ORDER BY e.`first_name` ASC , p.`name` ASC
LIMIT 5;



#8.	Employee 24
#Write a query that selects:
#•	employee_id
#•	first_name
#•	project_name
#Filter all the projects of employees with id 24. If the project has started after 2005 inclusively the return value should be NULL. Sort the result by project_name alphabetically.

SELECT 
    e.`employee_id`,
    e.`first_name`,
    IF(YEAR(p.`start_date`) > 2004,
        NULL,
        p.`name`) AS `p_name`
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON ep.`employee_id` = e.`employee_id`
        JOIN
    `projects` AS p ON p.`project_id` = ep.`project_id`
WHERE
    e.`employee_id` = 24
ORDER BY `p_name`;
    
#9.	Employee Manager
#Write a query that selects:
#•	employee_id
#•	first_name
#•	manager_id
#•	manager_name
#Filter all employees with a manager who has id equal to 3 or 7. 
#Return all rows sorted by employee first_name in ascending order.
 SELECT 
    e.`employee_id`,
    e.`first_name`,
    e.`manager_id`,
    m.`first_name` AS `manager_name`
FROM
    `employees` AS e
        JOIN
    `employees` AS m ON e.`manager_id` = m.`employee_id`
WHERE
    e.`manager_id` IN (3 , 7)
    ORDER BY e.`first_name` ASC;




#10.	Employee Summary
#Write a query that selects:
#•	employee_id
#•	employee_name
#•	manager_name		
#•	department_name
#Show the first 5 employees (only for employees who have a manager) with their managers and the departments they are in 
#(show the departments of the employees). 
#Order by employee_id.

SELECT 
    e.`employee_id`,
    CONCAT_WS(' ', e.`first_name`, e.`last_name`) AS `employee_name`,
    CONCAT_WS(' ', m.`first_name`, m.`last_name`) AS `manager_name`,
    d.`name`
FROM
    `employees` AS e
        JOIN
    `employees` AS m ON e.`manager_id` = m.`employee_id`
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
ORDER BY e.`employee_id`
LIMIT 5;

#11.	Min Average Salary
#Write a query that returns the value of the lowest average salary of all departments.

SELECT 
    AVG(`salary`) AS `avg_salary`
FROM
    `employees`
GROUP BY `department_id`
ORDER BY `avg_salary`
LIMIT 1;