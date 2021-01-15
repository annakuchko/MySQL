USE vk;
LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/users.csv' 
INTO TABLE users FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/profiles.csv' 
INTO TABLE profiles FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/messages.csv' 
INTO TABLE messages FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/friendship.csv' 
INTO TABLE friendship FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/friendship_statuses.csv' 
INTO TABLE friendship_statuses FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/communities.csv' 
INTO TABLE communities FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/community_types.csv' 
INTO TABLE community_types FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/community_categories.csv' 
INTO TABLE community_categories FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/communities_users.csv' 
INTO TABLE communities_users FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/media.csv' 
INTO TABLE media FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/media_types.csv' 
INTO TABLE media_types FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/posts.csv' 
INTO TABLE posts FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/media_likes.csv' 
INTO TABLE media_likes FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';

LOAD DATA LOCAL INFILE '/home/db/nmt/filldb/posts_likes.csv' 
INTO TABLE posts_likes FIELDS TERMINATED BY ',' LINES
TERMINATED BY '\n';