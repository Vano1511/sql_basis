DROP DATABASE IF EXISTS lesson_3;
CREATE DATABASE lesson_3;
USE lesson_3;

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(45),
	lastname VARCHAR(45),
	post VARCHAR(100),
	seniority INT, 
	salary INT, 
	age INT
);

INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 25),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Иван', 'Иванов', 'Рабочий', '40', 30000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49);

SELECT * FROM staff
ORDER BY id;

SELECT firstname, age FROM staff
ORDER BY firstname DESC, age DESC;

SELECT DISTINCT firstname FROM staff;

SELECT * FROM staff
ORDER BY id DESC
LIMIT 2, 3;

SELECT COUNT(*) AS 'workers'
FROM staff
WHERE post = 'Рабочий';

SELECT SUM(salary) AS 'SHEFF SALLARY'
FROM staff
WHERE post = 'Начальник';

SELECT AVG(age) AS 'Avarage age (salary > 30K)'
FROM staff
WHERE salary > 30000;

SELECT 
	MAX(salary) AS 'max salary',
	MIN(salary) AS 'min salary'
FROM staff;

DROP TABLE IF EXISTS activity_staff;
CREATE TABLE activity_staff (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	staff_id INT NOT NULL,
	date_activity DATE,
	count_pages INT,
	FOREIGN KEY (staff_id) REFERENCES staff (id) ON DELETE CASCADE ON UPDATE CASCADE  
);


INSERT INTO activity_staff (staff_id, date_activity, count_pages)
VALUES
(1, '2022-01-01', 250),
(2, '2022-01-01', 220),
(3, '2022-01-01', 170),
(1, '2022-01-02', 100),
(2, '2022-01-02', 220),
(3, '2022-01-02', 300),
(7, '2022-01-02', 350),
(1, '2022-01-03', 168),
(2, '2022-01-03', 62),
(3, '2022-01-03', 84);

SELECT * FROM activity_staff;

SELECT 
	staff_id, 
	SUM(count_pages) AS 'all pages' 
FROM activity_staff
GROUP BY staff_id;


SELECT 
	date_activity, 
	SUM(count_pages) AS 'all pages' 
FROM activity_staff
GROUP BY date_activity;

SELECT 
	date_activity, 
	AVG(count_pages) AS 'average pages for employee' 
FROM activity_staff
GROUP BY date_activity;


SELECT 
	groupes, 
	SUM(salary) 
FROM (SELECT salary,
				CASE 
					WHEN age < 20 THEN 'lower 20'
					WHEN age > 40 THEN 'higher 40'
					ELSE 'between 20 and 40'
				END AS groupes
			FROM staff) AS list
GROUP BY groupes
ORDER BY groupes;


SELECT staff_id, SUM(count_pages)
FROM activity_staff
GROUP BY staff_id
HAVING SUM(count_pages) > 500;


SELECT 
	date_activity AS 'DAY',
	COUNT(staff_id) AS 'working_employees'
FROM activity_staff
GROUP BY date_activity
HAVING working_employees > 3;

SELECT 
	post, 
	AVG(salary) AS 'Average_post_salary'
FROM staff
GROUP BY post
HAVING Average_post_salary > 30000;
