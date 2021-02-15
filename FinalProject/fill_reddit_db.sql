USE reddit;
LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/users.csv' 
INTO TABLE users FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/communities.csv' 
INTO TABLE communities FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/communities_users.csv' 
INTO TABLE communities_users FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/chat.csv' 
INTO TABLE chat FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/follow.csv' 
INTO TABLE follow FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/media.csv' 
INTO TABLE media FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/posts.csv' 
INTO TABLE posts FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/comments.csv' 
INTO TABLE comments FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb_reddit/posts_users.csv' 
INTO TABLE posts_users FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

--
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
  'http://temp.com/reddit/',
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
