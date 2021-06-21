#8.	Find Full Name
#You are given a database schema with tables:
#•	account_holders(id (PK), first_name, last_name, ssn) 
#•	accounts(id (PK), account_holder_id (FK), balance).
#Write a stored procedure usp_get_holders_full_name that selects the full names of all people. 
#The result should be sorted by full_name alphabetically and id ascending. 
#Submit your query statement as Run skeleton, run queries & check DB in Judge.
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_full_name`()
BEGIN
SELECT CONCAT_WS(' ', a.`first_name`,a.`last_name`) AS `full_name` FROM `account_holders` AS a  ORDER BY `full_name`,a.`id` ASC;
END $$
CALL `usp_get_holders_full_name`();
DELIMITER ;

#9.	People with Balance Higher Than
#Your task is to create a stored procedure usp_get_holders_with_balance_higher_than that accepts a number as a parameter
#and returns all people who have more money in total of all their accounts than the supplied number. 
#The result should be sorted by account_holders.id ascending. 
#Submit your query statement as Run skeleton, run queries & check DB in Judge.

select * from accounts;

DELIMITER $$
CREATE PROCEDURE `usp_get_holders_with_balance_higher_than`(`target_balance` INT)
BEGIN
SELECT 
    ah.`first_name`, ah.`last_name`
FROM
    `accounts` AS a
        JOIN
    `account_holders` AS ah ON a.`account_holder_id` = ah.`id`
GROUP BY a.`account_holder_id`
HAVING SUM(a.`balance`) > `target_balance`
ORDER BY a.`account_holder_id` ASC;
END $$

CALL `usp_get_holders_with_balance_higher_than`(7000);
DELIMITER ;

#10.	Future Value Function
#Your task is to create a function ufn_calculate_future_value 
#that accepts as parameters – sum (with precision, 4 digits after the decimal point), 
#yearly interest rate (double) and number of years(int). 
#It should calculate and return the future value of the initial sum. 
#The result from the function must be decimal, with percision 4.
 #Using the following formula:
 #FV=iX((1+R)^T)
#•	I – Initial sum
#•	R – Yearly interest rate#
#•	T – Number of years
#Submit your query statement as Run skeleton, run queries & check DB in Judge.
DELIMITER $$
CREATE FUNCTION `ufn_calculate_future_value`(`I` DECIMAL(19,4),`R` DECIMAL(19,4),`T` INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC

BEGIN

RETURN `I`*(POW((1+`R`),`T`));

END$$

SELECT `ufn_calculate_future_value`(1000,0.5,5);

#11.Calculating Interest
#Your task is to create a stored procedure usp_calculate_future_value_for_account 
#that accepts as parameters – id of account and interest rate. 
#The procedure uses the function from the previous problem to give an interest to a persons account for 5 years
#along with information about his/her account id, first name, last name and current balance as it is shown in the example below.
#It should take the account_id and the interest_rate as parameters. 
#Interest rate should have precision up to 0.0001, 
#same as the calculated balance after 5 years.
## Be extremely careful to achieve the desired precision!
#Submit your query statement as Run skeleton, run queries & check DB in Judge.
SELECT a.`id` AS `acount_id`,ah.`first_name`,ah.`last_name`,a.`balance` AS `current_balance` FROM
    `accounts` AS a
        JOIN
    `account_holders` AS ah ON a.`account_holder_id` = ah.`id`;

DELIMITER $$
CREATE PROCEDURE `usp_calculate_future_value_for_account`(`account_id` INT,`interest_rate` DECIMAL(19,4))
BEGIN
SELECT a.`id` AS `acount_id`,
ah.`first_name`,
ah.`last_name`,
a.`balance` AS `current_balance`,
ufn_calculate_future_value(a.`balance`,`interest_rate`,5) AS `balance_in_5_years`
 FROM
    `accounts` AS a
        JOIN
    `account_holders` AS ah ON a.`account_holder_id` = ah.`id`
    WHERE a.`id`=`account_id`;
END$$

#CALL `usp_calculate_future_value_for_account`(1,0.1);
#DELIMITER;
#12.Deposit Money
#Add stored procedure usp_deposit_money(account_id, money_amount) that operate in transactions. 
#Make sure to guarantee valid positive money_amount with precision up
#to fourth sign after decimal point. 
#The procedure should produce exact results working with the specified precision.
#Submit your query statement as Run skeleton, run queries & check DB in Judge.
DELIMITER $$
CREATE PROCEDURE `usp_deposit_money`(`account_id` INT, `money_amount` DECIMAL(19,4))
BEGIN
START TRANSACTION;
	CASE
	WHEN `money_amount`<0
		THEN ROLLBACK;
	ELSE
		UPDATE `accounts` AS a 
		SET a.`balance`=a.`balance` + `money_amount`
		WHERE a.`id`=`account_id`;
END CASE;
COMMIT;
END $$
SELECT * FROM `accounts`;
CALL usp_deposit_money(1,10);

#13.Withdraw Money
#Add stored procedures usp_withdraw_money(account_id, money_amount) that operate in transactions. 
#Make sure to guarantee withdraw is done only when balance is enough and money_amount is valid positive number. 
#Work with precision up to fourth sign after decimal point. 
#The procedure should produce exact results working with the specified precision.
#Submit your query statement as Run skeleton, run queries & check DB in Judge
DELIMITER $$
CREATE PROCEDURE `usp_withdraw_money`(`account_id` INT, `money_amount` DECIMAL(19,4))
BEGIN
START TRANSACTION;
	CASE
	WHEN `money_amount`<0 OR (SELECT a.`balance` FROM `accounts` AS a WHERE a.`id`=`account_id`)<`money_amount`
		THEN ROLLBACK;
	ELSE
		UPDATE `accounts` AS a 
		SET a.`balance`=a.`balance` - `money_amount`
		WHERE a.`id`=`account_id`;
END CASE;
COMMIT;
END $$

/*#14.	Money Transfer
Write stored procedure usp_transfer_money(from_account_id, to_account_id, amount) 
that transfers money from one account to another. 
Consider cases when one of the account_ids is not valid, the amount of money is negative number, 
outgoing balance is enough or transferring from/to one and the same account. 
Make sure that the whole procedure passes without errors and if error occurs make no change in the database. 
Make sure to guarantee exact results working with precision up to fourth sign after decimal point.
Submit your query statement as Run skeleton, run queries & check DB in Judge.*/

DELIMITER $$
CREATE PROCEDURE `usp_transfer_money`(`from_account_id` INT, `to_account_id` INT, `amount` DECIMAL(18,4)) 
BEGIN
START TRANSACTION;
	CASE
	WHEN `amount`<0 
    OR (SELECT a.`balance` FROM `accounts` AS a WHERE a.`id`=`from_account_id`)<`amount`
    OR NOT EXISTS (SELECT a.`id` FROM `accounts` AS a WHERE a.`id`=`from_account_id`) 
    OR NOT EXISTS (SELECT a.`id` FROM `accounts` AS a WHERE a.`id`=`to_account_id`)
		THEN ROLLBACK;
	ELSE
		UPDATE `accounts` AS a 
		SET a.`balance`=a.`balance` - `amount`
        WHERE a.`id`=`from_account_id`;
UPDATE `accounts` AS a 
SET 
    a.`balance` = a.`balance` + `amount`
WHERE
    a.`id` = `to_account_id`;
END CASE;
COMMIT;
END $$

#call `usp_transfer_money`(1,2,10);

#15.	Log Accounts Trigger
#Create another table – logs(log_id, account_id, old_sum, new_sum). 
#Add a trigger to the accounts table that enters a new entry into the logs table every time the sum on an account changes.
#Submit your query statement as Run skeleton, run queries & check DB in Judge.

CREATE TABLE `logs` (
    `log_id` INT PRIMARY KEY AUTO_INCREMENT,
    `account_id` INT NOT NULL,
    `old_sum` DECIMAL(19 , 4 ),
    `new_sum` DECIMAL(19 , 4 )
);
/*DELIMITER$$
CREATE TRIGGER  `tr_sum_change_lo1g`
AFTER UPDATE
ON `accounts`
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (`account_id`,`old_sum`,`new_sum`)
	VALUES(OLD.`id`,OLD.`balance`,NEW.`balance`);
END$$*/

 /* 16.	Emails Trigger
Create another table – notification_emails(id, recipient, subject, body). 
Add a trigger to logs table to create new email whenever new record is inserted in logs table. 
The following data is required to be filled for each email:
•	recipient – account_id
•	subject – "Balance change for account: {account_id}"
•	body - "On {date (current date)} your balance was changed from {old} to {new}."
Submit your query statement as Run skeleton, run queries & check DB in Judge.
  */

CREATE TABLE notification_emacreate_notification_emailils (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipient INT NOT NULL,
    subject VARCHAR(50) NOT NULL,
    body TEXT NOT NULL
);
