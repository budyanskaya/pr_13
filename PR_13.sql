--Задание 1
--Создайте таблицу table1 со следующими параметрами:
﻿﻿--Поля: id1 int, id2 int, gen1 text, gen2 text.
﻿﻿--Первичным ключом сделайте поля id1, id2, gen1.

CREATE TABLE table1 (
    id1 INT,
    id2 INT,
    gen1 TEXT,
    gen2 TEXT,
    PRIMARY KEY (id1, id2, gen1)
);

--Задание 2
--Создайте таблицу table2 со следующими параметрами: 
--Возьмите набор полей table1 с помощью директивы LIKE.

CREATE TABLE table2 (
    LIKE table1 including all
);

--Задание 3
--Проверить, какое количество внешних таблиц присутствует в бд

SELECT count(*)
FROM pg_foreign_table;


--Задание 4
--Сгенерируйте данные и вставьте их в обе таблицы(200 тысяч и 400 тысяч значений соответственно):
--insert into table1 select gen, gen, gen::text  'text1', gen::text  'text2' from generate_series (1,200000) gen;
--insert into table2 select gen,gen, gen::text  'text1', gen::text  'text2' from generate_series (1,400000) gen;

INSERT INTO table1
SELECT gen, gen, gen::text AS text1, gen::text AS text2
FROM generate_series(1, 200000) AS gen;

INSERT INTO table2
SELECT gen, gen, gen::text AS text1, gen::text AS text2
FROM generate_series(1, 400000) AS gen;

--Задание 5
--С помощью директивы EXPLAIN просмотрите план соединения таблиц table1 и table2 по ключу id1.

EXPLAIN
SELECT *
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1;

--Задание 6
--Используя таблицы table1 и table2 реализовать план запроса:
--План запроса встроенного инструмента dbeaver.

SELECT *
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1;


-- Задание 7
-- Реализовать запросы с использованием объединений, группировок, вложенного подзапроса. 
--Экспортировать план в файл в формате json

-- JOIN

SELECT * FROM table1 t1 JOIN table2 t2 ON t1.id1 = t2.id1;

-- GROUP BY

SELECT gen1, COUNT(*) FROM table1 GROUP BY gen1;

-- Подзапрос

SELECT * FROM table1 WHERE id1 IN (SELECT id1 FROM table2 LIMIT 100);


