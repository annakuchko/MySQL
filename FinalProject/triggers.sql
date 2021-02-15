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
