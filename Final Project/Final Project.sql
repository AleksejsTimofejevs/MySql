-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- Общее текстовое описание БД и решаемых ею задач:
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Данная БД является упрощенной версией модели хранения данных различных платформ по доставке готовой еды из ресторанов (Delivery Club, Yandex Еда и т.д.)

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Cоздание таблиц
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

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
	price DECIMAL UNSIGNED NOT NULL,
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
    image blob not null,
    image_name varchar(50) not null default ''
);

-- Создаем таблицу пользователей
DROP TABLE IF EXISTS users;

CREATE TABLE users(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	sex ENUM ('M', 'F') NOT NULL,
	birthday DATE,
	phone VARCHAR(120) NOT NULL UNIQUE,
	mail VARCHAR(120) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- Создаем таблицу адресов пользователей
DROP TABLE IF EXISTS addresses;

CREATE TABLE addresses(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
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
	courier_id INT UNSIGNED NOT NULL
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
	sex ENUM ('M', 'F') NOT NULL,
	birthday DATE,
	city ENUM ('Moscow', 'Saint Petersburg'),
	phone VARCHAR(120) NOT NULL UNIQUE,
	mail VARCHAR(120) NOT NULL UNIQUE
);

-- Таблица отзывов
DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	order_id INT UNSIGNED NOT NULL,
	mark TINYINT UNSIGNED NOT NULL,
	comment TEXT,
	created_at DATETIME DEFAULT NOW()
);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Добавляем внешние ключи
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Таблица orders
ALTER TABLE orders
	ADD CONSTRAINT orders_user_id_fk
		FOREIGN KEY (user_id)
		REFERENCES users(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT orders_address_id_fk
		FOREIGN KEY (address_id)
		REFERENCES addresses(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT orders_promo_id_fk
		FOREIGN KEY (promo_id)
		REFERENCES promocodes(id)
		ON DELETE SET NULL,
	ADD CONSTRAINT orders_courier_id_fk
		FOREIGN KEY (courier_id)
		REFERENCES couriers(id)
		ON DELETE CASCADE;

-- Таблица course_orders

ALTER TABLE course_orders
	ADD CONSTRAINT course_orders_course_id_fk
		FOREIGN KEY (course_id)
		REFERENCES menu(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT course_orders_order_id_fk
		FOREIGN KEY (order_id)
		REFERENCES orders(id)
		ON DELETE CASCADE;
	
-- Таблица menu

ALTER TABLE menu
	ADD CONSTRAINT menu_food_category_id_fk
		FOREIGN KEY (food_category_id)
		REFERENCES food_categories(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT menu_restaurant_id_fk
		FOREIGN KEY (restaurant_id)
		REFERENCES restaurants(id)
		ON DELETE CASCADE,
	ADD CONSTRAINT menu_image_id_fk
		FOREIGN KEY (image_id)
		REFERENCES images(id)
		ON DELETE CASCADE;
	
-- Таблица reviews
ALTER TABLE reviews
	ADD CONSTRAINT reviews_order_id_fk
		FOREIGN KEY (order_id)
		REFERENCES orders(id)
		ON DELETE CASCADE;


-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Наполняем БД данными
-- ------------------------------------------------------------------------------------------------------------------------------------------------------


-- Таблица addresses
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (1, 'Saint Petersburg', '4861 Powlowski Ville\nWest Martine, AL 65683');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (2, 'Moscow', '08841 Boyle Passage Apt. 094\nHesselmouth, AK 68005');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (3, 'Moscow', '38399 Blanda Square\nNorth Maxberg, WY 23583-4584');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (4, 'Moscow', '5478 Littel Place Apt. 175\nMaudieland, OR 08185-1191');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (5, 'Saint Petersburg', '7101 Ophelia Run Apt. 267\nHesselport, NJ 82031-9308');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (6, 'Moscow', '42282 Prohaska Street\nPort Kareemland, OH 13621-1170');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (7, 'Moscow', '70220 Feil Corner Suite 585\nLexustown, TX 27998-7467');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (8, 'Moscow', '64034 Teresa Valleys Apt. 899\nNorth Jude, AZ 52895');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (9, 'Moscow', '5234 Parisian Expressway\nTerrybury, VA 49343-1631');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (10, 'Moscow', '903 Fabian Alley Apt. 064\nGrayceport, TN 95039');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (11, 'Saint Petersburg', '35494 Elissa Drive Suite 570\nLake Ryleyfort, ND 48832-3111');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (12, 'Moscow', '201 Brown Rapid Suite 207\nRolfsonton, AZ 81637');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (13, 'Saint Petersburg', '33187 Veum Village\nKuhlmanborough, WY 45348');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (14, 'Moscow', '5386 Gorczany Branch\nEast Clementineport, OK 38647-1572');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (15, 'Moscow', '04882 Briana Viaduct Apt. 326\nDooleyberg, IL 02508');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (16, 'Saint Petersburg', '03657 Antoinette Common Suite 542\nFraneckiville, MD 78126');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (17, 'Moscow', '384 Beatty Rapid Suite 341\nWest Ian, DE 66301');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (18, 'Moscow', '87984 Ullrich Knoll Apt. 958\nO\'Konland, ND 98156');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (19, 'Saint Petersburg', '981 Gulgowski Tunnel\nDeckowville, OR 73900');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (20, 'Saint Petersburg', '294 Jeromy Squares\nMaymieville, CA 40619-9093');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (21, 'Moscow', '771 Judah Trafficway Suite 223\nMullerview, MA 36646');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (22, 'Moscow', '62122 Devin Orchard\nNorth Derektown, IL 20297-1324');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (23, 'Moscow', '669 Goyette Islands\nGoldnerland, RI 66812');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (24, 'Saint Petersburg', '626 Dewayne Track Suite 503\nFredyhaven, IA 23155-2986');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (25, 'Saint Petersburg', '681 Trace Viaduct Apt. 680\nIzabellabury, IN 77848-5630');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (26, 'Moscow', '2736 Brandt Inlet\nMyleshaven, OK 48525-2170');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (27, 'Saint Petersburg', '6954 Reagan Points\nLake Lonie, HI 43407');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (28, 'Moscow', '3589 Swift Fork Apt. 635\nLake Jesse, WV 05853-8162');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (29, 'Saint Petersburg', '563 Mueller Skyway\nPacochaview, OH 52115');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (30, 'Moscow', '24970 Laverna Trafficway\nNew Gideonport, ID 56278');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (31, 'Saint Petersburg', '632 Hermann Falls Apt. 680\nWest Daleton, DC 53847-6473');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (32, 'Saint Petersburg', '144 Amie Springs Suite 150\nSouth Zander, OR 00997-1883');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (33, 'Moscow', '1197 Rempel Trail\nPort Adrien, MA 29760');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (34, 'Saint Petersburg', '41575 Prosacco Circles\nPort Dedrick, NM 88235');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (35, 'Saint Petersburg', '0106 Jarrod Spurs\nMarquardtmouth, LA 56464-6607');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (36, 'Moscow', '775 Koss Forges\nNew Lance, MT 39209-1730');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (37, 'Moscow', '8435 Kessler View Apt. 847\nEast Alysha, RI 77648-1316');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (38, 'Moscow', '213 Odessa Estates Suite 335\nBeiershire, IA 01341');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (39, 'Moscow', '7405 Scotty Inlet Apt. 357\nWest Jalynmouth, MS 24573-2488');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (40, 'Moscow', '35378 Schaden Green\nCharleychester, NE 59451');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (41, 'Moscow', '124 Marks Estate Apt. 459\nSchillerport, SC 95281');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (42, 'Moscow', '30475 Von Greens\nWeimannstad, NH 82479-2029');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (43, 'Saint Petersburg', '70591 O\'Connell Walk\nGibsonville, MN 71092');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (44, 'Moscow', '7359 Weimann Lock\nJenkinsside, ME 04901');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (45, 'Saint Petersburg', '983 Melvin Locks Apt. 263\nNorth Jerrell, LA 36672');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (46, 'Moscow', '94376 Arvid Island\nMosciskimouth, OK 61639-5770');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (47, 'Moscow', '3163 Vaughn Brook\nCummingsmouth, VA 23442-7576');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (48, 'Moscow', '3327 Ella Mountains Apt. 298\nPort Adelleport, HI 21153-0506');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (49, 'Moscow', '29488 Clement Drives\nNakiaborough, OH 86651');
INSERT INTO `addresses` (`id`, `city`, `address`) VALUES (50, 'Saint Petersburg', '01055 Pouros Plaza Apt. 805\nNorth Devyn, AR 07538-0051');

-- Таблица couriers

INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (1, 'enim', 'veritatis', 'United States Virgin Islands', '71919044074', 'M', '1988-06-30', 'Saint Petersburg', '899.376.3009', 'marcelo.nolan@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (2, 'cupiditate', 'optio', 'Taiwan', '71676138564', 'M', '1975-05-25', 'Moscow', '898-299-5242x4887', 'odell.block@example.net');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (3, 'in', 'dolor', 'Algeria', '72486845180', 'M', '2001-06-14', 'Moscow', '233-438-4580x6267', 'tkirlin@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (4, 'distinctio', 'quia', 'Congo', '72826113286', 'F', '1986-05-21', 'Saint Petersburg', '366.357.7745x30705', 'eusebio.nienow@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (5, 'architecto', 'architecto', 'French Southern Territories', '77868764395', 'M', '2002-11-06', 'Saint Petersburg', '127-462-7103', 'marcellus.emard@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (6, 'repellat', 'consequatur', 'Luxembourg', '77646739347', 'M', '1990-05-23', 'Moscow', '1-846-563-2786x1821', 'skohler@example.net');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (7, 'quam', 'iure', 'Taiwan', '74720638608', 'F', '2007-09-09', 'Moscow', '939-499-1964x6816', 'twaters@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (8, 'quia', 'repellat', 'Panama', '71376698017', 'M', '2006-04-28', 'Saint Petersburg', '1-656-529-3448', 'xleannon@example.net');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (9, 'accusamus', 'facere', 'Madagascar', '78794329222', 'M', '2009-10-23', 'Saint Petersburg', '849-962-2704', 'bennett15@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (10, 'maxime', 'recusandae', 'Finland', '79697784157', 'F', '2009-11-03', 'Moscow', '761.432.0098x32649', 'qrau@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (11, 'veniam', 'illum', 'Mayotte', '72303658458', 'M', '1970-05-18', 'Moscow', '(015)057-4011', 'madaline.baumbach@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (12, 'fugiat', 'non', 'Brazil', '76641275486', 'M', '1987-04-10', 'Saint Petersburg', '665.406.1414x378', 'iziemann@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (13, 'aut', 'voluptate', 'Saint Martin', '71300838580', 'F', '2006-08-04', 'Saint Petersburg', '686-013-3502', 'vicenta.hoppe@example.net');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (14, 'illo', 'excepturi', 'Bhutan', '79208495626', 'F', '2013-05-06', 'Saint Petersburg', '(540)669-5221x9650', 'conroy.lesly@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (15, 'maiores', 'minus', 'Indonesia', '79579622177', 'M', '1994-03-16', 'Saint Petersburg', '896-258-6520x56814', 'hlebsack@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (16, 'quidem', 'et', 'Uruguay', '74170450880', 'M', '2013-10-10', 'Moscow', '380-109-5686', 'destin.schmitt@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (17, 'natus', 'veniam', 'Belize', '71534015568', 'F', '2018-03-26', 'Saint Petersburg', '019-831-0797x801', 'ccrona@example.net');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (18, 'dolores', 'recusandae', 'Bhutan', '79148730258', 'F', '1983-06-03', 'Saint Petersburg', '1-988-001-5399x849', 'mgorczany@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (19, 'eaque', 'numquam', 'Hong Kong', '72711000661', 'F', '2013-01-11', 'Saint Petersburg', '741.123.5530', 'kale45@example.net');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (20, 'consequuntur', 'sapiente', 'India', '79044880191', 'M', '2019-03-18', 'Moscow', '024.797.3926x45857', 'abigale57@example.net');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (21, 'odit', 'quo', 'South Georgia and the South Sandwich Islands', '74765217946', 'M', '1997-02-09', 'Saint Petersburg', '(195)212-6873x56823', 'champlin.sonia@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (22, 'rem', 'velit', 'Hungary', '79716530675', 'M', '1970-06-11', 'Saint Petersburg', '589.079.7733x0159', 'elody.collins@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (23, 'dolorem', 'perspiciatis', 'Italy', '71343827839', 'M', '2002-07-08', 'Saint Petersburg', '1-492-749-6444', 'ray.klocko@example.net');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (24, 'fugit', 'dicta', 'Tonga', '70095129841', 'M', '1990-04-15', 'Saint Petersburg', '+28(0)7130496862', 'arden.kerluke@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (25, 'eum', 'ratione', 'Mayotte', '76368796727', 'M', '2002-03-12', 'Saint Petersburg', '786-949-6414x870', 'bailey.nelson@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (26, 'nulla', 'deserunt', 'Norway', '76240516803', 'F', '1995-08-16', 'Saint Petersburg', '(770)043-3702', 'bsmith@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (27, 'aut', 'ullam', 'Turks and Caicos Islands', '77662933352', 'M', '2008-02-11', 'Saint Petersburg', '1-263-192-1831', 'afriesen@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (28, 'unde', 'et', 'Nicaragua', '73519271989', 'M', '1983-06-20', 'Saint Petersburg', '630-410-9126', 'tillman.bret@example.org');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (29, 'reprehenderit', 'a', 'Suriname', '78622268252', 'F', '2018-04-05', 'Moscow', '038.497.4199', 'yhane@example.com');
INSERT INTO `couriers` (`id`, `name`, `surname`, `nationality`, `passport`, `sex`, `birthday`, `city`, `phone`, `mail`) VALUES (30, 'consequatur', 'illo', 'Liberia', '79432251439', 'F', '1981-12-18', 'Moscow', '331-753-1544', 'chegmann@example.net');

-- Таблица food_categories

INSERT INTO `food_categories` (`id`, `name`) VALUES (1, 'sushi');
INSERT INTO `food_categories` (`id`, `name`) VALUES (2, 'pizza');
INSERT INTO `food_categories` (`id`, `name`) VALUES (3, 'burgers');
INSERT INTO `food_categories` (`id`, `name`) VALUES (4, 'kebabs');
INSERT INTO `food_categories` (`id`, `name`) VALUES (5, 'pies');
INSERT INTO `food_categories` (`id`, `name`) VALUES (6, 'meat and fish');
INSERT INTO `food_categories` (`id`, `name`) VALUES (7, 'healthy food');

-- Таблица images

INSERT INTO `images` VALUES 
('1','tmp//a6cc2b5a603e6440f179a841faff6ecb.jpg','vero'),
('2','tmp//b4c2210bfcb39a2e47784b4888fe07c9.jpg','sed'),
('3','tmp//af0af0fe5f5262a61c2ab654dfc10a99.jpg','perspiciatis'),
('4','tmp//0156578ff3da5f080dc9f73490a89adb.jpg','voluptas'),
('5','tmp//7cf7ee834ad01b71b8a613d4baa2d878.jpg','nulla'),
('6','tmp//a0ef9464b28b91cc79522a1140f98823.jpg','rerum'),
('7','tmp//79db0ee49a55e575aeaf3272995e4258.jpg','rerum'),
('8','tmp//c2ce90682b3025845998aaf7639b6f42.jpg','qui'),
('9','tmp//8d731cd0d427ad7159e495e8ed8712f9.jpg','sapiente'),
('10','tmp//7621946d9f1e4a6a5916a96606443fc6.jpg','nulla'),
('11','tmp//d44abcc89e8d447d912ea08c0cbeb5c9.jpg','quis'),
('12','tmp//7c1c83e9efdaeaa636a92f9224430b31.jpg','necessitatibus'),
('13','tmp//82f496a48dfa814e5be1f9ef665dfc4c.jpg','dolorum'),
('14','tmp//9368381039a50b1ed1ecdb4beeeaa24c.jpg','qui'),
('15','tmp//cf8a36f805b8282196435bb6d6b3b7ef.jpg','omnis'),
('16','tmp//9ff8738fcf709ea625276160afac659e.jpg','voluptatum'),
('17','tmp//e4af86f3ac0a6eb520c28312549fc519.jpg','odit'),
('18','tmp//44c9a35cbf554292287943a9efe09315.jpg','et'),
('19','tmp//2c4593f5140c35796a67a8deda8973cd.jpg','optio'),
('20','tmp//2a6baaec7cf7b65e6421936a7760cc6b.jpg','nisi'),
('21','tmp//e41760a343ff6a85bfad5bcfb2919577.jpg','voluptatibus'),
('22','tmp//e67d8ab8154a35411b89c472e2b1af26.jpg','aliquam'),
('23','tmp//aaa3d5d582844db0b82cdbe020c094a1.jpg','doloremque'),
('24','tmp//e1746fb96ccb93154c10fd64963e53df.jpg','fugit'),
('25','tmp//5a46c6178a34d787664858d8c6014c92.jpg','ea'),
('26','tmp//19c329b518fddfcde24a0cd2f05913b0.jpg','sed'),
('27','tmp//bde69d19e9d15399dc37755f8c83a2f2.jpg','ex'),
('28','tmp//ea18fa09827675cdf2402a452fa0b1ff.jpg','numquam'),
('29','tmp//fad04c8d4370f4eef838af7837d80e1f.jpg','ut'),
('30','tmp//52681bdf3aee7a99219f5a05153b191d.jpg','voluptatem'),
('31','tmp//b47faf41b18d11a9fe0a56dfaa37216c.jpg','in'),
('32','tmp//67d85b6322baddb056ef596136b5e9a0.jpg','nam'),
('33','tmp//b237d8e26aea61f8771eee960aa1fe0c.jpg','tenetur'),
('34','tmp//0404b8df4add9d8181cdc42fc1ab7ab5.jpg','placeat'),
('35','tmp//cb92860a037884c13c687338c39316c6.jpg','pariatur'),
('36','tmp//eb95beb0f90193a311861430eb77f5a9.jpg','ipsam'),
('37','tmp//0eccbc358facb98317173674aa72c6d7.jpg','debitis'),
('38','tmp//29627346327fa3db35c2e18f7f71f481.jpg','ea'),
('39','tmp//130b4e359766166cf5a23e490a249114.jpg','vero'),
('40','tmp//5c4ff264f8a8a2a3e1b150c89c69b432.jpg','laudantium'),
('41','tmp//dfa59d9d893cbce4227ab14a0914ae61.jpg','itaque'),
('42','tmp//edeef8960f1b9bf9db06ced8219e8b34.jpg','sunt'),
('43','tmp//2400df562dca371f1bcd802be6d5d9e1.jpg','et'),
('44','tmp//feb2543adc7f3424ccfd55e207fff137.jpg','numquam'),
('45','tmp//6d5b67d30f092c216c2221f66f5a49b1.jpg','est'),
('46','tmp//094703a61089e824ac9089c02245c6b9.jpg','qui'),
('47','tmp//4281a8981b01db6d76a9e5f895a1aeee.jpg','iure'),
('48','tmp//3139c0c448ac73daf790605b6c8d3da2.jpg','ab'),
('49','tmp//e5e9fd70ec9c1d26c7ee7a9ba2655212.jpg','aspernatur'),
('50','tmp//8f65384be95f60732b7a71a76c8f8584.jpg','corrupti'),
('51','tmp//53f39dc95bf18e57348e9cb3d76e1f2e.jpg','autem'),
('52','tmp//faed42445f42e0b89f72063a88d2f6f0.jpg','distinctio'),
('53','tmp//b0f44d1b04c2874bee5daaa5bfc18fe7.jpg','fugiat'),
('54','tmp//d059e89e1af026b3ffa45d0e25605a5b.jpg','et'),
('55','tmp//75c8c4d92483d47f4ab7d3754124a3eb.jpg','molestiae'),
('56','tmp//7980b5c231cd4659b1670700f0eeccde.jpg','voluptas'),
('57','tmp//a9d190c83472ce9c301e01392ab06ef3.jpg','hic'),
('58','tmp//d6bf1aeeef5a5c18740c2aaa7707966e.jpg','deleniti'),
('59','tmp//9089f60d37ecb7c33a8f7d2374e5db85.jpg','beatae'),
('60','tmp//69f2f9a8de7717e310c16d225c31cb58.jpg','deleniti'),
('61','tmp//3208e24bc872ffef6dbff3ce13305ab2.jpg','ullam'),
('62','tmp//213c1bcb69313eb209e3cd9dde11729f.jpg','dolorum'),
('63','tmp//8acc278c8fcd18c2ada7ca1bd0b6de9d.jpg','praesentium'),
('64','tmp//63db689fbccd6373153c50730423f270.jpg','iure'),
('65','tmp//cc0b1b95f964a04d8000d7de436a3f38.jpg','ut'),
('66','tmp//1e027078751c81e4783283c4434bb0a1.jpg','ullam'),
('67','tmp//dfe3c7ab64fc7fad54964d4eac958b05.jpg','cum'),
('68','tmp//15d1fc5733eb09c5aa52bb187ece9546.jpg','occaecati'),
('69','tmp//86b20a2150a59c497047a66d6a20f440.jpg','perspiciatis'),
('70','tmp//c226f38d512132566f8f2fc9edaf5813.jpg','non'),
('71','tmp//ef2857af029219e777970ab9acae303d.jpg','voluptas'),
('72','tmp//c6435347413f98c502ef5d22e440d5c0.jpg','qui'),
('73','tmp//34ac4b2658c0ff43d6ecfa4ca7ac87ad.jpg','ab'),
('74','tmp//13aae44c99b179d9e8b0ad74dc2787d7.jpg','debitis'),
('75','tmp//e1ed892c48fcfc8a3f6e096ff2bae91c.jpg','dicta'),
('76','tmp//c1818ddfc4b3d5807bdd74bbe8cbef70.jpg','harum'),
('77','tmp//0290e7e4c60c5860e8213f9d7e6964d3.jpg','voluptatibus'),
('78','tmp//2561392786d39535325bf31520a3805a.jpg','nihil'),
('79','tmp//5a7d6542625f06c121433b0b87e065e2.jpg','laudantium'),
('80','tmp//0069dbbf00f06f59c257c4955d6960ca.jpg','commodi'),
('81','tmp//612e2ec41b448f57cc657943afe5109b.jpg','nostrum'),
('82','tmp//7b42eff5127a7d20f8dd7e1ad04739b1.jpg','voluptatem'),
('83','tmp//0b22959a46dc5d91ce57af23b333fc97.jpg','doloremque'),
('84','tmp//0d2e9b28cd13e23f9f2ce55ca877ea0a.jpg','est'),
('85','tmp//938645967e1b6e2af5eb4c7333c00097.jpg','et'),
('86','tmp//89238fb4669226889517854c5e60cfc0.jpg','dolor'),
('87','tmp//752e5149b06284af9bd4f797a6e3e136.jpg','ea'),
('88','tmp//77f2781af6a431d5ce963f9e885d7085.jpg','accusantium'),
('89','tmp//5dc5d290293fe6c316d1ba53f47ccb50.jpg','ut'),
('90','tmp//9ba64fe8dd38bdc3fecac3513dfc1c5c.jpg','rerum'),
('91','tmp//2b6b047769339a70f5f051d3ec67f6f8.jpg','eaque'),
('92','tmp//8b87653522f4f4d47080c2d23ce01b5e.jpg','nesciunt'),
('93','tmp//230df5aae0e443c2d39b64db3ac39a32.jpg','eos'),
('94','tmp//6746275c16657e82d8d570814735ac17.jpg','nihil'),
('95','tmp//68ab8101a38519959a3920b4e7e01a9e.jpg','odio'),
('96','tmp//b5ee96721153d7c0d6e3bc77ab82b5f4.jpg','quae'),
('97','tmp//577637fecda8ae9480630cb6b3c16cfc.jpg','rem'),
('98','tmp//cc49ca9b119b1bad684a381f7607230a.jpg','repudiandae'),
('99','tmp//fa6c092106a93b575d5995c760fd0844.jpg','similique'),
('100','tmp//3ed84e58fb78749bd0cc87151b0de988.jpg','eligendi'),
('101','tmp//e1fa15d84a58b9efdd1d470fe5748d43.jpg','modi'),
('102','tmp//9af0f5506227213a9421a20014f11af6.jpg','aut'),
('103','tmp//4e0971be5b0fce785fb8b71c5c618215.jpg','dolor'),
('104','tmp//91fea7c118e1230ad9c116278a19b0e8.jpg','totam'),
('105','tmp//22460fdcd873a2da9ac45d3d9ddd0877.jpg','adipisci'),
('106','tmp//4b84c251c6a25aa0576700b1d330a363.jpg','perspiciatis'),
('107','tmp//c614d2be23a9a277b3bb9dbe4f8cb40a.jpg','tenetur'),
('108','tmp//ee6475031d7e7ffe275b15034444ac8e.jpg','aperiam'),
('109','tmp//7f891299ed02d4b2909db7ce0357fe4f.jpg','quia'),
('110','tmp//ff664ebfb571099c968477b1fc2b5bba.jpg','aliquid'),
('111','tmp//05e56707d11e3f04c73323ae51f37a40.jpg','veniam'),
('112','tmp//e7db4d32672e082897ed5e2ad79a9301.jpg','exercitationem'),
('113','tmp//81dc32c69150b062dc3da29ddc68181c.jpg','eveniet'),
('114','tmp//a02c633143363b1690d1ee197a094767.jpg','at'),
('115','tmp//04ed7a114ea71c579b8d140b28735087.jpg','et'),
('116','tmp//78131af7463f1d0ba4a54dae75bf069c.jpg','quos'),
('117','tmp//84d16bc42d3acbdd4c786d9a4162bed0.jpg','sed'),
('118','tmp//896720e1e0cf8ebd95fabdb2f6049d87.jpg','earum'),
('119','tmp//f977e92a1d2a61e69b20916d3c691990.jpg','dolores'),
('120','tmp//40d3c476ce2cbc3be764945c76e8d056.jpg','sit'),
('121','tmp//b70ac5efde3c76a21c429a7a6ee15a21.jpg','numquam'),
('122','tmp//d3d2d431378e65858d9072ccaa50da6c.jpg','nobis'),
('123','tmp//18084d01bcd552092e6f0f9ba8ee7bde.jpg','sit'),
('124','tmp//331357d515b6fa9173f3a288f4e5a5d6.jpg','odit'),
('125','tmp//89e35376e928df0b23c42a0e8dad30f7.jpg','libero'),
('126','tmp//70d3f6e99db2cab7bacf85206fdab511.jpg','maiores'),
('127','tmp//6f3a67eaed08d99f3e93ef01a65770c6.jpg','ex'),
('128','tmp//b6f063ca028022dd2bdfdf2e8944876f.jpg','natus'),
('129','tmp//7656c32b36a05f3c222ac2b9b1cc5b89.jpg','voluptatibus'),
('130','tmp//e388e5c6d50e48d8163f50ee0440b161.jpg','eum'),
('131','tmp//36019a75b7a6decacee64e2c2b806bc1.jpg','quia'),
('132','tmp//cb0e2bade0870f198442347f6a26695c.jpg','porro'),
('133','tmp//8124cea7341dbf54668e7683f839d3cc.jpg','quia'),
('134','tmp//4f2eb0bdf1631884973800fdf225cd37.jpg','ut'),
('135','tmp//e07e6ef774a3978449695d09ca7c85c0.jpg','minima'),
('136','tmp//164b8d00af04366649f240d1bbef9a65.jpg','iusto'),
('137','tmp//7c8425f906ff9169187e45ee5d37e597.jpg','quisquam'),
('138','tmp//9e9c6e09df368f431ef76284811c7e6b.jpg','ea'),
('139','tmp//b35d931759c30d60ebe4281d3c6ba46b.jpg','ad'),
('140','tmp//fcb9b41e82ab3bb9e8d4c0b3bfe81d36.jpg','inventore'),
('141','tmp//4d385ff07648dbdcc9e162cdcae46ef6.jpg','vero'),
('142','tmp//9483ed7f543f45cb9fea30878bd7cee8.jpg','harum'),
('143','tmp//9f4177851eb8fcd23c4e422bd916490b.jpg','cum'),
('144','tmp//3488dc73b2f89f2bdbbda1991f6abc98.jpg','est'),
('145','tmp//0fb15e5cba5dc3063e1388ba713482c0.jpg','voluptatem'),
('146','tmp//f0c2b4add27c6e6b54975c68060ab4c7.jpg','omnis'),
('147','tmp//189da1197a181e31b8c504f17833f8b9.jpg','aliquid'),
('148','tmp//c5f321be7baafb9ae63b21c4a17e0806.jpg','quaerat'),
('149','tmp//8f261436edf2714e64d0b87240b4c7ba.jpg','tenetur'),
('150','tmp//d50fd56843b6d2d294468d3b55a03688.jpg','beatae'),
('151','tmp//1d31171c5f66115308e69ff5ca391c2f.jpg','officia'),
('152','tmp//7c8d95c6852b5d96f4ae7bec7afd13fd.jpg','exercitationem'),
('153','tmp//ff59abeb980da8c9bf40a05a5dfb3165.jpg','libero'),
('154','tmp//58a27b8bfdc0cf4ebd9ac0d210431196.jpg','vitae'),
('155','tmp//9549cee3a2b12f6bb2d0ca18c17729a4.jpg','est'),
('156','tmp//6f95ae44ae0dd5ecc1f47d0cddb70660.jpg','voluptatem'),
('157','tmp//8858aa4d1d3bcb9705d5719952349a64.jpg','in'),
('158','tmp//0be12b2dbd0ff55ac3cc10929d5575d4.jpg','nostrum'),
('159','tmp//91b313e6a038ece31ca0f8ccd73b5b86.jpg','suscipit'),
('160','tmp//c66c44d940feccd84c81616a36e51f39.jpg','hic'),
('161','tmp//265631174f7df0eaacb94e0563820761.jpg','aut'),
('162','tmp//8ff2fa6f8e36192e0b590991e2d4acd2.jpg','molestiae'),
('163','tmp//008a6e177214a2c1791f71a914d37fda.jpg','totam'),
('164','tmp//c3e053d5d52c93e8760f7b2d67e9e32c.jpg','earum'),
('165','tmp//d7b724554a7989218ffec1727b0a3c4b.jpg','magnam'),
('166','tmp//3a11788226b3abc56892e2c13c37cd55.jpg','accusantium'),
('167','tmp//35d2fcef40f19689e91c7d3e9518819b.jpg','delectus'),
('168','tmp//6ae4a99a1ba4b6dc37d76dfb9bfdd36e.jpg','et'),
('169','tmp//949393af20c70b8b3be2b107149cb902.jpg','quia'),
('170','tmp//e18432afa293987f2302c3ecfe46b863.jpg','iste'),
('171','tmp//d65ebf1458d5ee8b12424617915dc3de.jpg','assumenda'),
('172','tmp//a4dcc36adf7f1f14ba64cb81ebd0bf5e.jpg','enim'),
('173','tmp//0d13eb2a7470a8d2586d6b49a5a528cc.jpg','possimus'),
('174','tmp//cf6e4eeefd8e7bf505c55b265e9d361f.jpg','et'),
('175','tmp//a4c1fc0fdfd0d53f7b7fadb3a4385ef2.jpg','dolores'),
('176','tmp//2f91383a07ae9b8aa34160951786b4f6.jpg','aspernatur'),
('177','tmp//ca8072896f6da1c5edd5531f4dada28e.jpg','quam'),
('178','tmp//5ed00fe587255d460ac08c318f1cbcc2.jpg','sit'),
('179','tmp//67604019e3022db61cd66732f105f9b0.jpg','aperiam'),
('180','tmp//207041b7d066cdf17dda08518e386c38.jpg','non'),
('181','tmp//110e2db8a50ad50b09bad116ae4beef7.jpg','possimus'),
('182','tmp//db094b5b4839bd627011354e5eff16bd.jpg','vel'),
('183','tmp//2138214efd259fe68c10a31a923b00e3.jpg','voluptas'),
('184','tmp//3492a4da7065588029f8af0c9815e60c.jpg','sed'),
('185','tmp//7eadd67dc7b3582876d0cc851bc35ff6.jpg','dicta'),
('186','tmp//1aeeef00aa5b070aa9ab661a9bf5aa42.jpg','ut'),
('187','tmp//d949fb798e7eca2e6aae2fbb8688af16.jpg','consequatur'),
('188','tmp//5601b25beb4cefc25f1966a4a2a9087f.jpg','illum'),
('189','tmp//76126c96cc49b36da51705be6da3ecf3.jpg','dolorem'),
('190','tmp//e3d76e72543fb8300476330f09bda5f4.jpg','est'),
('191','tmp//d49712f614f074d7d5a02df2ead58ce9.jpg','illum'),
('192','tmp//923b21f8466c1d0783d867901e282e1e.jpg','dolor'),
('193','tmp//bf788a88f1201aa14953c784b820229a.jpg','reiciendis'),
('194','tmp//281aa54ae7779633691ac4851e24b87b.jpg','voluptas'),
('195','tmp//5b32a87c1ff9b887b91d38297a1b0d94.jpg','sit'),
('196','tmp//a3cb243672d6583caa3128c8ec523a42.jpg','est'),
('197','tmp//95a32a7792d942ccea74283aaa55ce5c.jpg','reiciendis'),
('198','tmp//ee6f5bfe2bb59d9de48af778f0ff1747.jpg','laboriosam'),
('199','tmp//44c8c6cd09871dc43baf559e999dde4a.jpg','nisi'),
('200','tmp//98f11412fd30549d980c5933b82593c1.jpg','ut'); 

-- Таблица restaurants

INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (1, 'rem', 'Apt. 499', 'Id id voluptas voluptate ad optio ducimus et quo. Sint a at temporibus praesentium fugiat numquam fugiat nihil. Sunt voluptas alias dolor est ut odio.', 'Saint Petersburg', '028.955.6293x960', '00:00:00', '14:54:25');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (2, 'consequatur', 'Suite 792', 'Vero vel consequatur at rem eos. Dolor nihil sed asperiores minus et similique eum. Repellat est ex eos cum omnis.', 'Moscow', '926.225.3962x6040', '00:00:00', '20:04:23');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (3, 'et', 'Suite 634', 'Commodi ut autem sit inventore. Ut excepturi saepe quae vitae aut hic. Est quaerat veritatis hic quo aut est officia.', 'Moscow', '928.748.6182', '00:00:00', '04:08:58');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (4, 'ea', 'Apt. 775', 'Doloribus molestiae molestias aut eos voluptatem. Incidunt est excepturi sit natus. Delectus perspiciatis expedita aut fugiat veniam eos cum incidunt.', 'Saint Petersburg', '02680783483', '00:00:00', '05:24:11');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (5, 'doloremque', 'Apt. 986', 'Et quasi corrupti ipsa voluptatem. Sed praesentium quasi impedit voluptatibus minima architecto exercitationem. Sit omnis repellendus omnis et dolorum assumenda maxime. Repellendus voluptas ea fugit et.', 'Saint Petersburg', '470-206-7015', '00:00:00', '12:50:58');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (6, 'est', 'Apt. 270', 'Et numquam consectetur corporis. Voluptas sed qui eos amet. Quae repellendus aspernatur atque neque eius autem inventore. Adipisci est ipsa soluta amet voluptatem iste.', 'Moscow', '1-149-583-0758x8687', '00:00:00', '06:45:15');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (7, 'pariatur', 'Suite 169', 'Dolores repellendus eum mollitia doloremque modi dicta inventore officiis. Voluptas itaque velit neque sit aut nihil officiis recusandae. Voluptatem ipsam accusamus repellendus corporis. Consectetur aspernatur rerum eum beatae.', 'Saint Petersburg', '1-537-347-6896x94467', '00:00:00', '04:57:29');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (8, 'aspernatur', 'Apt. 626', 'Praesentium modi dignissimos ut. Dolorem quis a harum reprehenderit nostrum architecto.', 'Moscow', '+59(9)4496252094', '00:00:00', '19:38:26');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (9, 'dolores', 'Apt. 151', 'Laborum consequatur cupiditate possimus qui id. Perferendis enim alias dicta id quam. Fuga necessitatibus quo eligendi amet voluptatem. Quos non iste et. Eos sed nam adipisci aut itaque incidunt facere.', 'Saint Petersburg', '08462679997', '00:00:00', '05:41:11');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (10, 'rerum', 'Suite 566', 'Vitae eveniet blanditiis iste aut ut. Autem saepe id eius ipsam qui cumque dicta. Consequatur debitis nobis consequuntur autem autem molestias. Tenetur quam ea est laboriosam deleniti.', 'Saint Petersburg', '1-949-389-8662x632', '00:00:00', '00:31:54');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (11, 'eveniet', 'Apt. 033', 'Iste molestiae fugiat quam cum iusto. At praesentium quam et omnis facere. Animi quidem qui vitae et vitae voluptas at.', 'Moscow', '(063)676-7848x5979', '00:00:00', '19:59:20');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (12, 'cupiditate', 'Apt. 887', 'Architecto amet praesentium omnis dolore accusantium voluptatem aut. Vel aliquid dolorem reprehenderit ut iusto sequi minima quo. Consequatur ex ut harum sed qui aut beatae ducimus. Est quaerat quis voluptatibus dolorum illo quod sed.', 'Moscow', '1-649-526-2543', '00:00:00', '16:04:58');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (13, 'optio', 'Apt. 025', 'Rerum ipsa consequatur rerum. Quos iusto sint totam est eaque velit. Ex eligendi explicabo modi.', 'Moscow', '(130)226-2608', '00:00:00', '06:34:19');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (14, 'commodi', 'Apt. 091', 'Et similique harum possimus minus at sit nostrum et. Atque unde ducimus quibusdam aut quos. Voluptas libero labore veniam.', 'Moscow', '301-766-6296x856', '00:00:00', '18:01:47');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (15, 'sint', 'Suite 861', 'Quidem eos est quas omnis. Quidem fugit necessitatibus corporis. Itaque veritatis in consequatur et ipsa.', 'Moscow', '115.307.2914', '00:00:00', '04:58:38');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (16, 'nostrum', 'Apt. 434', 'Occaecati cum quia aut doloremque asperiores est. Assumenda quia rem molestiae excepturi. Consectetur voluptatum inventore sit.', 'Saint Petersburg', '1-872-169-2701x888', '00:00:00', '20:07:02');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (17, 'qui', 'Apt. 688', 'Inventore illum asperiores asperiores est sapiente fugiat. Ad aut alias ut. Dolores eveniet soluta enim voluptatum dicta et blanditiis et.', 'Moscow', '+51(8)8410823348', '00:00:00', '02:26:01');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (18, 'esse', 'Apt. 136', 'Est molestias nesciunt quos deserunt. Animi incidunt dicta sit eum magnam et veritatis. Sint est esse libero distinctio laudantium cum.', 'Saint Petersburg', '128.486.9290', '00:00:00', '15:01:40');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (19, 'rem', 'Suite 173', 'Saepe velit enim exercitationem rerum nihil quaerat. Quia numquam ex et mollitia quidem sunt. Consequatur id ut cupiditate adipisci.', 'Moscow', '(772)788-5075x500', '00:00:00', '12:48:06');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (20, 'et', 'Apt. 398', 'Voluptas praesentium neque voluptatem maxime. Quia sint quas iusto illum qui minima. Quis debitis tempore voluptatum corrupti molestiae.', 'Saint Petersburg', '264.257.4809', '00:00:00', '03:10:46');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (21, 'totam', 'Apt. 012', 'Corporis magnam et illo commodi accusamus voluptatibus quaerat. Saepe qui sint blanditiis voluptatem inventore. Ex incidunt aut saepe rem similique.', 'Saint Petersburg', '710-478-9060x04274', '00:00:00', '08:04:42');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (22, 'dolorum', 'Apt. 052', 'Ipsa ut vel et dicta. Ut sit ipsum adipisci accusamus tenetur et. Est possimus quis vel ipsum modi et.', 'Saint Petersburg', '(421)033-0769', '00:00:00', '06:10:55');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (23, 'totam', 'Suite 404', 'Cum fugit aut minus doloribus voluptatem ratione. Eos vel aut eligendi deserunt tempora. Aut velit fugiat et aut amet. Facilis architecto pariatur saepe a ut sapiente.', 'Moscow', '1-748-495-5853', '00:00:00', '00:04:37');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (24, 'a', 'Apt. 775', 'Temporibus neque et iusto aliquid libero nostrum in. Sunt qui aut tempora consequatur veritatis explicabo. Necessitatibus quae et temporibus itaque eius eum.', 'Moscow', '(394)415-4422', '00:00:00', '05:37:03');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (25, 'cupiditate', 'Apt. 214', 'Aut maxime velit provident amet quis voluptatibus autem commodi. Adipisci reiciendis nam fuga vel magnam maxime. Ea excepturi itaque soluta sequi. Illum quas et expedita.', 'Saint Petersburg', '03590734491', '00:00:00', '12:00:11');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (26, 'et', 'Apt. 179', 'Quae officia voluptatibus totam consectetur est et atque. Fuga esse at delectus corporis fuga quisquam eaque et. Consequatur praesentium et quae velit sit. Aut consequatur exercitationem veritatis dolor sed tempore molestias.', 'Moscow', '(887)238-4280', '00:00:00', '13:04:45');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (27, 'repellat', 'Apt. 748', 'Dolorum dolorem tempora laboriosam est. Dolor esse ullam reiciendis commodi officia minus voluptas. Sunt magni eaque dignissimos qui quod esse. Facilis est nulla distinctio dolor voluptates ut.', 'Saint Petersburg', '415-685-5543', '00:00:00', '18:00:45');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (28, 'laudantium', 'Apt. 691', 'Voluptates ea laborum blanditiis sit. Animi assumenda quibusdam aut officia assumenda saepe omnis modi. Ad quis voluptas incidunt doloremque.', 'Moscow', '1-707-618-7424', '00:00:00', '16:37:06');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (29, 'et', 'Suite 766', 'In omnis quia asperiores et assumenda perferendis. Culpa cupiditate accusantium explicabo consectetur. Velit non consequuntur ullam dolor modi sed odit libero.', 'Saint Petersburg', '130.343.0435x6413', '00:00:00', '12:44:30');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (30, 'rem', 'Apt. 906', 'Ut expedita laboriosam ratione rem rerum voluptatum. Officia non provident dolores placeat corporis dolore. Minus explicabo nemo in enim eos ipsum porro esse.', 'Moscow', '(992)274-1974', '00:00:00', '10:03:02');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (31, 'nisi', 'Apt. 492', 'Ut dicta provident vel libero quo expedita. Nisi eos eius est qui itaque ex eius quidem. Ducimus sed perspiciatis cum doloremque quia et sit sed.', 'Saint Petersburg', '1-428-117-7889x3559', '00:00:00', '04:15:51');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (32, 'amet', 'Apt. 025', 'Et illum vero ducimus maxime quia rerum. Totam corporis omnis dolor nobis quod. Dolores aut et autem animi laudantium quasi reprehenderit sed.', 'Saint Petersburg', '+04(4)5248204011', '00:00:00', '20:47:03');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (33, 'sed', 'Suite 554', 'Quas unde porro quo omnis officia odio fuga. Rerum exercitationem similique eum dolores quo perspiciatis. Quasi distinctio suscipit quia repellendus nihil a error. Est modi rerum libero maiores.', 'Moscow', '908.111.8653x4698', '00:00:00', '06:38:47');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (34, 'magni', 'Suite 243', 'Omnis officia pariatur dignissimos debitis. Est ullam aspernatur placeat autem quas nisi velit. Vel doloremque vel voluptas voluptatem recusandae ab eveniet est. Esse minima optio dicta.', 'Moscow', '1-437-042-5520', '00:00:00', '06:06:54');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (35, 'veritatis', 'Suite 081', 'Eaque tenetur earum maxime. Et quidem quaerat perspiciatis quos quae in. Dolorem saepe voluptates nulla quam eos fuga.', 'Saint Petersburg', '474.578.2436x149', '00:00:00', '15:49:14');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (36, 'dignissimos', 'Apt. 350', 'Quos dolor et sit quia nemo. Placeat doloribus laudantium qui exercitationem. Enim nihil optio ratione voluptatum.', 'Saint Petersburg', '(633)192-8727x774', '00:00:00', '00:40:10');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (37, 'necessitatibus', 'Apt. 253', 'Magni a doloremque nostrum qui voluptas et magni hic. Dolores consequuntur tenetur et excepturi. Asperiores voluptates pariatur tempore ducimus id ipsa molestiae repellat.', 'Saint Petersburg', '578.655.0512', '00:00:00', '18:31:36');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (38, 'deserunt', 'Suite 930', 'Quae delectus quisquam dolores hic expedita. Et asperiores ipsa alias tenetur. Ab beatae voluptates dolor ipsam. Optio voluptate omnis minima accusamus.', 'Saint Petersburg', '+39(2)5365766977', '00:00:00', '03:25:00');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (39, 'qui', 'Suite 544', 'Voluptate error non architecto alias quam dolore. Sint deleniti est est quis. Alias aspernatur unde ut repellat ipsum rerum et.', 'Saint Petersburg', '(598)723-9998x0144', '00:00:00', '16:48:32');
INSERT INTO `restaurants` (`id`, `name`, `adress`, `description`, `city`, `phone`, `open_at`, `close_at`) VALUES (40, 'fugiat', 'Suite 710', 'Eligendi saepe quisquam itaque sed officiis qui. Officia dolor ipsam facilis et tenetur. Quas dolores ex repudiandae. Voluptate nostrum minima pariatur. Laborum veniam aut et pariatur.', 'Moscow', '(952)959-3315', '00:00:00', '04:09:41');

-- Таблица promocodes

INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (1, 'eum', 47, '2019-09-20 21:11:38', '2019-10-24 00:47:44');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (2, 'tenetur', 10, '2019-02-28 14:33:00', '2019-06-12 11:33:44');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (3, 'dolore', 14, '2019-07-21 08:48:26', '2019-07-01 03:39:02');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (4, 'non', 50, '2019-10-15 21:30:08', '2019-02-22 18:35:49');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (5, 'fugiat', 28, '2019-03-23 16:50:20', '2019-06-21 20:43:39');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (6, 'id', 21, '2019-05-05 01:10:20', '2019-04-23 01:36:27');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (7, 'commodi', 33, '2019-12-18 21:05:35', '2019-04-05 18:50:30');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (8, 'ipsa', 31, '2019-07-13 19:37:52', '2019-06-22 05:02:02');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (9, 'quia', 16, '2019-02-22 11:09:08', '2019-04-17 16:18:11');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (10, 'nemo', 10, '2019-09-17 07:26:42', '2019-01-12 23:30:54');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (11, 'nulla', 12, '2019-08-01 08:10:20', '2019-03-14 09:13:11');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (12, 'debitis', 42, '2019-02-26 18:02:21', '2019-05-15 23:15:27');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (13, 'numquam', 8, '2019-10-13 07:58:30', '2019-03-23 17:16:35');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (14, 'aperiam', 27, '2019-09-17 15:30:14', '2019-11-09 01:21:33');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (15, 'autem', 41, '2019-04-21 09:45:44', '2019-06-14 22:29:28');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (16, 'error', 49, '2019-06-13 23:19:13', '2019-11-17 01:37:31');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (17, 'maxime', 2, '2019-07-08 17:46:25', '2019-05-06 21:51:26');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (18, 'dolore', 17, '2019-05-12 01:53:47', '2019-08-15 03:59:16');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (19, 'natus', 18, '2019-03-26 09:56:12', '2019-08-23 17:13:43');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (20, 'sint', 13, '2019-06-02 08:46:16', '2019-12-01 10:19:10');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (21, 'maiores', 37, '2019-09-15 02:12:15', '2019-06-29 08:59:24');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (22, 'excepturi', 23, '2019-10-12 17:11:13', '2019-09-08 13:11:10');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (23, 'commodi', 43, '2019-10-11 10:27:55', '2019-07-23 07:46:09');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (24, 'blanditiis', 11, '2019-03-23 00:25:37', '2019-10-21 14:36:31');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (25, 'harum', 26, '2019-05-18 23:10:03', '2019-04-12 11:12:30');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (26, 'voluptas', 17, '2019-01-19 17:56:31', '2019-10-26 22:52:19');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (27, 'quibusdam', 25, '2019-07-15 17:58:50', '2019-08-19 11:52:04');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (28, 'non', 41, '2019-07-26 15:13:23', '2019-09-12 23:30:43');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (29, 'atque', 45, '2019-09-12 04:03:35', '2019-09-02 10:54:59');
INSERT INTO `promocodes` (`id`, `name`, `discount`, `start_date`, `end_date`) VALUES (30, 'necessitatibus', 26, '2019-02-11 10:31:18', '2019-07-12 17:13:36');

-- Таблица menu

INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (1, 'dolorum', '3614', 'Voluptatum et est dolores et ut necessitatibus. Repellendus impedit error rerum et ex.', 1, 1, 1, 1);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (2, 'vitae', '3233', 'Recusandae voluptatum quia molestiae ea laboriosam eos sed. Accusantium sed enim doloremque repellat. Dolor est delectus voluptatem voluptatibus assumenda est dolor. Cupiditate architecto minima distinctio eos earum.', 2, 2, 0, 2);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (3, 'illum', '3171', 'Quis fugit at distinctio ab enim quia voluptatibus. Consectetur ullam possimus quos id aut qui quod. Placeat ab esse alias possimus illo ipsum et. Earum deserunt ea nam nihil.', 3, 3, 1, 3);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (4, 'magni', '4468', 'Eaque veritatis deleniti non veritatis magnam. Eligendi nisi dolores magnam ullam blanditiis. Non maiores rerum esse sunt ratione eum dolor tenetur.', 4, 4, 1, 4);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (5, 'explicabo', '4270', 'Est qui molestiae animi sint sint soluta. Culpa et reiciendis qui dolor. Recusandae voluptate sunt voluptatem et minus praesentium.', 5, 5, 1, 5);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (6, 'quis', '4710', 'Qui consequatur et qui voluptate saepe cum ducimus enim. Suscipit ipsam delectus quaerat. Recusandae culpa hic voluptatem nobis.', 6, 6, 1, 6);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (7, 'facere', '197', 'Possimus ut porro et ut id. Sapiente ut qui nam totam. Molestiae nobis neque minima esse et dicta sed. Assumenda excepturi qui dolorum aspernatur.', 7, 7, 1, 7);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (8, 'ut', '2551', 'In optio enim fugit enim. Ab praesentium temporibus ut aut quia similique quis dolores. Nihil necessitatibus veritatis quis sapiente.', 1, 8, 0, 8);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (9, 'quaerat', '3470', 'Dolor rerum enim quo eos ipsum provident. Earum voluptas omnis aspernatur inventore accusamus molestiae omnis. Quaerat velit esse ut maiores velit. Velit est velit omnis.', 2, 9, 1, 9);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (10, 'tempore', '977', 'Nostrum iure nam sed qui in et. Et inventore officiis aut deleniti ipsam voluptatem.', 3, 10, 0, 10);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (11, 'ab', '2217', 'Accusantium ab ut nobis similique dolore nostrum. Perspiciatis magni beatae quae et et nisi. Qui exercitationem amet nihil molestiae in molestias ut necessitatibus.', 4, 11, 0, 11);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (12, 'voluptatibus', '1508', 'Aut repellendus fugit veritatis. Qui voluptatem rerum repellendus dolore minima harum perspiciatis velit. Perferendis nisi quia qui sit est hic esse. Rem aliquam repellat ratione omnis sunt amet.', 5, 12, 1, 12);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (13, 'nostrum', '1492', 'Possimus in fugiat consequatur quia. Ipsa autem aperiam error incidunt nesciunt ab. Eos et culpa hic sapiente deleniti molestiae. Nam aut officiis molestias ullam.', 6, 13, 1, 13);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (14, 'sunt', '753', 'Nam id et temporibus placeat non. Ut alias et ipsam accusantium. Quasi error atque nihil illo.', 7, 14, 0, 14);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (15, 'natus', '2906', 'Corporis saepe nulla quia. Impedit harum autem modi fugit aspernatur. Qui distinctio corrupti commodi. Molestias ut magni dolore tempora sit nam.', 1, 15, 1, 15);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (16, 'error', '1048', 'Id et dolorem impedit voluptas rerum quaerat. Quae nihil iusto illo molestiae blanditiis. Velit quia voluptas et quasi quod.', 2, 16, 1, 16);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (17, 'eos', '4855', 'Et ut accusantium quos aut ex tenetur beatae. Delectus hic omnis pariatur alias dolorem debitis. Qui est fugiat voluptas sequi suscipit porro.', 3, 17, 1, 17);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (18, 'explicabo', '4649', 'Voluptatum dolores incidunt qui sed. Consequatur non expedita dignissimos hic quia quia et.', 4, 18, 0, 18);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (19, 'dolor', '130', 'Ducimus reprehenderit et ut deserunt. Beatae est tempora vitae. Molestiae est cumque non et. Sed perferendis assumenda impedit non ducimus aut. Sint labore ullam commodi ratione et ipsum eius.', 5, 19, 1, 19);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (20, 'suscipit', '468', 'Quia nihil quo aperiam eum. Unde laudantium rerum et totam autem vero harum. Et minus perspiciatis omnis. Voluptas ipsam sit et in aut amet.', 6, 20, 0, 20);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (21, 'explicabo', '3756', 'Autem nemo ratione labore quibusdam nihil. Omnis sapiente veniam accusantium ea quia. Facilis natus exercitationem et ut est corporis. Non veritatis et sed explicabo molestiae eos.', 7, 21, 0, 21);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (22, 'unde', '1581', 'Voluptates officia et dolorum reprehenderit facilis quidem. Eos culpa itaque aut ut in blanditiis at. Est ipsam totam et. Quia rerum eveniet tenetur.', 1, 22, 1, 22);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (23, 'libero', '324', 'Delectus quia eos quae distinctio earum officia numquam. Perferendis consequatur id aliquid dolores ea nam. Est atque facere quisquam consequatur omnis harum tenetur ut.', 2, 23, 0, 23);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (24, 'aut', '3536', 'Magni nulla doloremque ullam enim. Quia ipsum eos natus fugit laboriosam magnam in.', 3, 24, 1, 24);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (25, 'placeat', '4134', 'Vero mollitia magni dolores ut. Optio aut quidem eum aliquam cumque dolor nam. Repellendus vel et quam nihil est.', 4, 25, 1, 25);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (26, 'nobis', '1768', 'At deleniti maxime accusamus. A qui numquam aut incidunt numquam nihil.', 5, 26, 0, 26);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (27, 'voluptatum', '2786', 'Quo autem voluptas exercitationem saepe aut. In asperiores iste quia vitae. Architecto eum accusantium modi veritatis. Eum et iusto cumque.', 6, 27, 0, 27);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (28, 'temporibus', '4162', 'Doloribus odit quo et ea laudantium dignissimos et. Eos porro non est. Distinctio sequi delectus cumque veniam corporis eligendi quibusdam.', 7, 28, 1, 28);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (29, 'sint', '2398', 'Temporibus sunt ducimus eaque quae hic. Dolore voluptatem voluptas pariatur iure. Quo nesciunt maiores ipsa. Et ab consequuntur culpa.', 1, 29, 0, 29);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (30, 'inventore', '650', 'Aliquid rerum praesentium blanditiis magnam voluptatum qui explicabo. Voluptatum sed aut dignissimos est. Voluptate deserunt est soluta velit ullam delectus iure sint.', 2, 30, 0, 30);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (31, 'molestias', '1762', 'Possimus sed suscipit doloribus. Omnis qui atque soluta eius vero. Voluptatem quibusdam voluptate officia. Aspernatur sint rerum id illo fugiat numquam rerum facere.', 3, 31, 0, 31);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (32, 'dicta', '859', 'Totam incidunt assumenda et nesciunt qui qui. Iusto quis error molestiae ducimus magnam eaque corporis. A voluptas inventore ea perferendis temporibus voluptatum iusto.', 4, 32, 0, 32);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (33, 'quibusdam', '65', 'Rerum aperiam deserunt perspiciatis voluptate. Aut suscipit distinctio fugiat aliquid. Modi optio libero et consequatur repellat eveniet culpa beatae. Beatae impedit ad id qui esse.', 5, 33, 1, 33);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (34, 'est', '4977', 'Veritatis fugiat autem nihil eveniet eligendi quibusdam voluptatem. Ut ipsam necessitatibus nemo inventore veniam. Molestiae et sint cumque ex alias. Eius quis aut deleniti.', 6, 34, 0, 34);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (35, 'voluptatem', '2104', 'Dolorem ea culpa a. Et repellendus quidem ullam ab odio magnam aut. Et nulla rerum vel.', 7, 35, 0, 35);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (36, 'facilis', '2320', 'Quia exercitationem harum voluptas esse distinctio. In enim et accusamus veritatis aut rerum nam ullam. Atque sed eaque ipsum non.', 1, 36, 0, 36);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (37, 'minima', '3289', 'Facere repellat sunt voluptatum molestiae ut consequatur sit. Magnam consectetur aut eos accusamus fuga voluptas. Aspernatur facilis possimus in quaerat. Totam consequatur tempora hic non architecto.', 2, 37, 1, 37);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (38, 'qui', '2630', 'Fugit aperiam non velit perferendis vel molestias. Impedit ratione dicta iure vitae nam. Consequatur sapiente et quia amet.', 3, 38, 1, 38);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (39, 'alias', '2665', 'Nam quia sequi a soluta consequatur. Atque voluptate quam ipsum rerum. Qui debitis quia perferendis soluta. Asperiores qui veniam neque dolore.', 4, 39, 1, 39);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (40, 'asperiores', '1163', 'Molestiae at aliquam aut. Eos eligendi et consequatur repellendus nam. Ab qui nihil ut nemo enim dolores at nobis.', 5, 40, 0, 40);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (41, 'veritatis', '1763', 'Ut velit aut dolorem voluptatibus. Quibusdam vel illum aut et. Autem dolorum suscipit qui distinctio qui in ullam.', 6, 1, 0, 41);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (42, 'modi', '1309', 'Exercitationem quaerat magni earum maxime corporis nulla deleniti adipisci. Hic aut atque ut similique commodi consequatur rerum accusantium. Magni laudantium numquam laudantium laboriosam ipsa.', 7, 2, 1, 42);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (43, 'voluptas', '3601', 'Sint nisi esse perspiciatis expedita reiciendis voluptatum. Unde assumenda et enim non quia deserunt. Hic pariatur non optio commodi. Sed excepturi explicabo accusantium et sed atque omnis.', 1, 3, 0, 43);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (44, 'in', '1964', 'Et dolor accusamus illo distinctio. Expedita neque voluptas rerum autem nulla sed nostrum. Qui enim optio consequuntur a natus adipisci cumque.', 2, 4, 0, 44);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (45, 'dolor', '3075', 'Est voluptas perspiciatis aut. Adipisci et aut sed. Est blanditiis est repellendus. Enim vitae similique hic qui.', 3, 5, 1, 45);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (46, 'deserunt', '3720', 'Laudantium omnis cupiditate enim quo. Corrupti voluptatem nulla ex est assumenda facilis.', 4, 6, 1, 46);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (47, 'qui', '3261', 'Amet necessitatibus dolores consectetur libero. Repellat voluptatem enim ut eum. Cumque ipsum voluptate autem omnis mollitia.', 5, 7, 1, 47);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (48, 'necessitatibus', '2851', 'Cumque ad nulla est eligendi facere nemo. Quis eos non error rerum dolorem. Voluptates voluptates aut voluptatem id sequi.', 6, 8, 0, 48);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (49, 'velit', '3728', 'Consectetur modi voluptates et numquam autem dolor. Sed neque est deleniti sunt enim. Sint ad quia repellat eum omnis enim vero.', 7, 9, 1, 49);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (50, 'sunt', '911', 'Et sunt possimus laborum deserunt quasi id. Animi laudantium sapiente at quo perferendis quibusdam excepturi qui. Debitis quis vel molestiae vel voluptatem non.', 1, 10, 1, 50);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (51, 'repudiandae', '1178', 'Quaerat perferendis quo eum illum et voluptas ad. Ea voluptatum adipisci eum consequuntur. Doloribus esse perspiciatis minus et blanditiis. Tempora aperiam porro eius sint autem minus et.', 2, 11, 1, 51);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (52, 'est', '2162', 'Nostrum quia dolores quia exercitationem excepturi debitis. Labore ut aliquam ipsam mollitia similique ut. Cupiditate omnis est aut rerum. Debitis consequatur aspernatur neque ipsa ad sed.', 3, 12, 1, 52);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (53, 'molestiae', '304', 'Ut ipsum quia vitae ut velit ullam. Incidunt quidem sed amet omnis voluptas inventore modi.', 4, 13, 0, 53);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (54, 'cumque', '1278', 'Expedita labore harum est. Voluptas quia reprehenderit beatae molestias. Inventore quas et corrupti ipsa consectetur eius ipsum aliquam.', 5, 14, 1, 54);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (55, 'quo', '3089', 'Occaecati et quis non et aperiam. Rerum deleniti aliquam beatae non atque debitis nobis. Ipsam repellat voluptas porro.', 6, 15, 0, 55);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (56, 'sed', '1704', 'Soluta unde sit ad at cum sunt. Quam ab nisi amet dolorem minima. Qui consequatur animi saepe iure voluptas. Voluptatem qui tempore eaque blanditiis ullam numquam nihil.', 7, 16, 0, 56);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (57, 'reiciendis', '3218', 'Velit qui dolor ducimus omnis dolor asperiores a quia. Ducimus et blanditiis minima in. Vitae iusto libero rerum nihil qui culpa. Autem aut qui voluptas illum.', 1, 17, 1, 57);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (58, 'illo', '1849', 'Voluptatem est consequatur cumque esse rerum maxime commodi. Ipsa quibusdam corporis molestiae nisi et amet rerum. Tempore consequatur id fugiat aut dolores a. Molestiae pariatur consequatur soluta vitae earum quibusdam.', 2, 18, 0, 58);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (59, 'fugiat', '264', 'Debitis voluptas ducimus natus repellat possimus sed. Voluptates aut ipsam qui omnis. Dolore et neque molestiae nostrum sunt quisquam cum.', 3, 19, 1, 59);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (60, 'et', '2770', 'Aut possimus at eveniet. Quibusdam voluptatem enim sint aperiam. Sit quo aut tempora quisquam officiis.', 4, 20, 0, 60);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (61, 'delectus', '2266', 'Aut dicta repudiandae minus minus autem rerum aspernatur. Labore ea nostrum iusto amet. Fuga error beatae laboriosam consectetur velit veniam. Nostrum deserunt quo non id sequi iste. Optio praesentium at est quaerat cumque porro dolores.', 5, 21, 1, 61);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (62, 'excepturi', '800', 'Non laboriosam qui dolor ea deleniti ut. Et exercitationem architecto repellat iste rerum id perferendis. A accusamus dolorem illum ut consequatur. Omnis dolores ut sint facere et.', 6, 22, 0, 62);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (63, 'fuga', '1678', 'Modi fugit consectetur quos repudiandae ab voluptates quis. Repudiandae vel repudiandae aut consequuntur. Exercitationem nihil velit ducimus nobis perferendis qui.', 7, 23, 0, 63);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (64, 'cumque', '1134', 'Rerum saepe in impedit eaque. Non molestiae neque sit impedit.', 1, 24, 0, 64);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (65, 'iure', '158', 'Cumque et id quia mollitia unde et et. Esse repudiandae et ut eum consequatur nulla aut. Voluptates magni at sit et. Accusamus aspernatur ipsum ea placeat.', 2, 25, 1, 65);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (66, 'qui', '3628', 'Ullam nihil doloremque ab neque quam deleniti rem. Aut et saepe minus id quam. Suscipit voluptatem consequatur nostrum labore ut vero.', 3, 26, 1, 66);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (67, 'officiis', '3677', 'Asperiores voluptas dolore in aut aliquid placeat. Facere aut ut cum consectetur atque commodi. Molestiae id est quaerat quisquam quo hic ipsum. Illum omnis ea repellendus qui nulla.', 4, 27, 0, 67);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (68, 'doloremque', '768', 'Qui et vero id doloremque quasi. Qui aut commodi maxime aperiam numquam quaerat omnis. Sunt et in ratione animi corporis delectus. Et id quibusdam ut vitae inventore vitae.', 5, 28, 1, 68);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (69, 'provident', '1642', 'Expedita quia accusantium exercitationem quia qui vel. Omnis in nihil optio ipsum aut ut iusto quo. Quo deserunt molestiae nulla reiciendis blanditiis.', 6, 29, 1, 69);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (70, 'quia', '1803', 'Dolorem voluptas dignissimos facilis doloribus. Ut magnam nulla doloribus iure et deserunt. Deserunt cumque ducimus nesciunt asperiores ut ut tempore.', 7, 30, 0, 70);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (71, 'voluptas', '1650', 'Dolorem ducimus esse id fugit aperiam eaque quo. Et quasi nobis fugit temporibus tempore. Est aut recusandae aut ea reprehenderit accusantium facilis. Nobis est eligendi quos nostrum.', 1, 31, 0, 71);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (72, 'non', '2638', 'Expedita suscipit omnis in quasi est minus. Vitae inventore suscipit omnis. Eius sed qui et. Iure nesciunt nihil impedit qui labore odit.', 2, 32, 0, 72);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (73, 'consectetur', '3135', 'Porro suscipit velit sint architecto placeat vitae id. Tempore consequatur dignissimos in non. Sit perspiciatis cupiditate sapiente beatae. Sunt est aperiam ipsum sapiente facilis dolores cum.', 3, 33, 0, 73);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (74, 'fugit', '2380', 'Et non dolorem maiores est quis maxime aliquam et. Nostrum rem corrupti excepturi doloribus sunt ut. Sunt praesentium quaerat quo veniam quis eum molestias.', 4, 34, 0, 74);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (75, 'dolores', '3952', 'Voluptas minus molestiae quia consequatur. Qui voluptatem doloremque delectus ducimus in et. Esse qui aspernatur et iusto aspernatur sed.', 5, 35, 0, 75);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (76, 'debitis', '4282', 'Quos pariatur ut necessitatibus et dolorum ut. Provident repudiandae voluptas voluptates ut. Voluptas architecto quia et omnis.', 6, 36, 1, 76);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (77, 'amet', '1103', 'Omnis inventore tenetur dignissimos voluptatem omnis id sed eos. Aliquam voluptatibus vitae voluptatum et ipsam voluptatum. Dolorum dolores pariatur saepe perferendis voluptatem.', 7, 37, 0, 77);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (78, 'similique', '810', 'Quos voluptatem modi et a odit nulla. Nemo ipsam ratione cum aut facilis.', 1, 38, 1, 78);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (79, 'quos', '4405', 'Voluptas quo saepe odio omnis reiciendis. Dolores qui qui ipsam ab. Dolores fuga ea sequi dolor veritatis iusto. Accusantium voluptas quia fugiat.', 2, 39, 1, 79);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (80, 'id', '1509', 'Blanditiis nemo suscipit rem dolore voluptatibus sapiente cum ipsum. Fugit vel error suscipit delectus sed provident quae.', 3, 40, 1, 80);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (81, 'voluptatibus', '2646', 'Laudantium et est qui laboriosam dolor. Et quam voluptate aut delectus mollitia et. Qui quia neque sed cupiditate aperiam voluptas.', 4, 1, 1, 81);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (82, 'eius', '1730', 'Ut provident expedita vel. Delectus nemo delectus a quibusdam cum consequatur. Ut tempore placeat ut eius pariatur.', 5, 2, 0, 82);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (83, 'dolorum', '2748', 'Qui praesentium et maiores neque. Sed autem quia enim nesciunt magni similique. Iste laudantium eum magnam voluptates. Provident voluptas nesciunt quis est est est. Doloremque voluptatem fuga occaecati dolorum.', 6, 3, 1, 83);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (84, 'et', '3552', 'Velit et tempora doloremque. Suscipit tempora perferendis incidunt alias. Omnis atque dolore quo excepturi. Dolores quisquam amet laboriosam hic ut et et molestiae.', 7, 4, 1, 84);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (85, 'sed', '4945', 'Voluptatem eos non eius voluptas minima provident eum. Quo quae est eveniet dicta. Doloremque ea ad doloremque placeat debitis vel. In iure et molestias aut.', 1, 5, 0, 85);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (86, 'excepturi', '4120', 'Consectetur est quae reprehenderit. Repudiandae voluptas quo quasi quas nemo. A eius enim est itaque. Ea accusantium rerum dolor ab ut.', 2, 6, 1, 86);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (87, 'illum', '2610', 'Rem aliquam officia tenetur et non recusandae. Veritatis numquam neque illum. Qui expedita in quae voluptas in ea ut.', 3, 7, 1, 87);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (88, 'omnis', '1064', 'Et error rerum culpa autem explicabo animi eaque. Officia tempore sunt id fugit blanditiis laboriosam sunt aut. Fugit quia officia velit beatae. Optio veritatis velit illum quo quisquam inventore. Dolorum suscipit dolorem et expedita necessitatibus unde ut.', 4, 8, 0, 88);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (89, 'ut', '3029', 'Quod omnis iure nulla repudiandae voluptates reprehenderit est qui. Quia et in eos tempore et qui nam. Adipisci voluptatem ea ipsum quasi dolore iste.', 5, 9, 0, 89);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (90, 'laudantium', '2387', 'Magnam harum nisi laborum et. Veniam sequi omnis vitae. Reiciendis aut dolorum et aut blanditiis aut. Aut molestias quis quasi similique aut eum eos.', 6, 10, 0, 90);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (91, 'exercitationem', '624', 'Sunt sit itaque magni numquam velit et. Velit eaque et quia natus et est fuga. Optio et sapiente rerum eaque voluptas consequatur.', 7, 11, 0, 91);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (92, 'dolorum', '2041', 'Praesentium velit necessitatibus sint quidem rerum aperiam atque. Beatae quo sed id autem iure harum. Neque dignissimos amet inventore aut quia provident.', 1, 12, 1, 92);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (93, 'nemo', '3997', 'Ut recusandae voluptatem cum aut molestiae. Illum maxime suscipit aut rerum tempore. Odio molestiae omnis provident perspiciatis odit qui reiciendis.', 2, 13, 0, 93);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (94, 'aperiam', '2330', 'Iusto velit sapiente molestiae possimus. Non reiciendis eligendi officia ipsum sunt qui saepe. Vitae atque et sapiente laborum dolor dolorum. Qui ipsa vitae nihil rerum alias. Placeat exercitationem ex velit quas.', 3, 14, 0, 94);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (95, 'explicabo', '4755', 'Perferendis et quidem perferendis similique et accusantium inventore. Natus pariatur sint nulla quod. Impedit alias ipsum ex delectus et veritatis. Aut quis occaecati recusandae.', 4, 15, 0, 95);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (96, 'tenetur', '4090', 'Quasi laudantium totam dolor laborum qui est aut. Deleniti quaerat modi temporibus qui rem.', 5, 16, 0, 96);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (97, 'quis', '3264', 'Architecto cum molestias quia dolores. Quia nihil assumenda repellendus non. Id qui sed magni. Et consequatur deleniti non perspiciatis aliquam.', 6, 17, 1, 97);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (98, 'enim', '3309', 'Placeat cupiditate numquam aut dolorem. Aperiam perspiciatis placeat assumenda cumque. Asperiores nostrum ut porro autem laborum. Aspernatur hic sed unde ut id.', 7, 18, 1, 98);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (99, 'corrupti', '1537', 'Eaque dolores beatae maxime fuga id. Quis tempore et quisquam eos blanditiis magni. Optio in cumque ex pariatur nihil ut odit.', 1, 19, 1, 99);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (100, 'velit', '4256', 'Qui corporis ea laboriosam in consequuntur. Et sit et perferendis facere eos id aut. Id aut deserunt ipsam ullam. Ipsa quas ut voluptas officia asperiores. Est ipsum soluta impedit vitae.', 2, 20, 1, 100);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (101, 'est', '4448', 'Non eius quisquam in quam non laborum. Quia enim ut sit quo voluptatibus. Et aut quas excepturi ad.', 3, 21, 0, 101);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (102, 'corporis', '784', 'Reprehenderit aut ullam recusandae distinctio. Sunt similique delectus et magnam.', 4, 22, 0, 102);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (103, 'repellendus', '1535', 'Eum corrupti nemo velit. Distinctio incidunt porro ratione perferendis tempora optio tenetur eveniet. Consequatur expedita voluptatem amet necessitatibus voluptatem rerum dolores. Magni quam id veniam totam.', 5, 23, 0, 103);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (104, 'consequuntur', '2243', 'Dolores odio sed ab eos consequatur alias. Ut dicta non mollitia sit eaque. Ut est ipsa atque et. Impedit quas soluta ut dolores.', 6, 24, 0, 104);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (105, 'sunt', '819', 'Veniam quibusdam dolores omnis vero. Repellendus velit repellendus mollitia voluptatum. Aliquam voluptatem molestiae consequatur facilis eos.', 7, 25, 0, 105);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (106, 'perspiciatis', '1855', 'Rerum autem officiis iure et. Enim illum dolores dolores veniam cupiditate enim architecto.', 1, 26, 1, 106);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (107, 'non', '3689', 'Quidem ut quod quo dolorem sit. Inventore omnis debitis occaecati ut fuga nostrum aut in. Eos non provident atque id ut. Odit id deleniti rerum nihil ullam aliquid impedit. Delectus sapiente similique qui quasi debitis dolore fugiat.', 2, 27, 0, 107);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (108, 'quos', '2368', 'Animi nesciunt rerum praesentium saepe hic ea perferendis. Similique et adipisci totam expedita. Qui delectus aut et quos.', 3, 28, 0, 108);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (109, 'illum', '3171', 'Maiores sit qui consequuntur facere. Dicta eligendi provident id quia officiis et. Provident aliquam cumque est qui ipsa nulla ut.', 4, 29, 1, 109);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (110, 'omnis', '1893', 'Repellendus asperiores sed consequatur. Eaque enim id voluptas ut voluptatibus officia. Eum debitis debitis quis accusamus.', 5, 30, 0, 110);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (111, 'saepe', '433', 'Illum labore qui laborum natus sapiente quisquam. Odit pariatur fugiat in est. Iure est officia beatae veniam veritatis facilis laudantium. Natus tempora doloremque non enim praesentium repudiandae.', 6, 31, 0, 111);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (112, 'ut', '3596', 'Culpa neque eum odio qui magni porro occaecati. Soluta placeat ex quod nemo. Aut at perspiciatis dolorem aperiam.', 7, 32, 1, 112);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (113, 'asperiores', '2913', 'Sequi et animi ipsam ipsam nemo adipisci assumenda cupiditate. Eaque corrupti fugiat inventore repellendus illo et. Maiores quia qui quisquam. Sunt veniam vero et id voluptatem adipisci quo.', 1, 33, 1, 113);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (114, 'aut', '2864', 'Qui perspiciatis id sit cumque consectetur. Sit vero nobis necessitatibus iusto voluptas. Sit doloribus architecto laboriosam et voluptas quos dolorem qui. Sed dolor odio repellat.', 2, 34, 1, 114);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (115, 'repudiandae', '1730', 'Harum ullam cum reiciendis quas et ratione. Soluta earum iure eaque aut ut sit aliquam. Sed aut voluptatum voluptatem quasi ducimus in.', 3, 35, 0, 115);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (116, 'beatae', '3110', 'Consequatur nisi accusantium est est. Voluptas possimus et iure eos magnam est. Molestias quia sit ipsum et natus in. Sequi velit voluptate qui iure sint molestias.', 4, 36, 0, 116);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (117, 'qui', '3426', 'Aut mollitia quasi ut nihil facilis. Est sed corrupti ut vel. Fuga quaerat deserunt ab perferendis explicabo. Perspiciatis praesentium sed repellendus sed. Rerum eum qui iste qui ducimus dignissimos.', 5, 37, 0, 117);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (118, 'consequatur', '184', 'Labore quia eaque ut qui consectetur eius. Nam dignissimos vitae sequi nesciunt enim. Qui quam iste deserunt nemo. Qui iste voluptas veritatis voluptatem.', 6, 38, 1, 118);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (119, 'debitis', '4761', 'Blanditiis nisi vero aut sunt consectetur magnam magnam. Ducimus natus voluptatum est ex qui qui. Non sit voluptas inventore omnis ex. Veritatis provident ut quae tempora et.', 7, 39, 0, 119);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (120, 'cupiditate', '4087', 'Velit ea deserunt aliquam iste minima. Voluptas magni laboriosam illum quia numquam. Consequuntur rem placeat optio. Aut nulla ea repellat veniam vel. Omnis quasi aut et.', 1, 40, 0, 120);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (121, 'rem', '3244', 'Sint enim molestiae soluta libero amet. Tempore sint voluptate omnis.', 2, 1, 0, 121);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (122, 'incidunt', '1101', 'Qui quod rerum quo illo est. Sunt facilis soluta quos aut illum. Quod nihil veritatis excepturi vel ab quae. Maiores atque quibusdam sint quo suscipit.', 3, 2, 0, 122);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (123, 'culpa', '948', 'Provident atque omnis incidunt ab. Veritatis totam dolores quis ea. Non quis animi cum molestias molestiae non.', 4, 3, 1, 123);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (124, 'eum', '2832', 'Eos tempora sapiente ea architecto quibusdam provident magni. Sit est aut exercitationem hic sapiente sed iusto nam. Adipisci doloremque nulla maiores quo.', 5, 4, 0, 124);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (125, 'quod', '123', 'Doloremque perspiciatis eveniet illum incidunt. Qui saepe ut hic amet libero est placeat. Enim incidunt non sunt voluptas iure et. Omnis nisi sed libero mollitia fugit blanditiis.', 6, 5, 0, 125);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (126, 'hic', '1855', 'Vel odit qui velit fugit dolorem. Ipsum sit temporibus autem tempora velit quaerat. Officiis dolorem aliquid autem qui eius. Laudantium unde fugiat sapiente voluptatem qui est.', 7, 6, 0, 126);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (127, 'atque', '1005', 'Rerum voluptatem provident non inventore. Aliquid temporibus numquam sunt impedit reprehenderit iusto esse. Consequatur et eveniet rerum non doloremque.', 1, 7, 1, 127);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (128, 'est', '282', 'Vel dignissimos voluptates commodi omnis in ea hic. Ad aliquam error minima provident neque. Quas animi nesciunt quia et aliquid error. Cumque dolorem necessitatibus culpa veniam omnis assumenda laudantium.', 2, 8, 0, 128);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (129, 'eos', '3345', 'Sapiente ut et repellat. Et temporibus minima velit numquam consequatur cupiditate. Modi consequatur quo aspernatur earum. Quo repellendus est et sed.', 3, 9, 0, 129);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (130, 'repellendus', '67', 'Delectus quis nam reiciendis et quo in voluptas. Laudantium et cumque facilis. Nihil odit amet quas architecto. Sequi sint ut est ullam veniam nemo molestias.', 4, 10, 0, 130);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (131, 'aut', '2733', 'Praesentium qui modi id ad. Possimus quia autem deleniti nemo saepe qui repellat. Iste perferendis quia qui nostrum. Sed quam labore cumque sit necessitatibus ab autem et.', 5, 11, 0, 131);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (132, 'ut', '4322', 'Voluptas inventore aperiam in atque aspernatur odio inventore. Non nesciunt eos nam dolorem maiores voluptates magnam. Consequatur fugit consequatur deserunt. Ullam molestias reiciendis nulla occaecati rerum dicta et.', 6, 12, 0, 132);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (133, 'qui', '241', 'Aut libero nihil incidunt maiores aut mollitia. Excepturi ex non quos qui nesciunt. Dignissimos corrupti rem ea dolores et ex aut. Exercitationem sit commodi dignissimos.', 7, 13, 0, 133);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (134, 'quod', '2115', 'Aut quasi eligendi quia repellendus veritatis minima. In deleniti expedita earum mollitia molestias velit natus.', 1, 14, 0, 134);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (135, 'dolor', '1730', 'Molestiae cum dolores ea officia velit a. Temporibus dolor eum quo unde eum qui. Inventore vel deleniti voluptatum ea a.', 2, 15, 0, 135);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (136, 'exercitationem', '2505', 'Deserunt tempore et rem nemo. Mollitia reiciendis magnam architecto. At qui tempora et perferendis fugiat saepe et quasi. Voluptas consequatur magnam dignissimos aliquam ratione dolorem nihil.', 3, 16, 1, 136);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (137, 'aliquid', '3120', 'A molestiae neque eaque ut. Fuga rerum quibusdam consequuntur tempore. Quis porro voluptatibus consequatur et et accusamus. Debitis occaecati molestias ipsum.', 4, 17, 0, 137);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (138, 'cum', '315', 'Quae aliquid saepe qui id aut sit. Ullam sed rem voluptatem alias quas. Et molestiae eius aperiam illo et et. At dolor eum sed itaque ducimus doloremque.', 5, 18, 1, 138);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (139, 'accusantium', '4576', 'Labore laudantium delectus et fugiat. Dolores explicabo suscipit atque corrupti ex aut beatae. At aliquam nesciunt laborum quia. Nesciunt vel illo dolores dolores quidem.', 6, 19, 1, 139);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (140, 'eum', '2177', 'Eveniet non fugiat perferendis debitis sapiente. Aut earum et qui odio illo. Dolorem error perferendis architecto quo impedit. Magni aut et minus voluptas.', 7, 20, 1, 140);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (141, 'suscipit', '129', 'Expedita quaerat quis ipsum natus et aut. Itaque et sed consequatur laborum maxime sint.', 1, 21, 1, 141);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (142, 'accusantium', '3054', 'Est laudantium rerum nihil sit fuga velit. Illo ipsam fugiat ut. Quia dolor nesciunt in. Distinctio ducimus odit sit fuga doloribus alias.', 2, 22, 0, 142);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (143, 'explicabo', '4561', 'Quia non aliquam quibusdam quas. Et officia architecto reiciendis a accusamus. Minus quia laudantium amet eligendi. Autem ex accusamus sed dolorem dolore quos.', 3, 23, 1, 143);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (144, 'eius', '3634', 'Libero nobis dicta quis qui ut hic vel. Quaerat ut earum ipsa ad exercitationem eum. Labore id sint excepturi totam quaerat. Culpa non occaecati eveniet.', 4, 24, 0, 144);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (145, 'eos', '782', 'Voluptatem autem quos amet. Cupiditate repudiandae ex iusto aut consectetur rerum corrupti. Quia non quisquam placeat illo dolor eaque dignissimos.', 5, 25, 1, 145);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (146, 'assumenda', '4580', 'Animi expedita et ea assumenda incidunt. Voluptas nihil nesciunt velit ipsam neque amet eum eaque. Rem ipsam deleniti et. Et ducimus quidem expedita nam quaerat perspiciatis architecto.', 6, 26, 0, 146);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (147, 'molestiae', '3714', 'Sit eaque tenetur rerum dolor ducimus. Suscipit beatae temporibus laboriosam aperiam earum repudiandae aut exercitationem. Ut facere consequatur eveniet error dolorem ea excepturi.', 7, 27, 1, 147);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (148, 'dolorum', '122', 'Quam fugit quia porro occaecati suscipit. Ratione ipsa eaque distinctio totam qui molestias. Commodi provident consequuntur aut nemo. Adipisci consequatur quis fugit molestiae.', 1, 28, 1, 148);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (149, 'voluptatibus', '48', 'Sapiente laborum magni saepe doloribus repudiandae enim. Inventore aut aperiam nobis doloremque maxime. Dolor nostrum ut et occaecati reiciendis sit non.', 2, 29, 1, 149);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (150, 'cupiditate', '4608', 'Aut quod beatae perspiciatis quia error asperiores. Aspernatur autem omnis natus ut possimus et esse. Cupiditate aperiam sunt ut consequatur vero. Sint culpa sunt minima et vel provident tempore consequatur.', 3, 30, 1, 150);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (151, 'quos', '4624', 'Autem aliquid neque quibusdam aperiam explicabo sit et. Iure dolor voluptatem eveniet maxime sed. Fugit aliquid quia ut nam dolorem. Et exercitationem libero tempora laboriosam facere. Fuga et quaerat deserunt quia ratione natus consequatur ea.', 4, 31, 0, 151);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (152, 'velit', '1512', 'Vel dolorem voluptatibus animi aut. Temporibus molestiae sit cumque.', 5, 32, 0, 152);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (153, 'ut', '3152', 'Vel sunt voluptatem dolores. Molestiae velit aspernatur voluptatem sed suscipit voluptas. Soluta consequatur et voluptatum ut. Et architecto et animi labore non.', 6, 33, 1, 153);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (154, 'ad', '663', 'Ipsa voluptas maxime laudantium in quos laboriosam. Maiores illum voluptatum consectetur nostrum. Ullam qui fugiat optio porro sapiente veniam et.', 7, 34, 0, 154);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (155, 'sequi', '1708', 'Voluptas et beatae magnam deleniti. Rerum fugit accusamus dolores doloribus. Eius officiis veniam et. Veniam nihil et consequatur eos a minima voluptatem. Eveniet rerum aspernatur nihil rem vitae illo vero.', 1, 35, 0, 155);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (156, 'voluptatem', '2039', 'Fuga consectetur voluptatem consequatur dolor animi quasi. Delectus quidem vel nobis delectus sit sed minus non. Excepturi maiores quod non at sapiente ullam. Quas enim provident nihil placeat.', 2, 36, 1, 156);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (157, 'alias', '1998', 'In ratione iste quia quidem quo eveniet laborum. Expedita laudantium officiis quibusdam nulla. Officiis molestiae autem earum aut porro possimus.', 3, 37, 1, 157);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (158, 'sit', '3755', 'Magnam laboriosam est est distinctio amet. In qui rem quia in quisquam aut. Blanditiis molestiae id placeat eius sed accusamus perferendis.', 4, 38, 1, 158);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (159, 'iure', '447', 'Ad quia ullam minima deleniti et. Voluptate quis sunt quae explicabo. Eius est pariatur sint doloribus voluptate consequatur molestiae.', 5, 39, 0, 159);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (160, 'neque', '1585', 'Aut commodi repellat assumenda debitis et porro quia. Qui voluptates quia modi sit soluta aliquid. Eligendi eum in quis nihil delectus. Voluptas laborum ipsa doloremque sunt et dolore dolorum.', 6, 40, 1, 160);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (161, 'et', '2040', 'Consequatur blanditiis molestiae magni autem accusantium. Quia corporis magnam officiis cumque quibusdam nisi. Aut in officia quas dolores laborum culpa. Vero accusantium fuga architecto harum.', 7, 1, 0, 161);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (162, 'eligendi', '2008', 'Minima sint velit adipisci at omnis. Et facere amet ut aperiam quia. Officia molestias explicabo dicta ipsum nulla. Repudiandae consequatur dolores perspiciatis consequatur sapiente laborum voluptatibus. Dolore corrupti ipsa dicta voluptas velit tempora recusandae.', 1, 2, 0, 162);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (163, 'non', '2859', 'Laborum excepturi et fugit est. Magni totam illo iusto corrupti eius mollitia. Voluptatem nobis quos et dolore.', 2, 3, 1, 163);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (164, 'quia', '2154', 'Sequi qui corporis non odio voluptatibus sapiente ut. Quidem temporibus pariatur quisquam ab temporibus corporis ut. Molestias autem necessitatibus laudantium praesentium dolor. Provident necessitatibus consectetur nobis repellat.', 3, 4, 0, 164);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (165, 'temporibus', '2324', 'Rem velit accusamus beatae adipisci consequuntur. Et dolor minima minima ut sunt dolorem quaerat. Fugiat nesciunt illum qui consequatur libero consequatur. Eos est voluptatum esse officiis et architecto.', 4, 5, 0, 165);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (166, 'et', '1158', 'Ea qui rerum aut saepe sunt soluta velit. Repellat deleniti earum ad dolorem. Aut pariatur sed minima atque. Quo et veritatis aut non rem qui voluptatem. Voluptas dicta rerum nostrum perferendis rerum delectus expedita.', 5, 6, 0, 166);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (167, 'quo', '1793', 'Aut nobis atque quia qui sit aperiam unde. Exercitationem vero voluptas aut ullam est iusto fuga sunt. Vero ut debitis distinctio sint. Sapiente totam neque exercitationem natus adipisci.', 6, 7, 1, 167);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (168, 'a', '4614', 'Totam laboriosam rerum est impedit earum. Aut sed unde earum sit hic odit. Laudantium similique minus libero rem laudantium sequi.', 7, 8, 1, 168);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (169, 'et', '1583', 'Omnis enim illum voluptatum aperiam fuga. Voluptatem corporis aut quae quidem. Aspernatur delectus eligendi est debitis sunt rem.', 1, 9, 0, 169);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (170, 'neque', '688', 'Ex quasi qui odio voluptas iusto aut. Illum et aliquam recusandae aut possimus possimus sed. Saepe architecto commodi illo eum ut dolor est. Nisi qui id maxime non molestiae nesciunt culpa.', 2, 10, 0, 170);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (171, 'eaque', '2268', 'Numquam voluptas qui vitae illo. Vel veritatis enim quos. Ullam qui sapiente ipsa numquam ad et rerum. Laboriosam quos ut amet aliquid ea dolor blanditiis.', 3, 11, 0, 171);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (172, 'officiis', '3959', 'Deleniti eligendi accusamus non et deserunt. Voluptate quisquam rerum accusamus quibusdam. Temporibus molestias in nulla dolores culpa omnis.', 4, 12, 1, 172);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (173, 'sit', '4078', 'Et et deserunt officiis ullam qui nihil. Corporis reiciendis eos qui ad et. Id pariatur ea necessitatibus velit qui vel.', 5, 13, 1, 173);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (174, 'aut', '721', 'Itaque consequuntur sit officia placeat nihil recusandae et. Voluptas quibusdam dolorem et id placeat. Animi recusandae ea ea.', 6, 14, 1, 174);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (175, 'esse', '4528', 'Quidem sint optio nobis itaque consequatur ipsam nam. Ut asperiores doloribus perferendis numquam. Soluta assumenda nisi rerum deserunt. Corporis hic dolor facilis fugiat voluptas odio asperiores.', 7, 15, 0, 175);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (176, 'at', '3825', 'Culpa hic voluptate quis dolores exercitationem. Necessitatibus reiciendis incidunt recusandae sapiente qui consequatur aut asperiores. Aut fuga voluptatem natus eos tempore. Tempore sint dolores et repellendus. Iure velit aspernatur vel esse animi et ut.', 1, 16, 1, 176);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (177, 'incidunt', '126', 'Et aliquam veniam officia at et dolores ullam quasi. Ut ullam cum dolores suscipit voluptate eum suscipit. Voluptas dolor odio qui labore molestias deleniti.', 2, 17, 1, 177);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (178, 'rem', '2998', 'Eveniet vel sequi voluptatem excepturi nobis aut harum. Laudantium tenetur sed saepe odio sunt. Aut possimus consequatur sed quia dolores officiis voluptatem. Optio beatae tempore maiores accusantium reprehenderit. Error exercitationem atque molestiae sed cupiditate.', 3, 18, 0, 178);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (179, 'et', '101', 'Placeat atque aliquam est quo non perspiciatis. Aliquam voluptas rerum aut neque impedit enim. Pariatur totam officia animi. Eum omnis quos voluptate autem ipsam possimus tenetur.', 4, 19, 0, 179);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (180, 'consequatur', '606', 'Nulla sit autem aut a. Nihil non impedit adipisci sunt libero. Qui aut explicabo aut. Aut enim laboriosam et est.', 5, 20, 0, 180);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (181, 'et', '4825', 'Magni veniam corrupti cum sunt voluptas distinctio ut pariatur. Rerum tenetur voluptatum est aut qui laboriosam quia. Beatae perspiciatis porro et accusamus natus. Consequatur consequatur sed voluptatibus est necessitatibus quidem placeat.', 6, 21, 0, 181);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (182, 'dolorem', '515', 'Sunt minima ducimus ipsa sed dolorem. Officia ut nobis ducimus est laborum sit. Id incidunt quas ut necessitatibus nostrum nostrum magni. Quam velit amet qui laborum quas ea sed.', 7, 22, 1, 182);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (183, 'eaque', '548', 'Cupiditate numquam ut amet alias. Eum dicta rerum aperiam. Quisquam aut porro dolorem tenetur. Aut facilis non asperiores nam qui placeat.', 1, 23, 1, 183);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (184, 'expedita', '2646', 'Repudiandae provident consectetur quia quos sed. Sed magni enim repudiandae amet eveniet eligendi. Harum dolores vel nisi dicta id.', 2, 24, 0, 184);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (185, 'nisi', '4357', 'Eius id eum sit. Est ipsum delectus omnis ab ad aut. Quaerat eos aliquam quia iste. Sint vero iste vel soluta iste est ea.', 3, 25, 1, 185);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (186, 'pariatur', '1188', 'Dignissimos qui inventore enim dolor. Eveniet sed dolorem placeat est eaque non repellat. Nisi autem quas voluptatem. Totam neque repellendus fugiat corporis voluptas.', 4, 26, 0, 186);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (187, 'saepe', '4707', 'Recusandae ut ratione et qui aut sunt. Quia aut et perspiciatis autem explicabo fugiat.', 5, 27, 1, 187);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (188, 'est', '4874', 'Voluptate et modi saepe eum ipsa. Minima qui molestias temporibus qui dolore. Velit nobis quasi nesciunt nemo et id fuga ipsa. Asperiores alias ut quaerat sapiente aperiam.', 6, 28, 1, 188);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (189, 'itaque', '1306', 'Aliquid et deleniti sed et nulla et illum perferendis. Magni est et saepe voluptatem explicabo assumenda. Est dicta autem ullam aliquam libero rerum. Et libero ducimus harum et minus voluptatem nulla.', 7, 29, 0, 189);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (190, 'natus', '4456', 'Eum possimus aut mollitia rem. Consequatur recusandae ea cum eaque. Ipsam culpa aut magni quod et rerum nemo.', 1, 30, 1, 190);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (191, 'perspiciatis', '1706', 'Corporis et voluptatum repellendus totam enim nulla eius aut. Dolorem esse ducimus rerum repellat. Unde modi et dolorem necessitatibus excepturi veniam omnis. Mollitia quia dolorum consectetur rerum.', 2, 31, 1, 191);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (192, 'et', '3118', 'Omnis fugit quam porro accusamus quos. A ad ut voluptas dolores dolore. Velit similique sint quos ipsum illum id rem iusto.', 3, 32, 0, 192);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (193, 'et', '1480', 'Accusamus occaecati ullam beatae voluptates non molestiae. Error alias facilis repellat aut cum et et expedita. Magni voluptatem maiores consequatur inventore sapiente earum sequi.', 4, 33, 1, 193);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (194, 'dolore', '4926', 'Quia tempore placeat assumenda tempora culpa in quam. Natus qui sunt accusamus qui quia. Aut incidunt tempore neque velit nisi. Est quod fuga voluptatem ratione possimus quos hic. Quidem voluptas non earum laudantium.', 5, 34, 1, 194);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (195, 'voluptate', '3896', 'Blanditiis ad ad est et officiis vitae. Autem omnis odio id quo qui voluptatem ipsum. Saepe qui nemo dolores dolore nobis et sed. Nulla ut doloremque accusamus.', 6, 35, 0, 195);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (196, 'autem', '4726', 'Dolor deserunt velit est quia sint rerum soluta explicabo. Nihil vero sed dolorum illum nulla quis veritatis. Ipsa dolores accusantium molestiae id neque accusamus voluptas. Omnis adipisci veritatis ipsa est sapiente ex.', 7, 36, 0, 196);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (197, 'itaque', '563', 'Voluptate pariatur iste et voluptatem in modi. Expedita facilis ab amet vero excepturi. Placeat dolorem quas et nobis deleniti omnis. Iste sunt nisi quos soluta aut unde.', 1, 37, 0, 197);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (198, 'quia', '1566', 'Veritatis doloremque maiores excepturi eos incidunt. Nisi est recusandae voluptas itaque neque similique harum quis. Ut vitae debitis voluptates velit ut. Quia tenetur rerum rerum corporis repellat.', 2, 38, 1, 198);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (199, 'fugit', '2680', 'Eos earum iste odio optio maxime quas blanditiis rerum. Eum a et est eum quibusdam aliquam. Ut expedita quia esse qui inventore voluptas.', 3, 39, 0, 199);
INSERT INTO `menu` (`id`, `course_name`, `price`, `description`, `food_category_id`, `restaurant_id`, `is_available`, `image_id`) VALUES (200, 'beatae', '2768', 'Laboriosam dolor dolor dolor dolor eaque velit. Dolores tenetur nihil quia. Aperiam mollitia voluptatem enim minima dolores temporibus perspiciatis.', 4, 40, 1, 200);

-- Таблица users

INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (1, 'Omer', 'Terry', 'F', '2011-04-12', '1-664-587-9928', 'mafalda.shields@example.org', '2019-08-02 18:31:02', '2019-01-10 06:33:28');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (2, 'Torrey', 'Considine', 'F', '1989-12-21', '702.812.6562x81457', 'isabelle.kuphal@example.com', '2019-12-19 16:07:58', '2019-08-31 08:43:29');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (3, 'Lulu', 'Bauch', 'M', '1990-05-09', '1-264-076-2053x34181', 'rbaumbach@example.com', '2019-04-12 09:19:35', '2019-11-13 06:28:46');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (4, 'Noel', 'Vandervort', 'M', '2015-05-23', '695.093.1470x0295', 'arnaldo.terry@example.org', '2019-04-03 19:21:26', '2019-01-08 23:38:18');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (5, 'Crystel', 'Morissette', 'M', '1981-05-08', '742-651-8113', 'jhaag@example.net', '2019-10-17 21:07:29', '2019-04-18 11:14:37');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (6, 'Chanelle', 'Kihn', 'F', '1971-10-15', '608.163.6038', 'hanna.hahn@example.net', '2019-07-10 10:42:17', '2019-03-22 09:00:46');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (7, 'Ocie', 'O\'Conner', 'M', '1992-05-06', '697.463.3419', 'mellie11@example.com', '2019-10-10 21:21:46', '2019-07-22 03:11:56');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (8, 'Amina', 'Kohler', 'F', '2014-06-26', '475-780-6831x8200', 'luna55@example.net', '2019-05-06 11:52:18', '2019-08-20 14:09:00');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (9, 'Herman', 'Kub', 'F', '1979-12-15', '1-923-567-6821', 'amie16@example.net', '2019-01-05 20:52:25', '2019-01-24 13:51:14');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (10, 'Jameson', 'Kub', 'M', '1977-05-09', '714-480-2754x8524', 'haag.gabrielle@example.net', '2019-02-28 15:41:22', '2019-04-22 09:28:40');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (11, 'Allene', 'Gaylord', 'F', '1979-01-29', '311-596-4502x1425', 'lo\'kon@example.org', '2019-07-29 03:49:56', '2019-07-12 21:44:35');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (12, 'Isabelle', 'Hickle', 'M', '1976-03-21', '519-193-9070', 'ledner.emmanuelle@example.org', '2019-05-20 11:47:45', '2019-05-06 19:52:15');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (13, 'Billie', 'Raynor', 'M', '2005-08-13', '1-816-383-9720x248', 'leanne.moen@example.org', '2019-02-08 14:38:01', '2019-10-13 04:55:43');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (14, 'Kennith', 'Adams', 'M', '2009-02-02', '1-576-888-4432', 'zmayert@example.com', '2019-12-23 01:13:37', '2019-10-06 12:13:06');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (15, 'Meggie', 'Little', 'M', '2015-03-21', '769.962.2448', 'hammes.gonzalo@example.org', '2019-07-21 10:22:54', '2019-02-18 23:13:31');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (16, 'Jonas', 'Cremin', 'M', '1985-12-14', '665-246-5410x377', 'mann.maxwell@example.org', '2019-07-06 17:40:22', '2019-11-21 12:10:39');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (17, 'Tressa', 'Champlin', 'F', '2013-01-18', '(866)703-0539', 'zackary.gottlieb@example.net', '2019-07-27 08:22:31', '2019-03-01 21:46:30');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (18, 'Allen', 'Gislason', 'M', '2003-08-27', '084-900-3902x8651', 'efrain83@example.net', '2019-04-22 03:24:50', '2019-01-15 18:48:10');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (19, 'Lennie', 'Barton', 'M', '2010-06-05', '(213)248-1243x272', 'buddy.adams@example.com', '2019-04-05 12:00:53', '2019-10-17 00:41:39');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (20, 'Pete', 'Ernser', 'F', '1988-03-03', '573.661.8710', 'spinka.kristofer@example.com', '2019-04-30 22:58:47', '2019-10-18 04:33:49');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (21, 'Anthony', 'Nicolas', 'M', '2007-08-14', '1-929-336-1338', 'sporer.darren@example.com', '2019-02-28 21:19:00', '2019-08-04 13:16:18');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (22, 'Geo', 'White', 'M', '2000-04-06', '980-290-2026x5945', 'auer.glenda@example.com', '2019-09-17 16:06:36', '2019-02-19 05:56:57');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (23, 'Ryder', 'Howe', 'M', '2019-04-30', '199.880.5606x906', 'colleen05@example.org', '2019-08-04 21:32:45', '2019-04-04 07:46:39');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (24, 'Marjolaine', 'Pagac', 'M', '1999-04-02', '(709)187-3984', 'wilkinson.sofia@example.net', '2019-10-21 16:58:52', '2019-11-03 03:22:46');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (25, 'Pasquale', 'Jenkins', 'M', '1999-05-25', '299-960-1423x577', 'kelly.bartoletti@example.com', '2019-05-16 09:42:31', '2019-09-10 21:16:12');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (26, 'Anissa', 'Bruen', 'F', '1975-04-09', '+83(7)6126195015', 'magnus70@example.com', '2019-11-16 10:20:20', '2019-05-28 16:35:40');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (27, 'Richard', 'Daniel', 'M', '1976-03-28', '762-010-4819', 'ywhite@example.net', '2019-10-09 22:59:27', '2019-07-31 23:58:55');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (28, 'Mertie', 'Bode', 'M', '1979-10-25', '720.794.1118', 'goyette.gay@example.net', '2019-03-21 18:08:53', '2019-09-12 09:51:24');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (29, 'Timmy', 'Altenwerth', 'F', '2008-08-15', '+55(0)2291979958', 'fredy.spencer@example.net', '2019-11-02 08:52:59', '2019-07-25 20:05:31');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (30, 'Zita', 'Huel', 'F', '1980-10-20', '(490)732-8785', 'neffertz@example.net', '2019-06-12 05:09:50', '2019-09-06 04:36:26');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (31, 'Fritz', 'Schuster', 'F', '1992-03-22', '523-080-2231x3029', 'deborah32@example.org', '2019-09-30 07:27:34', '2019-03-24 07:41:15');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (32, 'Presley', 'West', 'F', '1986-09-17', '1-857-070-0630', 'schaden.darren@example.com', '2019-05-06 19:24:46', '2019-10-13 06:06:15');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (33, 'Retha', 'Beer', 'M', '2006-03-05', '486-637-4892x68214', 'fgerlach@example.net', '2019-10-27 02:15:16', '2019-12-17 12:29:51');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (34, 'Benton', 'Lind', 'M', '1989-10-20', '939.764.3821x442', 'd\'amore.rubye@example.org', '2018-12-31 12:01:12', '2019-06-19 22:09:30');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (35, 'Donnell', 'Okuneva', 'M', '2000-07-01', '(149)454-2628x39671', 'oleta.ward@example.com', '2019-04-04 05:31:34', '2019-07-01 10:03:20');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (36, 'Garfield', 'Kuhlman', 'F', '1971-08-31', '06726941201', 'dominic.ryan@example.org', '2019-03-04 01:42:05', '2019-07-25 20:37:03');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (37, 'Donato', 'Jaskolski', 'M', '2009-08-30', '112.668.4901x459', 'laverne20@example.org', '2019-11-24 17:16:37', '2019-02-27 12:46:35');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (38, 'Ludie', 'Grant', 'M', '2010-02-28', '305-447-9710x20561', 'gkling@example.org', '2019-09-18 20:42:11', '2019-06-04 12:37:59');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (39, 'Tyson', 'Quitzon', 'F', '1992-08-23', '1-732-555-0410x69455', 'wilber.stoltenberg@example.com', '2019-07-02 01:51:43', '2019-10-12 22:36:13');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (40, 'Joanne', 'Dooley', 'F', '1993-09-13', '751.677.7200', 'lbashirian@example.com', '2019-08-28 21:58:20', '2019-01-09 18:07:53');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (41, 'Ross', 'Parker', 'F', '1986-09-06', '044.005.0174x04100', 'pschuster@example.com', '2019-07-19 13:24:06', '2019-04-28 20:42:48');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (42, 'Antonina', 'Gleason', 'F', '2014-04-29', '064-104-8337x21450', 'tiffany.leffler@example.net', '2019-02-11 18:01:37', '2019-03-04 21:14:08');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (43, 'Stanley', 'Hodkiewicz', 'F', '2002-06-11', '(855)530-7441x774', 'jordy.kovacek@example.com', '2019-12-15 20:32:27', '2019-11-24 16:47:41');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (44, 'Mya', 'Jenkins', 'F', '1974-07-05', '338.736.2733', 'grant.clifton@example.net', '2019-11-12 07:19:01', '2019-07-15 16:26:08');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (45, 'Nedra', 'Quigley', 'M', '2011-03-21', '1-806-415-6127', 'spagac@example.net', '2019-03-20 00:42:44', '2019-01-29 17:08:21');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (46, 'Audra', 'Botsford', 'M', '1988-11-29', '404.689.7021', 'scot.bins@example.org', '2019-09-08 11:30:27', '2019-02-13 12:52:37');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (47, 'Mattie', 'Jakubowski', 'M', '2003-06-30', '1-026-814-2780x6860', 'xkoch@example.org', '2019-07-02 13:28:32', '2019-10-15 16:43:59');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (48, 'Rhoda', 'Treutel', 'F', '2002-11-22', '+30(9)0620894014', 'ashton.dicki@example.net', '2019-11-23 08:52:08', '2019-06-16 11:21:00');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (49, 'Alda', 'Kihn', 'F', '1985-12-05', '1-143-146-0556', 'champlin.kiana@example.net', '2019-05-01 22:48:54', '2019-09-18 20:32:33');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (50, 'Renee', 'Lakin', 'M', '2004-01-11', '900-143-6925', 'nicolas.rosendo@example.net', '2019-08-11 15:13:53', '2019-01-15 05:35:54');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (51, 'Athena', 'Hettinger', 'F', '1987-02-04', '200.221.4833', 'gkshlerin@example.net', '2019-09-28 00:49:12', '2019-03-11 20:38:39');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (52, 'Noe', 'Hauck', 'F', '1996-11-26', '1-479-999-1140x10895', 'wisozk.amanda@example.org', '2019-06-15 11:03:59', '2019-04-01 15:45:11');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (53, 'Edna', 'Gaylord', 'F', '2017-09-04', '+75(5)2644095905', 'emelia68@example.net', '2019-05-06 19:19:46', '2019-06-05 15:15:35');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (54, 'Hortense', 'Ruecker', 'M', '1980-06-30', '(630)003-3490x580', 'lloyd27@example.com', '2019-10-24 14:40:23', '2019-08-21 09:47:33');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (55, 'Jillian', 'Hirthe', 'F', '2013-04-07', '+88(8)0814466468', 'paige42@example.com', '2019-03-22 20:28:34', '2019-07-23 17:01:28');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (56, 'Jamie', 'Ziemann', 'F', '2014-02-09', '(956)892-4089x14623', 'isobel.price@example.net', '2019-06-06 05:22:22', '2019-04-27 22:16:11');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (57, 'Blaze', 'Rohan', 'M', '2000-09-17', '388-057-8508', 'eprohaska@example.org', '2019-08-18 05:49:17', '2019-12-03 18:54:02');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (58, 'Tianna', 'Sawayn', 'M', '2008-06-16', '819-053-7959', 'westley79@example.net', '2019-05-18 20:14:50', '2019-01-25 13:32:07');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (59, 'Ludwig', 'Conroy', 'M', '2008-01-19', '1-407-129-5773x461', 'lauryn.anderson@example.com', '2019-10-15 16:57:15', '2019-08-07 22:36:22');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (60, 'Josie', 'Becker', 'F', '2007-04-14', '(273)375-1556', 'llebsack@example.org', '2019-08-16 12:24:17', '2019-11-01 00:41:08');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (61, 'Easter', 'Conroy', 'F', '2010-07-13', '743.644.2448', 'klemke@example.com', '2019-09-10 02:16:04', '2019-06-01 23:59:20');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (62, 'Annette', 'Schiller', 'M', '1997-09-28', '229.938.3425x3025', 'clemmie44@example.org', '2019-07-01 06:32:26', '2019-07-05 06:53:12');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (63, 'Ryley', 'Marvin', 'M', '1973-06-11', '012-343-8681x2882', 'brian.shanahan@example.com', '2019-05-15 15:00:58', '2019-11-11 06:54:45');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (64, 'Hector', 'Wiza', 'M', '2015-06-17', '04760922242', 'burnice04@example.com', '2019-03-19 19:24:50', '2019-06-04 20:11:58');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (65, 'Clotilde', 'Upton', 'F', '1983-04-11', '(832)223-4526x48046', 'geffertz@example.com', '2019-03-07 10:15:10', '2019-01-08 20:43:36');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (66, 'Thea', 'Dicki', 'F', '1997-12-13', '981-758-4037x423', 'matt39@example.org', '2019-08-18 23:13:38', '2019-11-13 23:47:32');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (67, 'Consuelo', 'Gerlach', 'M', '2017-11-20', '217-298-7179x9400', 'reginald.pfeffer@example.net', '2019-06-20 16:30:34', '2019-11-23 16:38:08');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (68, 'Omari', 'Funk', 'F', '1981-04-24', '1-795-165-5302x6866', 'mmedhurst@example.com', '2019-09-30 18:28:59', '2019-05-19 02:09:11');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (69, 'Paige', 'Cormier', 'F', '2019-11-03', '1-233-046-5187', 'lafayette67@example.org', '2019-05-11 08:54:02', '2019-03-04 19:25:08');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (70, 'Luigi', 'Buckridge', 'F', '1980-05-28', '1-348-421-3281x7350', 'iosinski@example.org', '2019-07-02 22:53:24', '2019-07-25 13:28:00');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (71, 'Dovie', 'Gibson', 'M', '2012-07-07', '1-066-320-1649x4225', 'mercedes79@example.net', '2019-11-25 23:35:03', '2019-07-06 19:21:18');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (72, 'Josiane', 'Hilpert', 'M', '2000-10-02', '425.864.3046', 'vferry@example.org', '2019-01-15 15:34:01', '2019-08-27 09:05:51');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (73, 'Ayla', 'Batz', 'F', '2009-03-09', '+15(7)7198789254', 'dhaley@example.net', '2019-08-19 23:17:49', '2019-01-02 10:22:35');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (74, 'Vilma', 'Auer', 'M', '2005-10-02', '505-964-6935', 'uweimann@example.net', '2019-08-02 20:22:27', '2019-03-01 08:38:16');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (75, 'Anya', 'Stoltenberg', 'F', '1980-04-05', '591-521-4922x773', 'laurine.rice@example.net', '2019-05-26 20:25:50', '2019-09-28 09:02:07');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (76, 'Jett', 'Carter', 'M', '1970-03-24', '520-552-1634x469', 'zachariah51@example.com', '2019-01-17 15:58:23', '2019-07-29 18:52:28');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (77, 'Gaylord', 'Wiegand', 'F', '1980-02-07', '515-967-0261x7757', 'marvin.meagan@example.net', '2019-06-08 20:07:01', '2019-02-03 18:36:38');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (78, 'Cale', 'Sipes', 'M', '1978-11-29', '(533)312-9800', 'tluettgen@example.org', '2019-07-27 13:46:57', '2019-05-01 09:30:14');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (79, 'Laurie', 'Hills', 'M', '2012-07-06', '674-652-2751x394', 'june20@example.org', '2019-08-13 14:28:35', '2019-06-09 23:49:40');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (80, 'Leonard', 'Prosacco', 'F', '1987-01-01', '(903)985-2457x4948', 'williamson.neva@example.net', '2019-07-01 16:59:02', '2019-10-17 01:30:12');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (81, 'Genevieve', 'Ortiz', 'M', '1980-10-19', '959-877-6683x671', 'evangeline.bergnaum@example.com', '2019-01-26 14:57:13', '2019-03-13 11:11:05');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (82, 'Taryn', 'King', 'F', '1972-05-01', '+31(5)6762594607', 'marianne44@example.net', '2019-11-05 22:36:23', '2019-01-02 11:58:54');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (83, 'Conrad', 'Schuppe', 'M', '2017-03-25', '1-773-708-7510x819', 'osborne92@example.org', '2019-01-02 01:59:47', '2019-07-11 14:17:39');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (84, 'Humberto', 'Lakin', 'M', '1985-09-29', '+97(6)2885165921', 'fritsch.payton@example.org', '2019-06-15 22:21:10', '2019-04-25 00:17:55');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (85, 'Devante', 'Lakin', 'M', '1989-02-14', '1-914-958-7236', 'iboehm@example.com', '2019-05-21 21:47:46', '2019-07-08 17:44:16');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (86, 'Annie', 'Donnelly', 'M', '2013-10-24', '028-348-2543', 'cgleichner@example.com', '2019-10-13 17:04:30', '2019-09-05 21:09:18');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (87, 'Chelsie', 'Bode', 'F', '1988-02-20', '+30(7)7362371492', 'tyson.predovic@example.org', '2019-08-02 17:38:26', '2019-02-19 23:29:45');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (88, 'Jarrod', 'Hintz', 'F', '2008-09-12', '(112)179-9477', 'kwiza@example.net', '2018-12-31 13:27:55', '2019-11-05 22:07:39');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (89, 'Vito', 'Gulgowski', 'M', '1985-04-08', '(828)527-3254x324', 'ivandervort@example.org', '2019-09-16 00:22:33', '2019-02-20 08:19:51');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (90, 'Joanny', 'Konopelski', 'M', '1975-07-31', '858.134.2975x76979', 'fgleason@example.org', '2019-03-11 04:25:56', '2019-03-02 11:03:40');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (91, 'Charlene', 'Harris', 'M', '1994-07-07', '(672)675-0513x0301', 'cmurazik@example.org', '2019-06-16 11:51:21', '2019-04-30 07:04:37');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (92, 'Marilyne', 'Ankunding', 'F', '1977-01-21', '04712575160', 'hheathcote@example.com', '2019-03-18 08:20:44', '2019-11-20 21:59:12');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (93, 'Alexandra', 'Torphy', 'M', '2014-10-04', '(272)341-7125x9834', 'xlueilwitz@example.net', '2019-12-25 02:29:30', '2019-01-03 10:00:07');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (94, 'Vergie', 'Cummerata', 'F', '2016-09-07', '664.865.0192', 'dach.arnulfo@example.org', '2019-05-22 15:30:18', '2019-05-03 06:51:08');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (95, 'Leopoldo', 'Mertz', 'M', '1997-04-30', '07220799782', 'ndietrich@example.com', '2019-09-12 22:47:32', '2019-08-02 14:57:12');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (96, 'Macy', 'Watsica', 'M', '1979-07-18', '+98(8)7508469084', 'luisa86@example.net', '2019-10-01 21:42:18', '2019-01-22 23:57:13');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (97, 'Garrett', 'Marquardt', 'M', '2019-04-28', '(181)821-9474x890', 'kreichel@example.com', '2019-05-12 00:42:53', '2019-01-10 01:53:25');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (98, 'Taya', 'Marquardt', 'F', '1992-06-07', '+22(4)1773239862', 'adelbert99@example.org', '2019-09-05 09:56:22', '2019-06-06 03:41:03');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (99, 'Johanna', 'Rutherford', 'M', '1999-10-21', '463-797-2835', 'ikuhic@example.org', '2019-01-01 06:55:51', '2019-12-14 11:35:19');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (100, 'June', 'Ratke', 'M', '1992-02-10', '495-293-0455x91789', 'so\'keefe@example.net', '2019-06-20 01:46:33', '2019-09-24 21:37:49');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (101, 'Dessie', 'Pagac', 'M', '1988-02-17', '477.125.7487x755', 'abshire.eugene@example.org', '2019-11-13 04:52:07', '2019-10-21 20:49:53');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (102, 'Cleora', 'Cartwright', 'M', '2009-12-06', '(644)903-2472x5942', 'emmerich.dewayne@example.com', '2019-12-20 18:49:31', '2019-08-16 06:13:51');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (103, 'Kobe', 'Cormier', 'F', '1997-04-30', '934-177-6423', 'zena95@example.com', '2019-01-05 07:06:09', '2019-03-29 23:54:35');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (104, 'Lilla', 'Gleichner', 'M', '1998-05-26', '259-128-5749x91104', 'dina.hoppe@example.net', '2019-04-25 16:40:01', '2019-02-24 12:54:16');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (105, 'Zakary', 'Conn', 'M', '2005-01-31', '(842)305-9846', 'joaquin08@example.net', '2019-02-15 07:00:59', '2019-02-07 10:14:15');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (106, 'Ettie', 'Moore', 'F', '1997-01-15', '1-027-524-9182', 'akassulke@example.net', '2019-02-17 19:12:24', '2019-06-28 04:32:39');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (107, 'Litzy', 'Dickens', 'M', '1993-12-21', '06566314237', 'elisha34@example.org', '2019-11-05 02:07:56', '2019-01-20 08:53:12');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (108, 'Simeon', 'Mills', 'M', '1994-04-10', '684-039-0817', 'antonio34@example.com', '2019-06-10 15:21:47', '2019-12-28 02:38:46');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (109, 'Nora', 'Dach', 'F', '2003-01-24', '(981)058-1386x70328', 'rempel.juliana@example.org', '2019-11-10 17:05:31', '2019-11-25 15:31:52');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (110, 'Duncan', 'Mohr', 'F', '2009-06-22', '914.236.4117', 'josefa.schmitt@example.net', '2019-03-01 03:31:11', '2019-07-15 04:15:39');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (111, 'Berry', 'Mann', 'M', '1997-07-01', '579-581-1524', 'barton.justina@example.com', '2019-08-24 17:23:58', '2019-11-14 21:57:01');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (112, 'Jay', 'Kuvalis', 'F', '2009-03-08', '030.015.3886', 'elissa82@example.net', '2019-11-20 06:32:51', '2019-04-27 04:15:03');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (113, 'Toney', 'Stehr', 'F', '1974-08-06', '1-599-986-8999x2058', 'ethyl05@example.org', '2019-12-01 13:23:40', '2019-04-29 02:28:18');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (114, 'Austyn', 'Dicki', 'M', '1996-10-27', '033-769-1876x760', 'witting.emily@example.com', '2019-01-02 21:14:21', '2019-03-02 19:18:29');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (115, 'Cyril', 'Harber', 'M', '1988-05-06', '1-763-974-7623x41620', 'gaylord.arjun@example.org', '2019-12-17 14:27:22', '2019-02-08 13:24:53');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (116, 'Grayce', 'Wolf', 'F', '2007-04-07', '(602)860-9249', 'olemke@example.net', '2019-02-03 04:22:26', '2019-06-28 13:46:56');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (117, 'Haley', 'Weissnat', 'M', '1978-05-03', '746.058.5480', 'gino47@example.net', '2019-05-03 02:31:10', '2019-10-02 22:58:54');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (118, 'Fidel', 'McGlynn', 'M', '2008-12-24', '(713)097-4521x9046', 'rice.maximus@example.com', '2019-04-30 11:39:23', '2019-11-05 07:47:38');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (119, 'Kirk', 'Anderson', 'F', '1996-04-16', '299.045.8318', 'barrows.dangelo@example.com', '2019-08-12 20:34:34', '2019-02-17 14:38:07');
INSERT INTO `users` (`id`, `name`, `surname`, `sex`, `birthday`, `phone`, `mail`, `created_at`, `updated_at`) VALUES (120, 'Clemmie', 'Crooks', 'M', '1999-06-30', '(582)379-6355x38202', 'kcorkery@example.net', '2019-05-15 18:06:39', '2019-07-15 10:42:14');

-- Таблица orders

INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (1, 1, 1, '2019-05-07 00:28:47', '1', '2009-12-18 03:17:48', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (2, 2, 2, '2015-08-17 09:05:02', '1', '2017-11-20 18:05:27', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (3, 3, 3, '2008-07-21 15:39:10', '', '2015-12-03 15:44:10', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (4, 4, 4, '2006-12-19 06:37:18', '1', '2017-01-05 04:44:55', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (5, 5, 5, '2010-03-20 16:30:07', '', '1979-11-26 00:20:14', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (6, 6, 6, '1983-05-12 14:55:22', '1', '1977-06-23 05:31:35', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (7, 7, 7, '2000-12-23 08:49:28', '1', '2001-09-18 15:50:59', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (8, 8, 8, '1998-08-27 06:13:34', '', '1993-01-04 11:23:41', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (9, 9, 9, '1970-11-13 01:30:59', '1', '1989-12-28 12:08:56', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (10, 10, 10, '1978-05-26 06:29:32', '', '1977-04-05 14:52:35', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (11, 11, 11, '1977-08-21 16:27:38', '1', '1979-06-25 04:30:55', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (12, 12, 12, '1971-10-31 18:09:11', '1', '2013-05-04 14:55:24', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (13, 13, 13, '1990-11-25 11:30:27', '', '2003-01-13 03:11:30', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (14, 14, 14, '2013-11-10 10:49:46', '1', '1988-11-04 00:30:04', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (15, 15, 15, '1991-07-27 14:19:05', '', '2013-08-22 05:09:30', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (16, 16, 16, '1985-06-24 16:09:58', '', '2002-03-03 08:52:10', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (17, 17, 17, '2016-08-03 14:15:04', '1', '1993-01-19 09:03:53', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (18, 18, 18, '2010-07-06 15:12:47', '', '2019-09-25 23:24:52', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (19, 19, 19, '1983-12-21 19:48:07', '', '1991-10-05 04:34:50', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (20, 20, 20, '1997-10-16 10:11:02', '1', '1978-07-04 17:53:58', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (21, 21, 21, '2017-04-17 18:35:53', '', '2008-09-09 16:16:11', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (22, 22, 22, '1990-04-19 04:19:06', '', '1990-09-26 16:35:58', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (23, 23, 23, '2015-02-28 03:24:36', '', '2013-05-08 21:04:40', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (24, 24, 24, '1998-06-05 14:38:27', '', '2012-11-07 08:39:51', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (25, 25, 25, '1972-03-17 06:53:32', '', '1995-07-08 08:40:39', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (26, 26, 26, '1985-09-11 19:10:33', '', '1982-07-29 05:29:34', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (27, 27, 27, '2016-08-27 07:04:15', '1', '1982-02-07 00:31:33', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (28, 28, 28, '2009-08-13 16:33:29', '', '1988-09-27 23:53:17', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (29, 29, 29, '1985-05-27 09:03:34', '', '2010-07-05 17:45:24', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (30, 30, 30, '1998-11-18 11:11:24', '', '1990-01-03 00:28:26', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (31, 31, 31, '2003-07-20 11:17:43', '1', '2002-03-20 05:01:29', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (32, 32, 32, '2003-11-25 12:21:14', '', '1991-06-06 15:22:02', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (33, 33, 33, '2000-08-24 20:36:05', '', '1994-03-19 12:46:55', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (34, 34, 34, '1981-08-02 01:33:01', '1', '2007-02-02 13:52:20', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (35, 35, 35, '1980-07-31 18:21:41', '', '1986-10-20 17:36:17', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (36, 36, 36, '2008-12-22 21:24:25', '', '2013-06-04 22:14:41', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (37, 37, 37, '2002-11-18 17:48:54', '', '1996-05-03 22:20:52', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (38, 38, 38, '1973-07-19 19:57:28', '1', '2009-04-18 17:22:09', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (39, 39, 39, '2017-06-22 13:37:53', '1', '1984-07-02 08:39:47', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (40, 40, 40, '1982-05-23 23:16:15', '', '2000-04-12 10:30:25', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (41, 41, 41, '2019-03-04 22:29:02', '1', '1971-03-04 03:11:51', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (42, 42, 42, '1999-03-19 03:10:31', '1', '2006-04-11 10:38:14', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (43, 43, 43, '2013-09-13 08:09:54', '', '1986-08-28 02:33:23', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (44, 44, 44, '2003-07-22 07:30:57', '1', '2011-08-14 17:16:25', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (45, 45, 45, '1992-07-13 22:48:13', '1', '1997-03-01 12:31:14', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (46, 46, 46, '2019-05-03 01:10:17', '1', '2010-04-17 07:27:32', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (47, 47, 47, '2010-12-10 10:29:28', '', '1999-06-21 21:04:14', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (48, 48, 48, '2009-07-14 07:43:48', '', '2005-03-23 10:07:01', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (49, 49, 49, '2018-04-17 19:10:39', '', '1972-07-03 02:35:59', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (50, 50, 50, '1975-05-16 13:26:17', '1', '1983-03-11 01:28:07', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (51, 51, 1, '1984-09-16 13:19:53', '', '2001-03-08 14:36:52', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (52, 52, 2, '2015-12-18 22:44:22', '1', '1986-10-04 04:28:32', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (53, 53, 3, '1982-06-26 13:40:46', '', '2008-04-24 02:21:41', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (54, 54, 4, '1984-03-01 23:54:23', '', '1983-09-22 04:16:23', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (55, 55, 5, '1987-04-15 02:00:30', '', '1977-07-26 05:53:09', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (56, 56, 6, '2018-02-20 01:07:28', '', '1978-08-10 00:07:06', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (57, 57, 7, '1980-02-07 16:12:19', '', '1971-01-05 13:07:53', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (58, 58, 8, '1993-02-22 11:32:37', '1', '1979-11-16 22:34:44', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (59, 59, 9, '2001-02-14 07:08:49', '', '2012-08-11 09:05:16', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (60, 60, 10, '2004-10-09 07:18:18', '', '2004-09-25 11:42:30', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (61, 61, 11, '1988-03-16 02:01:23', '1', '2006-01-26 16:54:05', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (62, 62, 12, '1975-09-24 02:02:21', '1', '2016-03-19 12:14:04', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (63, 63, 13, '2010-10-25 20:08:16', '1', '1979-10-04 14:15:55', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (64, 64, 14, '2011-03-17 11:01:54', '1', '1999-10-01 04:32:33', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (65, 65, 15, '2003-11-02 05:35:07', '1', '1992-07-03 02:56:24', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (66, 66, 16, '1972-03-17 07:07:58', '', '1978-10-15 18:09:36', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (67, 67, 17, '2011-06-19 10:44:14', '', '1977-05-03 19:00:24', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (68, 68, 18, '2006-09-29 17:16:50', '1', '2011-07-23 11:11:25', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (69, 69, 19, '1984-09-06 17:29:58', '', '1991-10-21 06:19:30', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (70, 70, 20, '2001-03-12 14:23:42', '1', '2002-07-03 06:00:29', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (71, 71, 21, '1999-05-23 15:16:49', '', '1984-08-21 06:44:41', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (72, 72, 22, '1990-04-09 13:43:06', '', '2016-07-02 08:09:53', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (73, 73, 23, '1994-04-24 15:58:17', '', '2006-08-03 06:58:29', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (74, 74, 24, '2013-03-23 05:05:05', '', '2010-10-04 00:18:21', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (75, 75, 25, '1995-08-20 06:31:15', '1', '2006-08-05 04:58:11', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (76, 76, 26, '2011-11-19 15:50:05', '1', '1986-06-09 14:53:59', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (77, 77, 27, '1983-03-06 09:26:03', '1', '1974-12-06 06:05:15', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (78, 78, 28, '1978-06-03 01:16:38', '', '2007-12-31 05:08:36', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (79, 79, 29, '1982-06-07 18:35:07', '', '2004-08-08 23:12:38', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (80, 80, 30, '1972-04-08 04:02:25', '', '1977-07-25 07:35:02', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (81, 81, 31, '1975-12-15 08:26:53', '1', '2018-12-09 16:15:52', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (82, 82, 32, '1980-12-11 23:36:39', '', '1975-11-30 02:18:27', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (83, 83, 33, '1984-05-17 15:55:12', '', '2000-11-13 22:52:33', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (84, 84, 34, '2006-03-15 08:30:37', '1', '2013-02-15 14:45:28', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (85, 85, 35, '1991-11-30 10:26:12', '1', '2003-07-17 13:50:26', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (86, 86, 36, '1977-02-15 15:25:18', '', '1979-03-21 19:24:21', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (87, 87, 37, '1991-12-15 15:58:05', '1', '1983-07-08 09:09:13', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (88, 88, 38, '2010-12-15 13:30:18', '', '1992-11-29 00:32:55', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (89, 89, 39, '1998-06-10 01:57:14', '1', '2012-07-08 11:04:09', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (90, 90, 40, '2000-08-15 05:16:13', '', '1982-04-01 09:04:38', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (91, 91, 41, '2011-11-27 15:55:41', '', '1980-01-20 18:26:15', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (92, 92, 42, '2008-05-27 23:54:50', '', '1988-01-01 23:44:55', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (93, 93, 43, '2002-01-17 10:41:53', '1', '1998-05-16 08:34:43', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (94, 94, 44, '1993-11-13 19:40:16', '1', '1988-10-27 03:08:09', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (95, 95, 45, '1999-08-24 17:32:20', '', '1990-12-04 00:16:14', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (96, 96, 46, '1975-08-25 05:59:03', '1', '1988-09-28 16:06:35', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (97, 97, 47, '2019-12-03 03:22:52', '', '1978-08-22 23:08:52', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (98, 98, 48, '1973-02-24 07:33:19', '1', '1999-01-22 05:48:13', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (99, 99, 49, '1992-09-09 05:08:10', '', '1997-02-11 18:14:04', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (100, 100, 50, '1997-08-04 07:06:36', '1', '2007-05-06 12:41:42', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (101, 101, 1, '1978-09-18 08:43:00', '1', '1985-12-23 17:05:12', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (102, 102, 2, '1995-07-17 22:31:52', '', '1977-08-25 14:03:56', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (103, 103, 3, '1982-06-16 08:36:45', '', '2010-07-12 15:09:23', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (104, 104, 4, '1987-08-08 10:19:45', '', '2001-10-10 01:02:54', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (105, 105, 5, '1980-12-08 06:14:48', '', '1996-07-24 19:41:51', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (106, 106, 6, '2006-12-19 05:51:48', '1', '1976-01-13 06:05:18', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (107, 107, 7, '1978-01-10 21:55:31', '', '1990-04-05 09:27:40', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (108, 108, 8, '1988-06-15 08:24:07', '', '1980-11-04 16:18:53', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (109, 109, 9, '2009-05-10 23:51:17', '1', '1987-12-23 21:45:51', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (110, 110, 10, '2001-11-11 20:53:27', '1', '1972-11-22 08:24:57', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (111, 111, 11, '1991-04-07 16:09:44', '', '2013-12-23 03:36:44', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (112, 112, 12, '2005-09-10 13:25:17', '1', '1973-02-27 17:46:12', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (113, 113, 13, '2012-08-16 02:51:05', '', '1977-05-09 20:04:12', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (114, 114, 14, '2003-11-20 14:54:11', '1', '1975-01-11 18:13:13', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (115, 115, 15, '1993-01-15 01:02:19', '1', '2018-01-12 11:43:32', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (116, 116, 16, '1984-10-06 12:38:26', '', '2002-05-15 10:14:23', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (117, 117, 17, '1992-06-10 09:41:31', '1', '2018-06-29 16:05:23', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (118, 118, 18, '1995-05-10 22:22:03', '1', '2015-01-25 07:35:09', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (119, 119, 19, '2002-12-25 22:02:16', '1', '2009-12-25 06:30:01', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (120, 120, 20, '2002-10-02 23:29:44', '1', '1970-07-18 20:16:27', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (121, 1, 21, '1984-03-11 02:56:07', '', '1970-02-28 18:07:30', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (122, 2, 22, '1981-12-04 20:00:18', '', '1996-03-08 08:41:06', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (123, 3, 23, '1991-11-01 02:21:26', '', '2008-03-08 04:18:22', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (124, 4, 24, '1981-01-04 03:27:48', '', '1977-04-07 00:08:34', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (125, 5, 25, '1988-11-19 03:50:01', '', '1970-12-02 06:34:32', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (126, 6, 26, '2011-07-07 18:22:47', '1', '2015-04-01 02:30:31', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (127, 7, 27, '2012-09-07 02:38:15', '1', '2004-06-14 02:54:53', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (128, 8, 28, '2004-09-11 03:39:54', '1', '2002-08-27 05:02:47', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (129, 9, 29, '1993-06-28 22:03:24', '1', '1995-01-25 14:41:54', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (130, 10, 30, '2004-03-04 15:29:22', '', '2007-05-21 01:56:25', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (131, 11, 31, '2018-02-12 11:59:19', '1', '1986-07-25 14:20:26', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (132, 12, 32, '1993-06-05 18:06:09', '1', '1994-09-08 07:16:40', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (133, 13, 33, '2004-10-14 15:03:14', '', '2010-12-10 05:44:27', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (134, 14, 34, '2015-03-14 14:09:15', '', '1984-06-04 06:33:07', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (135, 15, 35, '1977-10-05 08:38:11', '', '1988-04-06 03:56:49', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (136, 16, 36, '1971-06-10 00:09:44', '', '2009-11-28 06:37:06', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (137, 17, 37, '1982-11-14 17:36:29', '', '2019-10-04 15:45:54', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (138, 18, 38, '1996-02-08 20:24:40', '', '2015-04-27 15:03:50', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (139, 19, 39, '1976-10-09 14:17:16', '', '1992-08-30 05:43:27', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (140, 20, 40, '1997-07-26 03:18:47', '', '1980-05-31 04:38:11', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (141, 21, 41, '2014-07-29 12:46:21', '1', '1996-06-01 01:55:04', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (142, 22, 42, '2007-05-14 17:22:43', '', '2003-08-16 17:26:49', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (143, 23, 43, '1998-10-04 22:03:08', '1', '2010-06-11 19:08:02', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (144, 24, 44, '1970-05-05 12:32:17', '1', '1984-04-29 05:06:40', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (145, 25, 45, '1992-12-21 17:36:37', '1', '2011-12-13 10:29:03', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (146, 26, 46, '1970-09-29 19:51:48', '', '1985-06-22 22:22:18', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (147, 27, 47, '2011-02-15 07:03:30', '1', '2000-11-12 22:50:38', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (148, 28, 48, '1989-07-11 21:09:58', '1', '1992-10-11 03:53:43', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (149, 29, 49, '2004-01-29 03:57:09', '1', '2017-03-22 06:29:53', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (150, 30, 50, '1979-05-18 16:48:04', '', '1986-02-02 14:13:00', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (151, 31, 1, '2013-01-17 19:49:53', '1', '2017-08-26 19:43:13', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (152, 32, 2, '1994-08-28 08:02:08', '1', '2006-09-30 00:11:40', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (153, 33, 3, '1976-03-13 14:49:41', '', '1999-05-13 20:12:02', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (154, 34, 4, '2017-03-24 13:42:13', '1', '1982-03-21 16:30:56', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (155, 35, 5, '1997-06-11 15:51:52', '', '1996-05-22 14:11:35', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (156, 36, 6, '2006-02-26 10:56:11', '', '2012-07-02 07:22:02', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (157, 37, 7, '1976-02-14 21:05:29', '1', '2004-11-17 15:04:05', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (158, 38, 8, '1994-05-02 18:12:26', '', '1984-10-24 14:34:45', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (159, 39, 9, '1978-03-25 12:49:18', '', '2002-01-26 15:01:50', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (160, 40, 10, '1984-03-15 11:19:39', '', '1996-07-01 11:00:48', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (161, 41, 11, '2017-09-17 17:03:22', '1', '1984-02-14 01:06:08', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (162, 42, 12, '1987-04-20 12:03:06', '1', '1996-01-09 09:06:35', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (163, 43, 13, '1979-12-23 18:43:35', '1', '2014-08-24 05:36:30', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (164, 44, 14, '1991-06-23 22:38:54', '1', '1995-04-12 14:43:41', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (165, 45, 15, '2016-09-04 12:50:40', '', '1992-12-22 13:27:55', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (166, 46, 16, '1981-08-20 13:34:01', '', '1997-01-04 02:15:12', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (167, 47, 17, '2011-08-29 10:50:52', '', '1990-05-31 09:15:55', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (168, 48, 18, '1996-01-08 12:05:26', '1', '2019-01-06 02:31:20', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (169, 49, 19, '1975-08-01 22:04:32', '1', '2007-07-02 10:30:38', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (170, 50, 20, '1996-04-23 16:24:04', '1', '2004-05-26 10:52:37', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (171, 51, 21, '2003-09-23 02:31:16', '', '1999-03-31 09:32:45', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (172, 52, 22, '2019-07-02 02:45:41', '1', '1982-09-05 10:58:38', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (173, 53, 23, '2000-05-01 17:44:02', '', '2002-06-16 04:51:15', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (174, 54, 24, '1999-03-05 06:16:31', '', '2006-11-29 13:11:51', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (175, 55, 25, '1970-06-02 08:11:18', '', '2009-06-25 06:49:53', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (176, 56, 26, '1979-08-20 11:08:57', '1', '1986-12-07 21:55:55', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (177, 57, 27, '1994-04-03 06:05:03', '1', '1991-02-24 23:00:53', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (178, 58, 28, '1970-03-13 11:21:13', '1', '1975-06-21 18:36:40', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (179, 59, 29, '2004-10-09 17:44:38', '', '1995-07-14 11:35:44', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (180, 60, 30, '1994-12-21 17:51:53', '1', '2012-12-09 11:09:56', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (181, 61, 31, '1993-02-03 14:28:21', '1', '2012-08-10 07:42:34', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (182, 62, 32, '1974-01-12 07:51:32', '1', '1994-01-05 06:04:34', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (183, 63, 33, '2014-12-11 06:16:40', '1', '1983-06-27 19:55:55', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (184, 64, 34, '2010-02-25 01:57:19', '', '2001-04-01 00:13:39', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (185, 65, 35, '1974-01-08 23:21:25', '1', '2001-11-04 21:04:11', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (186, 66, 36, '2004-05-21 11:45:54', '1', '1997-08-18 13:22:34', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (187, 67, 37, '2013-11-20 23:23:15', '', '1981-01-26 09:51:54', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (188, 68, 38, '2012-04-24 08:51:05', '1', '2014-01-25 10:07:09', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (189, 69, 39, '2012-07-28 09:48:11', '', '2009-11-02 02:21:37', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (190, 70, 40, '1982-05-08 17:45:46', '1', '1992-04-28 01:05:32', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (191, 71, 41, '1986-05-20 22:12:13', '1', '2013-03-12 08:23:10', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (192, 72, 42, '1998-01-05 20:56:34', '', '2010-09-07 13:32:45', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (193, 73, 43, '1975-09-17 01:03:34', '', '1983-06-27 13:56:55', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (194, 74, 44, '1985-04-01 02:01:33', '1', '1988-02-09 23:52:12', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (195, 75, 45, '1972-09-03 07:28:41', '1', '1982-12-28 23:44:59', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (196, 76, 46, '1978-07-10 01:56:39', '1', '1990-06-04 02:33:45', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (197, 77, 47, '1999-06-26 15:14:06', '', '1972-01-30 03:26:45', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (198, 78, 48, '1989-07-29 10:04:30', '1', '2004-05-03 22:37:47', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (199, 79, 49, '1983-07-15 13:18:38', '1', '1985-03-15 19:03:37', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (200, 80, 50, '2011-06-16 10:13:16', '1', '1985-11-16 21:33:23', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (201, 81, 1, '1978-02-26 22:13:45', '', '2002-12-05 03:44:37', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (202, 82, 2, '1995-11-21 21:00:15', '', '1983-08-05 20:21:34', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (203, 83, 3, '1996-02-23 20:09:49', '', '2015-07-09 14:24:45', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (204, 84, 4, '1976-03-30 17:27:29', '', '2003-03-16 20:26:04', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (205, 85, 5, '2014-05-30 16:31:37', '1', '2015-08-15 21:48:05', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (206, 86, 6, '1993-05-01 03:09:45', '1', '2012-09-02 09:27:36', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (207, 87, 7, '1992-02-10 07:28:58', '', '1979-07-04 21:28:55', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (208, 88, 8, '2011-06-29 13:12:46', '1', '2019-03-15 06:22:15', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (209, 89, 9, '2007-11-03 13:21:34', '1', '1990-10-24 00:18:51', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (210, 90, 10, '1982-04-29 21:12:10', '', '2004-10-10 21:28:42', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (211, 91, 11, '2009-12-02 21:10:39', '', '1981-08-16 22:31:04', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (212, 92, 12, '2011-02-21 06:08:12', '1', '2002-10-06 07:18:23', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (213, 93, 13, '1992-07-30 23:32:31', '1', '1993-12-16 20:37:04', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (214, 94, 14, '1978-05-09 12:11:30', '', '1995-08-28 07:05:12', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (215, 95, 15, '1993-05-09 15:51:49', '', '1984-11-14 17:21:52', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (216, 96, 16, '1975-09-15 19:09:16', '', '1971-04-16 09:49:37', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (217, 97, 17, '2010-02-15 03:35:41', '1', '1971-05-14 14:18:48', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (218, 98, 18, '2004-10-30 09:13:29', '1', '1981-05-03 09:55:05', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (219, 99, 19, '1976-12-26 09:28:01', '1', '1992-03-12 00:18:44', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (220, 100, 20, '1972-12-12 05:01:18', '', '1998-02-05 03:22:07', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (221, 101, 21, '1998-10-10 15:20:15', '', '1987-12-03 11:05:05', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (222, 102, 22, '1972-05-16 11:54:02', '1', '1992-12-19 00:07:47', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (223, 103, 23, '2002-12-26 02:40:14', '1', '2018-05-06 05:11:34', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (224, 104, 24, '1976-03-06 09:11:55', '', '1997-01-23 21:39:14', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (225, 105, 25, '1973-07-12 14:38:06', '', '2013-11-07 17:24:54', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (226, 106, 26, '1984-08-29 03:43:01', '', '1999-04-14 15:15:12', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (227, 107, 27, '1970-11-15 10:18:41', '1', '1992-01-18 16:02:23', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (228, 108, 28, '2014-07-17 03:35:26', '1', '2004-08-13 15:13:47', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (229, 109, 29, '2016-07-07 20:22:41', '1', '1973-04-27 15:22:51', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (230, 110, 30, '2007-11-30 15:49:52', '', '1983-08-12 08:22:09', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (231, 111, 31, '2015-11-28 02:28:55', '1', '2007-03-25 14:51:29', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (232, 112, 32, '1982-05-12 08:00:04', '', '1999-03-25 03:57:18', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (233, 113, 33, '1998-04-24 12:07:22', '', '2019-03-16 01:52:55', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (234, 114, 34, '1997-04-13 09:34:39', '', '2003-12-21 07:18:20', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (235, 115, 35, '1983-07-21 11:26:39', '', '1985-07-06 00:08:47', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (236, 116, 36, '1991-01-10 14:28:11', '1', '1991-07-25 02:21:16', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (237, 117, 37, '1971-10-20 20:46:46', '1', '2005-10-23 02:13:07', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (238, 118, 38, '1980-02-01 23:08:12', '1', '2008-05-15 02:51:52', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (239, 119, 39, '2004-05-26 23:06:10', '', '1991-03-16 03:45:49', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (240, 120, 40, '2003-05-01 04:31:03', '1', '1975-06-03 03:07:17', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (241, 1, 41, '1986-12-28 01:35:30', '1', '1994-08-25 01:29:45', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (242, 2, 42, '1986-12-28 12:40:00', '', '1983-09-27 22:06:40', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (243, 3, 43, '1985-07-28 18:42:52', '', '1983-09-20 09:43:01', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (244, 4, 44, '1996-02-06 23:01:11', '', '1972-09-11 10:24:51', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (245, 5, 45, '2001-03-07 13:50:03', '', '2003-03-12 02:12:18', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (246, 6, 46, '2013-03-13 20:50:33', '1', '1998-12-04 01:32:46', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (247, 7, 47, '2011-05-23 09:36:41', '', '2008-08-29 15:32:47', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (248, 8, 48, '2008-01-25 00:21:30', '1', '2003-06-13 15:49:54', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (249, 9, 49, '1972-05-08 08:19:57', '1', '2011-10-05 03:14:16', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (250, 10, 50, '1983-02-27 04:35:38', '1', '1993-08-24 07:48:56', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (251, 11, 1, '1999-07-30 07:45:32', '', '2007-11-24 02:20:08', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (252, 12, 2, '2007-03-07 02:06:20', '', '1987-10-25 22:43:46', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (253, 13, 3, '1995-11-20 04:32:11', '', '1973-03-31 04:30:51', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (254, 14, 4, '2009-09-18 01:41:13', '1', '1984-07-15 06:42:53', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (255, 15, 5, '2006-12-01 15:24:12', '1', '2012-10-14 22:05:19', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (256, 16, 6, '2008-10-30 00:09:44', '1', '1977-10-23 04:49:34', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (257, 17, 7, '2014-08-04 16:10:21', '', '1991-02-12 13:30:37', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (258, 18, 8, '1977-03-31 13:25:56', '1', '2019-04-06 00:29:48', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (259, 19, 9, '1979-11-26 15:54:18', '', '2009-09-13 14:33:10', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (260, 20, 10, '2003-11-16 13:07:47', '1', '2002-11-11 12:19:46', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (261, 21, 11, '2006-08-19 13:21:19', '', '2000-04-08 22:55:46', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (262, 22, 12, '2015-04-02 19:49:44', '1', '1988-10-11 17:36:39', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (263, 23, 13, '2007-09-20 19:08:07', '1', '1986-04-24 22:43:11', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (264, 24, 14, '1995-03-06 10:45:55', '', '1994-07-26 08:50:24', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (265, 25, 15, '1999-03-19 14:44:03', '', '1984-08-02 07:23:05', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (266, 26, 16, '1989-11-03 18:00:23', '1', '2008-07-24 23:31:06', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (267, 27, 17, '1979-10-19 20:58:48', '1', '2007-08-18 09:31:23', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (268, 28, 18, '2008-09-08 11:35:34', '', '1980-07-14 22:52:50', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (269, 29, 19, '1984-10-21 01:23:52', '1', '1998-03-22 05:23:09', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (270, 30, 20, '2008-10-17 12:05:10', '1', '1991-03-01 00:56:14', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (271, 31, 21, '1977-02-01 10:14:40', '', '2008-02-18 07:44:44', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (272, 32, 22, '2013-07-29 01:58:56', '1', '1990-01-30 00:23:23', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (273, 33, 23, '1984-03-05 16:43:55', '', '1986-09-16 10:16:28', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (274, 34, 24, '2008-07-15 16:01:22', '1', '2000-01-25 01:27:49', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (275, 35, 25, '1982-05-19 13:57:16', '1', '1998-04-17 15:06:03', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (276, 36, 26, '1987-09-30 11:43:29', '', '2019-01-24 03:49:05', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (277, 37, 27, '1998-08-06 16:41:05', '1', '2014-05-14 09:31:14', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (278, 38, 28, '1986-03-06 15:51:31', '1', '1976-06-26 19:26:51', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (279, 39, 29, '1975-03-12 21:59:44', '1', '1994-11-23 17:22:04', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (280, 40, 30, '1990-07-05 08:41:43', '1', '1987-04-30 11:02:42', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (281, 41, 31, '1974-06-08 18:44:54', '1', '1991-09-21 15:10:59', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (282, 42, 32, '2018-04-26 15:45:51', '', '1996-11-16 03:57:11', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (283, 43, 33, '1987-08-03 19:22:26', '', '1980-09-17 11:44:42', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (284, 44, 34, '2009-02-07 05:51:12', '1', '2016-09-10 22:36:10', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (285, 45, 35, '1999-02-26 00:47:37', '1', '2016-11-15 18:21:40', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (286, 46, 36, '1972-09-28 20:36:03', '', '1985-07-27 17:39:34', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (287, 47, 37, '1993-11-29 05:03:23', '', '2012-05-24 02:18:36', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (288, 48, 38, '1978-05-13 03:21:13', '1', '2002-10-14 14:28:46', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (289, 49, 39, '1979-11-28 09:12:22', '1', '2014-03-29 20:20:35', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (290, 50, 40, '1991-01-27 08:41:35', '', '2005-05-21 01:11:48', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (291, 51, 41, '2004-01-12 11:23:39', '1', '2018-10-17 04:28:10', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (292, 52, 42, '1973-01-28 15:21:36', '1', '1974-03-29 23:35:58', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (293, 53, 43, '2001-09-18 01:48:05', '1', '1995-09-24 10:39:59', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (294, 54, 44, '1986-02-26 22:50:18', '', '1990-07-22 17:28:14', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (295, 55, 45, '1996-01-16 10:54:40', '1', '1999-11-27 12:09:47', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (296, 56, 46, '2001-08-03 09:39:24', '', '1992-03-17 00:38:48', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (297, 57, 47, '2018-05-29 13:18:51', '', '1996-06-11 03:07:51', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (298, 58, 48, '1996-02-23 14:45:22', '1', '1997-09-03 06:56:12', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (299, 59, 49, '2014-10-24 07:13:17', '1', '2019-11-28 08:21:15', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (300, 60, 50, '1989-02-23 14:06:47', '', '1975-08-19 18:09:37', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (301, 61, 1, '2003-12-18 15:05:28', '', '1975-04-27 14:56:16', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (302, 62, 2, '2011-08-23 22:47:08', '', '1991-08-28 10:39:33', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (303, 63, 3, '1974-03-25 16:31:14', '', '2002-08-25 09:59:04', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (304, 64, 4, '2017-10-18 07:16:13', '1', '1979-07-30 21:44:09', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (305, 65, 5, '1993-09-07 18:31:36', '', '2006-10-03 17:38:54', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (306, 66, 6, '2003-09-10 18:37:32', '', '1973-12-20 10:06:23', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (307, 67, 7, '1979-06-08 09:51:59', '', '1979-05-02 07:50:26', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (308, 68, 8, '2001-05-15 09:55:39', '1', '1991-04-06 01:41:49', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (309, 69, 9, '1970-09-20 08:33:44', '1', '2017-04-16 14:02:18', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (310, 70, 10, '1991-10-15 10:11:50', '', '1970-02-06 01:06:51', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (311, 71, 11, '2006-05-22 16:37:00', '', '2015-11-30 01:28:53', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (312, 72, 12, '1985-12-17 08:59:21', '', '1976-05-21 05:48:51', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (313, 73, 13, '1981-06-25 00:06:12', '', '2019-11-14 02:57:26', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (314, 74, 14, '1992-06-13 16:19:14', '', '1972-06-25 20:36:40', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (315, 75, 15, '1977-11-14 11:56:42', '1', '2015-03-10 00:48:38', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (316, 76, 16, '2004-03-18 04:23:14', '1', '1973-11-09 14:19:09', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (317, 77, 17, '1975-03-16 06:58:57', '1', '2010-05-15 13:27:41', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (318, 78, 18, '2000-01-14 13:35:44', '1', '2019-04-01 09:58:57', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (319, 79, 19, '2010-10-22 21:41:48', '1', '1976-03-24 11:56:20', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (320, 80, 20, '2006-11-27 00:26:02', '', '1994-09-13 15:09:24', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (321, 81, 21, '1990-06-26 06:57:32', '', '1973-10-05 19:27:38', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (322, 82, 22, '1980-11-24 08:25:11', '', '2002-08-02 22:50:01', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (323, 83, 23, '1982-01-09 11:15:50', '', '2008-12-02 05:32:14', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (324, 84, 24, '1972-03-11 00:30:36', '1', '1993-07-13 02:38:24', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (325, 85, 25, '2000-10-18 01:16:52', '', '1997-05-17 09:10:50', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (326, 86, 26, '1972-04-20 00:39:12', '', '2018-02-11 23:30:12', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (327, 87, 27, '1971-04-06 21:46:22', '1', '1970-04-14 13:28:25', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (328, 88, 28, '1995-08-10 16:35:59', '1', '2015-01-10 06:39:22', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (329, 89, 29, '2010-08-22 10:50:40', '1', '1982-11-27 00:22:30', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (330, 90, 30, '1991-07-30 23:05:15', '1', '1986-02-25 03:36:09', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (331, 91, 31, '1982-07-13 17:39:12', '1', '1970-07-10 20:37:37', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (332, 92, 32, '1973-06-08 14:06:38', '1', '2005-09-09 21:02:47', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (333, 93, 33, '2012-11-12 21:29:59', '', '1984-02-13 22:07:11', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (334, 94, 34, '1989-11-02 17:10:12', '', '1980-01-13 07:01:10', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (335, 95, 35, '1989-04-15 05:02:07', '1', '1977-01-15 14:44:45', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (336, 96, 36, '1977-04-08 22:21:06', '', '1977-08-01 12:55:40', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (337, 97, 37, '1972-02-24 11:55:16', '', '2018-05-18 16:26:30', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (338, 98, 38, '1988-02-17 22:23:25', '', '2012-07-09 10:41:49', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (339, 99, 39, '1986-08-17 21:37:50', '1', '1980-09-13 05:34:23', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (340, 100, 40, '1996-03-26 12:37:01', '1', '1983-10-22 13:31:01', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (341, 101, 41, '1979-05-19 20:58:32', '1', '1997-07-20 13:10:20', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (342, 102, 42, '1976-11-25 08:34:12', '', '1989-06-09 22:32:19', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (343, 103, 43, '2009-09-01 05:47:23', '', '1973-07-01 17:24:25', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (344, 104, 44, '2014-09-02 10:43:22', '1', '1984-04-03 17:02:58', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (345, 105, 45, '1997-05-05 17:09:37', '1', '2003-02-08 23:01:26', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (346, 106, 46, '2010-02-27 04:11:03', '', '1979-11-08 16:02:38', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (347, 107, 47, '2014-04-01 11:58:02', '1', '1972-10-22 13:30:55', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (348, 108, 48, '1983-05-12 09:23:13', '', '1980-05-16 04:48:27', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (349, 109, 49, '2002-11-19 03:31:42', '1', '1993-08-06 02:49:38', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (350, 110, 50, '1988-04-24 05:16:26', '', '1987-01-10 18:42:07', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (351, 111, 1, '1974-08-14 15:36:27', '1', '2008-06-29 00:43:54', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (352, 112, 2, '1970-02-01 03:29:26', '', '1984-11-24 08:12:23', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (353, 113, 3, '1997-12-26 15:15:45', '', '2011-05-29 11:47:44', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (354, 114, 4, '1998-07-21 10:54:34', '', '1997-03-28 00:46:37', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (355, 115, 5, '1975-06-08 07:00:22', '1', '1990-08-05 10:26:56', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (356, 116, 6, '2001-02-21 00:32:49', '', '1980-07-14 18:27:29', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (357, 117, 7, '2010-09-27 20:41:16', '1', '2008-01-10 19:37:32', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (358, 118, 8, '2003-02-13 10:50:36', '1', '1981-09-08 11:19:42', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (359, 119, 9, '2000-04-02 07:42:33', '', '1995-04-04 11:57:08', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (360, 120, 10, '2010-11-13 01:29:45', '', '1984-01-20 19:27:45', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (361, 1, 11, '2005-07-02 05:38:24', '1', '2014-10-19 06:28:25', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (362, 2, 12, '1991-11-18 10:32:31', '1', '2001-06-02 13:22:58', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (363, 3, 13, '2014-03-30 04:49:32', '1', '1977-04-06 13:25:23', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (364, 4, 14, '2018-10-15 21:47:47', '1', '2000-05-25 01:57:13', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (365, 5, 15, '1981-12-03 07:43:23', '1', '1988-04-17 02:34:41', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (366, 6, 16, '1979-06-27 13:47:34', '', '2004-07-30 14:06:52', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (367, 7, 17, '1995-08-01 12:14:20', '1', '2008-03-17 22:40:45', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (368, 8, 18, '1982-03-25 17:27:14', '1', '1985-11-13 09:55:55', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (369, 9, 19, '2007-02-21 00:47:02', '', '2013-03-08 11:40:13', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (370, 10, 20, '2013-03-26 06:48:51', '1', '1991-07-10 21:51:09', 10, 10);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (371, 11, 21, '2019-09-05 15:45:29', '1', '1976-11-02 10:46:51', 11, 11);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (372, 12, 22, '2008-09-21 20:23:44', '', '2010-06-26 19:11:51', 12, 12);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (373, 13, 23, '1983-03-22 09:24:28', '', '1972-11-16 08:27:56', 13, 13);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (374, 14, 24, '2003-12-08 12:01:20', '', '2012-04-18 06:11:56', 14, 14);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (375, 15, 25, '1979-10-18 15:26:35', '1', '1989-05-14 17:24:41', 15, 15);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (376, 16, 26, '2014-09-18 06:16:36', '', '2013-05-02 18:24:06', 16, 16);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (377, 17, 27, '2017-07-16 17:31:02', '1', '1998-07-06 08:56:18', 17, 17);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (378, 18, 28, '2012-09-25 07:31:21', '', '1980-11-23 11:48:23', 18, 18);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (379, 19, 29, '1994-01-20 00:06:43', '', '1975-09-23 16:10:20', 19, 19);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (380, 20, 30, '1988-07-09 05:07:18', '1', '1980-08-17 21:55:24', 20, 20);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (381, 21, 31, '2003-02-23 02:55:06', '1', '2002-12-09 11:16:35', 21, 21);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (382, 22, 32, '1980-07-06 22:19:38', '', '1985-04-06 07:20:19', 22, 22);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (383, 23, 33, '2015-09-12 22:05:56', '1', '2016-02-07 03:42:46', 23, 23);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (384, 24, 34, '2010-09-03 04:30:19', '1', '1975-03-07 19:23:08', 24, 24);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (385, 25, 35, '1979-10-25 13:18:28', '', '1984-07-14 04:20:48', 25, 25);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (386, 26, 36, '2011-11-16 12:33:44', '', '2019-12-15 00:31:04', 26, 26);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (387, 27, 37, '1978-10-02 22:14:53', '', '1992-01-06 06:37:52', 27, 27);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (388, 28, 38, '1992-08-02 19:16:53', '1', '2018-01-11 03:48:14', 28, 28);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (389, 29, 39, '1992-11-28 09:06:59', '', '1978-04-22 20:10:15', 29, 29);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (390, 30, 40, '2001-09-30 08:48:55', '', '1972-02-02 22:06:56', 30, 30);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (391, 31, 41, '1996-02-09 04:48:08', '', '2008-01-01 03:06:31', 1, 1);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (392, 32, 42, '1971-08-03 22:49:45', '', '2010-07-31 01:49:08', 2, 2);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (393, 33, 43, '1999-10-09 19:53:00', '1', '1985-02-10 13:28:10', 3, 3);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (394, 34, 44, '1975-05-05 04:47:15', '1', '1992-08-02 03:17:10', 4, 4);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (395, 35, 45, '1999-05-11 20:03:45', '', '2008-05-10 00:00:30', 5, 5);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (396, 36, 46, '1982-02-05 06:11:11', '', '1971-10-02 04:32:05', 6, 6);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (397, 37, 47, '1978-05-29 06:54:56', '', '2012-04-04 09:39:50', 7, 7);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (398, 38, 48, '2019-10-22 09:35:31', '', '1985-10-31 10:53:17', 8, 8);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (399, 39, 49, '2012-12-02 21:10:33', '1', '2004-07-22 09:53:02', 9, 9);
INSERT INTO `orders` (`id`, `user_id`, `address_id`, `created_at`, `is_confirmed`, `condirmed_at`, `promo_id`, `courier_id`) VALUES (400, 40, 50, '1991-07-08 01:23:32', '1', '2015-03-24 19:42:27', 10, 10);

-- Таблица reviews

INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (1, 1, 4, 'Sed id nam aut facere iusto laudantium harum facere. Officiis rem id harum. Molestias commodi possimus rerum omnis. Ut eum laboriosam molestiae occaecati.', '2012-11-13 00:22:36');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (2, 2, 1, 'Nisi porro aliquam ut eum sed possimus temporibus. Et voluptatum totam temporibus quis odio. Quisquam consequatur autem et voluptas. Porro qui sunt consequatur enim est.', '1971-08-20 18:27:36');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (3, 3, 1, 'Eveniet reprehenderit veritatis molestias consequatur commodi assumenda rerum. Consequatur magnam sint cumque aut nemo temporibus.', '2001-02-27 01:26:46');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (4, 4, 4, 'Voluptatem libero eligendi sint sed deserunt et. Labore quisquam est omnis quasi. Ratione vero ex labore debitis quia consequatur praesentium. Vero sequi qui velit.', '2019-08-11 10:22:43');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (5, 5, 1, 'Eum ut cumque autem quia corporis. Sit ducimus labore accusantium veniam quam. Autem dolore perspiciatis qui aut autem similique placeat.', '1974-01-21 02:32:37');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (6, 6, 5, 'Et doloribus quaerat temporibus optio maxime suscipit. Laborum nihil et error velit. Error debitis voluptas nesciunt suscipit temporibus suscipit.', '1974-02-25 05:26:41');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (7, 7, 4, 'Laboriosam error aut ea facilis repellat. Ipsum eligendi omnis perferendis nobis quisquam consequatur. Voluptate est dolore delectus aut. Ea architecto est accusamus ipsa.', '2010-02-25 21:41:42');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (8, 8, 4, 'Pariatur nesciunt consequatur sit. Qui non et occaecati voluptatem. Velit incidunt non animi quas ea ratione alias.', '1974-03-31 14:21:45');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (9, 9, 2, 'Reprehenderit fugiat quo suscipit molestias et. Omnis non esse omnis et. Vero nostrum vero laboriosam doloribus et maiores. Quia nemo atque ut dignissimos incidunt doloribus fugit neque.', '2014-11-19 09:40:41');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (10, 10, 3, 'Excepturi consectetur sunt atque quisquam ipsum vero omnis. Labore quo sit facilis ipsam doloribus mollitia. Harum delectus aliquam similique ipsum. Id perferendis mollitia a et ut natus quia error.', '1992-10-01 20:13:50');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (11, 11, 4, 'Ut non consequatur nostrum beatae illum enim. Deleniti ipsam saepe officia nisi voluptatem.', '1980-04-18 20:18:20');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (12, 12, 5, 'Hic veniam id et. Excepturi rerum beatae nisi. Cupiditate sint dolore quia asperiores ut tempore eaque. Repudiandae officia et nemo reiciendis.', '1994-01-31 14:48:59');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (13, 13, 3, 'Minima reiciendis architecto ea. Excepturi id aut voluptas quia. Excepturi nulla debitis non cupiditate. Quisquam beatae rem et fuga.', '1984-09-08 17:05:03');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (14, 14, 3, 'Possimus nobis ullam repudiandae et impedit. Ut molestiae et ad sed nesciunt sit perferendis neque. Repudiandae molestias eos repudiandae alias quam recusandae.', '1981-02-28 14:14:26');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (15, 15, 2, 'Officiis autem et unde rem. Deleniti aut dolorum qui consequatur consequuntur. Non provident porro aperiam rerum repellendus. Ea tenetur minima dolores ipsa et.', '1994-01-18 10:54:16');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (16, 16, 2, 'Qui illo omnis nam suscipit. Laudantium itaque ut autem libero quaerat incidunt. Cupiditate debitis culpa consequatur vitae molestiae.', '1984-04-19 04:10:56');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (17, 17, 5, 'Iste consequatur facilis voluptas odio beatae unde ea. Doloremque qui est et fugit deleniti ipsum. Labore voluptatem dicta aut quasi odio.', '1987-06-30 09:27:26');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (18, 18, 4, 'Et maiores quam ut praesentium ipsum ipsum. Fugiat sit nihil ex dolorem doloremque voluptatem ut. Eum voluptas ipsa illo ratione.', '2009-12-02 04:44:54');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (19, 19, 1, 'Quam autem distinctio eius quibusdam est. Et non iste natus quod ea dolorum eveniet. Ea fuga fuga quas error iure consequatur quam dolorem.', '2015-11-08 10:32:25');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (20, 20, 2, 'Eum ut laborum rerum ut cupiditate quod. Qui nesciunt et et voluptas. Voluptatibus blanditiis sed quae nisi nulla aliquam.', '2015-09-20 03:50:20');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (21, 21, 1, 'Et possimus autem est blanditiis asperiores dolor. Quia aperiam voluptatem natus et numquam molestias. Similique qui ipsum aut. Aut voluptas qui cumque eaque nostrum.', '2003-03-25 21:03:18');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (22, 22, 5, 'Quasi dolorum quia eum vero nam. Amet aut est et perspiciatis officiis voluptatum. Ut labore dolores delectus ducimus delectus iste quae. Mollitia optio eum iusto blanditiis.', '2003-11-23 02:05:35');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (23, 23, 3, 'Sit architecto quas nemo qui fugiat enim. Quis odit sunt est quia recusandae totam. Ad ipsum et doloribus doloremque facilis. Autem nam quisquam sint qui dicta.', '1994-05-14 11:18:03');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (24, 24, 4, 'Et ea ut quidem architecto voluptatem. In unde tempora sequi id in asperiores. Illo facilis quis hic eum et id. Necessitatibus accusamus repellat quibusdam vero error autem.', '1978-02-06 06:33:50');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (25, 25, 4, 'Iure magni harum illum cumque officia deleniti illo. Accusamus dicta magni ut nisi sit reiciendis libero. Sequi voluptas accusantium atque fuga eligendi deleniti fuga.', '1975-04-14 16:58:39');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (26, 26, 1, 'Fuga iure a nostrum. Molestiae aut voluptatem quia perspiciatis deleniti est in. Voluptatem illo quis natus eos inventore et rerum.', '2012-11-07 11:40:22');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (27, 27, 3, 'Distinctio amet assumenda qui. Omnis sapiente ut corporis ipsum. Quis eos neque quis voluptas veritatis mollitia reprehenderit.', '1997-02-23 13:05:12');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (28, 28, 5, 'Voluptas est dignissimos non. Eveniet sunt corporis quod. Asperiores ut blanditiis omnis architecto quia dolores voluptatem corporis.', '2015-12-15 20:24:11');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (29, 29, 3, 'Labore eum mollitia voluptatem illo blanditiis voluptatibus. Soluta minus qui et et. Voluptate debitis ipsum repellat.', '2000-08-03 10:45:19');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (30, 30, 3, 'Eos eos omnis aperiam occaecati et. Officia debitis architecto eos animi consequatur minus. Id iusto ut tempora quidem atque perferendis excepturi. Excepturi omnis non doloribus saepe quaerat.', '2017-04-29 13:30:22');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (31, 31, 2, 'Culpa minus iste quod aut. In sit mollitia ex magni. Enim ut ut dolor totam placeat. Ipsum saepe at omnis fuga maxime esse quibusdam.', '1990-02-23 11:19:18');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (32, 32, 5, 'Quis dolorum sed est veritatis reprehenderit veniam. Pariatur ducimus doloribus voluptates molestiae ut. Dolorum ut tenetur ut et vitae rerum.', '1979-09-30 22:44:40');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (33, 33, 3, 'Eaque quam officia autem dolor. Maiores soluta quod omnis voluptatem. Tempora quis accusantium reiciendis odio. Velit voluptatibus voluptas fugit iusto aliquam voluptas.', '1979-01-17 02:18:52');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (34, 34, 5, 'Voluptatem totam accusantium libero consequatur nemo. Necessitatibus qui asperiores magni ab enim rerum ipsam. Et perspiciatis ratione quia et. Quia ea omnis id hic.', '1984-04-05 08:19:46');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (35, 35, 2, 'Similique officiis amet doloremque repellat. Sunt assumenda delectus deserunt illo. Asperiores facere vel omnis vel occaecati sed vel.', '1996-09-12 06:41:16');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (36, 36, 3, 'Eaque voluptatem sunt doloremque ea nobis. Voluptatem aut repudiandae inventore veritatis nesciunt. Exercitationem cumque recusandae quos culpa et. Est a veniam saepe voluptatem.', '2017-05-28 06:15:23');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (37, 37, 2, 'Voluptates repellat consequatur atque repudiandae fuga. Consequatur odit nostrum molestiae distinctio ut voluptas nam. Natus est et beatae repudiandae a autem animi.', '1988-04-11 11:43:24');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (38, 38, 3, 'Nihil et inventore optio distinctio dicta aperiam molestiae. Voluptatem dolores a itaque totam et consequatur. Consequatur dolorem hic voluptas aspernatur odit ex molestiae.', '1995-07-05 07:45:18');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (39, 39, 4, 'Omnis blanditiis quia iste natus sint assumenda. Consequuntur sint quos illum ex perspiciatis.', '1974-09-22 12:26:12');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (40, 40, 4, 'Pariatur molestias dolorem commodi optio a in tenetur. Dolor vitae et est assumenda voluptates aut ratione. Voluptas atque et neque et.', '2009-12-14 18:43:32');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (41, 41, 2, 'In tenetur fuga debitis blanditiis. Iure consectetur et praesentium quibusdam et. Est qui omnis quia ducimus fugiat incidunt.', '2003-04-09 18:44:09');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (42, 42, 3, 'Voluptatem necessitatibus maxime alias cumque veniam. Temporibus nostrum temporibus voluptas similique officiis velit. Facilis fuga necessitatibus enim non dolorem. Quas natus nihil qui voluptatem.', '1979-05-04 03:16:31');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (43, 43, 3, 'Ea dolore at consequuntur hic sint et. Blanditiis numquam consequuntur et ex tempora nemo voluptatem. Nobis atque possimus sit atque. Et quis ducimus sed id officiis ducimus aut.', '1992-07-15 05:44:21');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (44, 44, 4, 'Quas dolores sapiente quas ab culpa velit voluptates quasi. Necessitatibus et animi iusto repellat. Ipsam reiciendis qui et aut facere ab. Est aliquam suscipit non deleniti quis commodi voluptatem.', '2018-11-20 07:34:44');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (45, 45, 1, 'Ut sit dolores et placeat. Tempora quam minima nisi amet. Sed nostrum qui non dolorem dolores perferendis nesciunt. Dolorem ducimus neque voluptatibus ex veritatis omnis et.', '2015-06-11 15:23:43');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (46, 46, 2, 'Eius autem maiores neque repellendus. Eligendi corporis doloremque sint optio ut. Labore cupiditate eum nihil et ut.', '1990-08-18 00:08:21');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (47, 47, 3, 'Est qui optio nostrum magnam praesentium. Quis voluptate odit ut qui dolorem soluta. Autem blanditiis et itaque dolores unde aut impedit. Commodi corrupti aut aliquid magnam harum esse distinctio.', '1978-09-30 01:50:24');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (48, 48, 4, 'Omnis quia porro voluptatem earum sunt. Placeat aut dignissimos veniam quasi. Quasi similique corrupti delectus perferendis laudantium qui. Non exercitationem dolorem sunt porro et voluptatem veniam.', '1974-11-18 13:02:29');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (49, 49, 4, 'Consequuntur nostrum quis est iure. Ea qui quibusdam aut. Iusto veniam autem dignissimos facilis.', '2017-11-09 10:37:28');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (50, 50, 5, 'Cum dolorum aperiam tempora sunt aut sint. Vel quidem mollitia ipsa facilis quia architecto est. Iste excepturi eos enim sint.', '1990-07-19 11:31:18');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (51, 51, 2, 'Voluptatem soluta voluptatem soluta ipsam eum dicta. Minima aut ea non et eum totam velit. Rerum fugiat quis pariatur voluptatem aut libero.', '1974-09-08 18:15:19');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (52, 52, 5, 'Minus itaque suscipit doloremque eius. Et ut dolorem sequi. Et tenetur facilis quo fuga quo.', '1981-09-20 02:15:20');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (53, 53, 2, 'Rerum aliquid alias impedit officia adipisci reprehenderit. Ut consequuntur ratione possimus qui corporis consequatur occaecati est. In ut quod et voluptatem.', '1975-07-03 17:57:51');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (54, 54, 3, 'Totam dolor architecto vitae sit delectus doloribus sint. Corporis molestias qui sed voluptas mollitia voluptate quo. Fugiat quo sunt nesciunt expedita.', '1979-03-15 13:15:41');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (55, 55, 2, 'Nulla aliquam laudantium quas. Vero necessitatibus eligendi dolorem dolore ea aliquid qui. Delectus similique est quia.', '2015-11-22 06:12:44');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (56, 56, 2, 'Autem molestias facilis iure corporis asperiores. Autem qui est ex enim culpa. Deleniti velit ullam sapiente accusantium non minus.', '2014-06-15 02:48:27');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (57, 57, 1, 'Et quaerat saepe blanditiis est ipsum quos. Alias voluptas esse accusamus id voluptatem. Voluptas quia sunt asperiores nam ipsum voluptas eum. Illo corporis dolor facilis corporis nisi.', '1980-05-21 00:11:42');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (58, 58, 1, 'Officiis distinctio sit minus dolorem voluptas ullam. Rerum eligendi cumque iure corporis ut possimus deleniti. Qui omnis sint aut ut iste rerum dicta.', '1974-05-20 23:57:37');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (59, 59, 2, 'Rerum iste qui qui aut doloribus. Voluptatum earum beatae fuga nisi. Vitae est ea voluptatem aliquam sunt natus.', '2010-08-09 22:59:21');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (60, 60, 3, 'Vel eius illo cumque autem nemo fugiat. Nostrum aut eum sit commodi dicta ad nostrum. Eos hic et in autem. Quasi culpa at quibusdam.', '2012-05-31 17:42:54');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (61, 61, 3, 'Aut consequatur inventore et repudiandae. Eos aliquam ut repellat modi vero autem. Cupiditate distinctio molestias molestiae et. Excepturi quia eaque sequi neque non.', '2001-12-08 11:39:14');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (62, 62, 2, 'Dignissimos sapiente libero dolorem. Sapiente eaque ut sequi quod excepturi.', '2004-11-15 23:01:25');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (63, 63, 3, 'Soluta quibusdam excepturi dignissimos sequi sint quia corporis. Ut architecto modi qui ut architecto. Similique voluptatem modi quo illum et. Incidunt odit at ducimus veritatis.', '1985-08-25 23:15:42');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (64, 64, 2, 'Tenetur magnam deleniti deleniti aliquid. Ad assumenda explicabo amet cupiditate eligendi. Qui sequi molestiae et qui nemo libero. Repellendus et non libero qui earum laborum.', '1990-10-22 13:44:58');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (65, 65, 5, 'Dolor accusantium facilis impedit modi at tenetur. Tempore et suscipit ut velit ab. Ducimus consequatur quasi voluptatem temporibus cum sint. Non ratione voluptatem illo.', '1982-01-04 02:54:39');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (66, 66, 2, 'Veniam in aliquam illo in molestiae est. Libero reiciendis commodi explicabo sint atque deserunt. Nihil modi facere qui non architecto.', '2006-07-18 14:56:21');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (67, 67, 4, 'Exercitationem rerum commodi et ea ut. Sit qui non aperiam et. Neque officia ducimus odio voluptatem sed.', '2017-01-24 01:56:21');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (68, 68, 5, 'Natus eos delectus et modi maxime. Et fugit ipsum ullam dolorum iure consequuntur. Harum doloribus architecto quo dicta et est. Necessitatibus nisi aspernatur qui saepe voluptatem impedit et.', '1994-04-28 15:42:14');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (69, 69, 4, 'Qui itaque placeat maiores vitae aperiam quasi. Rerum vitae et sapiente voluptate ea sapiente omnis ut. Deserunt pariatur dolore delectus qui.', '1979-05-20 05:23:10');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (70, 70, 4, 'Quidem et ipsam quae iure libero quia dolor nisi. Ea ut tenetur voluptatem atque est. Illum nulla eveniet voluptatum voluptatem libero.', '1994-08-19 21:31:45');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (71, 71, 2, 'Consequuntur aperiam ut omnis voluptas qui. Aut qui voluptas autem blanditiis eveniet. Recusandae velit suscipit error.', '1987-04-30 14:47:46');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (72, 72, 1, 'Beatae iure explicabo non voluptatem quia odio. Aliquid quisquam consequatur enim voluptatem.', '1992-06-14 18:57:45');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (73, 73, 5, 'Explicabo minus sunt eligendi ratione consequatur. Officia et ea nihil eos qui. Aspernatur non vitae ducimus. Deserunt qui molestiae commodi sequi.', '2019-10-13 16:41:21');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (74, 74, 5, 'Nobis quas voluptas maiores aperiam sit alias quibusdam. Quia perferendis eum delectus autem quia hic. Corporis voluptatem eligendi ea quod. Vitae modi ab quo voluptatum molestias porro.', '1979-07-15 16:12:47');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (75, 75, 5, 'Voluptatem quis dignissimos sit possimus. Cum maiores id est. In dolor sapiente animi non non et nihil. Est et iusto et distinctio inventore.', '1989-09-29 14:49:04');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (76, 76, 3, 'Atque beatae eligendi et quaerat nisi ea. Eum fugit autem sed repudiandae. Dolores ducimus a qui. Ut porro fugit aspernatur aut est.', '2013-04-11 19:11:21');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (77, 77, 4, 'Id repellat quaerat exercitationem. Quia ab modi veritatis qui odio est et totam. Perspiciatis vel nulla voluptas temporibus numquam eum dolores.', '2008-06-07 11:04:04');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (78, 78, 5, 'Repudiandae qui unde voluptates. Deleniti tenetur rerum eum occaecati. Et reiciendis architecto ipsa occaecati rerum quia autem.', '2019-08-18 04:11:35');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (79, 79, 5, 'Optio qui eaque id est nemo et nesciunt. Aut omnis est esse autem. Id sint facere vel ullam sequi consectetur assumenda expedita.', '1986-07-21 15:48:58');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (80, 80, 3, 'Repudiandae consequatur officia quia explicabo quaerat deserunt. Libero est vitae repudiandae illum dolore consectetur. Velit veniam voluptas quisquam quis velit et.', '2000-12-12 16:31:25');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (81, 81, 5, 'Hic voluptatem dolores labore nulla quia esse sed. Eaque dolor porro ad dicta delectus et. Expedita vel temporibus aut facilis consequatur optio. Est omnis earum facilis dolores eos qui quaerat.', '1997-12-08 00:50:19');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (82, 82, 5, 'Itaque aut voluptates qui. Consectetur et eum dicta aut dolor molestiae. Rerum earum iste iusto accusamus atque et.', '1975-02-23 16:51:20');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (83, 83, 4, 'Corporis voluptates ullam nihil impedit. Odio ea impedit quasi esse exercitationem voluptas cum. Nemo magni vero ut cupiditate aut voluptas ut.', '2014-12-20 14:30:37');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (84, 84, 3, 'Qui ratione tempore sed error commodi autem. Incidunt minus totam quas. Consectetur est officia unde.', '1999-11-27 04:18:14');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (85, 85, 2, 'Corrupti et ducimus omnis dolorem. Sunt velit quis libero voluptas neque. Veniam quia aut magni quo nisi ut dicta.', '1998-10-27 05:40:11');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (86, 86, 1, 'Distinctio nesciunt molestias consectetur at eos hic. Nesciunt rerum ducimus aut doloremque et earum rerum.', '2011-10-09 13:01:20');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (87, 87, 4, 'Nostrum consequatur quaerat et quas. Neque deleniti corrupti odit cum. Voluptas quod et reprehenderit laborum iusto id cupiditate.', '1989-10-03 16:56:40');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (88, 88, 4, 'Nesciunt labore laboriosam dicta assumenda vel voluptatum. Quam quo sed beatae quia. Facilis explicabo esse dolores nisi sed exercitationem officiis. Aut sunt est nam iusto.', '2011-06-09 22:08:26');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (89, 89, 4, 'Sit dolorem nihil molestiae debitis. Quasi esse magni commodi. Et ducimus in rerum amet iusto. Et dolor dolores corporis consequuntur minima sequi.', '1985-05-20 08:16:13');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (90, 90, 2, 'Placeat aliquam et quidem omnis repudiandae ducimus vel. Velit quisquam provident dolorum odio molestias. Et sed voluptas et laudantium deleniti nisi. Expedita provident cumque deserunt.', '1985-09-06 05:33:14');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (91, 91, 5, 'Quasi reprehenderit quod et. Sint quis distinctio quia quasi adipisci. Similique ad aliquam non culpa est eos. Eius dicta iure quisquam quae doloribus.', '2002-05-17 13:18:10');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (92, 92, 2, 'Veniam et vel voluptatem. Odit consectetur illo iusto hic non. Laudantium ea velit facere similique ducimus.', '1992-11-18 22:41:12');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (93, 93, 2, 'Ut molestiae repudiandae nihil necessitatibus ipsam sed minima. Ea quos autem aut necessitatibus sapiente modi.', '1994-11-13 07:07:59');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (94, 94, 2, 'Repellat veniam ut adipisci et distinctio. Vel laudantium error iure dignissimos aliquid. Nisi soluta sit est ab. Aut quidem qui amet doloremque.', '1990-08-07 00:48:53');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (95, 95, 1, 'Repudiandae voluptatem et repellat nesciunt modi. Quia dolores repellendus praesentium. Animi ut tenetur distinctio corrupti sit ut qui.', '2004-10-01 00:47:37');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (96, 96, 3, 'Voluptas et rerum beatae vel. Enim eligendi molestiae et eum. Eius sit pariatur architecto sint. Numquam cumque quam rerum necessitatibus.', '1999-12-28 14:27:18');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (97, 97, 2, 'Omnis blanditiis ipsa omnis labore voluptas. Aut dicta vero exercitationem ut consectetur. Odio maxime explicabo cumque voluptatum nam. Nostrum eum laudantium qui ut velit fugiat est.', '2002-09-16 20:24:28');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (98, 98, 5, 'Consequatur voluptas iusto fuga aut eaque tempore ex cum. Quis voluptatem non facere et sint. Vero ratione possimus tenetur iusto itaque.', '1998-03-28 16:54:11');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (99, 99, 5, 'Natus distinctio omnis recusandae provident. Optio pariatur adipisci dolorem minus in. Fuga labore odit tempore sunt.', '1996-08-12 11:31:15');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (100, 100, 3, 'Iure voluptate harum perspiciatis id eum. Aut qui numquam molestiae assumenda aut.', '2000-11-20 14:36:18');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (101, 101, 5, 'Et id est culpa molestiae voluptate recusandae debitis. Eveniet est deserunt quia. Veniam explicabo mollitia harum asperiores eos mollitia.', '1998-07-17 02:38:22');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (102, 102, 2, 'Aperiam quo deleniti sequi autem sunt. Suscipit unde sunt ex iste tenetur. Cupiditate vero esse sit impedit omnis sapiente est.', '1982-05-30 20:37:07');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (103, 103, 1, 'Quisquam libero id incidunt expedita. Facere ipsa quis hic quia voluptas. Voluptates ad at eligendi deserunt est dolores quia.', '2008-06-21 15:31:13');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (104, 104, 1, 'Sit ut adipisci unde mollitia. Sapiente non perspiciatis dolores laboriosam et pariatur. Ipsa quia blanditiis distinctio id velit necessitatibus. Eius consequatur nam et tempora asperiores ex.', '1972-04-07 05:32:03');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (105, 105, 1, 'Ut dolor repellendus voluptatum eligendi repellat. Quod qui aut neque dolorem quis voluptas veniam debitis. Incidunt aperiam nihil hic officia autem eius. Optio ut vel debitis et provident qui.', '2017-07-31 19:52:43');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (106, 106, 1, 'Laudantium amet inventore consequatur iste. Sequi quisquam ullam vel tempore nam. Fugiat accusantium numquam sed accusantium. Autem est debitis enim ad libero consectetur.', '1988-02-28 08:16:29');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (107, 107, 3, 'Aliquam sint occaecati est quia. Atque dicta voluptatum ea illo quia voluptatem. Consequatur veritatis fuga eaque libero quidem dolorem voluptas labore. Qui illum perspiciatis sed.', '2000-09-17 21:50:42');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (108, 108, 3, 'Et officia vel fugiat et possimus corporis nesciunt. Repellendus explicabo debitis a rerum facere ut dolorum. Adipisci voluptate cupiditate esse dignissimos sequi quos.', '2008-08-22 21:24:09');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (109, 109, 3, 'Tenetur aut est omnis. Non amet accusamus voluptatem. Et sint at non. Sit magni voluptatum repudiandae consequuntur.', '2007-02-19 20:26:30');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (110, 110, 2, 'Ut voluptatem omnis voluptatem quaerat. Aut reiciendis omnis qui. Commodi voluptatem qui quaerat placeat nostrum eligendi.', '2008-07-14 08:08:10');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (111, 111, 2, 'Illo dignissimos pariatur magni iusto reiciendis. Quisquam et expedita ut laborum est dolorem. Velit quas optio minus eum aut nam et.', '2007-07-05 03:20:44');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (112, 112, 4, 'Nam eos aliquam corporis similique. Sapiente iure id incidunt amet et voluptas. Aut cum quo quasi ut ut illum rem.', '2004-02-05 15:39:28');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (113, 113, 4, 'Vitae quibusdam et at cupiditate voluptatem. Omnis dolor voluptatem provident. Dolores suscipit facere odit itaque.', '2006-02-25 23:56:47');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (114, 114, 3, 'Sit inventore tenetur laudantium repellendus necessitatibus consequatur. Blanditiis modi iusto amet qui. Illum mollitia ut nulla fuga qui ipsum.', '1981-06-19 21:44:42');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (115, 115, 2, 'Voluptatibus at rerum voluptatem nihil mollitia. Eum unde ut possimus minus. Nulla et sed necessitatibus officiis.', '1976-02-10 15:17:06');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (116, 116, 5, 'Sequi quibusdam voluptatem dicta omnis non nihil. Sapiente corporis porro quibusdam. Qui vitae maiores quia rem voluptates. Ut ut et vel.', '1983-02-15 18:24:51');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (117, 117, 4, 'Sed et ea amet dolor. Et quia autem quod est ea pariatur ut. Libero enim itaque reiciendis. Rerum ipsum laboriosam sit suscipit natus dolor voluptatem esse. Neque consequuntur nesciunt omnis et.', '2002-06-20 16:54:49');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (118, 118, 5, 'Architecto dolor omnis quis debitis qui. Quos id odio ut necessitatibus et aut similique explicabo.\nMollitia aut id reiciendis in. Mollitia autem qui autem eligendi.', '1984-10-02 21:27:29');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (119, 119, 2, 'Perferendis hic ea hic tenetur fugit non. Omnis ipsam magnam beatae quidem quaerat aperiam.', '2008-05-11 08:49:56');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (120, 120, 4, 'Aut voluptates qui aut laborum vel sapiente et qui. Debitis dolores et voluptatem animi adipisci. Nesciunt non dolore mollitia sint natus voluptate delectus.', '2014-11-25 12:34:06');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (121, 121, 3, 'Aut cupiditate quod nihil cupiditate totam error. Doloribus non quos aut minima. Et in esse consequatur eligendi minima molestiae eum.', '1989-06-06 23:24:22');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (122, 122, 4, 'Mollitia distinctio veniam iste culpa consequuntur ea quae quae. Molestiae vel consequuntur officiis.', '1991-06-26 13:55:49');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (123, 123, 1, 'Optio perspiciatis sunt atque omnis illo nisi corporis. Dolor quas deleniti quam aut quae ut iure. Dicta sed cumque porro quo exercitationem amet.', '2011-08-08 06:07:25');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (124, 124, 1, 'Adipisci corporis perferendis nobis omnis illum. Sequi odit voluptatem sed doloremque. Itaque laborum et ut distinctio a ad at. Totam quae alias sint natus voluptas voluptate incidunt.', '1985-09-28 15:09:47');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (125, 125, 1, 'Voluptatum consequatur rem qui est qui. Ut quibusdam iure aut culpa fugiat praesentium et recusandae. Qui dicta voluptas accusantium aut.', '1979-04-17 16:52:59');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (126, 126, 4, 'Perspiciatis minus error reiciendis quod quidem voluptas. Quia dolorem eum necessitatibus animi.\nIste magnam est laborum ut similique aliquid ducimus. Et vero consequatur ipsum iusto rerum.', '2000-07-26 08:17:33');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (127, 127, 2, 'Id consequatur suscipit blanditiis beatae hic architecto repellat. Et hic vitae ut neque qui. Est possimus qui deleniti soluta labore quia. Ut quis a veniam voluptas cupiditate aut.', '2002-03-06 11:07:07');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (128, 128, 1, 'Beatae ullam sunt architecto omnis illo velit. Ut voluptas distinctio harum excepturi nihil consequuntur placeat voluptates. Accusantium velit vel aspernatur laudantium nobis officia.', '1971-11-03 03:10:06');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (129, 129, 4, 'Maiores aspernatur excepturi fuga asperiores. Saepe et fugiat eligendi placeat.', '2007-09-13 16:12:41');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (130, 130, 2, 'Corrupti est error id est unde est excepturi numquam. Cupiditate tenetur voluptatum nulla aspernatur aliquam. A sunt beatae sit.', '1982-05-25 18:41:04');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (131, 131, 1, 'Dolorum et libero totam dolor minima cupiditate ea esse. Ex hic vitae et est eius. Et quod iure repellendus ab. Odio itaque nostrum dolores.', '1998-02-28 09:53:14');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (132, 132, 3, 'Et corrupti omnis eveniet voluptatem et. Nam dicta nisi nam occaecati. Autem minima consequatur veritatis occaecati eveniet blanditiis. Rerum nobis ducimus rerum iusto necessitatibus aut.', '1987-10-19 22:27:34');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (133, 133, 2, 'Temporibus amet quos laboriosam. Et labore et sit eaque quia. Sed vel occaecati ipsa qui adipisci pariatur quos. Est neque delectus cupiditate omnis.', '2000-02-09 07:13:16');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (134, 134, 1, 'Labore sit voluptate ea aut corporis consequatur. Voluptas ducimus quis vel id. Sapiente adipisci similique quo nemo placeat voluptatem est ad.', '1985-07-18 11:46:37');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (135, 135, 5, 'Rerum explicabo blanditiis ratione aut ducimus non. Quia dicta quia dolore deleniti veniam libero. Voluptatum sint libero temporibus neque.', '1984-08-30 23:51:47');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (136, 136, 2, 'Nam rerum dolore vel et odit atque accusamus. Qui molestias sapiente natus natus reprehenderit sunt architecto. Quibusdam ipsum qui voluptas. Qui atque sunt asperiores eum reiciendis eius.', '1971-04-29 05:46:44');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (137, 137, 5, 'Eos esse ipsum reprehenderit odit optio iusto. Quasi facilis quidem quia enim sed doloremque praesentium aspernatur. Consectetur facilis sunt id enim tempore incidunt omnis nemo.', '1978-09-26 09:39:41');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (138, 138, 5, 'Qui numquam voluptas quam officiis sed consequatur illo. Molestiae totam quas quos. Officiis sit temporibus sit placeat itaque. Dolores autem dolore sit velit possimus sit facere.', '1996-04-28 14:16:35');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (139, 139, 5, 'Omnis nobis facilis nesciunt vel voluptatibus deserunt harum. Debitis ad repudiandae doloremque eos ducimus fuga eos. Dolores enim beatae nulla debitis sunt optio sint.', '2001-09-03 02:59:22');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (140, 140, 2, 'Aut eos quam non quo. Est consequatur quia doloremque maxime quasi voluptates. Libero nobis quidem quia optio et.', '2010-06-22 15:21:49');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (141, 141, 1, 'Quidem dolores aut consequatur dicta est ea. Ea magnam a enim nesciunt ad et est. Eos distinctio veniam ad pariatur quidem accusamus voluptatem.', '1979-04-06 06:52:47');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (142, 142, 1, 'Ipsum sapiente accusantium esse quis. Esse magnam consequatur sit consectetur temporibus ipsam ipsam. Ducimus quisquam aut quia sunt vero magnam laboriosam. Totam et et aliquid repudiandae.', '2012-08-28 09:48:07');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (143, 143, 5, 'Aut ut nam consequatur enim ab tempore ut. Neque omnis qui sint adipisci ea eligendi ullam. Dicta nemo voluptate ea.', '1983-08-09 01:48:35');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (144, 144, 5, 'Iste est in voluptatem et veniam. Alias recusandae voluptas consequuntur delectus et accusantium est. Autem quis impedit assumenda omnis neque ad ea.', '1982-04-27 05:34:00');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (145, 145, 2, 'Ex voluptates cumque quia. Dignissimos blanditiis sint aut minima nihil eum. Hic quia quod in non. Et sapiente eos eos officiis porro.', '2013-11-26 22:21:40');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (146, 146, 1, 'Cum et dicta nihil sit itaque error sint. Dolorem sapiente rerum aut qui ab. Voluptas eveniet sit amet harum earum aut velit. Tenetur ut rerum eligendi assumenda ex placeat velit.', '1986-09-03 11:10:37');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (147, 147, 1, 'Dignissimos sit et odit. Esse pariatur et quia earum nobis dolorem quia. Quam aut nesciunt saepe illum eaque. Alias qui fugiat explicabo velit consequatur aliquid ea.', '2011-03-24 03:41:31');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (148, 148, 4, 'Totam aut expedita quo. Adipisci culpa ipsa doloribus tempora et dolores. Laudantium porro magnam cumque sunt quisquam qui. Unde vel corrupti non ut.', '1986-06-20 16:22:16');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (149, 149, 4, 'Tempora earum et nam occaecati ea in. Sit modi iure adipisci sunt. Autem magni illo illo cum est sed. Unde praesentium odit sequi quia sit quia.', '1985-04-27 16:33:48');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (150, 150, 5, 'Perferendis ex similique ea eos provident ut voluptas fuga. Ad hic nam rem alias quia. Sunt laborum molestiae provident alias. In reprehenderit atque dolor quod quibusdam ex.', '2013-02-14 22:04:01');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (151, 151, 3, 'Maiores ab ullam adipisci dolore modi dolorem. Repellat nihil sint itaque repellat ut. Nostrum ratione consequatur suscipit id dolorum. Cum sequi eos est assumenda ullam.', '2006-07-15 04:36:32');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (152, 152, 4, 'Sunt rem ut neque voluptas. Qui sit temporibus quis est inventore. Minima libero et enim accusamus odit optio soluta. Dolorem architecto omnis soluta quibusdam numquam.', '1989-06-08 04:57:01');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (153, 153, 4, 'Aliquid doloribus perferendis nostrum maxime nulla dolore cum. Mollitia et minima explicabo qui ut dolorem quas. Non cumque totam ea.', '2010-08-27 12:36:12');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (154, 154, 3, 'Consequuntur facere reprehenderit tempora. Quidem et deleniti voluptatem expedita. Veritatis velit eligendi et omnis excepturi. Omnis quia aut nulla aut repellendus est.', '1984-02-10 14:26:55');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (155, 155, 3, 'Autem numquam recusandae in nostrum saepe. Enim est sed vitae.', '1982-03-10 20:49:31');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (156, 156, 5, 'Ut at adipisci sed repellendus consequatur suscipit eum. Sint saepe laborum sint libero et. Vitae qui doloribus nostrum necessitatibus.', '1979-11-02 00:47:50');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (157, 157, 1, 'Explicabo atque fugiat voluptatem qui id blanditiis neque. Distinctio iure ut provident quas. Ab minima tempore quidem dolorum ut rerum asperiores.', '1973-04-07 10:36:52');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (158, 158, 5, 'In et omnis voluptatem aut voluptatum velit. Quod quasi repellat est porro. Eveniet accusamus quaerat et ducimus. Aut rerum aut veniam deserunt nihil.', '2016-02-09 14:08:11');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (159, 159, 1, 'Consequatur magni sunt architecto consectetur itaque vel nobis. Dignissimos eos et unde cum sequi velit. Eos repellat debitis omnis provident.', '2014-06-16 20:44:55');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (160, 160, 5, 'Fuga ut quibusdam cumque molestiae velit consequatur veritatis. Quo odit sunt quo est corrupti harum fugit. Eum id ipsa natus exercitationem mollitia nobis.', '1986-08-21 22:28:36');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (161, 161, 2, 'Qui doloremque non quos hic. Expedita ipsam alias beatae autem. Quia magni aperiam exercitationem modi aut delectus. Quod consectetur nisi omnis eum.', '2010-08-06 17:21:01');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (162, 162, 4, 'Amet consequuntur unde est nostrum. Impedit quam similique rerum quo minima. Suscipit nihil minus rerum quos eum expedita maxime. Totam aliquid qui officiis dolores provident occaecati et.', '1993-06-26 04:38:16');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (163, 163, 1, 'Dolorem ad accusantium molestias ut. Ut quia vitae accusamus aperiam corrupti nihil quo. Quo suscipit amet quae. Et placeat assumenda odio sunt non.', '2019-03-05 23:16:22');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (164, 164, 2, 'Consequuntur dolores ipsum voluptate eos expedita perspiciatis. Aut fuga eaque fuga. Tempore est natus aliquam blanditiis iure quaerat.', '1981-09-10 23:05:31');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (165, 165, 3, 'Officiis aliquam et voluptatem molestiae enim est. Exercitationem est tempora facere et saepe beatae.\nQuibusdam in ut quisquam eum quia sed. Ad perspiciatis nemo nesciunt blanditiis.', '2001-04-13 06:30:20');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (166, 166, 2, 'Quia saepe sed ut cumque sint molestiae. Sunt in id dignissimos excepturi quisquam sit alias. Voluptas vero qui nemo necessitatibus.', '1975-01-18 02:55:06');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (167, 167, 5, 'Corporis vero nesciunt quam nihil quos non. Qui rem amet sed odio. Nemo eligendi occaecati aut qui. Totam culpa ut nostrum similique nam quo.', '2016-08-13 02:57:54');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (168, 168, 3, 'Cupiditate esse molestiae et repellendus nihil. Consequuntur et vero modi. Error ea sit et et aut.', '1993-10-27 17:35:10');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (169, 169, 1, 'Et architecto veniam culpa rerum. Eius sit dolorem est aut dicta. In voluptatem consequatur error soluta.\nEius fuga autem nesciunt et earum. Dolore corrupti similique perspiciatis exercitationem.', '2008-04-01 23:22:26');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (170, 170, 3, 'Eveniet vitae voluptas quia. Perspiciatis velit autem et. Quos at consequuntur quis itaque dolorum aperiam aut.', '2014-10-04 10:01:45');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (171, 171, 3, 'Modi et ut placeat eius et eligendi consectetur. Eos excepturi consequatur et optio ut. Ea reiciendis eligendi voluptatem laudantium. Voluptate ipsam architecto ut voluptate hic officia.', '1996-07-11 12:34:46');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (172, 172, 3, 'Saepe minus et quaerat ut eos. Recusandae repellendus necessitatibus quibusdam rem soluta aut temporibus. Minus enim autem voluptatem et.', '1976-04-23 20:45:47');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (173, 173, 1, 'Eius voluptatem voluptatem id omnis. Officia esse odit deleniti ipsa consequuntur. Ipsam fugit rem accusantium et nisi. Fugit velit ea temporibus veritatis error vitae.', '1983-01-21 04:59:39');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (174, 174, 4, 'Unde et suscipit et autem pariatur voluptas. Eaque deserunt est repellendus non voluptatem. Dolores iste eum officia iusto ex quia.', '1979-10-07 06:50:27');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (175, 175, 2, 'Est et cumque enim totam perspiciatis voluptatibus est. Aut aut aperiam dolorum similique et. Nihil culpa deleniti optio sapiente doloribus. Inventore aut eveniet in sed quia et optio consequuntur.', '2017-04-14 15:38:16');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (176, 176, 1, 'Autem officiis quia iste aut. Est eum reprehenderit similique dolores deleniti in. Neque ipsa et consequatur rerum vitae aut illum.', '1996-08-14 04:45:10');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (177, 177, 4, 'Eius vel fuga hic neque itaque culpa est a. Et quidem consectetur aperiam est. Saepe est dolore recusandae vero. Ipsam ipsum dicta ut quos dolor mollitia et vero.', '2004-03-26 01:14:19');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (178, 178, 5, 'Ipsam amet harum rem iure sunt quasi. Molestiae perferendis voluptatum suscipit consequuntur. Nam cum non et est dolore eius. Provident autem adipisci perferendis placeat pariatur unde et.', '1977-08-27 21:44:27');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (179, 179, 5, 'Quia sint molestias accusantium quia praesentium. Autem minima a pariatur sed. Aut aliquam omnis quidem similique. Qui odit est repudiandae nam molestiae consectetur.', '2002-02-25 05:17:33');
INSERT INTO `reviews` (`id`, `order_id`, `mark`, `comment`, `created_at`) VALUES (180, 180, 5, 'Inventore velit qui possimus. Sit minus a dolor est. Enim quia et sunt fugiat. Temporibus ullam maiores eligendi commodi omnis eaque.', '1975-06-16 05:32:52');

-- Таблица course_orders

INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (1, 1);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (2, 2);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (3, 3);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (4, 4);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (5, 5);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (6, 6);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (7, 7);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (8, 8);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (9, 9);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (10, 10);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (11, 11);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (12, 12);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (13, 13);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (14, 14);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (15, 15);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (16, 16);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (17, 17);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (18, 18);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (19, 19);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (20, 20);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (21, 21);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (22, 22);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (23, 23);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (24, 24);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (25, 25);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (26, 26);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (27, 27);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (28, 28);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (29, 29);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (30, 30);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (31, 31);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (32, 32);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (33, 33);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (34, 34);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (35, 35);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (36, 36);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (37, 37);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (38, 38);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (39, 39);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (40, 40);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (41, 41);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (42, 42);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (43, 43);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (44, 44);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (45, 45);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (46, 46);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (47, 47);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (48, 48);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (49, 49);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (50, 50);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (51, 51);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (52, 52);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (53, 53);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (54, 54);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (55, 55);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (56, 56);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (57, 57);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (58, 58);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (59, 59);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (60, 60);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (61, 61);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (62, 62);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (63, 63);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (64, 64);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (65, 65);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (66, 66);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (67, 67);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (68, 68);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (69, 69);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (70, 70);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (71, 71);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (72, 72);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (73, 73);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (74, 74);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (75, 75);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (76, 76);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (77, 77);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (78, 78);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (79, 79);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (80, 80);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (81, 81);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (82, 82);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (83, 83);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (84, 84);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (85, 85);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (86, 86);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (87, 87);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (88, 88);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (89, 89);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (90, 90);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (91, 91);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (92, 92);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (93, 93);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (94, 94);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (95, 95);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (96, 96);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (97, 97);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (98, 98);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (99, 99);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (100, 100);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (101, 101);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (102, 102);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (103, 103);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (104, 104);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (105, 105);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (106, 106);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (107, 107);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (108, 108);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (109, 109);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (110, 110);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (111, 111);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (112, 112);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (113, 113);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (114, 114);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (115, 115);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (116, 116);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (117, 117);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (118, 118);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (119, 119);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (120, 120);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (121, 121);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (122, 122);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (123, 123);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (124, 124);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (125, 125);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (126, 126);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (127, 127);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (128, 128);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (129, 129);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (130, 130);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (131, 131);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (132, 132);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (133, 133);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (134, 134);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (135, 135);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (136, 136);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (137, 137);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (138, 138);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (139, 139);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (140, 140);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (141, 141);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (142, 142);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (143, 143);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (144, 144);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (145, 145);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (146, 146);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (147, 147);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (148, 148);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (149, 149);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (150, 150);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (151, 151);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (152, 152);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (153, 153);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (154, 154);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (155, 155);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (156, 156);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (157, 157);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (158, 158);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (159, 159);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (160, 160);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (161, 161);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (162, 162);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (163, 163);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (164, 164);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (165, 165);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (166, 166);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (167, 167);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (168, 168);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (169, 169);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (170, 170);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (171, 171);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (172, 172);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (173, 173);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (174, 174);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (175, 175);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (176, 176);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (177, 177);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (178, 178);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (179, 179);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (180, 180);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (181, 181);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (182, 182);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (183, 183);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (184, 184);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (185, 185);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (186, 186);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (187, 187);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (188, 188);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (189, 189);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (190, 190);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (191, 191);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (192, 192);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (193, 193);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (194, 194);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (195, 195);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (196, 196);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (197, 197);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (198, 198);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (199, 199);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (200, 200);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (1, 201);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (2, 202);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (3, 203);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (4, 204);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (5, 205);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (6, 206);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (7, 207);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (8, 208);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (9, 209);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (10, 210);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (11, 211);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (12, 212);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (13, 213);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (14, 214);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (15, 215);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (16, 216);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (17, 217);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (18, 218);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (19, 219);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (20, 220);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (21, 221);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (22, 222);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (23, 223);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (24, 224);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (25, 225);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (26, 226);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (27, 227);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (28, 228);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (29, 229);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (30, 230);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (31, 231);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (32, 232);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (33, 233);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (34, 234);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (35, 235);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (36, 236);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (37, 237);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (38, 238);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (39, 239);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (40, 240);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (41, 241);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (42, 242);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (43, 243);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (44, 244);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (45, 245);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (46, 246);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (47, 247);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (48, 248);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (49, 249);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (50, 250);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (51, 251);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (52, 252);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (53, 253);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (54, 254);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (55, 255);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (56, 256);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (57, 257);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (58, 258);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (59, 259);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (60, 260);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (61, 261);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (62, 262);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (63, 263);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (64, 264);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (65, 265);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (66, 266);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (67, 267);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (68, 268);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (69, 269);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (70, 270);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (71, 271);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (72, 272);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (73, 273);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (74, 274);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (75, 275);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (76, 276);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (77, 277);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (78, 278);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (79, 279);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (80, 280);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (81, 281);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (82, 282);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (83, 283);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (84, 284);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (85, 285);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (86, 286);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (87, 287);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (88, 288);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (89, 289);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (90, 290);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (91, 291);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (92, 292);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (93, 293);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (94, 294);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (95, 295);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (96, 296);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (97, 297);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (98, 298);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (99, 299);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (100, 300);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (101, 301);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (102, 302);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (103, 303);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (104, 304);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (105, 305);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (106, 306);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (107, 307);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (108, 308);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (109, 309);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (110, 310);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (111, 311);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (112, 312);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (113, 313);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (114, 314);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (115, 315);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (116, 316);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (117, 317);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (118, 318);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (119, 319);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (120, 320);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (121, 321);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (122, 322);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (123, 323);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (124, 324);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (125, 325);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (126, 326);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (127, 327);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (128, 328);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (129, 329);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (130, 330);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (131, 331);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (132, 332);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (133, 333);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (134, 334);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (135, 335);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (136, 336);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (137, 337);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (138, 338);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (139, 339);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (140, 340);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (141, 341);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (142, 342);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (143, 343);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (144, 344);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (145, 345);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (146, 346);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (147, 347);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (148, 348);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (149, 349);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (150, 350);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (151, 351);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (152, 352);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (153, 353);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (154, 354);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (155, 355);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (156, 356);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (157, 357);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (158, 358);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (159, 359);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (160, 360);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (161, 361);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (162, 362);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (163, 363);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (164, 364);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (165, 365);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (166, 366);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (167, 367);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (168, 368);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (169, 369);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (170, 370);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (171, 371);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (172, 372);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (173, 373);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (174, 374);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (175, 375);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (176, 376);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (177, 377);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (178, 378);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (179, 379);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (180, 380);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (181, 381);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (182, 382);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (183, 383);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (184, 384);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (185, 385);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (186, 386);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (187, 387);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (188, 388);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (189, 389);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (190, 390);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (191, 391);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (192, 392);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (193, 393);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (194, 394);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (195, 395);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (196, 396);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (197, 397);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (198, 398);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (199, 399);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (200, 400);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (1, 1);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (2, 2);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (3, 3);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (4, 4);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (5, 5);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (6, 6);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (7, 7);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (8, 8);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (9, 9);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (10, 10);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (11, 11);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (12, 12);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (13, 13);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (14, 14);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (15, 15);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (16, 16);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (17, 17);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (18, 18);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (19, 19);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (20, 20);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (21, 21);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (22, 22);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (23, 23);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (24, 24);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (25, 25);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (26, 26);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (27, 27);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (28, 28);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (29, 29);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (30, 30);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (31, 31);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (32, 32);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (33, 33);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (34, 34);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (35, 35);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (36, 36);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (37, 37);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (38, 38);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (39, 39);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (40, 40);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (41, 41);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (42, 42);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (43, 43);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (44, 44);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (45, 45);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (46, 46);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (47, 47);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (48, 48);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (49, 49);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (50, 50);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (51, 51);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (52, 52);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (53, 53);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (54, 54);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (55, 55);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (56, 56);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (57, 57);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (58, 58);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (59, 59);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (60, 60);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (61, 61);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (62, 62);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (63, 63);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (64, 64);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (65, 65);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (66, 66);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (67, 67);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (68, 68);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (69, 69);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (70, 70);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (71, 71);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (72, 72);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (73, 73);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (74, 74);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (75, 75);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (76, 76);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (77, 77);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (78, 78);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (79, 79);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (80, 80);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (81, 81);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (82, 82);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (83, 83);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (84, 84);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (85, 85);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (86, 86);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (87, 87);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (88, 88);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (89, 89);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (90, 90);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (91, 91);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (92, 92);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (93, 93);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (94, 94);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (95, 95);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (96, 96);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (97, 97);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (98, 98);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (99, 99);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (100, 100);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (101, 101);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (102, 102);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (103, 103);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (104, 104);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (105, 105);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (106, 106);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (107, 107);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (108, 108);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (109, 109);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (110, 110);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (111, 111);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (112, 112);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (113, 113);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (114, 114);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (115, 115);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (116, 116);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (117, 117);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (118, 118);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (119, 119);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (120, 120);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (121, 121);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (122, 122);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (123, 123);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (124, 124);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (125, 125);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (126, 126);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (127, 127);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (128, 128);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (129, 129);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (130, 130);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (131, 131);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (132, 132);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (133, 133);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (134, 134);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (135, 135);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (136, 136);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (137, 137);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (138, 138);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (139, 139);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (140, 140);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (141, 141);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (142, 142);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (143, 143);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (144, 144);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (145, 145);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (146, 146);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (147, 147);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (148, 148);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (149, 149);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (150, 150);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (151, 151);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (152, 152);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (153, 153);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (154, 154);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (155, 155);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (156, 156);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (157, 157);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (158, 158);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (159, 159);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (160, 160);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (161, 161);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (162, 162);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (163, 163);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (164, 164);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (165, 165);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (166, 166);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (167, 167);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (168, 168);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (169, 169);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (170, 170);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (171, 171);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (172, 172);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (173, 173);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (174, 174);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (175, 175);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (176, 176);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (177, 177);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (178, 178);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (179, 179);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (180, 180);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (181, 181);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (182, 182);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (183, 183);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (184, 184);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (185, 185);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (186, 186);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (187, 187);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (188, 188);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (189, 189);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (190, 190);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (191, 191);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (192, 192);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (193, 193);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (194, 194);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (195, 195);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (196, 196);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (197, 197);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (198, 198);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (199, 199);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (200, 200);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (1, 201);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (2, 202);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (3, 203);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (4, 204);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (5, 205);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (6, 206);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (7, 207);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (8, 208);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (9, 209);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (10, 210);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (11, 211);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (12, 212);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (13, 213);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (14, 214);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (15, 215);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (16, 216);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (17, 217);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (18, 218);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (19, 219);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (20, 220);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (21, 221);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (22, 222);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (23, 223);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (24, 224);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (25, 225);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (26, 226);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (27, 227);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (28, 228);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (29, 229);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (30, 230);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (31, 231);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (32, 232);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (33, 233);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (34, 234);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (35, 235);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (36, 236);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (37, 237);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (38, 238);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (39, 239);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (40, 240);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (41, 241);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (42, 242);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (43, 243);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (44, 244);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (45, 245);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (46, 246);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (47, 247);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (48, 248);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (49, 249);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (50, 250);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (51, 251);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (52, 252);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (53, 253);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (54, 254);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (55, 255);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (56, 256);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (57, 257);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (58, 258);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (59, 259);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (60, 260);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (61, 261);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (62, 262);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (63, 263);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (64, 264);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (65, 265);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (66, 266);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (67, 267);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (68, 268);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (69, 269);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (70, 270);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (71, 271);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (72, 272);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (73, 273);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (74, 274);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (75, 275);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (76, 276);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (77, 277);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (78, 278);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (79, 279);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (80, 280);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (81, 281);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (82, 282);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (83, 283);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (84, 284);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (85, 285);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (86, 286);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (87, 287);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (88, 288);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (89, 289);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (90, 290);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (91, 291);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (92, 292);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (93, 293);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (94, 294);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (95, 295);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (96, 296);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (97, 297);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (98, 298);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (99, 299);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (100, 300);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (101, 301);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (102, 302);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (103, 303);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (104, 304);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (105, 305);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (106, 306);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (107, 307);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (108, 308);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (109, 309);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (110, 310);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (111, 311);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (112, 312);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (113, 313);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (114, 314);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (115, 315);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (116, 316);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (117, 317);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (118, 318);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (119, 319);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (120, 320);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (121, 321);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (122, 322);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (123, 323);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (124, 324);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (125, 325);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (126, 326);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (127, 327);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (128, 328);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (129, 329);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (130, 330);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (131, 331);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (132, 332);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (133, 333);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (134, 334);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (135, 335);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (136, 336);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (137, 337);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (138, 338);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (139, 339);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (140, 340);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (141, 341);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (142, 342);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (143, 343);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (144, 344);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (145, 345);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (146, 346);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (147, 347);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (148, 348);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (149, 349);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (150, 350);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (151, 351);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (152, 352);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (153, 353);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (154, 354);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (155, 355);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (156, 356);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (157, 357);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (158, 358);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (159, 359);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (160, 360);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (161, 361);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (162, 362);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (163, 363);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (164, 364);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (165, 365);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (166, 366);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (167, 367);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (168, 368);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (169, 369);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (170, 370);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (171, 371);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (172, 372);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (173, 373);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (174, 374);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (175, 375);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (176, 376);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (177, 377);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (178, 378);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (179, 379);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (180, 380);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (181, 381);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (182, 382);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (183, 383);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (184, 384);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (185, 385);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (186, 386);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (187, 387);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (188, 388);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (189, 389);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (190, 390);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (191, 391);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (192, 392);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (193, 393);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (194, 394);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (195, 395);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (196, 396);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (197, 397);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (198, 398);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (199, 399);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (200, 400);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (1, 1);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (2, 2);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (3, 3);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (4, 4);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (5, 5);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (6, 6);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (7, 7);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (8, 8);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (9, 9);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (10, 10);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (11, 11);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (12, 12);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (13, 13);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (14, 14);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (15, 15);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (16, 16);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (17, 17);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (18, 18);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (19, 19);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (20, 20);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (21, 21);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (22, 22);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (23, 23);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (24, 24);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (25, 25);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (26, 26);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (27, 27);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (28, 28);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (29, 29);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (30, 30);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (31, 31);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (32, 32);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (33, 33);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (34, 34);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (35, 35);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (36, 36);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (37, 37);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (38, 38);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (39, 39);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (40, 40);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (41, 41);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (42, 42);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (43, 43);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (44, 44);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (45, 45);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (46, 46);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (47, 47);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (48, 48);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (49, 49);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (50, 50);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (51, 51);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (52, 52);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (53, 53);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (54, 54);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (55, 55);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (56, 56);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (57, 57);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (58, 58);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (59, 59);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (60, 60);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (61, 61);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (62, 62);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (63, 63);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (64, 64);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (65, 65);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (66, 66);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (67, 67);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (68, 68);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (69, 69);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (70, 70);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (71, 71);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (72, 72);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (73, 73);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (74, 74);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (75, 75);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (76, 76);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (77, 77);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (78, 78);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (79, 79);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (80, 80);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (81, 81);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (82, 82);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (83, 83);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (84, 84);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (85, 85);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (86, 86);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (87, 87);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (88, 88);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (89, 89);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (90, 90);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (91, 91);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (92, 92);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (93, 93);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (94, 94);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (95, 95);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (96, 96);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (97, 97);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (98, 98);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (99, 99);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (100, 100);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (101, 101);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (102, 102);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (103, 103);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (104, 104);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (105, 105);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (106, 106);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (107, 107);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (108, 108);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (109, 109);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (110, 110);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (111, 111);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (112, 112);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (113, 113);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (114, 114);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (115, 115);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (116, 116);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (117, 117);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (118, 118);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (119, 119);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (120, 120);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (121, 121);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (122, 122);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (123, 123);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (124, 124);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (125, 125);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (126, 126);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (127, 127);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (128, 128);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (129, 129);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (130, 130);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (131, 131);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (132, 132);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (133, 133);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (134, 134);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (135, 135);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (136, 136);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (137, 137);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (138, 138);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (139, 139);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (140, 140);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (141, 141);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (142, 142);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (143, 143);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (144, 144);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (145, 145);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (146, 146);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (147, 147);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (148, 148);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (149, 149);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (150, 150);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (151, 151);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (152, 152);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (153, 153);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (154, 154);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (155, 155);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (156, 156);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (157, 157);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (158, 158);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (159, 159);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (160, 160);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (161, 161);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (162, 162);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (163, 163);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (164, 164);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (165, 165);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (166, 166);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (167, 167);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (168, 168);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (169, 169);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (170, 170);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (171, 171);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (172, 172);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (173, 173);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (174, 174);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (175, 175);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (176, 176);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (177, 177);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (178, 178);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (179, 179);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (180, 180);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (181, 181);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (182, 182);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (183, 183);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (184, 184);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (185, 185);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (186, 186);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (187, 187);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (188, 188);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (189, 189);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (190, 190);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (191, 191);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (192, 192);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (193, 193);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (194, 194);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (195, 195);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (196, 196);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (197, 197);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (198, 198);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (199, 199);
INSERT INTO `course_orders` (`course_id`, `order_id`) VALUES (200, 200);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Корректировка данных
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE course_orders SET course_id = FLOOR(1 + (RAND() * 200));
UPDATE course_orders SET order_id = FLOOR(1 + (RAND() * 400));
UPDATE menu SET restaurant_id = FLOOR(1 + (RAND() * 40));
UPDATE menu SET food_category_id = FLOOR(1 + (RAND() * 7));
UPDATE menu SET is_available = 1;
UPDATE menu SET is_available = 0 WHERE id IN (8, 65, 87);
UPDATE orders SET user_id = FLOOR(1 + (RAND() * 120));
UPDATE orders SET address_id = FLOOR(1 + (RAND() * 50));
UPDATE orders SET is_confirmed = 1;
UPDATE orders SET is_confirmed = 0 WHERE id IN (3, 69, 153, 215, 361);
UPDATE orders SET condirmed_at = NULL WHERE id IN (3, 69, 153, 215, 361);
UPDATE promocodes set end_date = NOW();
UPDATE orders SET promo_id = FLOOR(1 + (RAND() * 30));
UPDATE restaurants SET close_at = SEC_TO_TIME(FLOOR(TIME_TO_SEC('12:00:00') + RAND() * (TIME_TO_SEC(TIMEDIFF('24:00:00', '12:00:00')))));
UPDATE restaurants SET open_at = SEC_TO_TIME(FLOOR(TIME_TO_SEC('00:00:00') + RAND() * (TIME_TO_SEC(TIMEDIFF('12:00:00', '00:00:00')))));
UPDATE reviews SET order_id = FLOOR(1 + (RAND() * 400));
UPDATE reviews SET mark = FLOOR(1 + (RAND() * 5));

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Характерные выборки (включающие группировки, JOIN'ы, вложенные запросы)
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Состав определенного заказа
SELECT
menu.course_name,
menu.price,
(SELECT name from food_categories where food_categories.id = food_category_id) AS 'Category'
FROM 
course_orders
JOIN
menu
ON course_orders.course_id = menu.id
WHERE course_orders.order_id = 1;

-- Самый активный пользователь
SELECT
CONCAT(users.name, ' ', users.surname) as name,
COUNT(orders.id) AS orders
FROM
users
LEFT JOIN
orders
ON users.id = orders.user_id
GROUP BY users.id
LIMIT 1;

-- 5 ресторанов с самым высоким рейтингом
SELECT 
	restaurants.name,
	AVG(reviews.mark) as mark
	FROM 
	restaurants
	JOIN
	menu
	ON restaurants.id = menu.restaurant_id
	JOIN course_orders
	ON menu.id = course_orders.course_id
	JOIN orders
	ON course_orders.order_id = orders.id
	JOIN
	reviews
	ON orders.id =  reviews.order_id
	GROUP BY restaurants.name
	ORDER BY mark DESC
	LIMIT 5;

-- Стоимость всех заказов с учетом промокодов
SELECT 
orders.id, 
(SUM(price) * promocodes.discount / 100) AS "Сумма заказа"
FROM menu
JOIN course_orders
ON course_orders.course_id = menu.id
JOIN orders
ON course_orders.order_id = orders.id
LEFT JOIN promocodes
ON orders.promo_id = promocodes.id
GROUP BY orders.id
ORDER BY orders.id;

-- Запрос статистики по каждому ресторану
SELECT DISTINCT
	restaurants.name AS 'Название ресторана',
	COUNT(orders.id) OVER(PARTITION BY restaurants.id) AS 'Количество заказов у данного ресторана',
	AVG(reviews.mark) OVER(PARTITION BY restaurants.id) AS 'Рейтинг ресторана',
	AVG(menu.price) OVER(PARTITION BY restaurants.id) AS 'Средняя цена за блюдо',
	FIRST_VALUE(menu.course_name) OVER(PARTITION BY restaurants.id ORDER BY menu.price) AS 'Самое дорогое блюдо'
	FROM restaurants
	LEFT JOIN menu
		ON restaurants.id = menu.restaurant_id
	LEFT JOIN course_orders
		ON course_orders.course_id = menu.id
	LEFT JOIN orders
		ON course_orders.order_id = orders.id
	LEFT JOIN reviews
		ON orders.id = reviews.order_id
	;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- Представления
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- Представление Блюдо-Ресторан

CREATE OR REPLACE VIEW menu_restaurants AS
SELECT
  m.course_name AS 'Блюдо',
  r.name AS 'Ресторан'
FROM
  menu AS m
JOIN
  restaurants AS r
ON
  m.restaurant_id = r.id;
 

-- Представление Заказ-Пользователь-Цена

CREATE OR REPLACE VIEW orders_price AS
SELECT
  o.id AS 'Заказ',
  o.user_id AS 'Пользователь',
  SUM(m.price) AS 'Цена'
FROM
 	orders AS o
LEFT JOIN
 	course_orders AS co
ON
 	o.id = co.order_id
LEFT JOIN
	menu AS m
ON
	co.course_id = m.id
GROUP BY o.id;
 
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- Хранимые процедуры / триггеры
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
	
-- Функция (оценка привередливости пользователя)

DROP FUNCTION IF EXISTS critique_lvl;

DELIMITER //
CREATE FUNCTION critique_lvl(critique_user_id INT)
	RETURNS FLOAT READS SQL DATA
	BEGIN
    	DECLARE avg_rate FLOAT; 
    	SET avg_rate = (SELECT AVG(mark) FROM reviews WHERE order_id IN (SELECT id FROM orders WHERE user_id = critique_user_id));
    RETURN avg_rate;
  END//
  
DELIMITER ;

SELECT critique_lvl(3);

-- Процедура возвращает последний заказ пользователя

DROP PROCEDURE IF EXISTS last_order;

DELIMITER //

CREATE PROCEDURE last_order (IN for_user_id INT)

  BEGIN 
    (SELECT
    CONCAT (users.name, ' ', users.surname) AS 'Заказчик',
    addresses.address 'Адрес',
    CONCAT (couriers.name, ' ', couriers.surname) 'Курьер',
    SUM(menu.price) 'Сумма к оплате',
    orders.condirmed_at AS 'Дата заказа'
    FROM users
    JOIN orders
    ON users.id = orders.user_id
    JOIN course_orders
    ON orders.id = course_orders.order_id
    JOIN addresses
    ON orders.address_id = addresses.id
   	JOIN couriers
    ON orders.courier_id = couriers.id
    JOIN 
   	menu
   	ON course_orders.course_id = menu.id
   	JOIN
   	restaurants
   	ON menu.restaurant_id = restaurants.id
    WHERE users.id = for_user_id
    GROUP BY orders.id
    ORDER BY orders.condirmed_at DESC
    )
   LIMIT 1
   ;
END//
DELIMITER ;

	
