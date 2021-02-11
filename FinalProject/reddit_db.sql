DROP DATABASE IF EXISTS reddit;
CREATE DATABASE reddit;
USE reddit;

-- Users table
DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Row id", 
  login VARCHAR(100) NOT NULL COMMENT "User name",
  avatar_id INT UNSIGNED COMMENT "Link to avatar photo",
  karma_count INT UNSIGNED COMMENT "Karma count",
  email VARCHAR(100) NOT NULL COMMENT "Email",
  status INT UNSIGNED COMMENT "User status",
  cake_day DATETIME COMMENT "User birthday date",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Users";  

ALTER TABLE users ADD CONSTRAINT chk_upd_date CHECK (
	date(updated_at)>=date(created_at)
);



-- Communities table
DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Row id",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  about TEXT NOT NULL COMMENT "Описание группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";


ALTER TABLE communities ADD CONSTRAINT chk_upd_date1 CHECK (
	date(updated_at)>=date(created_at)
);


-- Users-communities table
DROP TABLE IF EXISTS communities_users;
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Link to community id",
  user_id INT UNSIGNED NOT NULL COMMENT "Link to user id",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";

-- Chats table
DROP TABLE IF EXISTS chat;
CREATE TABLE chat(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  is_viewed BOOLEAN COMMENT "Признак прочтения",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Сообщения";

ALTER TABLE chat ADD CONSTRAINT chk_upd_date2 CHECK (
	date(updated_at)>=date(created_at)
);

-- Followers table
DROP TABLE IF EXISTS follow;
CREATE TABLE follow(
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на подписчика",
  followed_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на того, на кого подписались",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
  PRIMARY KEY (user_id, followed_user_id) COMMENT "Составной первичный ключ"
) COMMENT "Таблица фолловеров";

ALTER TABLE follow ADD CONSTRAINT chk_upd_date3 CHECK (
	date(updated_at)>=date(created_at)
);


-- Media table
DROP TABLE IF EXISTS media;
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который загрузил файл",
  filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
  size INT UNSIGNED NOT NULL COMMENT "Размер файла",
  metadata JSON COMMENT "Метаданные файла",
  media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип контента",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Медиафайлы";

ALTER TABLE media ADD CONSTRAINT chk_upd_date4 CHECK (
	date(updated_at)>=date(created_at)
);

	
-- Media types table
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";

ALTER TABLE media_types ADD CONSTRAINT chk_upd_date5 CHECK (
	date(updated_at)>=date(created_at)
);

-- Posts table
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Post id",
  author_id INT UNSIGNED NOT NULL COMMENT "Ссылка на создателя поста",
  content TEXT NOT NULL COMMENT "Текст поста", 
  hot_flg BOOLEAN COMMENT "Признак доставки",
  new_flg BOOLEAN COMMENT "New post flag",
  top_flg BOOLEAN COMMENT "Top post flag",
  id_media INT UNSIGNED COMMENT "Идентификатор прикрепленного медиафайла, если есть", 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания поста",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления поста"
) COMMENT "Посты";

ALTER TABLE posts ADD CONSTRAINT chk_upd_date6 CHECK (
	date(updated_at)>=date(created_at)
);


-- Таблица комментариев
DROP TABLE IF EXISTS comments;
CREATE TABLE comments(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Comment id",
  post_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пост",
  author_id INT UNSIGNED NOT NULL COMMENT "Ссылка на создателя комментария",
  content TEXT NOT NULL COMMENT "Текст комментария",  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания комментария",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления комментария"
) COMMENT "Комментарии";

ALTER TABLE posts ADD CONSTRAINT chk_upd_date7 CHECK (
	date(updated_at)>=date(created_at)
);


-- Таблица связи голосов и постов
DROP TABLE IF EXISTS posts_users;
CREATE TABLE posts_users (
  post_id INT UNSIGNED NOT NULL COMMENT "Link to post id",
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, поставившего оценку",
  vote_status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на vote-статус",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (post_id, from_user_id) COMMENT "Составной первичный ключ"
) COMMENT "Лайки апвоутов";


