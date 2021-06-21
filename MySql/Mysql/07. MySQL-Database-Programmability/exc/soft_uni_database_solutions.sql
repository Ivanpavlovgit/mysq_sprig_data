#1.	Employees with Salary Above 35000
#Create stored procedure usp_get_employees_salary_above_35000 that returns all employees 
#first and last names for whose salary is above 35000. 
#The result should be sorted by 
#first_name then by last_name alphabetically, and id ascending.
# Submit your query statement as Run skeleton, run queries & check DB in Judge.
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above_35000`()
BEGIN
SELECT 
    e.`first_name`, e.`last_name`
FROM
    `employees` AS e
WHERE
    e.`salary` > 35000
ORDER BY e.`first_name` , e.`last_name` , e.`employee_id` ASC;
END $$

CALL `usp_get_employees_salary_above_35000`;

#2.	Employees with Salary Above Number
#Create stored procedure usp_get_employees_salary_above that accept a 
#decimal number (with precision, 4 digits after the decimal point) as parameter and return 
#all employee's first and last names whose salary is above or equal to the given number. 
#The result should be sorted by first_name then by last_name alphabetically and id ascending. 
#Submit your query statement as Run skeleton, run queries & check DB in Judge.
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above`(`target_salary`  DECIMAL(10,4))
BEGIN
SELECT 
    e.`first_name`, e.`last_name`
FROM
    `employees` AS e
WHERE
    e.`salary` >= `target_salary`
ORDER BY e.`first_name` , e.`last_name` , e.`employee_id` ASC;
END $$

CALL `usp_get_employees_salary_above`(48100);


#3.	Town Names Starting With
#Write a stored procedure usp_get_towns_starting_with that 
#accept string as parameter and returns all town names starting with that string. 
#The result should be sorted by town_name alphabetically. 
#Submit your query statement as Run skeleton, run queries & check DB in Judge.
DELIMITER $$
CREATE PROCEDURE `usp_get_towns_starting_with`(`string` VARCHAR(30))
BEGIN 
SELECT t.`name` FROM `towns` AS t
WHERE LEFT(t.`name`,LENGTH(`string`)) LIKE `string` ORDER BY t.`name`;
END$$

#4.	Employees from Town
#Write a stored procedure usp_get_employees_from_town 
#that accepts town_name as parameter and return the employees' 
#first and last name that live in the given town. 
#The result should be sorted by 
#first_name then by 
#last_name alphabetically and 
#id ascending. 
#Submit your query statement as Run skeleton, run queries & check DB in Judge.

DELIMITER $$
CREATE PROCEDURE  `usp_get_employees_from_town`(`searched_town_name` VARCHAR(33))
BEGIN
SELECT 
    e.`first_name`, e.`last_name`
FROM
    `employees` AS e
        JOIN
    `addresses` AS a ON e.`address_id` = a.`address_id`
        JOIN
    `towns` AS t ON a.`town_id` = t.`town_id`
WHERE
    t.`name` = `searched_town_name`
ORDER BY e.`first_name` , e.`last_name` , e.`employee_id` ASC;
END $$
CALL `usp_get_employees_from_town`('Sofia');

#5.	Salary Level Function
#Write a function ufn_get_salary_level that receives salary of an employee and returns the level of the salary.
#•	If salary is < 30000 return "Low"
#•	If salary is between 30000 and 50000 (inclusive) return "Average"
#•	If salary is > 50000 return "High"
#Submit your query statement as Run skeleton, run queries & check DB in Judge.
DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level`( `salary_for_level` DECIMAL(10,4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN

RETURN(SELECT
CASE
WHEN `salary_for_level`<30000 THEN 'Low'
WHEN `salary_for_level`BETWEEN 30000 AND 50000 THEN 'Average'
WHEN `salary_for_level`>50000 THEN 'High' 
END) ;

END $$
SELECT `ufn_get_salary_level`(130500.0000) AS `salary_level`;
 /*SELECT `first_name`,`salary`,
CASE 
WHEN `salary`<30000 THEN 'low'
WHEN `salary` BETWEEN 30000 AND 50000 THEN 'Average'
WHEN `salary`>30000 THEN 'High'
END AS `level`*/


#6.	Employees by Salary Level
#Write a stored procedure usp_get_employees_by_salary_level 
#that receive as parameter level of salary (low, average or high) 
#and print the names of all employees that have given level of salary. 
#The result should be sorted by first_name then by last_name both in descending order.
#Submit your query statement as Run skeleton, run queries & check DB in Judge.
DELIMITER $$
CREATE PROCEDURE  `usp_get_employees_by_salary_level`(`salary_level` VARCHAR(10))
BEGIN
SELECT e.`first_name`,e.`last_name` FROM `employees` AS e WHERE 
(CASE
 WHEN `salary_level`='low' THEN e.`salary`<30000
 WHEN `salary_level`='average' THEN e.`salary` BETWEEN 30000 AND 50000
 WHEN `salary_level`='high' THEN e.`salary`>50000
END) ORDER BY e.`first_name` DESC,e.`last_name` DESC;
#SELECT e.`first_name`,e.`last_name`,e.`salary`,CASE 
#WHEN `salary`<30000 THEN 'low'
#WHEN `salary` BETWEEN 30000 AND 50000 THEN 'Average'
#WHEN `salary`>30000 THEN 'High'
#END AS `level` FROM `employees` AS e;
END  $$
CALL `usp_get_employees_by_salary_level`('high');

#7.	Define Function
#Define a function ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
#that returns 1 or 0 depending on that if the word is a comprised of the given set of letters. 
#Submit your query statement as Run skeleton, run queries & check DB in Judge.

CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS INT
BEGIN
	DECLARE result INT;
	DECLARE counter INT;
	DECLARE our_char VARCHAR(30);
	SET result = 1;
	SET counter = 0;
	REPEAT
		SET our_char = SUBSTRING(word, counter, 1);
		SET result = IF(set_of_letters NOT LIKE CONCAT('%', our_char, '%'), 0, 1);
		SET counter = counter + 1;
	UNTIL result = 0 OR counter = CHAR_LENGTH(word) + 1
	END REPEAT;
	RETURN result;
END;