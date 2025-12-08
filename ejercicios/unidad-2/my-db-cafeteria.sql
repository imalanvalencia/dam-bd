 -- Cafeteria
-- Base de datos creada para hacer prácticas de JOINs en clase
-- Módulo: Bases de datos
-- Grupo:  1º DAMB
--
-- Tenemos dos tablas: Cliente y Cafe
-- Tenemos dos clientes sin cafeFavorito asignado
-- y un cafe del que no tenemos ningún cliente.

----------------------------------------------------------------
---- Creacion de la base de datos y las tablas
----------------------------------------------------------------

/*Eliminamos la base de datos entera, por si existiera previamente*/
DROP DATABASE IF EXISTS Cafeteria;

/*Creamos la base de datos vacía*/
CREATE DATABASE  Cafeteria;

/*Activamos la base de datos*/
USE Cafeteria;

/*Creamos la tabla géneros*/
CREATE TABLE Cafes
(
	IdCafe int(11) NOT NULL,
	Nombre varchar(255) NOT NULL,
	PRIMARY KEY (IdCafe)
);

/*Y la tabla Cliente*/
CREATE TABLE Clientes
(
	Id int NOT NULL,
	Nombre varchar(255) NOT NULL,
	CafesPorDia int(11),
	CafeFavorito int(11),
	PRIMARY KEY (Id),
	FOREIGN KEY (CafeFavorito) REFERENCES Cafes(IdCafe)
);

/* Insertamos los datos en la tabla Cafe */
INSERT INTO Cafes (IdCafe, Nombre) VALUES (1,'Cappuccino');
INSERT INTO Cafes (IdCafe, Nombre) VALUES (2,'Espresso');
INSERT INTO Cafes (IdCafe, Nombre) VALUES (3,'Latte');

/* Insertamos los datos en la tabla Cliente */
INSERT INTO Clientes (Id,Nombre,CafesPorDia,CafeFavorito) VALUES (1,'Juan',3,1);
INSERT INTO Clientes (Id,Nombre,CafesPorDia,CafeFavorito) VALUES (2,'Marta',5,2);
INSERT INTO Clientes (Id,Nombre,CafesPorDia,CafeFavorito) VALUES (3,'Pedro',2,NULL);
INSERT INTO Clientes (Id,Nombre,CafesPorDia,CafeFavorito) VALUES (4,'Laura',6,1);
INSERT INTO Clientes (Id,Nombre,CafesPorDia,CafeFavorito) VALUES (5,'Ana',1,NULL);




----------------------------------------------------------------
---- CONSULTAS
----------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- Un SELECT * de cada tabla para ver sus campos y sus registros
---- tabla Clientes
SELECT 	*
FROM  	Clientes;
+----+--------+-------------+--------------+
| Id | Nombre | CafesPorDia | CafeFavorito |
+----+--------+-------------+--------------+
|  1 | Juan   |           3 |            1 |
|  2 | Marta  |           5 |            2 |
|  3 | Pedro  |           2 |         NULL |
|  4 | Laura  |           6 |            1 |
|  5 | Ana    |           1 |         NULL |
+----+--------+-------------+--------------+


---- tabla Cafes
SELECT 	*
FROM  	Cafes;
+--------+------------+
| IdCafe | Nombre     |
+--------+------------+
|      1 | Cappuccino |
|      2 | Espresso   |
|      3 | Latte      |
+--------+------------+


-- --------------------------------------------------------------------------------------
-- El producto de las tablas con JOIN
---- El producto cuando cafe es derecha
SELECT 	*
FROM 	Clientes JOIN Cafes;
+----+--------+-------------+--------------+--------+------------+
| Id | Nombre | CafesPorDia | CafeFavorito | IdCafe | Nombre     |
+----+--------+-------------+--------------+--------+------------+
|  1 | Juan   |           3 |            1 |      1 | Cappuccino |
|  1 | Juan   |           3 |            1 |      2 | Espresso   |
|  1 | Juan   |           3 |            1 |      3 | Latte      |
|  2 | Marta  |           5 |            2 |      1 | Cappuccino |
|  2 | Marta  |           5 |            2 |      2 | Espresso   |
|  2 | Marta  |           5 |            2 |      3 | Latte      |
|  3 | Pedro  |           2 |         NULL |      1 | Cappuccino |
|  3 | Pedro  |           2 |         NULL |      2 | Espresso   |
|  3 | Pedro  |           2 |         NULL |      3 | Latte      |
|  4 | Laura  |           6 |            1 |      1 | Cappuccino |
|  4 | Laura  |           6 |            1 |      2 | Espresso   |
|  4 | Laura  |           6 |            1 |      3 | Latte      |
|  5 | Ana    |           1 |         NULL |      1 | Cappuccino |
|  5 | Ana    |           1 |         NULL |      2 | Espresso   |
|  5 | Ana    |           1 |         NULL |      3 | Latte      |
+----+--------+-------------+--------------+--------+------------+


