SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET NAMES utf8;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0;
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:
USE vk;

-- 1. Создать и заполнить таблицы лайков и постов.
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(257 + RAND() * 405-257), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

-- Проверим
SELECT * FROM likes LIMIT 10;
-- Создадим таблицу постов
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



-- 2. Создать все необходимые внешние ключи и диаграмму отношений.
-- Для таблицы профилей

-- Смотрим структуру таблицы
DESC profiles;

-- Добавляем внешние ключи
ALTER TABLE profiles
	ADD CONSTRAINT profiles_user_id_fk 
		FOREIGN KEY (user_id) REFERENCES users(id)
		ON DELETE CASCADE,
 	ADD CONSTRAINT profiles_photo_id_fk
 		FOREIGN KEY (photo_id) REFERENCES media(id)
      	ON DELETE SET NULL;

ALTER TABLE profiles
	ADD CONSTRAINT profiles_status_id_fk
 		FOREIGN KEY (status_id) REFERENCES user_statuses(id)
      	ON DELETE SET NULL;
      
-- Изменяем тип столбца при необходимости
#ALTER TABLE profiles DROP FOREIGN KEY messages_to_user_id_fk;
ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;
      
-- Для таблицы сообщений

-- Смотрим структурв таблицы
DESC messages;

-- Добавляем внешние ключи
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

-- Для таблицы дружбы
-- Добавляем внешние ключи
ALTER TABLE friendships
  ADD CONSTRAINT user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friend_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT status_id_fk 
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);

-- Для таблицы communities_users
-- Добавляем внешние ключи
ALTER TABLE communities_users
  ADD CONSTRAINT comm_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT community_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id);

-- Для таблицы communities
-- Добавляем внешние ключи
ALTER TABLE communities
  ADD CONSTRAINT community_type_id_fk 
    FOREIGN KEY (community_type_id) REFERENCES community_types(id),
  ADD CONSTRAINT community_category_id_fk 
    FOREIGN KEY (community_category_id) REFERENCES community_categories(id);

-- Для таблицы posts_likes
-- Добавляем внешние ключи
ALTER TABLE posts_likes
  ADD CONSTRAINT post_id_fk 
    FOREIGN KEY (post_id) REFERENCES posts(id),
  ADD CONSTRAINT post_like_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id);
   
-- Для таблицы media_likes
-- Добавляем внешние ключи
ALTER TABLE media_likes
  ADD CONSTRAINT media_id_fk 
    FOREIGN KEY (id_media) REFERENCES media(id),
  ADD CONSTRAINT media_like_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id);

-- Для таблицы media
-- Добавляем внешние ключи
ALTER TABLE media
  ADD CONSTRAINT media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id);

   
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

