-- Общее текстовое описание БД и решаемых ею задач:
-- Данная БД является упрощенной версией модели хранения данных различных платформ по доставке готовой еды из ресторанов (Delivery Club, Yandex Еда и т.д.)

DROP DATABASE delivery_club;
CREATE DATABASE delivery_club;
use delivery_club;

-- Создаем таблицу ресторанов
DROP TABLE IF EXISTS restaurants;

CREATE TABLE restaurants (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(150) NOT NULL,
  adress  VARCHAR(255) NOT NULL,
  description TEXT,
  city ENUM ('Moscow', 'Saint Petersburg'),
  phone VARCHAR(120) NOT NULL UNIQUE,
  open_at TIME NOT NULL,
  close_at TIME NOT NULL
);

-- Создаем таблицу категорий еды
DROP TABLE IF EXISTS food_categories;

CREATE TABLE food_categories (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name varchar (150) NOT NULL
);

-- Создаем таблицу меню
DROP TABLE IF EXISTS menu;

CREATE TABLE menu(
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  course_name VARCHAR(100) NOT NULL,
  price SMALLINT UNSIGNED NOT NULL,
  description TEXT,
  food_category_id INT UNSIGNED NOT NULL,
  restaurant_id INT UNSIGNED NOT NULL,
  is_available BOOLEAN DEFAULT TRUE,
  image_id INT UNSIGNED NOT NULL
);

-- Создаем таблицу картинок
DROP TABLE IF EXISTS images;

CREATE TABLE images (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	image_type ENUM ('jpg', 'png'),
    image blob not null,
    image_name varchar(50) not null default ''
);

-- Создаем таблицу пользователей
DROP TABLE IF EXISTS users;

CREATE TABLE users(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	sex CHAR(1) NOT NULL,
	birthday DATE,
	phone VARCHAR(120) NOT NULL UNIQUE,
	mail VARCHAR(120) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- Создаем таблицу адресов пользователей
DROP TABLE IF EXISTS user_addresses;

CREATE TABLE user_addresses(
	user_id INT UNSIGNED NOT NULL,
	city ENUM ('Moscow', 'Saint Petersburg'),
	address varchar(255) NOT NULL
);

-- Создаем таблицу заказов
DROP TABLE IF EXISTS orders;

CREATE TABLE orders(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
	address_id INT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	is_confirmed CHAR(1) NOT NULL,
	condirmed_at DATETIME,
	promo_id INT UNSIGNED,
	courier_id INT UNSIGNED
);

-- Создаем таблицу блюдо_заказ

DROP TABLE IF EXISTS course_orders;

CREATE TABLE course_orders(
	course_id INT UNSIGNED NOT NULL,
	order_id INT UNSIGNED NOT NULL
);

-- Таблица промоакций
DROP TABLE IF EXISTS promocodes;

CREATE TABLE promocodes(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	discount TINYINT UNSIGNED NOT NULL,
	start_date DATETIME DEFAULT NOW(),
	end_date DATETIME
);

-- Таблица курьеров
DROP TABLE IF EXISTS couriers;

CREATE TABLE couriers(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	nationality VARCHAR(100) NOT NULL,
	passport VARCHAR(100) NOT NULL,
	sex CHAR(1) NOT NULL,
	birthday DATE,
	city ENUM ('Moscow', 'Saint Petersburg'),
	phone VARCHAR(120) NOT NULL UNIQUE,
	mail VARCHAR(120) NOT NULL UNIQUE
);

-- Таблица отзывов
DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
	order_id INT UNSIGNED NOT NULL,
	mark TINYINT UNSIGNED NOT NULL,
	comment TEXT,
	created_at DATETIME DEFAULT NOW()
);

