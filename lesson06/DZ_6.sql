USE vk;

# Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).

# Пусть задан некоторый пользователь. 
# Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
DESC vk.messages;

-- Все сообщения пользователя

(SELECT 
	from_user_id,
	COUNT(from_user_id) as message_number
FROM messages
WHERE to_user_id = 182
GROUP BY from_user_id
LIMIT 1)
UNION
(SELECT 
	to_user_id,
	COUNT(to_user_id) as message_number
FROM messages
WHERE from_user_id = 182
GROUP BY to_user_id)
ORDER BY message_number DESC
LIMIT 1;

# Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

-- Кол-во лайков у каждого из 10 самых молодых пользователей

SELECT 
target_id,
COUNT(*) as number_of_likes,
(SELECT birthday from vk.profiles where vk.profiles.user_id = l.target_id) AS birthday
from vk.likes l 
where target_type_id = (SELECT id from vk.target_types where name = 'user') 
GROUP BY target_id
ORDER by birthday DESC
LIMIT 10;


# Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT
'male' as gender,
COUNT(*) as like_numbers
from vk.likes
WHERE id IN (SELECT user_id from vk.profiles WHERE sex = 'm')
UNION
SELECT
'female' as gender,
COUNT(*) as like_numbers
from vk.likes
WHERE id IN (SELECT user_id from vk.profiles WHERE sex = 'f');

# Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