-- Таблица статусов воутов
DROP TABLE IF EXISTS vote_status;
CREATE TABLE vote_status (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Vote id",
  status VARCHAR(10) NOT NULL COMMENT "Статус голоса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления голоса"
) COMMENT "Голоса";

ALTER TABLE posts ADD CONSTRAINT chk_upd_date8 CHECK (
	date(updated_at)>=date(created_at)
);
INSERT INTO vote_status (status) VALUES ('upvote'),('downvote');


ALTER TABLE users 
	ADD CONSTRAINT avatar_id_fk
		FOREIGN KEY (avatar_id) REFERENCES media(id)
		ON DELETE CASCADE;
	
ALTER TABLE comments
	ADD CONSTRAINT post_id_fk
		FOREIGN KEY (post_id) REFERENCES posts(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT author_id_fk
		FOREIGN KEY (author_id) REFERENCES users(id)
		ON DELETE CASCADE;

ALTER TABLE communities_users
	ADD CONSTRAINT community_id_fk
		FOREIGN KEY (community_id) REFERENCES communities(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
		ON DELETE CASCADE;

ALTER TABLE posts_users
	ADD CONSTRAINT post_id_vote_fk
		FOREIGN KEY (post_id) REFERENCES posts(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT from_user_id_fk
		FOREIGN KEY (from_user_id) REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT vote_status_id_fk
		FOREIGN KEY (vote_status_id) REFERENCES vote_status(id)
		ON DELETE CASCADE;

ALTER TABLE follow
	ADD CONSTRAINT follower_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT followed_user_id_fk
		FOREIGN KEY (followed_user_id) REFERENCES users(id)
		ON DELETE CASCADE;

ALTER TABLE media
	ADD CONSTRAINT media_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT media_type_id_fk
		FOREIGN KEY (media_type_id) REFERENCES media_types(id)
		ON DELETE CASCADE;

ALTER TABLE posts
	ADD CONSTRAINT posts_author_id_fk
		FOREIGN KEY (author_id) REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT id_media_post_fk
		FOREIGN KEY (id_media) REFERENCES media(id)
		ON DELETE CASCADE;

ALTER TABLE chat
	ADD CONSTRAINT chat_from_user_id_fk
		FOREIGN KEY (from_user_id) REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT chat_to_user_id_fk
		FOREIGN KEY (to_user_id) REFERENCES users(id)
		ON DELETE CASCADE;


	
	
	

-- Logs triggers
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	tbl_name VARCHAR(50) NOT NULL,
	key_id INT(10) NOT NULL,
	value_content VARCHAR(50) NOT NULL
) ENGINE = ARCHIVE;

-- Users trigger
DROP TRIGGER IF EXISTS watchlog_users;
delimiter $$
CREATE TRIGGER watchlog_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, tbl_name, key_id, value_content)
	VALUES (NOW(), 'users', NEW.id, NEW.login);
END$$
delimiter ;

-- communities trigger
DROP TRIGGER IF EXISTS watchlog_communities;
delimiter $$
CREATE TRIGGER watchlog_catalogs AFTER INSERT ON communities
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, tbl_name, key_id, value_content)
	VALUES (NOW(), 'communities', NEW.id, NEW.name);
END$$
delimiter ;



CREATE UNIQUE INDEX users_email_uq ON users(email);
CREATE INDEX users_birthday_idx ON users(cake_day);
CREATE INDEX messages_from_user_id_to_user_id_idx ON chat(from_user_id, to_user_id);
CREATE UNIQUE INDEX comm_name_uq ON communities(name);
CREATE UNIQUE INDEX user_name_uq ON users(login);
CREATE UNIQUE INDEX post_votes_from_user_id_uq ON posts_users(post_id, from_user_id); 
