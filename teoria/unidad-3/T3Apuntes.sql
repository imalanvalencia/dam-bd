-- ----------------------------------------------------------------------------------------
-- Ejercicio: indica qu� consultas son correlacionadas, no correlacionadas o err�neas
-- ----------------------------------------------------------------------------------------
SELECT Nombre -- Correlacionada
FROM Pais
WHERE EXISTS(
        SELECT *
        FROM LenguaPais
        WHERE CodigoPais = Codigo
    );
-- Poner nombre de tablas Pais.Codigo
SELECT Nombre -- No Correlacionada (Independiente)
FROM Pais
WHERE EXISTS(
        SELECT *
        FROM LenguaPais
        WHERE CodigoPais = 'AFG'
    );
SELECT Nombre -- Erronea
FROM Pais
WHERE EXISTS(
        SELECT *
        FROM LenguaPais
        WHERE CodigoPais = Ciudad.Id
    );
SELECT Lengua -- Correlacionada
FROM LenguaPais
    JOIN Pais ON LenguaPais.CodigoPais = Pais.Codigo
WHERE (
        SELECT COUNT(*)
        FROM Ciudad
        WHERE Ciudad.CodigoPais = Pais.Codigo
    ) > 100
    AND EsOficial = 'T';
SELECT Lengua -- No Correlacionada
FROM LenguaPais
    JOIN Pais ON LenguaPais.CodigoPais = Pais.Codigo
WHERE (
        SELECT COUNT(*)
        FROM Ciudad
        WHERE Ciudad.CodigoPais > 'JJJ'
    ) > 100
    AND EsOficial = 'T';
SELECT Nombre AS 'Pais' -- Erronea
FROM Pais
WHERE (
        SELECT SUM(Ciudad.Poblacion)
        FROM Ciudad
        WHERE Poblacion = LenguaPais.Porcentaje
    ) > Pais.Poblacion;
-- -----------------------------------------------------------------------------
-- Ejecuci�n de una consulta correlacionada
-- -----------------------------------------------------------------------------
SELECT Nombre AS Pais -- 189 Registros
FROM Pais
WHERE AnyIndep / 4 > (
        SELECT COUNT(*)
        FROM Ciudad
        WHERE Ciudad.CodigoPais = Pais.Codigo
    );
-- 1. Nombre de los pa�ses en los que se hablan exactamente dos lenguas
SELECT Nombre
FROM Pais
WHERE (
        SELECT COUNT(*)
        FROM LenguaPais
        WHERE LenguaPais.CodigoPais = Pais.Codigo
    ) = 2;
-- 2. Nombre de los pa�ses que tienen dos o m�s ciudades con dos millones de habitantes como m�nimo
SELECT Nombre
FROM Pais
WHERE (
        SELECT COUNT(*)
        FROM Ciudad
        WHERE Ciudad.CodigoPais = Pais.Codigo
            AND Ciudad.Poblacion >= 2000000
    ) >= 2;
-- 3. Para detectar posibles errores en nuestra base de datos vamos a ver si existe alguna ciudad que sea ciudad de m�s de un pa�s a la vez
-- No se puede hacer
-- 4. Para detectar posibles errores en nuestra base de datos vamos a ver si existe alguna ciudad que sea capital de m�s de un pa�s a la vez
INSERT INTO Pais
VALUES (
        'XXX',
        'Spain2',
        'Europe',
        'SE',
        5,
        1492,
        3,
        7,
        5,
        5,
        'Espa�ist�n',
        'XX',
        'XX',
        653,
        'ES'
    );
/* Podemos crear un pa�s ficticio */
SELECT COUNT(*)
FROM Ciudad
WHERE (
        SELECT COUNT(*)
        FROM Pais
        WHERE Pais.Capital = Ciudad.Id
    ) > 1;
DELETE FROM Pais
WHERE Codigo = 'XXX';
/* Eliminamos el pa�s ficticio */
-- 5. Para detectar posibles errores en nuestra base de datos vamos a ver si existe alg�n pa�s para el que la suma de las poblaciones de sus ciudades es mayor que la poblaci�n del pa�s
SELECT Nombre
FROM Pais
WHERE (
        SELECT SUM(Ciudad.Poblacion)
        FROM Ciudad
        WHERE Ciudad.CodigoPais = Pais.Codigo
    ) > Pais.Poblacion;
