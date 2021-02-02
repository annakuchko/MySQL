use shop;
-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в 
-- таблицах users, catalogs и products в таблицу logs помещается время и дата 
-- создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

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
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END$$
delimiter ;

-- catalogs trigger
DROP TRIGGER IF EXISTS watchlog_catalogs;
delimiter $$
CREATE TRIGGER watchlog_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, tbl_name, key_id, value_content)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END$$
delimiter ;


-- products trigger
DROP TRIGGER IF EXISTS watchlog_products;
delimiter $$
CREATE TRIGGER watchlog_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, tbl_name, key_id, value_content)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END$$
delimiter ;

