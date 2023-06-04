USE lesson_4;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), 
--     которые не старше 20 лет.
CREATE OR REPLACE VIEW young_users AS
(SELECT 
	u.id, 
	CONCAT(u.firstname, ' ', u.lastname) AS Users,
	p.hometown AS town,
	CASE p.gender
		WHEN 'f' THEN 'female'
		WHEN 'm' THEN 'male'
	END AS gender,
	ROUND(DATEDIFF(NOW(), p.birthday)/365) AS age
FROM users u
JOIN profiles p ON p.user_id = u.id
WHERE DATEDIFF(NOW(), p.birthday) < 20*365);

SELECT * FROM young_users;



-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователей, 
--    указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
--    (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
SELECT 
	u.id,
	CONCAT(u.firstname, ' ', u.lastname) AS Users,
	counter.counter,
	DENSE_RANK() OVER(ORDER BY counter.counter DESC) AS ranking
FROM users u 
JOIN (SELECT from_user_id, COUNT(id) AS counter
		FROM messages
		GROUP BY from_user_id) AS counter
ON u.id = counter.from_user_id;


-- p. s.  Сделал выборку количества сообщений через подзапрос, так как на прямую у меня не сортировалось по псевдониму
/*
  SELECT 
	u.id,
	CONCAT(u.firstname, ' ', u.lastname) AS Users,
	COUNT(m.id) AS counter,
	DENSE_RANK() OVER(ORDER BY counter DESC) AS ranking  -- выдает, что не знает поле counter
FROM users u 
JOIN messages m ON u.id = m.from_user_id
GROUP BY m.from_user_id;
 */


-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и найдите разницу 
--    дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)

SELECT 
	m.id,
	m.created_at,
	LAG(m.created_at) OVER() AS previous_message,
	TIMEDIFF(m.created_at, LAG(m.created_at) OVER()) AS time_difference -- а вот так получилось, не уверен, что это хорошая практика
FROM messages m 
ORDER BY m.created_at;