-- 6. Nombre de los pa�ses con m�s de tres lenguas oficiales
SELECT Nombre
FROM Pais
WHERE (
        SELECT COUNT(*)
        FROM LenguaPais
        WHERE LenguaPais.CodigoPais = Pais.Codigo
            AND EsOficial = "T"
    ) > 3;
-- 7. Nombre y lenguas oficiales de los pa�ses con m�s de tres lenguas oficiales
SELECT Nombre,
    Lengua
FROM LenguaPais
    JOIN Pais ON LenguaPais.CodigoPais = Pais.Codigo
WHERE EsOficial = "T"
    AND (
        SELECT COUNT(*)
        FROM LenguaPais
        WHERE LenguaPais.CodigoPais = Pais.Codigo
            AND EsOficial = "T"
    ) > 3;
-- 8. Nombre de los pa�ses y de su ciudad para los pa�ses que tienen s�lo una ciudad
SELECT Pais.Nombre,
    Ciudad.Nombre
FROM Ciudad
    JOIN Pais ON Ciudad.CodigoPais = Pais.Codigo
WHERE (
        SELECT COUNT(*)
        FROM Ciudad
        WHERE Ciudad.CodigoPais = Pais.Codigo
    ) = 1;
-- 9. Pa�ses en los que se hablan m�s de dos lenguas, pero que no tienen ninguna lengua oficial
SELECT Nombre
FROM Pais
WHERE (
        SELECT COUNT(*)
        FROM LenguaPais
        WHERE LenguaPais.CodigoPais = Pais.Codigo
    ) > 2
    AND (
        SELECT COUNT(*)
        FROM LenguaPais
        WHERE LenguaPais.CodigoPais = Pais.Codigo
            AND EsOficial = "T"
    ) = 0;
-- 10. Lenguas que se hablan en m�s de 20 pa�ses
SELECT DISTINCT LP.Lengua
FROM LenguaPais LP
WHERE (
        SELECT COUNT(*)
        FROM LenguaPais
        WHERE LenguaPais.Lengua = LP.Lengua
    ) > 20;
-- 11. Pa�ses del continente europeo que tienen exactamente dos lenguas oficiales
SELECT Nombre
FROM Pais
WHERE Continente = "Europe"
    AND (
        SELECT COUNT(*)
        FROM LenguaPais
        WHERE LenguaPais.CodigoPais = Pais.Codigo
            AND EsOficial = "T"
    ) = 2;
-- 12. Continentes que tienen una poblaci�n mayor que 500 millones de habitantes
-- 13. Lenguas habladas por m�s de cien millones hablantes como lengua materna
-- --------------------------------------------------------------------------------------
-- Subconsultas correlacionadas de EXISTS y NOT EXISTS
-- --------------------------------------------------------------------------------------
/*
 Reescribimos la consulta 2: 
 Nombre de los pa�ses que tienen dos o m�s ciudades con dos millones de habitantes como m�nimo.
 De la siguiente manera:
 Nombre de los pa�ses que tienen al menos una ciudad con dos millones de habitantes como m�nimo.
 */
SELECT Nombre AS 'Pa�s'
FROM Pais
WHERE (
        SELECT COUNT(*)
        FROM Ciudad
        WHERE Ciudad.CodigoPais = Pais.Codigo
            AND Poblacion >= 2000000
    ) >= 1;
SELECT Nombre AS 'Pa�s'
FROM Pais
WHERE EXISTS (
        SELECT *
        FROM Ciudad
        WHERE Ciudad.CodigoPais = Pais.Codigo
            AND Poblacion >= 2000000
    );
-- 14. Listado de continentes que tienen alguna ciudad
SELECT  DISTINCT Continente
FROM    Pais PaisExterno
WHERE   EXISTS (
            SELECT  1
            FROM    Ciudad JOIN Pais 
            ON      Ciudad.CodigoPais = Pais.Codigo
            WHERE   Continente = PaisExterno.Continente
        );

-- 15. Listado de continentes que no tienen ninguna ciudad
SELECT  DISTINCT Continente
FROM    Pais PaisExterno
WHERE   NOT EXISTS (
            SELECT  1
            FROM    Ciudad JOIN Pais 
            ON      Ciudad.CodigoPais = Pais.Codigo
            WHERE   Continente = PaisExterno.Continente
        );


