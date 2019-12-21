use vk1;
#1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.

CREATE INDEX messages_from_user_id_to_user_id ON messages(from_user_id, to_user_id);
CREATE INDEX users_first_name_last_name ON users(first_name, last_name);
CREATE INDEX communities_name ON communities(name);
CREATE INDEX friendship_user_id_friend_id ON friendship(user_id, friend_id);

#2. Задание на оконные функции
#Построить запрос, который будет выводить следующие столбцы:
#имя группы
#среднее количество пользователей в группах
#самый молодой пользователь в группе
#самый пожилой пользователь в группе
#общее количество пользователей в группе
#всего пользователей в системе
#отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT DISTINCT
	communities.name AS 'имя группы',
	COUNT(communities_users.user_id) OVER() / (SELECT COUNT(*) FROM communities) AS 'среднее количество пользователей в группах',
	FIRST_VALUE(CONCAT(users.first_name, ' ', users.last_name)) OVER(PARTITION BY communities.id ORDER BY profiles.birthday) AS 'самый молодой пользователь в группе',
	LAST_VALUE(CONCAT(users.first_name, ' ', users.last_name)) OVER(PARTITION BY communities.id ORDER BY profiles.birthday) AS 'самый пожилой пользователь в группе',
	COUNT(users.id) OVER(PARTITION BY communities.id) AS 'общее количество пользователей в группе',
	COUNT(users.id) OVER() AS 'всего пользователей в системе',
	COUNT(users.id) OVER(PARTITION BY communities.id) / COUNT(users.id) OVER() AS 'отношение в процентах'
	FROM (communities
		JOIN communities_users
			ON communities_users.community_id = communities.id
		JOIN users
			ON users.id = communities_users.user_id
		JOIN profiles
			ON profiles.user_id = users.id);

#3. (по желанию) Задание на денормализацию
#Разобраться как построен и работает следующий запрос:
#Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
SELECT users.id,
  COUNT(DISTINCT messages.id) +
  COUNT(DISTINCT likes.id) +
  COUNT(DISTINCT media.id) AS activity
  FROM users
    LEFT JOIN messages
      ON users.id = messages.from_user_id
    LEFT JOIN likes
      ON users.id = likes.user_id
    LEFT JOIN media
      ON users.id = media.user_id
  GROUP BY users.id
  ORDER BY activity
  LIMIT 10;