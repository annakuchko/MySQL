-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:
USE vk;

-- 1. Создать и заполнить таблицы лайков и постов.
-- Сделано в HW 3-4

-- 2. Создать все необходимые внешние ключи и диаграмму отношений.
-- Сделано в HW 3-4

-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

CREATE TEMPORARY TABLE likes_counts SELECT from_user_id FROM media_likes;

INSERT INTO likes_counts SELECT from_user_id FROM posts_likes;

ALTER TABLE likes_counts ADD gender char(1);

UPDATE likes_counts t1 
	INNER JOIN profiles t2 ON t1.from_user_id = t2.user_id
	SET t1.gender = t2.gender;

DELETE FROM likes_counts WHERE  isnull(gender);

SELECT gender, COUNT(*) AS cnt FROM likes_counts GROUP BY gender;
-- Женщины поставили меньше лайков, чем мужчины
-- ----------
-- | f | 152|
-- |--------|
-- | m | 170|
-- ----------

-- 4. Подсчитать количество лайков которые получили 10 самых молодых пользователей.
UPDATE media_likes SET id_media = FLOOR(1 + RAND() * 525);
UPDATE media SET user_id = FLOOR(257 + RAND() * 405-257);

#drop table media_likes_counts;
CREATE TEMPORARY TABLE media_likes_counts SELECT id_media FROM media_likes;
ALTER TABLE media_likes_counts ADD user_id INT UNSIGNED;

UPDATE media_likes_counts t1 
	INNER JOIN media t2 ON t1.id_media = t2.id
	SET t1.user_id = t2.user_id;

#drop table youth_likes;
CREATE TEMPORARY TABLE youth_likes SELECT id FROM users ORDER BY birthday DESC LIMIT 10;

SELECT COUNT(1) FROM (
	SELECT * FROM media_likes_counts AS T 
		WHERE(
			user_id IN (
				SELECT id FROM youth_likes AS T
			)
		)
	)
AS T;
-- два лайка получили 10 самых молодых пользователей
#drop table elderly_likes;
CREATE TEMPORARY TABLE elderly_likes SELECT id FROM users ORDER BY birthday LIMIT 10;

SELECT COUNT(1) FROM (
	SELECT * FROM media_likes_counts AS T 
		WHERE(
			user_id IN (
				SELECT id FROM elderly_likes AS T
			)
		)
	)
AS T;
-- один лайк получили 10 самых старых пользователей

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в
-- использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).
drop table activity;
drop table messages_act;
drop table media_likes_act;
drop table posts_likes_act;
drop table friends_act;
-- Рассчитаем для пользователей коэффициент активности, равный
-- 0.25 * число отправленных сообщений + 0.25 * число поставленных лайков на медиа +
-- + 0.25 * число лайков, поставленных на посты + 0,25 * число друзей


UPDATE messages SET from_user_id = FLOOR(257 + RAND() * 405-257);
UPDATE messages SET from_user_id = FLOOR(257 + RAND() * 405-257);
UPDATE media_likes SET from_user_id = FLOOR(257 + RAND() * 405-257);
UPDATE friendships SET user_id = FLOOR(257 + RAND() * 405-257);

-- Создаем таблицу, в которой будем хранить данные по различным статьям активности
CREATE TEMPORARY TABLE activity SELECT id from users;
-- Создаем таблицу с подсчетом числа отправленных сообщений каждым пользователем
CREATE TEMPORARY TABLE messages_act SELECT from_user_id as user_id, COUNT(*) AS n_messages FROM messages GROUP BY from_user_id;

-- В таблицу activity добавляем столбец с числом отправленных сообщений
ALTER TABLE activity ADD n_messages INT;
UPDATE activity t1 
	RIGHT JOIN messages_act t2 ON t1.id = t2.user_id
	SET t1.n_messages = t2.n_messages;

-- Создаем таблицу с подсчетом числа поставленных на медиа лайков
CREATE TEMPORARY TABLE media_likes_act SELECT 
	from_user_id as user_id, COUNT(*) AS
		n_media_likes FROM media_likes GROUP BY from_user_id;

-- В таблицу activity добавляем столбец с числом лайков, поставленных медиа
ALTER TABLE activity ADD n_media_likes INT;
UPDATE activity t1 
	RIGHT JOIN media_likes_act t2 ON t1.id = t2.user_id
	SET t1.n_media_likes = t2.n_media_likes;

-- Создаем таблицу с подсчетом числа поставленных на посты лайков
CREATE TEMPORARY TABLE posts_likes_act SELECT 
	from_user_id as user_id, COUNT(*) AS
		n_posts_likes FROM posts_likes GROUP BY from_user_id;

-- В таблицу activity добавляем столбец с числом лайков, поставленных постам
ALTER TABLE activity ADD n_posts_likes INT;
UPDATE activity t1 
	RIGHT JOIN posts_likes_act t2 ON t1.id = t2.user_id
	SET t1.n_posts_likes = t2.n_posts_likes;


-- Создаем таблицу с подсчетом числа друзей
CREATE TEMPORARY TABLE friends_act SELECT 
	user_id as user_id, COUNT(*) AS
		n_friends FROM friendships WHERE status_id=2 GROUP BY user_id;

-- В таблицу activity добавляем столбец с числом друзей
ALTER TABLE activity ADD n_friends INT;
UPDATE activity t1 
	RIGHT JOIN friends_act t2 ON t1.id = t2.user_id
	SET t1.n_friends = t2.n_friends;

-- В таблицу activity добавляем столбец с подсчетом рейтинга
ALTER TABLE activity ADD activity_rating FLOAT;
UPDATE activity SET 
	activity_rating = 
		COALESCE(n_messages,0)* 0.25 + 
		COALESCE(n_media_likes*0.25,0) + 
		COALESCE(n_posts_likes*0.25,0) + 
		COALESCE(n_friends*0.25,0);
	
-- Смотрим рейтинг 10 самых активных пользователей
select * from activity order by activity_rating DESC LIMIT 10;

