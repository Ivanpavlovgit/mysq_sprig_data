#12.	 Employees Minimum Salaries
#That's it! You no longer work for Mr. Bodrog. You have decided to find a proper job as an analyst in SoftUni. 
#It's not a surprise that you will use the soft_uni database. 
#Select the minimum salary from the employees for departments with ID (2,5,7) but only for those who are hired after 01/01/2000. Sort result by department_id in ascending order.
#Your query should return:
#•	department_id

SELECT 
    `department_id`, MIN(`salary`)
FROM
    `employees`
WHERE
    `department_id` IN (2 , 5, 7)
        AND `hire_date` > '2000-01-01'
GROUP BY `department_id`
ORDER BY `department_id` ASC;

#13.	Employees Average Salaries
#Select all high paid employees who earn more than 30000 into a new table. 
#Then delete all high paid employees who have manager_id = 42 from the new table. 
#Then increase the salaries of all high paid employees with department_id = 1 with 5000 in the new table. 
#Finally, select the average salaries in each department from the new table. 
#Sort result by department_id in increasing order.

CREATE TABLE `high_paid` AS
SELECT * FROM `employees`
WHERE `salary`>30000 AND `manager_id`!=42;

UPDATE `high_paid`
SET `salary`=`salary`+5000
WHERE `department_id`=1;

SELECT 
    `department_id`, AVG(`salary`) AS `avg_salary`
FROM
    `high_paid`
GROUP BY `department_id`
ORDER BY `department_id` ASC;


#14. Employees Maximum Salaries
#Find the max salary for each department. 
#Filter those which have max salaries not in the range 30000 and 70000. 
#Sort result by department_id in increasing order.
SELECT 
    `department_id`, MAX(`salary`)
FROM
    `employees`
GROUP BY `department_id`
HAVING MAX(`salary`) NOT BETWEEN 30000 AND 70000
ORDER BY `department_id`;

#15. Employees Count Salaries
#Count the salaries of all employees who don't have a manager.	

SELECT COUNT(`salary`) AS 'count' FROM `employees`
WHERE `manager_id` IS NULL;



#16.	3rd Highest Salary*
#Find the third highest salary in each department if there is such. 
#Sort result by department_id in increasing order.

SELECT 
    e.`department_id`,
    (SELECT DISTINCT
            e2.`salary`
        FROM
            `employees` AS e2
        WHERE
            e2.`department_id` = e.`department_id`
        ORDER BY `salary` DESC
        LIMIT 1 OFFSET 2) AS `ths`
FROM
    `employees` AS e
GROUP BY e.`department_id`
HAVING `ths` IS NOT NULL
ORDER BY e.`department_id`;

#17.	 Salary Challenge**
#Write a query that returns:
#•	first_name
#•	last_name
#•	department_id
#for all employees who have salary higher than the average salary of their respective departments. 
#Select only the first 10 rows. 
#Order by department_id, employee_id.

SELECT 
    e.`first_name`, e.`last_name`, e.`department_id`
FROM
    `employees` AS e
    WHERE `salary`>(
    
    SELECT 
    AVG(e2.`salary`)
FROM
    `employees` AS e2
    WHERE e2.`department_id`=e.`department_id`
    
    )
ORDER BY `department_id` , `employee_id`
LIMIT 10;

#18.	Departments Total Salaries
#Create a query which shows the total sum of salaries for each department. 
#Order by department_id.
#Your query should return:	
#•	department_id

SELECT 
    `department_id`, SUM(`salary`)
FROM
    `employees`
GROUP BY `department_id`
ORDER BY `department_id`;