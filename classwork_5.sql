DROP DATABASE IF EXISTS lesson5;
CREATE DATABASE lesson5;
USE lesson5;

DROP TABLE IF EXISTS test_table;
CREATE TABLE test_table (
	Dates DATE,
	Medium VARCHAR(15),
	Conversion INT
);


INSERT INTO test_table (Dates, Medium, Conversion) VALUES
('2020-05-10', 'cpa', 1),
('2020-05-10', 'cpc', 2),
('2020-05-10', 'organic',1),
('2020-05-11', 'cpa', 1),
('2020-05-11', 'cpc', 3),
('2020-05-11', 'organic', 2),
('2020-05-11', 'direct', 1),
('2020-05-12', 'cpc', 1),
('2020-05-12', 'organic', 2);

SELECT 
	Dates,
	Medium,
	Conversion,
	LAG(Conversion) OVER(PARTITION BY Dates ORDER BY Dates) AS lags,
	LEAD(Conversion) OVER(PARTITION BY Dates ORDER BY Dates) AS leads,
	FIRST_VALUE(Conversion) OVER(PARTITION BY Dates ORDER BY Dates) AS firstv,
	LAST_VALUE(Conversion) OVER(PARTITION BY Dates ORDER BY Dates) As lastv
FROM test_table;


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

-- Наполнение данными
INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 25),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Ольга', 'Васютина', 'Инженер', '2', 70000, 25),
('Петр', 'Некрасов', 'Уборщик', '36', 16000, 59),
('Саша', 'Петров', 'Инженер', '12', 50000, 49),
('Иван', 'Сидоров', 'Рабочий', '40', 50000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49),
('Юрий', 'Онегин', 'Начальник', '8', 100000, 39);