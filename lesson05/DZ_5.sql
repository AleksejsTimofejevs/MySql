USE DATABASE test;

-- 1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
update users set created_at = NOW();
update users set updated_at  = NOW();

-- 2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
update users set created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i');
update users set updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');

-- 3.В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

SELECT * from storehouses_products ORDER BY CASE WHEN value = 0 THEN (SELECT max(value)+1 from communities_users) ELSE value END;

-- 4.(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
SELECT * FROM users WHERE birthday in ('may', 'august');

-- 5.(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.



-- 1.Подсчитайте средний возраст пользователей в таблице users

use vk;
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday, NOW())) FROM vk.profiles;

-- 2.Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT DAYNAME(CAST(CONCAT(YEAR(NOW()), '-', MONTH(birthday), '-', DAYOFMONTH(birthday)) AS DATE)) AS BD_THIS_YEAR, COUNT(*) from profiles GROUP BY BD_THIS_YEAR WITH ROLLUP;

-- 3.(по желанию) Подсчитайте произведение чисел в столбце таблицы


