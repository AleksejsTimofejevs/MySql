/* Создайте базу данных example, разместите в ней таблицу users, 
 * состоящую из двух столбцов, числового id и строкового name.  */

DROP database IF EXISTS example;
CREATE database example;
USE example;

DROP TABLE if EXISTS users;
CREATE TABLE users(
	id int UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	name varchar(255)
);

/* Создайте дамп базы данных example из предыдущего задания,
* разверните содержимое дампа в новую базу данных sample. 
*
* Для этого в консоли нужно ввести след. команды:
* 
* mysqldump example > sample.sql
* mysql
* CREATE database IF NOT EXISTS sample;
* \q
* mysql sample  < sample.sql
**/