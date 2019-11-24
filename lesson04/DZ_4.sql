-- Урок 4


-- Дорабатываем данные пола в таблице профили
CREATE TEMPORARY TABLE sex (sex CHAR(1));
INSERT INTO sex VALUES ('m'), ('f');
UPDATE profiles SET sex = (SELECT sex FROM sex ORDER BY RAND() LIMIT 1);


-- Дорабатываем данные пользователей в таблице сообщения
UPDATE messages SET
  from_user_id = FLOOR(1 + (RAND() * 200)),
  to_user_id = FLOOR(1 + (RAND() * 200))
;

-- Дорабатываем данные в таблице типы медиа
DELETE FROM media_types;
TRUNCATE media_types;
INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

-- Дорабатываем данные в таблице медиа и саму таблицу
UPDATE media SET media_type_id = FLOOR(1 + (RAND() * 3));
UPDATE media SET user_id = FLOOR(1 + (RAND() * 200));
UPDATE media SET metadata = CONCAT('{"', filename, '":"', size, '"}');
ALTER TABLE media MODIFY COLUMN metadata JSON;

-- Дорабатываем данные в таблице статусы дружбы
TRUNCATE friendship_statuses;
INSERT INTO friendship_statuses (name) VALUES
  ('requested'), 
  ('approved'), 
  ('rejected')
;

-- Дорабатываем данные в таблице дружба
UPDATE friendship SET status_id = FLOOR(1 + (RAND() * 3));
UPDATE friendship SET
  user_id = FLOOR(1 + (RAND() * 200)),
  friend_id = FLOOR(1 + (RAND() * 200))
;

-- Дорабатываем таблицу users
ALTER TABLE users ADD COLUMN is_banned BOOLEAN DEFAULT FALSE AFTER phone;
ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT  TRUE AFTER is_banned;

UPDATE users SET is_banned = TRUE WHERE id IN (12, 56, 66, 83, 121, 156, 178, 194);
UPDATE users SET is_active = FALSE WHERE id IN (8, 32, 77, 98, 101, 107, 148, 184, 187, 199);


-- Дорабатываем таблицу сообщества

ALTER TABLE communities ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER name;
ALTER TABLE communities ADD COLUMN is_closed BOOLEAN DEFAULT FALSE AFTER created_at;
ALTER TABLE communities ADD COLUMN closed_at TIMESTAMP AFTER is_closed;

UPDATE communities SET is_closed = TRUE WHERE id IN (3, 14, 27, 46);
UPDATE communities SET closed_at = NOW() WHERE is_closed IS TRUE;

-- Дорабатываем таблицу пользователь_сообщество

ALTER TABLE communities_users ADD column is_banned BOOLEAN DEFAULT FALSE AFTER user_id;
ALTER TABLE communities_users ADD column is_admin BOOLEAN DEFAULT FALSE AFTER user_id;

UPDATE communities_users SET is_banned = TRUE WHERE user_id IN (8, 65, 87);
UPDATE communities_users SET is_admin = TRUE WHERE user_id IN (1, 56, 74, 12, 34);


-- Дорабатываем таблицу сообщения

ALTER TABLE messages ADD COLUMN header VARCHAR(255) AFTER to_user_id;
UPDATE messages SET header = SUBSTRING(body, 1, 30);
ALTER TABLE messages ADD column attached_media_id INT UNSIGNED AFTER body;
UPDATE messages SET attached_media_id = (
  SELECT id FROM media WHERE user_id = from_user_id LIMIT 1
);

-- Создаем таблицу отношений

CREATE TABLE relations (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  relative_id INT UNSIGNED NOT NULL,
  relation_status_id INT UNSIGNED NOT NULL
);

-- Создаем таблицу статусов отношений
CREATE TABLE relation_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100)
);

INSERT INTO relation_statuses (name) VALUES 
  ('son'),
  ('daughter'),
  ('mother'),
  ('father'),
  ('wife'),
  ('husband')
;

INSERT INTO relations 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 200)), 
    FLOOR(1 + (RAND() * 200)),
    FLOOR(1 + (RAND() * 6)) 
  FROM users;
 
 -- Реализация лайков
DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes` (
  `user_id` int(10) unsigned NOT NULL,
  `media_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`, `media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
