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
Реализовать запросы с использованием объединений, группировок, вложенного подзапроса. Экспортировать план в файл с помощью psql -qAt -f объяснения.sql > анализ.json
Для наилучших достижений результатов викор EXPLAIN (АНАЛИЗ, ЗАТРАТЫ, ПОДРОБНОЕ, БУФЕРЫ, ФОРМАТ JSON)
