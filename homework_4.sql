USE lesson_4;

-- 1. Подсчитать общее количество лайков, которые получили пользователи
-- младше 12 лет.

SELECT 
	COUNT(l.id) AS likes_under_12
FROM likes l
JOIN profiles p ON p.user_id = l.user_id
WHERE DATEDIFF(NOW(), p.birthday) < 12*365;



-- 2. Определить кто больше поставил лайков (всего): мужчины или
-- женщины.

SELECT 
	CASE p.gender
		WHEN 'f' THEN 'женщины'
		WHEN 'm' THEN 'мужчины' END AS gender_case,
	COUNT(*) AS all_likes
FROM likes l
LEFT JOIN profiles p ON p.user_id = l.user_id 
GROUP BY gender_case;


-- 3. Вывести всех пользователей, которые не отправляли сообщения.

SELECT 
	CONCAT(u.firstname, ' ', u.lastname) AS dont_send_messages
FROM users u
WHERE u.id NOT IN 
(SELECT DISTINCT from_user_id FROM messages);


/*
4. (по желанию)* Пусть задан некоторый пользователь. Из всех друзей
этого пользователя найдите человека, который больше всех написал
ему сообщений.
*/


SELECT -- этот SELECT для красивого вывода
	u.id AS sender_id,
	CONCAT(u.firstname, ' ', u.lastname) AS best_sender,
	bs.counter AS messages_count
FROM users u 
JOIN  -- делаю таблицу, где известен id лучшего и количество сообщений
		(SELECT 
			m.from_user_id AS best_sender_id,
			COUNT(m.id) AS counter
		FROM messages m
		WHERE m.from_user_id IN -- вибираем друзей пользователя
						(SELECT target_user_id AS friends_id 
						FROM friend_requests 
						WHERE initiator_user_id = 5 -- вводим id пользователя вручную
						AND status = 'approved'
						UNION
						SELECT initiator_user_id AS friends_id 
						FROM friend_requests 
						WHERE target_user_id = 5 -- и тут вводим
						AND status = 'approved')
		GROUP BY best_sender_id 
		ORDER BY counter DESC
		LIMIT 1) AS bs
ON u.id = bs.best_sender_id;