CREATE UNIQUE INDEX users_email_uq ON users(email);
CREATE INDEX users_birthday_idx ON users(cake_day);
CREATE INDEX messages_from_user_id_to_user_id_idx ON chat(from_user_id, to_user_id);
CREATE UNIQUE INDEX comm_name_uq ON communities(name);
CREATE UNIQUE INDEX user_name_uq ON users(login);
CREATE UNIQUE INDEX post_votes_from_user_id_uq ON posts_users(post_id, from_user_id); 
