
-- 1. Составьте список пользователей users, которые осуществили 
-- хотя бы один заказ orders в интернет магазине.
USE shop;

SELECT name FROM users u WHERE (
	u.id IN (
		SELECT DISTINCT(user_id) FROM orders
	)
);

-- 2.Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT
	name,
	(
	SELECT
		name
	FROM
		catalogs
	WHERE
		catalogs.id = products.catalog_id) name_cat
FROM
	products;

-- 3.(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов
-- cities (label, name). Поля from, to и label содержат английские названия городов, поле 
-- name — русское. Выведите список рейсов flights с русскими названиями городов.

CREATE TABLE flights (
	id INT PRIMARY KEY,
	from_ VARCHAR(10),
	to_ VARCHAR(10)
);

INSERT INTO flights VALUES
  (1, 'moscow', 'omsk'),
  (2, 'novgorod', 'kazan'),
  (3, 'irkutsk', 'moscow'),
  (4, 'omsk', 'irkutsk'),
  (5, 'moscow', 'kazan');
  
 CREATE TABLE cities (
	label VARCHAR(10),
	name VARCHAR(10)
);
 
INSERT INTO cities VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');
 
 
SELECT id, (
	SELECT name FROM cities c WHERE 
		c.label=f.from_
	) from_, (
	SELECT name FROM cities c WHERE 
		c.label=f.to_
	) to_ 
FROM flights f;

 
