-- Примеры на основе базы данных vk
USE vk;

-- Получаем данные пользователя
SELECT * FROM users WHERE id = 288;

SELECT first_name, last_name, 'city', 'main_photo' FROM users WHERE id = 288;

SELECT
  first_name,
  last_name,
  (SELECT city FROM profiles WHERE user_id = 288) AS city,
  (SELECT filename FROM media WHERE id = 
    (SELECT photo_id FROM profiles WHERE user_id = 288)
  ) AS file_path
  FROM users
    WHERE id = 288;


-- Дорабатывем условия    
SELECT
  first_name,
  last_name,
  (SELECT city FROM profiles WHERE user_id = users.id) AS city,
  (SELECT filename FROM media WHERE id = 
    (SELECT photo_id FROM profiles WHERE user_id = users.id)
  ) AS file_path
  FROM users
    WHERE id = 288;          

 
 
   -- Получаем фотографии пользователя
SELECT filename FROM media
  WHERE user_id = 288
    AND media_type_id = (
      SELECT id FROM media_types WHERE name = 'image'
    );

   
   -- Выбираем историю по добавлению фотографий пользователем
SELECT CONCAT(
  'Пользователь ', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = media.user_id),
  ' добавил фото ', 
  filename, ' ', 
  created_at) AS news 
    FROM media 
    WHERE user_id = 288 AND media_type_id = (
        SELECT id FROM media_types WHERE name = 'image'
);

-- Найдём кому принадлежат 10 самых больших медиафайлов
SELECT user_id, filename, size 
  FROM media 
  ORDER BY size DESC
  LIMIT 10;

-- Улучшим запрос и используем алиасы для имён таблиц
SELECT 
  (SELECT CONCAT(first_name, ' ', last_name) 
    FROM users u WHERE u.id = m.user_id) AS owner,
  filename, 
  size 
    FROM media m
    ORDER BY size DESC
    LIMIT 10;
  
 -- Выбираем друзей пользователя с двух сторон отношения дружбы
(SELECT friend_id FROM friendships WHERE user_id = 288)
UNION
(SELECT user_id FROM friendships WHERE friend_id = 288);

-- Выбираем только друзей с активным статусом
SELECT * FROM friendship_statuses;
select * from friendships;

(SELECT friend_id 
  FROM friendships 
  WHERE user_id = 293 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
    )
)
UNION
(SELECT user_id 
  FROM friendships 
  WHERE friend_id = 293 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
    )
);


-- Выбираем медиафайлы друзей
SELECT filename FROM media WHERE user_id IN (
  (SELECT friend_id 
  FROM friendships
  WHERE user_id = 293 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
    )
  )
  UNION
  (SELECT user_id 
    FROM friendships 
    WHERE friend_id = 293 AND status_id = (
      SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
    )
  )
);

-- Определяем пользователей, общее занимаемое место медиафайлов которых 
-- превышает 100МБ

select * from media;
SELECT user_id, SUM(size) AS total
  FROM media
  GROUP BY user_id
  HAVING total > 100000000;
  
-- С итогами  
SELECT user_id, SUM(size) AS total
  FROM media
  GROUP BY user_id WITH ROLLUP
  HAVING total > 100000000;  
    
-- Выбираем сообщения от пользователя и к пользователю
SELECT from_user_id, to_user_id, body, is_delivered, created_at 
  FROM messages
    WHERE from_user_id = 288 OR to_user_id = 288
    ORDER BY created_at DESC;
    
-- Сообщения со статусом
SELECT from_user_id, 
  to_user_id, 
  body, 
  IF(is_delivered, 'delivered', 'not delivered') AS status 
    FROM messages
      WHERE (from_user_id = 290 OR to_user_id = 290)
    ORDER BY created_at DESC;
    
-- Поиск пользователя по шаблонам имени  
select * users;
SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM users
  WHERE first_name LIKE 'M%';
  
-- Используем регулярные выражения
SELECT CONCAT(first_name, ' ', last_name) AS fullname  
  FROM users
  WHERE last_name RLIKE '^K.*r$';