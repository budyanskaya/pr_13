# Практическая работа 13. План запроса

## Цель: Изучение механизмов построения и анализа планов выполнения SQL-запросов в СУБД PostgreSQL, а также оценка эффективности различных типов запросов (JOIN, GROUP BY, подзапросы) с использованием инструментов EXPLAIN и визуализации планов.

## Задание 1
Создайте таблицу table1 со следующими параметрами:
Поля: id1 int, id2 int, gen1 text, gen2 text.
Первичным ключом сделайте поля id1, id2, gen1.
````
CREATE TABLE table1 (
    id1 INT,
    id2 INT,
    gen1 TEXT,
    gen2 TEXT,
    PRIMARY KEY (id1, id2, gen1)
);
````
Получаем результат:

![Снимок экрана 2025-05-27 211628](https://github.com/user-attachments/assets/37505cb0-ca45-4468-b3e8-4c83a68a5e25)

## Задание 2
Создайте таблицу table2 со следующими параметрами: 
Возьмите набор полей table1 с помощью директивы LIKE.
````
CREATE TABLE table2 (
    LIKE table1
);
````
Получаем результат:

![Снимок экрана 2025-05-27 212049](https://github.com/user-attachments/assets/8843bc15-a4b1-42ab-8dbd-65ebb2986a8f)

## Задание 3
Проверить, какое количество внешних таблиц присутствует в бд
````
SELECT count(*)
FROM pg_foreign_table;
````
Получаем результат:

![Снимок экрана 2025-05-27 212904](https://github.com/user-attachments/assets/cb96b9e5-379f-4d25-b0e7-6563ab70b4b7)

## Задание 4
Сгенерируйте данные и вставьте их в обе таблицы(200 тысяч и 400 тысяч значений соответственно):
insert into table1 select gen, gen, gen::text  'text1', gen::text  'text2' from generate_series (1,200000) gen;
insert into table2 select gen,gen, gen::text  'text1', gen::text  'text2' from generate_series (1,400000) gen;
````
INSERT INTO table1
SELECT gen, gen, gen::text AS text1, gen::text AS text2
FROM generate_series(1, 200000) AS gen;

INSERT INTO table2
SELECT gen, gen, gen::text AS text1, gen::text AS text2
FROM generate_series(1, 400000) AS gen;
````
Получаем результат:

![Снимок экрана 2025-05-27 213436](https://github.com/user-attachments/assets/58ed8b8a-ea4e-4d14-b600-59b0c1c9cff6)

## Задание 5
С помощью директивы EXPLAIN просмотрите план соединения таблиц table1 и table2 по ключу id1.
````
EXPLAIN
SELECT *
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1;
````
Получаем результат:

![Снимок экрана 2025-05-27 214754](https://github.com/user-attachments/assets/9e45b1ac-0a9f-4a65-896f-a384b93f82f6)

## Задание 6
Используя таблицы table1 и table2 реализовать план запроса:
План запроса встроенного инструмента dbeaver.
````
SELECT *
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1;
````
Получаем следующий план запроса:

![image](https://github.com/user-attachments/assets/36126117-fba9-4001-8855-00735f2d50ca)

## Задание 7
Реализовать запросы с использованием объединений, группировок, вложенного подзапроса. Экспортировать план в файл в формате json

## JOIN
````
SELECT * FROM table1 t1 JOIN table2 t2 ON t1.id1 = t2.id1;
````
Получаем план:

![image](https://github.com/user-attachments/assets/540d8417-5ec0-4981-87d9-2ca0af121b97)

## GROUP BY
````
SELECT gen1, COUNT(*) FROM table1 GROUP BY gen1;
````
Получаем план:

![image](https://github.com/user-attachments/assets/f23ee290-55aa-4e14-828e-2c745d7a5a7e)

## Подзапрос
````
SELECT * FROM table1 WHERE id1 IN (SELECT id1 FROM table2 LIMIT 100);
````
Получаем план:

![image](https://github.com/user-attachments/assets/428f317b-2cd7-431b-8577-fbdf10656df3)

Файлы с планами сохранены в формате json и прикреплены.

## Задание 8 
Сравнить полученные результаты а пункте 13.6 локально с результатом на сайте https://tatiyants.com/pev/#/plans/new
сделайте вывод.

Локально:

![image](https://github.com/user-attachments/assets/1631e96e-ab2e-4f5b-b4a3-0cffddf929b2)

На сайте:

![image](https://github.com/user-attachments/assets/5e82d284-06a7-45ef-9224-3bf7839075a4)


Был проведен анализ плана выполнения запроса SELECT * FROM table1 t1 JOIN table2 t2 ON t1.id1 = t2.id1;. Локальный анализ показал, что основным узлом является Hash Join, который занимает около 223.425 мс, анализ на сайте подтвердил, что ХЭШ-СОЕДИНЕНИЕ является самым дорогим узлом, хотя общее время выполнения составило 726.8 мс, но эта разница может быть связана с различиями в конфигурации сервера

## Вывод: В ходе работы, мы изучили механизмы построения и анализа планов выполнения SQL-запросов в СУБД PostgreSQL, а также оценили эффективность различных типов запросов (JOIN, GROUP BY, подзапросы) с использованием инструментов EXPLAIN и визуализации планов.
