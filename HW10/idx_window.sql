use vk;
-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы 
-- приложения и добавить необходимые индексы.

-- CREATE UNIQUE INDEX users_email_uq ON users(email);
-- CREATE UNIQUE INDEX users_phone_uq ON users(phone);
-- CREATE INDEX users_birthday_idx ON users(birthday);
-- CREATE INDEX messages_from_user_id_to_user_id_idx ON messages (from_user_id, to_user_id);

CREATE INDEX comm_name_idx ON communities(name);
CREATE INDEX friend_request_user_id_friend_id_idx ON friendships (user_id, friend_id, status_id);-- индекс статуса дружбы между двумя пользователями
CREATE UNIQUE INDEX post_likes_from_user_id_uq ON posts_likes(post_id, from_user_id); -- один пользователь может поставить только один лайк на пост. Можно отслеживать, кто и что лайкнул))


-- 2. Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы: 
-- имя группы 
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе 
-- самый старший пользователь в группе 
-- общее количество пользователей в группе 
-- всего пользователей в системе 
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
use vk;
select * from communities;
select * from profiles;


SELECT
	DISTINCT communities.name AS comm_name,
	COUNT(communities_users.user_id) OVER() / (
	SELECT
		COUNT(*)
	FROM
		communities) AS avg_users_in_comms,
	FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name)) OVER w_community_birthday_desc AS youngest,
	FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name)) OVER w_community_birthday_asc AS oldest,
	COUNT(communities_users.user_id) OVER w_community AS users_in_group,
	(
	SELECT
		COUNT(*)
	FROM
		users) AS users_total,
	COUNT(communities_users.user_id) OVER w_community / (
	SELECT
		COUNT(*)
	FROM
		users) * 100 AS '%%'
FROM
	communities
LEFT JOIN communities_users ON
	communities_users.community_id = communities.id
LEFT JOIN users ON
	communities_users.user_id = users.id
LEFT JOIN profiles ON
	profiles.user_id = users.id WINDOW w_community AS (PARTITION BY communities.id),
	w_community_birthday_desc AS (PARTITION BY communities.id
ORDER BY
	users.birthday DESC),
	w_community_birthday_asc AS (PARTITION BY communities.id
ORDER BY
	users.birthday);
             
            
            
            
            