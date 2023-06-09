USE lesson_4;

/*  1.
 Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой можно переместить любого (одного) 
 пользователя из таблицы users в таблицу users_old. (использование транзакции с выбором commit или rollback – обязательно).
*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE
);


DROP PROCEDURE IF EXISTS remove_user;
DELIMITER //
CREATE PROCEDURE remove_user (users_id BIGINT)
BEGIN
	IF users_id IN (SELECT DISTINCT id FROM users) -- маленькая проверка
	THEN
		INSERT INTO users_old (firstname, lastname, email) SELECT firstname, lastname, email FROM users WHERE id = users_id;
		DELETE FROM users WHERE id = users_id;
		COMMIT;
	ELSE SELECT "BAD ID";
	END IF;
END//
DELIMITER ;

-- TRUNCATE TABLE users_old; -- для очистки таблицы

CALL remove_user(3);
-- возврат товарища обратно в группу users
-- INSERT INTO users (id, firstname, lastname, email) VALUES (3, "Nancey", "Drew", "nancy_fa@ups.com");  

/*
 Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
 С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
 */
DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello ()
RETURNS VARCHAR(50) READS SQL DATA
BEGIN
	DECLARE current_hour INT;
	DECLARE answer VARCHAR(50);
	SET current_hour = HOUR(NOW());
	SET answer = IF(current_hour BETWEEN 0 AND 5, "ДОБРОЙ НОЧИ!", 
						IF (current_hour BETWEEN 6 AND 11, "ДОБРОЕ УТРО!", 
								IF (current_hour BETWEEN 12 AND 17, "ДОБРЫЙ ДЕНЬ!", "ДОБРЫЙ ВЕЧЕР!")));
	RETURN answer;
END//
DELIMITER ;

SELECT hello();

/*
 (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
 communities и messages в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа.
 */

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	create_time DATETIME NOT NULL,
	table_name VARCHAR(30) NOT NULL,
	id_prime_key BIGINT NOT NULL
) ENGINE=ARCHIVE;

-- так как мои знания не позволяют мне сделать по другому - я создам три триггера для каждой группы


DROP TRIGGER if exists logging_communities;
DELIMITER //
CREATE TRIGGER logging_communities AFTER INSERT ON communities
FOR EACH ROW
BEGIN
    INSERT INTO logs (create_time, table_name, id_prime_key) 
    VALUES (CURRENT_TIMESTAMP(), "communities", (SELECT MAX(id) FROM communities));
END//
DELIMITER ;

DROP TRIGGER if exists logging_messages;
DELIMITER //
CREATE TRIGGER logging_messages AFTER INSERT ON messages
FOR EACH ROW
BEGIN
    INSERT INTO logs (create_time, table_name, id_prime_key) 
    VALUES (CURRENT_TIMESTAMP(), "messages", (SELECT MAX(id) FROM messages));
END//
DELIMITER ;


DROP TRIGGER if exists logging_users;
DELIMITER //
CREATE TRIGGER logging_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO logs (create_time, table_name, id_prime_key) 
    VALUES (CURRENT_TIMESTAMP(), "users", (SELECT MAX(id) FROM users));
END//
DELIMITER ;

-- проверочка

INSERT INTO communities (name) VALUES ("flowers");
INSERT INTO messages (from_user_id, to_user_id, body, created_at) VALUES (11, 8, "yankees go go", NOW());
INSERT INTO users (firstname, lastname, email) VALUES ("Luke", "Like", "msadfjhkfa@fnskfj.com");