-- 16. Listado de zonas con alguna ciudad de m�s de 5 millones habitantes. Poner las dos soluciones: COUNT(*) y EXISTS
SELECT  DISTINCT Continente
FROM    Ciudad CExt
WHERE   Poblacion (
            SELECT  1
            FROM    Ciudad 
            WHERE   Poblacion 
        );


SELECT  DISTINCT Zona
FROM    Pais PaisExterno
WHERE   EXISTS (
            SELECT  1
            FROM    Ciudad JOIN Pais 
            ON      Ciudad.CodigoPais = Pais.Codigo
            WHERE   Continente = PaisExterno.Continente
        );

SELECT Nombre FROM Pais; 
        
-- 16. Listado de zonas con alguna ciudad de más de 5 millones habitantes. Poner las dos soluciones: COUNT(*) y EXISTS

/*En MySQL es muy ineficiente el uso de COUNT(*) para saber si una subconsulta devuelve algún registro o no devuelve ninguno

Siempre usaremos EXISTS en vez de COUNT(*)>0 o COUNT(*)>=1
Siempre usaremos NOT EXISTS en vez de COUNT(*)=0
*/

-- Cuidado, porque el COUNT(*) y el 0 pueden estar lejos:
-- Consulta 9
SELECT Pais.Nombre AS 'País'
FROM   Pais
WHERE (SELECT COUNT(*)                                 -- Tiene 0 lenguas oficiales
       FROM   LenguaPais
       WHERE  LenguaPais.CodigoPais = Pais.Codigo
              AND EsOficial= 'T') = 0
       AND                                             -- Y
      (SELECT COUNT(*)                                 -- Se hablan más de dos lenguas
       FROM   LenguaPais
       WHERE  LenguaPais.CodigoPais = Pais.Codigo)> 2;

-- 17. Listado de continentes en los que no se habla ninguna lengua

-- 18. En la consulta 66 del tema anterior vimos la siguiente consulta. Reescribe la prueba para que sea correcta
-- Consulta del Tema 2. Países con un año de independencia igual al de alguno de los países con una superficie mayor que 500000 kilómetros cuadrados
SELECT Pais.Nombre AS 'País'
FROM   Pais  
WHERE  AnyIndep IN (    
    SELECT AnyIndep
    FROM   Pais
    WHERE  Superficie > 500000);
-- 115 Registros
-- Si en la subconsulta hay algún nulo no afecta al resultado.
-- Si la subconsulta devuelve un conjunto vacío de registros no sale ningún país.
SELECT COUNT(*)>0
FROM   Pais
WHERE  Superficie > 500000;
-- Debe dar verdadero para que la consulta principal tenga sentido

-- 19. Listado de nombres de países que son también nombres de ciudad
-- Operación intersección
-- El enunciado de esta consulta se podría reescribir como:
-- Nombre de los países para los que existe alguna ciudad con el mismo nombre

-- 20. Listado de países que son también una lengua

-- 21. Listado de países que no son nombres de lenguas
-- Operación diferencia

-- 22. Listado de países y lenguas a excepción de los países que son también lenguas
-- Operación Diferencia simétrica

-- 23. Empleados que trabajan en todos los departamentos [Base de datos de Empresa]
-- Empresa
-- Base de datos creada para probar una consulta del tipo "Empleados que trabajan en todos los departamentos"
-- Curso: 2017-18
-- Módulo: Bases de datos
--
-- Tenemos tres tablas: Empleados, Departamentos y Trabaja

/*Creamos la base de datos vacía*/
DROP DATABASE IF EXISTS Empresa;
CREATE DATABASE  Empresa;
USE Empresa;

/*Empleados*/
CREATE TABLE Empleados
(
IdEmpleado INT NOT NULL,
Nombre VARCHAR(255) NOT NULL,
PRIMARY KEY (IdEmpleado)
);

/*Departamentos*/
CREATE TABLE Departamentos
(
IdDepartamento INT NOT NULL,
Nombre VARCHAR(255) NOT NULL,
PRIMARY KEY (IdDepartamento)
);

