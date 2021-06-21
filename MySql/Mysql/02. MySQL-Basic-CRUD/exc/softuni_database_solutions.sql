#02. MySQL-Basic-CRUD-Exercises

#1 
SELECT     *
FROM    `departments`
ORDER BY `department_id`;

#2
SELECT `name` FROM `departments`;

#3. Find salary of Each Employee 
#Write SQL query to find the first name, last name and salary of each employee. Sort the information by id. Submit your query statements as Prepare DB & run queries. 

SELECT `first_name`,`last_name`,`salary` FROM `employees`
ORDER BY `employee_id`;

#4Find Full Name of Each Employee 
#Write SQL query to find the first, middle and last name of each employee. Sort the information by id. Submit your query statements as Prepare DB & run queries. 
SELECT `first_name`,`middle_name`,`last_name` FROM `employees`;

#5Find Email Address of Each Employee 
#Write a SQL query to find the email address of each employee. (by his first and last name). 
#Consider that the email domain is softuni.bg. Emails should look like "John.Doe@softuni.bg". 
#The produced column should be named "full_ email_address".  Submit your query statements as Prepare DB & run queries. 

SELECT 
    CONCAT(`first_name`,
            '.',
            `last_name`,
            '.softuni.bg') AS `full_email_address`
FROM
    `employees`;
    
#6. Find All Different Employee's Salaries 
#Write a SQL query to find all different employee's salaries.
#Show only the salaries. Sort the information by id.
#Submit your query statements as Prepare DB & run queries.  
SELECT DISTINCT `salary` FROM `employees`;

#7. Find all Information About Employees 
#Write a SQL query to find all information about the employees whose job title is "Sales Representative". 
#Sort the information by id. Submit your query statements as Prepare DB & run queries. 

SELECT * FROM `employees`
WHERE `job_title`='Sales Representative'
ORDER BY `employee_id`;

#8. Find Names of All Employees by salary in Range 
#Write a SQL query to find the first name, last name and job title of all employees whose salary is in the range [20000, 30000].
#Sort the information by id. Submit your query statements as Prepare DB & run queries. 

SELECT 
    `first_name`, `last_name`, `job_title`
FROM
    `employees`
WHERE
    `salary` BETWEEN 20000 AND 30000; 

#9.  Find Names of All Employees  
#Write a SQL query to find the full name of all employees whose salary is 25000, 14000, 12500 or 23600.
#Full Name is combination of first, middle and last name (separated with single space) and they should be in one column called "Full Name".
#Submit your query statements as Prepare DB & run queries. 
SELECT 
    CONCAT_WS(' ',
            `first_name`,
            `middle_name`,
            `last_name`) AS `Full Name`
FROM
    `employees`
WHERE
    `salary` IN (25000,14000,12500,23600);

#10.Find All Employees Without Manager 
#Write a SQL query to find first and last names about those employees that does not have a manager.
#Submit your query statements as Prepare DB & run queries. 
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    `manager_id` IS NULL;
    
#11. Find All Employees with salary More Than 50000 
#Write a SQL query to find first name, last name and salary of those employees who has salary more than 50000.
# Order them in decreasing order by salary. Submit your query statements as Prepare DB & run queries. 
SELECT 
    `first_name`, `last_name`, `salary`
FROM
    `employees`
WHERE
    `salary` > 50000
ORDER BY `salary` DESC;

#12. Find 5 Best Paid Employees 
#Write SQL query to find first and last names about 5 best paid Employees ordered descending by their salary.
#Submit your query statements as Prepare DB & run queries. 
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
ORDER BY `salary` DESC
LIMIT 5;

#13. Find All Employees Except Marketing 
#Write a SQL query to find the first and last names of all employees whose department ID is different from 4.
# Submit your query statements as Prepare DB & run queries. 
SELECT 
    `first_name`, `last_name`
FROM
    `employees`
WHERE
    NOT (`department_id` = 4);

#14. Sort Employees Table 
#Write a SQL query to sort all records in the еmployees table by the following criteria:  
#•	First by salary in decreasing order 
#•	Then by first name alphabetically 
#•	Then by last name descending 
#•	Then by middle name alphabetically 
#Sort the information by id. Submit your query statements as Prepare DB & run queries. 
SELECT * FROM `employees`
ORDER BY `salary` DESC;

SELECT * FROM `employees`
ORDER BY `first_name`;

SELECT * FROM `employees`
ORDER BY `last_name` DESC;

SELECT *FROM `employees`
ORDER BY `middle_name`;

#15. Create View Employees with Salaries 
#Write a SQL query to create a view v_employees_salaries with first name, last name and salary for each employee
#Submit your query statements as Run skeleton, run queries & check DB.  


CREATE VIEW `v_employees_salaries` AS
    SELECT 
        `first_name`, `last_name`, `salary`
    FROM
        `employees`;
        
        
#16. Create View Employees with Job Titles 
#Write a SQL query to create view v_employees_job_titles with full employee name and job title. 
#When middle name is NULL replace it with empty string ('').
# Submit your query statements as Run skeleton, run queries & check DB. 

CREATE VIEW `v_employees_job_titles` AS
    SELECT 
        CONCAT_WS(' ',
                `first_name`,
                `middle_name`,
                `last_name`) AS `full_name`,
        `job_title`
    FROM
        `employees`;

#17.  Distinct Job Titles 
#Write a SQL query to find all distinct job titles. Sort the result by job title alphabetically.
# Submit your query statements as Prepare DB & run queries. 
SELECT DISTINCT
    `job_title`
FROM
    `employees`
ORDER BY `job_title`;

#18. Find First 10 Started Projects 
#Write a SQL query to find first 10 started projects. 
#Select all information about them and sort them by start date, then by name. Sort the information by id. 
# Submit your query statements as Prepare DB & run queries. 
SELECT * FROM `projects`
ORDER BY `start_date`,`name`,`project_id`
LIMIT 10;

#19 Last 7 Hired Employees 
#Write a SQL query to find last 7 hired employees. 
#Select their first, last name and their hire date.
#Submit your query statements as Prepare DB & run queries. 

SELECT 
    `first_name`, `last_name`, `hire_date`
FROM
    `employees`
ORDER BY `hire_date` DESC
LIMIT 7;

#20 Increase Salaries 
#Write a SQL query to increase salaries of all employees that are in the
#Engineering, Tool Design, Marketing or Information Services department by 12%. Then select Salaries column from the Employees table.
#Submit your query statements as Prepare DB & run queries. 

UPDATE `employees`
SET `salary`=`salary`*1.12
WHERE `department_id` IN (1,2,4,11);
SELECT `salary` FROM `employees`;














