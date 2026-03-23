-- La base de datos:
DROP DATABASE IF EXISTS Funcional;
CREATE DATABASE IF NOT EXISTS Funcional;
USE Funcional;

DROP TABLE IF EXISTS FondoComun;
CREATE TABLE FondoComun (
    Nombre VARCHAR(50),
    Cantidad INT
);

TRUNCATE TABLE FondoComun;
INSERT INTO FondoComun VALUES
    ("Juan", 10),
    ("Ana", 15),
    ("Raquel", 35),
    ("Raquel", -15),
    ("Ana", -10),
    ("Raquel", -12),
    ("Juan", -17),
    ("Ana", 16),
    ("Juan", -5),
    ("Raquel", 20);

SELECT SUM(Cantidad) AS 'Saldo total'
FROM   FondoComun;

SELECT COUNT(*) AS 'Numero de operaciones'
FROM   FondoComun;

SELECT MAX(Cantidad) AS 'Operación con mayor cantidad'
FROM   FondoComun;

SELECT MIN(Cantidad) AS 'Operación con menor cantidad'
FROM   FondoComun;

SELECT AVG(Cantidad) AS 'Cantidad promedio'
FROM   FondoComun;

SELECT EXISTS(SELECT 1
              FROM   FondoComun
              WHERE  Cantidad < 0) AS '¿Alguna operación con cantidad negativa?';

SELECT NOT EXISTS (SELECT 1
                   FROM   FondoComun
                   WHERE  Cantidad <= 0) AS '¿Todas las operaciones son positivas?';

SELECT *
FROM   FondoComun
ORDER BY Nombre;

SELECT Nombre AS 'Nombre', SUM(Cantidad) AS 'Saldo'
FROM   FondoComun
GROUP BY Nombre;

SELECT Nombre AS 'Nombre', COUNT(*) AS 'Cantidad'
FROM   FondoComun
GROUP BY Nombre;

SELECT Nombre AS 'Nombre', MAX(Cantidad) AS 'Cantidad'
FROM   FondoComun
GROUP BY Nombre;


