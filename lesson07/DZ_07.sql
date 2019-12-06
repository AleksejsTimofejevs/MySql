SELECT * FROM users;
SELECT * FROM orders;

-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT DISTINCT u.id, u.name
FROM users as u JOIN orders as o
ON u.id = o.user_id;

SELECT * FROM products;
SELECT * FROM catalogs;

-- Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT p.id, p.name, c.name
FROM products AS p
JOIN catalogs AS c
ON p.catalog_id = c.id;

-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

-- Создаем таблицы flights и cities и заполняем их данными
DROP TABLE if EXISTS flights;
CREATE TABLE flights(
	id SERIAL PRIMARY key,
	from1 varchar(255) NOT NULL,
	to1 varchar(255) NOT NULL
);

INSERT INTO flights
(from1, to1)
VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

DROP TABLE if EXISTS cities;
CREATE TABLE cities(
	label varchar(255) NOT NULL,
	name varchar(255) NOT NULL
);

INSERT INTO cities
VALUES
('moscow', 'Mocква'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

SELECT * FROM flights;
SELECT * FROM cities;

-- Сам запрос
SELECT
(SELECT name from cities where label = f.from1) AS 'from',
c.name AS 'to'
FROM
flights as f
JOIN
cities as c
on f.to1 = c.label;

