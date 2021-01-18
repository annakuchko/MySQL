USE vk;
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.
UPDATE users SET created_at = NOW();
UPDATE users SET updated_at = NOW();


-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at 
-- были заданы типом VARCHAR и в них долгое время помещались значения в формате 
-- 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив 
-- введённые ранее значения.

ALTER TABLE users MODIFY COLUMN created_at DATETIME;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME;

-- UPDATE users SET created_at = (
-- 	SELECT DATE_FORMAT(
-- 		STR_TO_DATE(
-- 			created_at, '%Y-%m-%d %H:%m:%s'
-- 		),
-- 	'%d-%m-%Y %H:%m:%s')
-- );


-- 3. В таблице складских запасов storehouses_products в поле value могут 
-- встречаться самые разные цифры: 0, если товар закончился и выше нуля, если 
-- на складе имеются запасы. Необходимо отсортировать записи таким образом, 
-- чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы
-- должны выводиться в конце, после всех записей.

CREATE TABLE storehousees_products (
  value INT
 );
INSERT INTO storehousees_products VALUES (0), (2500), (0), (30), (500), (1);
SELECT * from storehousees_products;
SELECT value from storehousees_products ORDER BY value=0, value;
DROP TABLE storehousees_products;

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august)
SELECT * FROM users WHERE id IN (
	SELECT user_id FROM profiles WHERE 
		(MONTHNAME(birthday) ='August') or (MONTHNAME(birthday) ='January')
);


-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, 
-- заданном в списке IN.

USE shop;
INSERT INTO catalogs VALUES (4, 'Жесткие диски'), (5, "Ноутбуки"), (6, "Картриджи");
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);