/*Trabaja*/
CREATE TABLE Trabaja
(
IdEmpleado int NOT NULL,
IdDepartamento INT NOT NULL,
PRIMARY KEY (IdEmpleado, IdDepartamento),
FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado),
FOREIGN KEY (IdDepartamento) REFERENCES Departamentos(IdDepartamento)
);

/* Insertamos los datos en la tabla Empleados */
INSERT INTO Empleados (IdEmpleado, Nombre) VALUES (1,'Pedro');
INSERT INTO Empleados (IdEmpleado, Nombre) VALUES (2,'Luis');
INSERT INTO Empleados (IdEmpleado, Nombre) VALUES (3,'Ana');
INSERT INTO Empleados (IdEmpleado, Nombre) VALUES (4,'Marta');

/* Insertamos los datos en la tabla Departamentos */
INSERT INTO Departamentos (IdDepartamento, Nombre) VALUES (1,'Contabilidad');
INSERT INTO Departamentos (IdDepartamento, Nombre) VALUES (2,'Producción');
INSERT INTO Departamentos (IdDepartamento, Nombre) VALUES (3,'I+D');

/* Insertamos los datos en la tabla Trabaja */
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (1,1);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (1,2);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (1,3);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (3,1);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (3,2);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (3,3);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (2,1);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (2,2);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (4,2);
INSERT INTO Trabaja (IdEmpleado, IdDepartamento) VALUES (4,3);

-- Consulta: Empleados que trabajan en todos los Departamentos
-- Enunciado alternativo: Empleados para los que no existe un departamento para el que no trabajen

-- 24. Departamentos en los que trabajan todos los empleados
-- Enunciado alternativo: Departamentos para los que no existe un Empleado donde no trabaje

-- -----------------------------------------------------------------------------
-- Subconsultas en el FROM
-- -----------------------------------------------------------------------------
/*
Se puede usar el resultado de cualquier subconsulta como una tabla más en el FROM siempre que le asignemos un nombre de tabla con el AS
*/

-- 25. Zonas de países, en los que la zona tiene más de quince millones de habitantes
-- Consulta 18. Zonas de países, en los que la zona tiene más de quince millones de habitantes
SELECT DISTINCT Zona, CodigoPais
FROM   Ciudad AS CiudadExterna
WHERE (SELECT SUM(Poblacion)
       FROM   Ciudad
       WHERE  Ciudad.Zona=CiudadExterna.Zona AND
              Ciudad.CodigoPais=CiudadExterna.CodigoPais)
       > 15000000;

SELECT Zona
FROM   (
    SELECT DISTINCT Zona, CodigoPais
    FROM   Ciudad AS CiudadExterna
    WHERE (SELECT SUM(Poblacion)
           FROM   Ciudad
           WHERE  Ciudad.Zona=CiudadExterna.Zona AND
                  Ciudad.CodigoPais=CiudadExterna.CodigoPais)
           > 15000000) AS Tabla;
           
-- ----------------------------------------------------------------------------
-- GROUP BY
-- ----------------------------------------------------------------------------
SELECT CodigoPais FROM Ciudad;
SELECT COUNT(*) FROM Ciudad;
SELECT CodigoPais, COUNT(*) FROM Ciudad;

SELECT CodigoPais, Id, Zona FROM Ciudad;

SELECT 		CodigoPais, Id, Zona 
FROM 			Ciudad 
GROUP BY 	CodigoPais;

SELECT 		CodigoPais,  COUNT(*), Id,  Zona 
FROM 			Ciudad 
GROUP BY 	CodigoPais;

SELECT 		CodigoPais,  COUNT(*) -- No tiene sentido y no sirve poner id y zona solo tiene sentido el mismo valor de agrupacion y funciones agregadas
FROM 			Ciudad 
GROUP BY 	CodigoPais;

SELECT 		CodigoPais,  COUNT(*), SUM(Poblacion)
FROM 			Ciudad 
GROUP BY 	CodigoPais;

SELECT 		CodigoPais,  COUNT(*)
FROM 			Ciudad 
WHERE 			Poblacion > 3000000
GROUP BY 	CodigoPais;

SELECT 		CodigoPais,  COUNT(*)
FROM 			Ciudad 
WHERE		 	COUNT(*) > 50 /* VA A FALLAR */
GROUP BY 	CodigoPais;

SELECT 		CodigoPais,  COUNT(*)
FROM 			Ciudad 
GROUP BY 	CodigoPais
HAVING 			COUNT(*) > 50 ;

