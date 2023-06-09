USE lesson_4;

DROP PROCEDURE IF EXISTS rand_5;
DELIMITER //
CREATE PROCEDURE rand_5 (user_id INT)
BEGIN 
	WITH friends AS (SELECT target_user_id AS friends_id 
						FROM friend_requests 
						WHERE initiator_user_id = user_id AND status = 'approved'
						UNION
						SELECT initiator_user_id AS friends_id 
						FROM friend_requests 
						WHERE target_user_id = user_id AND status = 'approved')
		SELECT 
			p.user_id
		FROM profiles p 
		JOIN profiles p1 ON p.hometown = p1.hometown
		WHERE p1.user_id = user_id AND p.user_id != user_id
	UNION 
		SELECT 
			uc.user_id
		FROM users_communities uc 
		WHERE uc.community_id IN (SELECT uc1.community_id FROM users_communities uc1 WHERE uc1.user_id = user_id)
	UNION 
		SELECT fr.target_user_id AS fr_id 
				FROM friend_requests fr
				JOIN friends f ON fr.initiator_user_id = f.friends_id
				WHERE fr.target_user_id != user_id AND status = 'approved'
		UNION
				SELECT fr.initiator_user_id AS fr_id 
				FROM friend_requests fr
				JOIN friends f ON fr.initiator_user_id = f.friends_id
				WHERE fr.initiator_user_id = user_id AND status = 'approved' 
	ORDER BY RAND()
	LIMIT 5;
END //
DELIMITER ;

CALL rand_5(1);

DROP FUNCTION IF EXISTS friendship_direction;
DELIMITER //
CREATE FUNCTION friendship_direction(check_user_id BIGINT)
RETURNS FLOAT READS SQL DATA
BEGIN
	DECLARE requests_to_user INT; -- заявок к пользователю
	DECLARE requests_from_user INT; -- заявок от пользователя
SET requests_to_user = (SELECT count(*) FROM friend_requests
WHERE target_user_id = check_user_id);
SELECT count(*) INTO requests_from_user
FROM friend_requests WHERE initiator_user_id = check_user_id;
RETURN requests_to_user / requests_from_user;
END//
DELIMITER ;