USE lesson_3;


-- 1. Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
SELECT * FROM staff
ORDER BY salary DESC;

SELECT * FROM staff
ORDER BY salary;


-- 2. Выведите 5 максимальных заработных плат (saraly)
SELECT * FROM staff
ORDER BY salary DESC
LIMIT 5;

-- 3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
SELECT 
	post,
	SUM(salary) AS 'post_salary'
FROM staff
GROUP BY post;


-- 4. Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
SELECT COUNT(*) AS 'workers_from_24_to_49'
FROM staff
WHERE post = 'Рабочий' AND (age BETWEEN 24 AND 49); -- работает и без скобок, но мне так удобнее читать


-- 5.Найдите количество специальностей
SELECT COUNT(DISTINCT post) AS 'count_of_posts'
FROM staff;


-- 6. Выведите специальности, у которых средний возраст сотрудников меньше 30 лет
SELECT post FROM staff
GROUP BY post
HAVING AVG(age) < 30;
-- выведу показатели возраста для проверки
SELECT 
	post,
	AVG(age) AS 'avg_age' 
FROM staff
GROUP BY post
HAVING avg_age >= 30;