SELECT 		CodigoPais,  COUNT(*)
FROM 			Ciudad 
WHERE 			Poblacion > 3000000
GROUP BY 	CodigoPais
HAVING 			COUNT(*) > 3 ;

-- EL codigo y el numero de ciudades con una poblacion mayor a 3 millones de habitantes para paises que tienen mas de 3 ciudades con 3 millones de habitantes
SELECT 		CodigoPais,  COUNT(*)
FROM 			Ciudad 
WHERE 			Poblacion > 3000000
GROUP BY 	CodigoPais
HAVING 			COUNT(*) > 3;


-- vamos a explicar la consulta anterior
SELECT	CodigoPais, Poblacion
FROM  		Ciudad;


SELECT	CodigoPais, Poblacion
FROM  		Ciudad
WHERE 		Poblacion > 3000000;

SELECT		CodigoPais, Poblacion, COUNT(*)
FROM  			Ciudad
WHERE 			Poblacion > 3000000
GROUP BY	CodigoPais;

SELECT		CodigoPais, Poblacion, COUNT(*)
FROM  			Ciudad
WHERE 			Poblacion > 3000000
GROUP BY	CodigoPais
HAVING			COUNT(*) > 3;

-- Rellena los AS para que tengan sentido
SELECT 	MAX(AnyIndep)          AS 'Ultimo pais europeo en independizarse',
					MIN(EsperanzaVida)     AS 'Menor esperanza de vida de un pais europeo'
FROM   		Pais
WHERE  	Continente='Europe';

SELECT 	COUNT(AnyIndep)        AS 'Numero de paises que se han independizado en Europa',
					COUNT(*)               AS 'Numero de paises europeos',
					COUNT(DISTINCT Region) AS 'Numero de regiones en europa'
FROM   		Pais
WHERE  	Continente='Europe';

SELECT 	AVG(Poblacion)         AS 'Promedio de la poblacion de paises europeos',
					SUM(Superficie)        AS 'Superficie de europa'
FROM   		Pais
WHERE 		Continente='Europe';

SELECT 	GROUP_CONCAT(Codigo2) /* Concatena strings y los separa con comas*/  AS 'Lista del codigo de 2 letras de paises europeos' 
FROM   		Pais
WHERE  	Continente='Europe';


-- Revisamos las funciones agregadas con valores NULL. Mira la siguiente consulta y su resultado. Fíjate que hay un valor NULL. Mediante el uso de una consulta, explica cómo afectan los valores nulos a las funciones agregadas

SELECT 	Nombre, PNBAnt FROM Pais WHERE Nombre LIKE 'Ir%';

SELECT 	MAX(PNBAnt), MIN(PNBAnt), COUNT(PNBAnt), COUNT(*)
FROM 		Pais
WHERE 		Nombre LIKE 'Ir%';

SELECT 	AVG(PNBAnt), SUM(PNBAnt), GROUP_CONCAT(PNBAnt)
FROM 		Pais
WHERE 		Nombre LIKE 'Ir%';

SELECT 	COUNT(DISTINCT PNBAnt)
FROM 		Pais
WHERE 		Nombre LIKE 'Ir%';


-- Revisamos cómo actúa el operador + y la función SUM con nulos
SELECT 	PNBANT FROM Pais WHERE Nombre = 'Austria';
SELECT 	PNBANT FROM Pais WHERE Nombre = 'Monaco';

SELECT (
				SELECT 	PNBANT 
				FROM 		Pais 
				WHERE 		Nombre = 'Austria'
				)       +
				(
                SELECT 	PNBANT 
                FROM 		Pais 
                WHERE 		Nombre =  'Monaco'
                ) AS Resultado;

SELECT 	SUM(PNBANT) 
FROM 		Pais 
WHERE 		Nombre = 'Austria' or Nombre = 'Monaco';

-- 26. De las lenguas que son habladas por más de un 20% de la población, queremos saber el nombre de la lengua y el número de países en los que se habla
SELECT		Lengua, COUNT(*) AS "Numero de paises donde se habla"
FROM				LenguaPais
WHERE			Porcentaje > 20
GROUP BY	Lengua;

