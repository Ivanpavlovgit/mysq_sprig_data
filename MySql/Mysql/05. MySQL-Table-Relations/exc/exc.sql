#Create two tables as follows. Use appropriate data types.
#people
#person_id	first_name	salary	passport_id
#1  	Roberto                                            	43300.00	102
#2	Tom	56100.00	103
#3	Yana	60200.00	101
#passports
#passport_id	passport_number
#101	N34FG21B
#102	K65LO4R7
#103	ZE657QP2

#Insert the data from the example above.
#•	Alter table people and make person_id a primary key. 
#•	Create a foreign key between people and passports by using the passport_id column. 
#•	Think about which passport field should be UNIQUE.
#•	Format salary to second digit after decimal point.
#Submit your queries by using "MySQL run queries & check DB" strategy.


CREATE TABLE `passports` (
`passport_id` INT PRIMARY KEY AUTO_INCREMENT,
`passport_number` VARCHAR(20) UNIQUE
);
ALTER TABLE `passports` AUTO_INCREMENT=101;
INSERT INTO `passports`(`passport_number`)
VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2');

CREATE TABLE `people`(
`person_id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(20),
`salary` DECIMAL(10,2),
`passport_id` INT UNIQUE,

CONSTRAINT fk_people_passports
FOREIGN KEY(`passport_id`)
REFERENCES `passports`(`passport_id`)
);

INSERT INTO `people`
VALUES
(1,'Roberto',43300.00,102),
(2,'Tom',56100.00,103),
(3,'Yana',60200.00,101);

#2.	One-To-Many Relationship


CREATE TABLE `manufacturers`(
`manufacturer_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20),
`established_on` DATE 
); 

INSERT INTO `manufacturers`(`name`,`established_on`)
VALUES
('BMW','1916-03-01'),
('Tesla','2003-01-01'),
('Lada','1966-05-01');


CREATE TABLE `models`(
`model_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20),
`manufacturer_id` INT,
CONSTRAINT fk_models_manufacturers
FOREIGN KEY(`manufacturer_id`)
REFERENCES `manufacturers`(`manufacturer_id`)
);
ALTER TABLE `models` AUTO_INCREMENT=101;
INSERT INTO `models`(`name`,`manufacturer_id`)
VALUES
('X1',1),
('i6',1),
('Model S',2),
('Model X',2),
('Model 3',2),
('Nova',3);


#3.	Many-To-Many Relationship
#Create three tables as follows. 
#Use appropriate data types.

CREATE TABLE `exams`(
`exam_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);
ALTER TABLE `exams` AUTO_INCREMENT=101;
INSERT INTO `exams`(`name`)
VALUES 
('Spring MVC'),
('Neo4j'),
('Oracle 11g');


CREATE TABLE `students` (
`student_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);
INSERT INTO `students`(`name`)
VALUES
('Mila'),
('Toni'),
('Ron');

CREATE TABLE `students_exams`(
`student_id` INT,
`exam_id` INT,

CONSTRAINT `pk_students_exams`
PRIMARY KEY(`student_id`,`exam_id`),

CONSTRAINT `fk_students_exams_students`
FOREIGN KEY(`student_id`)
REFERENCES `students`(`student_id`),

CONSTRAINT `fk_students_exams_exams`
FOREIGN KEY(`exam_id`)
REFERENCES `exams`(`exam_id`)
);
INSERT INTO `students_exams`
VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103);


#4.	Self-Referencing
#Create a single table as follows. 
#Use appropriate data types.

CREATE TABLE `teachers` (
`teacher_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL,
`manager_id` INT
);
ALTER TABLE `teachers` AUTO_INCREMENT=101;

INSERT INTO `teachers`(`name`,`manager_id`)
VALUES 
('John',NULL),
('Maya',106),
('Silvia',106),
('Ted',105),
('Mark',101),
('Greta',101);

ALTER TABLE `teachers`
ADD CONSTRAINT `fk_teachers_managers`
FOREIGN KEY(`manager_id`)
REFERENCES `teachers`(`teacher_id`);
