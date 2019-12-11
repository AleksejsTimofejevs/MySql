use vk1;


# Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

-- Все сообщения пользователя со своими друзьями
SELECT users.id, friendship.user_id, friendship.friend_id, friendship.status_id, messages.body
FROM users
JOIN vk.friendship
ON (users.id = friendship.user_id OR users.id = friendship.friend_id)
LEFT JOIN vk.messages
ON ((friendship.user_id = messages.from_user_id AND friendship.friend_id = messages.to_user_id) or (friendship.friend_id = messages.from_user_id AND friendship.user_id = messages.to_user_id))
where users.id = 14 and friendship.status_id = 2;

# Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.


SELECT users.id, profiles.birthday, COUNT(likes.target_id) AS likes_number
FROM users
	JOIN vk.profiles
		ON (users.id = profiles.user_id)
	LEFT JOIN vk.likes
		ON (users.id = likes.target_id and likes.target_type_id = 2)
	GROUP BY users.id
	ORDER BY profiles.birthday DESC
	LIMIT 10
;

# Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT profiles.sex, COUNT(likes.user_id) as likes_number
FROM users
	JOIN vk.profiles
		ON (users.id = profiles.user_id)
	JOIN vk.likes
		ON (users.id = likes.user_id)
	GROUP BY profiles.sex
;

-- Добавление внешних ключей таблице медиа

ALTER TABLE media
	ADD CONSTRAINT media_media_type_id_fk
		FOREIGN KEY (media_type_id)
		REFERENCES media_types(id);
	
ALTER TABLE media
	ADD CONSTRAINT media_user_id_fk
		FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE CASCADE;
	
-- Добавление внешних ключей таблице сообщений

ALTER TABLE messages
	ADD CONSTRAINT messages_attached_media_id_fk
		FOREIGN KEY (attached_media_id)
		REFERENCES media(id)
		ON DELETE SET NULL;

-- Добавление внешних ключей таблице friendship

ALTER TABLE friendship
	ADD CONSTRAINT friendship_user_id_fk
		FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT friendship_friend_id_fk
		FOREIGN KEY (friend_id)
		REFERENCES users(id)
		ON DELETE CASCADE;
	
ALTER TABLE friendship
	ADD CONSTRAINT friendship_status_id_fk
		FOREIGN KEY (status_id)
		REFERENCES friendship_statuses(id)
		ON DELETE RESTRICT;

-- Добавление внешних ключей таблице likes (не до конца понял как сделать ключ к target_id
	
ALTER TABLE likes
	ADD CONSTRAINT likes_user_id_fk
		FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE CASCADE;
	
ALTER TABLE likes	
	ADD CONSTRAINT likes_target_type_id_fk
		FOREIGN KEY (target_type_id)
		REFERENCES target_types(id)
		ON DELETE CASCADE;

ALTER TABLE vk1.likes MODIFY COLUMN like_type_id int(10) unsigned NULL;

ALTER TABLE likes
	ADD CONSTRAINT likes_like_type_id_fk
		FOREIGN KEY (like_type_id)
		REFERENCES like_types(id)
		ON DELETE SET NULL;

-- Добавление внешних ключей таблице communities_users

ALTER TABLE communities_users
	ADD CONSTRAINT communities_users_community_id_fk
		FOREIGN KEY (community_id)
		REFERENCES communities(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT communities_users_user_id_fk
		FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE CASCADE;
	
-- Добавление внешних ключей таблице communities

ALTER TABLE communities
	ADD CONSTRAINT communities_user_id_fk
		FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE SET NULL;

-- Добавление внешних ключей таблице posts

ALTER TABLE posts
	ADD CONSTRAINT posts_user_id_fk
		FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT posts_attached_media_id_fk
		FOREIGN KEY (attached_media_id)
		REFERENCES media(id)
		ON DELETE SET NULL;
	
-- Добавление внешних ключей таблице relations

ALTER TABLE relations
	ADD CONSTRAINT relations_user_id_fk
		FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT relations_relative_id_fk
		FOREIGN KEY (relative_id)
		REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT relations_relation_status_id_fk
		FOREIGN KEY (relation_status_id)
		REFERENCES relation_statuses(id)
		ON DELETE RESTRICT;
	


	