-- 27. Código del país y número de lenguas habladas por más de un 20% de la población para los países con lenguas habladas por más de un 20% de la población
SELECT		CodigoPais, COUNT(*) AS "Numero de lenguas que se hablan"
FROM				LenguaPais
WHERE			Porcentaje > 20
GROUP BY	CodigoPais;

-- 28. Nombre del país y número de lenguas habladas por más de un 20% de la población para los países con lenguas habladas por más de un 20% de la población
SELECT		Nombre AS "Paises", COUNT(*) AS "Numero de lenguas que se hablan"
FROM				LenguaPais JOIN Pais
ON					LenguaPais.CodigoPais = Pais.Codigo
WHERE			Porcentaje > 20
GROUP BY	CodigoPais;

-- 29. Nombre del país y número de lenguas habladas por más de un 20% de la población para los países con lenguas habladas por más de un 20% de la población del continente Europeo
SELECT		Nombre AS "Paises", COUNT(*) AS "Numero de lenguas que se hablan"
FROM				LenguaPais JOIN Pais
ON					LenguaPais.CodigoPais = Pais.Codigo
WHERE			Porcentaje > 20
						AND Continente = "Europe"
GROUP BY	CodigoPais;

-- Sólo debemos poner en el SELECT el campo por el que agrupamos y funciones agregadas, con algunas excepciones:

SELECT Nombre, Codigo, Lengua, Porcentaje
FROM   Pais JOIN LenguaPais
ON     Pais.Codigo = LenguaPais.CodigoPais
WHERE  CodigoPais IN ('ESP', 'FRA');
/*
+--------+--------+------------+------------+
| Nombre | Codigo | Lengua     | Porcentaje |
+--------+--------+------------+------------+
| Spain  | ESP    | Basque     |        1.6 |
| Spain  | ESP    | Catalan    |       16.9 |
| Spain  | ESP    | Galecian   |        6.4 |
| Spain  | ESP    | Spanish    |       74.4 |
| France | FRA    | Arabic     |        2.5 |
| France | FRA    | French     |       93.6 |
| France | FRA    | Italian    |        0.4 |
| France | FRA    | Portuguese |        1.2 |
| France | FRA    | Spanish    |        0.4 |
| France | FRA    | Turkish    |        0.4 |
+--------+--------+------------+------------+*/

-- Para poder usar la tabla anterior, vamos a crear una vista
CREATE VIEW TablaAuxiliar AS
    SELECT Nombre, Codigo, Lengua, Porcentaje
    FROM   Pais JOIN LenguaPais
    ON     Pais.Codigo = LenguaPais.CodigoPais
    WHERE  CodigoPais IN ('ESP', 'FRA');

-- Partiendo de la siguiente tabla:
-- podemos agrupar por Lengua y contar los registros
SELECT   Lengua, COUNT(*)
FROM     TablaAuxiliar
GROUP BY Lengua;

-- pero no tiene sentido mostrar el pais porque no sabemos qué pais saldrá en los grupos que tienen más de un miembro
SELECT Lengua, COUNT(*), Nombre
FROM   TablaAuxiliar
GROUP BY Lengua;

-- por lo que sólo se puede mostrar en el SELECT el campo por el que agrupamos y funciones agregadas

-- La excepción es cuando agrupamos por el código del país y mostramos su nombre
SELECT Nombre, COUNT(*)
FROM   TablaAuxiliar
GROUP BY Codigo;

-- En este caso, en el SELECT mostramos el nombre del país porque es lo que conocemos, pero agrupamos por del código del país por dos razones:
-- 1. No puede haber dos países diferentes con el mismo código y sí que podría haberlos con el mismo nombre (ocurre con las ciudades)
-- 2. Es mucho más eficiente, ya que el código sólo tiene tres caracteres

DROP VIEW TablaAuxiliar;

-- 30. De cada continente indica: número de países que lo componen, superficie del país más extenso y del país más pequeño, media de población de sus países y el PNB del continente. Redondea los resultados

SELECT 		Continente,
						COUNT(*) AS  "Numero de paises",
						ROUND(MAX(Superficie)) AS "Pais con mayor superficie", 
                        ROUND(MIN(Superficie)) AS "Pais con menor superficie", 
                        ROUND(AVG(Poblacion)) AS "Poblacion media", 
                        ROUND(SUM(PNB))  AS "PNB total"
FROM 			Pais
GROUP BY 	Continente;