---- El producto cuando Clientes es derecha
SELECT 	*
FROM 	Cafes JOIN Clientes;
+--------+------------+----+--------+-------------+--------------+
| IdCafe | Nombre     | Id | Nombre | CafesPorDia | CafeFavorito |
+--------+------------+----+--------+-------------+--------------+
|      1 | Cappuccino |  1 | Juan   |           3 |            1 |
|      2 | Espresso   |  1 | Juan   |           3 |            1 |
|      3 | Latte      |  1 | Juan   |           3 |            1 |
|      1 | Cappuccino |  2 | Marta  |           5 |            2 |
|      2 | Espresso   |  2 | Marta  |           5 |            2 |
|      3 | Latte      |  2 | Marta  |           5 |            2 |
|      1 | Cappuccino |  3 | Pedro  |           2 |         NULL |
|      2 | Espresso   |  3 | Pedro  |           2 |         NULL |
|      3 | Latte      |  3 | Pedro  |           2 |         NULL |
|      1 | Cappuccino |  4 | Laura  |           6 |            1 |
|      2 | Espresso   |  4 | Laura  |           6 |            1 |
|      3 | Latte      |  4 | Laura  |           6 |            1 |
|      1 | Cappuccino |  5 | Ana    |           1 |         NULL |
|      2 | Espresso   |  5 | Ana    |           1 |         NULL |
|      3 | Latte      |  5 | Ana    |           1 |         NULL |
+--------+------------+----+--------+-------------+--------------+


-- --------------------------------------------------------------------------------------
-- Un JOIN de las dos tablas con elON correspondiente a su relación
---- Cuando Cafes es Derecha
SELECT 	*
FROM 	Clientes JOIN Cafes
ON 		Clientes.CafeFavorito = Cafes.IdCafe;
+----+--------+-------------+--------------+--------+------------+
| Id | Nombre | CafesPorDia | CafeFavorito | IdCafe | Nombre     |
+----+--------+-------------+--------------+--------+------------+
|  1 | Juan   |           3 |            1 |      1 | Cappuccino |
|  2 | Marta  |           5 |            2 |      2 | Espresso   |
|  4 | Laura  |           6 |            1 |      1 | Cappuccino |
+----+--------+-------------+--------------+--------+------------+


---- Cuando Clientes es Derecha
SELECT 	*
FROM 	Cafes JOIN Clientes
ON 		Clientes.CafeFavorito = Cafes.IdCafe;
+--------+------------+----+--------+-------------+--------------+
| IdCafe | Nombre     | Id | Nombre | CafesPorDia | CafeFavorito |
+--------+------------+----+--------+-------------+--------------+
|      1 | Cappuccino |  1 | Juan   |           3 |            1 |
|      2 | Espresso   |  2 | Marta  |           5 |            2 |
|      1 | Cappuccino |  4 | Laura  |           6 |            1 |
+--------+------------+----+--------+-------------+--------------+


-- --------------------------------------------------------------------------------------
-- Un JOIN de las dos tablas en el que aprezcan todos los registros de la tabla derecha
---- Cuando Clientes es Derecha
SELECT 	Cafes.* , Clientes.*
FROM 	Clientes LEFT JOIN Cafes
ON 		Clientes.CafeFavorito = Cafes.IdCafe;
+--------+------------+----+--------+-------------+--------------+
| IdCafe | Nombre     | Id | Nombre | CafesPorDia | CafeFavorito |
+--------+------------+----+--------+-------------+--------------+
|      1 | Cappuccino |  1 | Juan   |           3 |            1 |
|      2 | Espresso   |  2 | Marta  |           5 |            2 |
|   NULL | NULL       |  3 | Pedro  |           2 |         NULL |
|      1 | Cappuccino |  4 | Laura  |           6 |            1 |
|   NULL | NULL       |  5 | Ana    |           1 |         NULL |
+--------+------------+----+--------+-------------+--------------+


---- Cuando Cafes es Derecha
SELECT 	Clientes.* , Cafes.*
FROM 	Cafes LEFT JOIN Clientes
ON 		Clientes.CafeFavorito = Cafes.IdCafe;
+------+--------+-------------+--------------+--------+------------+
| Id   | Nombre | CafesPorDia | CafeFavorito | IdCafe | Nombre     |
+------+--------+-------------+--------------+--------+------------+
|    1 | Juan   |           3 |            1 |      1 | Cappuccino |
|    2 | Marta  |           5 |            2 |      2 | Espresso   |
|    4 | Laura  |           6 |            1 |      1 | Cappuccino |
| NULL | NULL   |        NULL |         NULL |      3 | Latte      |
+------+--------+-------------+--------------+--------+------------+


