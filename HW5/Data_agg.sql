USE vk;
-- 1. Подсчитайте средний возраст пользователей в таблице users.
ALTER TABLE users ADD birthday DATETIME DEFAULT NOW();
UPDATE users SET birthday = (SELECT DATE(DATE_SUB(NOW(), INTERVAL ROUND(RAND(1)*100) YEAR)));
SELECT AVG((YEAR(NOW())-YEAR(birthday))) from users;
 
-- 2. Подсчитайте количество дней рождения, которые приходятся на 
-- каждый из дней недели. Следует учесть, что необходимы дни недели 
-- текущего года, а не года рождения.
SELECT DAYOFWEEK(birthday) AS dayweek, COUNT(*) AS cnt FROM users GROUP BY dayweek;

-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.
CREATE TABLE tbl (
  value INT
 );
INSERT INTO tbl VALUES (1), (2), (3), (4), (5);
SELECT * FROM tbl;

SELECT ROUND(EXP(SUM(LOG(value))),1) FROM tbl;

DROP TABLE tbl;



