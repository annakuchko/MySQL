USE vk;
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;                  
UPDATE profiles SET photo_id = FLOOR(1 + RAND() * 100);
UPDATE profiles SET status_id = FLOOR(1 + RAND() * 2);
CREATE TEMPORARY TABLE genders (name CHAR(1));
INSERT INTO genders VALUES ('m'), ('f'); 
UPDATE profiles 
  SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);
 
UPDATE messages SET 
  from_user_id = FLOOR(1 + RAND() * 100),
  to_user_id = FLOOR(1 + RAND() * 100);
DELETE FROM media_types;
INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);
UPDATE media SET user_id = FLOOR(1 + RAND() * 100);
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');
UPDATE media SET filename = CONCAT(
  'http://dropbox.net/vk/',
  filename,
  (SELECT last_name FROM users ORDER BY RAND() LIMIT 1),
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;
UPDATE media SET metadata = (SELECT CONCAT(
	'{"owner":"', 
	REPLACE(first_name,'"', ''),
	" ", 
	REPLACE(last_name,'"', ''), 
	'"}') FROM users WHERE users.id = media.user_id);
UPDATE media SET created_at = NOW();
UPDATE media SET updated_at = NOW() WHERE updated_at<created_at;
ALTER TABLE media MODIFY COLUMN metadata JSON;
UPDATE friendships SET 
  user_id = FLOOR(1 + RAND() * 100),
  friend_id = FLOOR(1 + RAND() * 100);
UPDATE friendships SET friend_id = friend_id + 1 WHERE user_id = friend_id;
TRUNCATE friendship_statuses;
INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');
UPDATE friendships SET status_id = FLOOR(1 + RAND() * 3); 
DELETE FROM communities WHERE id > 20;
UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 20);