-- --------------------------------------------------------------------------------------
-- Un JOIN de las dos tablas en el que aprezcan todos los registros de la tabla izquierda
---- Cuando Clientes es Derecha
SELECT 	*
FROM 	Cafes LEFT JOIN Clientes
ON 		Clientes.CafeFavorito = Cafes.IdCafe;
+--------+------------+------+--------+-------------+--------------+
| IdCafe | Nombre     | Id   | Nombre | CafesPorDia | CafeFavorito |
+--------+------------+------+--------+-------------+--------------+
|      1 | Cappuccino |    1 | Juan   |           3 |            1 |
|      2 | Espresso   |    2 | Marta  |           5 |            2 |
|      1 | Cappuccino |    4 | Laura  |           6 |            1 |
|      3 | Latte      | NULL | NULL   |        NULL |         NULL |
+--------+------------+------+--------+-------------+--------------+


---- Cuando Cafes es Derecha
SELECT 	*
FROM 	Clientes LEFT JOIN Cafes
ON 		Clientes.CafeFavorito = Cafes.IdCafe;
+----+--------+-------------+--------------+--------+------------+
| Id | Nombre | CafesPorDia | CafeFavorito | IdCafe | Nombre     |
+----+--------+-------------+--------------+--------+------------+
|  1 | Juan   |           3 |            1 |      1 | Cappuccino |
|  2 | Marta  |           5 |            2 |      2 | Espresso   |
|  3 | Pedro  |           2 |         NULL |   NULL | NULL       |
|  4 | Laura  |           6 |            1 |      1 | Cappuccino |
|  5 | Ana    |           1 |         NULL |   NULL | NULL       |
+----+--------+-------------+--------------+--------+------------+


-- --------------------------------------------------------------------------------------
-- Un JOIN de las dos tablas en el que aprezcan todos los registros de la tabla derecha y de la tabla izquierda(FULL JOIN)
---- Cuando Clientes es Derecha
SELECT 	*
FROM 	Cafes LEFT JOIN Clientes
ON 		Clientes.CafeFavorito = Cafes.IdCafe
UNION 	ALL
SELECT 	Cafes.* , Clientes.*
FROM 	Clientes LEFT JOIN Cafes
ON 		Clientes.CafeFavorito = Cafes.IdCafe
WHERE 	Cafes.IdCafe IS NOT NULL;
+--------+------------+------+--------+-------------+--------------+
| IdCafe | Nombre     | Id   | Nombre | CafesPorDia | CafeFavorito |
+--------+------------+------+--------+-------------+--------------+
|      1 | Cappuccino |    1 | Juan   |           3 |            1 |
|      2 | Espresso   |    2 | Marta  |           5 |            2 |
|      1 | Cappuccino |    4 | Laura  |           6 |            1 |
|      3 | Latte      | NULL | NULL   |        NULL |         NULL |
|      1 | Cappuccino |    1 | Juan   |           3 |            1 |
|      2 | Espresso   |    2 | Marta  |           5 |            2 |
|      1 | Cappuccino |    4 | Laura  |           6 |            1 |
+--------+------------+------+--------+-------------+--------------+


---- Cuando Cafes es Derecha
SELECT 	*
FROM 	Clientes LEFT JOIN Cafes
ON 		Clientes.CafeFavorito = Cafes.IdCafe
UNION 	ALL
SELECT 	Clientes.* , Cafes.*
FROM 	Cafes LEFT JOIN Clientes
ON 		Clientes.CafeFavorito = Cafes.IdCafe
WHERE 	Clientes.Id IS NOT NULL;
+------+--------+-------------+--------------+--------+------------+
| Id   | Nombre | CafesPorDia | CafeFavorito | IdCafe | Nombre     |
+------+--------+-------------+--------------+--------+------------+
|    1 | Juan   |           3 |            1 |      1 | Cappuccino |
|    2 | Marta  |           5 |            2 |      2 | Espresso   |
|    3 | Pedro  |           2 |         NULL |   NULL | NULL       |
|    4 | Laura  |           6 |            1 |      1 | Cappuccino |
|    5 | Ana    |           1 |         NULL |   NULL | NULL       |
|    1 | Juan   |           3 |            1 |      1 | Cappuccino |
|    2 | Marta  |           5 |            2 |      2 | Espresso   |
|    4 | Laura  |           6 |            1 |      1 | Cappuccino |
+------+--------+-------------+--------------+--------+------------+
