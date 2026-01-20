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

-- 31. De cada año de independencia en el que se ha independizado algún país indicar cuántos países se independizaron ese año ordenados desde el año en que se han independizado más países al que menos

-- -----------------------------------------------------------------------------
-- Agrupando por varios campos
-- -----------------------------------------------------------------------------

-- 32. De cada continente y cada región queremos saber el número de países que lo componen y el número de países que no tienen datos de su esperanza de vida

-- 33. De cada continente y cada región queremos saber el número de ciudades ordenado de las regiones con más ciudades a las que tienen menos

-- -----------------------------------------------------------------------------
-- Agrupando por expresiones
-- -----------------------------------------------------------------------------

-- 34. Número de países que se han independizado cada siglo. Ordena la consulta de manera que obtengamos la mejor información
/*
floor()--> hacia abajo
ceiling()--> hacia arriba
truncate(,) --> negativos hacia arriba - positivos hacia abajo
round()(,) --> redondea
*/

SELECT Nombre, AnyIndep, FLOOR(( AnyIndep -  1)  / 100 ) + 1 AS "Siglo de independencia"
FROM Pais;

SELECT 		FLOOR(( AnyIndep -  1)  / 100 ) + 1 AS "Siglo de independencia", 
					COUNT(*) AS "Numero de paise que se independizaron"
FROM 			Pais
WHERE 		AnyIndep IS NOT NULL
GROUP BY 	`Siglo de independencia`
ORDER BY 	`Siglo de independencia`;


SELECT ROUND(FLOOR((AnyIndep - 1) / 100 + 1)+
            ((SIGN(AnyIndep) - 1) / 2)) AS 'Siglo de independencia',
       COUNT(*) AS 'Número de países'
FROM   Pais
WHERE  AnyIndep IS NOT NULL
GROUP BY `Siglo de independencia`
ORDER BY `Siglo de independencia`;

-- Igual, pero usando IF en vez de SIGN
SELECT IF(FLOOR((AnyIndep-1)/100+1) > 0, FLOOR((AnyIndep-1)/100+1), FLOOR((AnyIndep-1)/100))
             AS 'Siglo de independencia',
       COUNT(*) AS 'Número de países'
FROM   Pais
WHERE  AnyIndep IS NOT NULL
GROUP BY `Siglo de independencia`
ORDER BY `Siglo de independencia`; 

-- 35. Número de ciudades que comienzan por cada letra del alfabeto (es posible que no salga alguna letra). Ordena la consulta de manera que obtengamos la mejor información
SELECT 		LEFT(Nombre, 1) AS "Letra inicial", 
					COUNT(*) AS "Número de ciudades que comienzan por esta letra"
FROM 			Ciudad
GROUP BY 	`Letra inicial`
ORDER BY 	`Número de ciudades que comienzan por esta letra` DESC;

-- 36. Número de ciudades cuya población está en cada tramo de medio millón de habitantes (primer tramo, de 0 a medio millón, segundo tramo de medio a un millón, etc). Añadir las columnas desde y hasta de cada tramo
/* Este el el resultado esperado:
+----------+----------+--------------------+
| Desde    | Hasta    | Número de ciudades |
+----------+----------+--------------------+
|        0 |   500000 |               3539 |
|   500000 |  1000000 |                302 |
|  1000000 |  1500000 |                108 |
|  1500000 |  2000000 |                 38 | */
SELECT 	
				FLOOR(Poblacion / 500000) * 500000 AS "Desde",
                FLOOR(Poblacion / 500000) * 500000  + 500000 AS "Hasta",
                Nombre, Poblacion,
				FLOOR(Poblacion / 500000) AS "Tramo"
FROM Ciudad
GROUP BY `Desde` 
ORDER BY `Desde`;

SELECT 	
				FLOOR(Poblacion / 500000) * 500000 AS "Desde",
                FLOOR(Poblacion / 500000) * 500000  + 500000 AS "Hasta",
                COUNT(*) AS "Numero de ciudades"
FROM Ciudad
GROUP BY `Desde`
ORDER BY `Desde`;

-- 37 Número de países en cada tramo de incremento o decremento del PNB (PNB-PNBAnt) en decenas de miles de millones de dólares (el PNB se mide en millones de dólares)
SELECT 
				FLOOR((PNB - PNBAnt) / 10000) * 10000 AS "Desde",
                FLOOR((PNB - PNBAnt) / 10000) * 10000  + 10000 AS "Hasta",
                COUNT(*) AS "Numero de paises"
FROM Pais
WHERE PNB - PNBAnt IS NOT NULL
GROUP BY `Desde`
ORDER BY `Desde`;

-- 38. De cada continente y cada región queremos saber el número de países, el PNB más alto y la media de población con totales
SELECT 
				Continente, Region,
                COUNT(*) AS "Numero de paises",
                ROUND(MAX(PNB)) AS "PNB mas alto",
                ROUND(AVG(Poblacion), 2) AS "Media de poblacion"
FROM Pais
WHERE PNB - PNBAnt IS NOT NULL
GROUP BY Continente, Region WITH ROLLUP;

-- 39. De cada pais del la región sur (Southern Europe) del continente europeo (Europe), queremos saber el número de lenguas que se hablan en este país y, de ellas, cuántas son oficiales y cuántas no. También queremos saber el número de lenguas habladas por más de un veinte por ciento de la población en ese país
SELECT 	Nombre, Lengua, Porcentaje, EsOficial
FROM 		LenguaPais JOIN Pais
ON 			LenguaPais.CodigoPais = Pais.Codigo
WHERE 	Continente = "Europe" AND Region = "Southern Europe";

SELECT 	Nombre, Lengua, Porcentaje, EsOficial, 
				IF(EsOficial = "T", 1 , NULL) AS OficialT,
                IF(EsOficial = "F", 1 , NULL) AS OficialF,
                IF(Porcentaje = 20, 1 , NULL) AS PorcentajeMayor20
FROM 		LenguaPais JOIN Pais
ON 			LenguaPais.CodigoPais = Pais.Codigo
WHERE 	Continente = "Europe" AND Region = "Southern Europe";


SELECT 		Nombre, COUNT(*) AS "Numero de lenguas",
					COUNT(IF(EsOficial = "T", 1 , NULL)) AS "Son Oficiales", /* Truco para contar valores independientes*/
					COUNT(IF(EsOficial = "F", 1 , NULL)) AS "No son Oficiales",
					COUNT(IF(Porcentaje = 20, 1 , NULL)) AS "Numero de lenguas habladas por mas del 20"
FROM 			LenguaPais JOIN Pais
ON 				LenguaPais.CodigoPais = Pais.Codigo
WHERE 		Continente = "Europe" AND Region = "Southern Europe"
GROUP BY 	Codigo; /* Siempre agrupar por la clave primaria*/

-- ----------------------------------------------------------------------------
-- Creando datos
-- ----------------------------------------------------------------------------
SELECT  "A" AS "Letra", 1 AS "Inicio", 9 AS "Fin"
UNION ALL
SELECT "B", 10, 19;


-- Crear la siguiente tabla:
/*
+------------------------+----------------+----------------+
| NombreTramo            | LimiteInferior | LimiteSuperior |
+------------------------+----------------+----------------+
| Muy Poco extendida     |              0 |              1 |
| Poco extendida         |              2 |              3 |
| Medianamente extendida |              4 |              5 |
| Bastante extendida     |              6 |              7 |
| Muy extendida          |              8 |          10000 |
+------------------------+----------------+----------------+
*/


SELECT  "Muy Poco extendida" AS NombreTramo, 0 AS LimiteInferior, 1 AS LimiteSuperior
UNION ALL
SELECT "Poco extendida", 2, 3
UNION ALL
SELECT "Medianamente extendida", 4, 5
UNION ALL
SELECT "Bastante extendida", 6, 7
UNION ALL
SELECT "Muy extendida", 8, 10000;

SELECT NombreTramo, LimiteSuperior
FROM (
	SELECT  "Muy Poco extendida" AS NombreTramo, 0 AS LimiteInferior, 1 AS LimiteSuperior
	UNION ALL
	SELECT "Poco extendida", 2, 3
	UNION ALL
	SELECT "Medianamente extendida", 4, 5
	UNION ALL
	SELECT "Bastante extendida", 6, 7
	UNION ALL
	SELECT "Muy extendida", 8, 10000
) T
WHERE LimiteSuperior > 4;

SELECT 	Lengua, COUNT(*)
FROM 		LenguaPais
WHERE 	EsOficial = "T";

SELECT Lengua, NombreTramo AS "Extension como oficial" /*Bien formateado para el usuario*/
FROM (
	SELECT  	"Muy Poco extendida" AS NombreTramo, 0 AS LimiteInferior, 1 AS LimiteSuperior
	UNION ALL
	SELECT 	"Poco extendida", 2, 3
	UNION ALL
	SELECT 	"Medianamente extendida", 4, 5
	UNION ALL
	SELECT 	"Bastante extendida", 6, 7
	UNION ALL
	SELECT 	"Muy extendida", 8, 10000
) Tramos
JOIN (
	SELECT 	Lengua, COUNT(*) NumeroPaises
	FROM 		LenguaPais
	WHERE 	EsOficial = "T"
    GROUP BY	Lengua 
) Datos
ON  				Datos.NumeroPaises BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior; /*No se necesita Datos.x*/

SELECT NombreTramo AS "Categorias", COUNT(*) AS "Numero de lenguas"
FROM (
	SELECT  	"Muy Poco extendida" AS NombreTramo, 0 AS LimiteInferior, 1 AS LimiteSuperior
	UNION ALL
	SELECT 	"Poco extendida", 2, 3
	UNION ALL
	SELECT 	"Medianamente extendida", 4, 5
	UNION ALL
	SELECT 	"Bastante extendida", 6, 7
	UNION ALL
	SELECT 	"Muy extendida", 8, 10000
	UNION ALL
	SELECT 	"Extremadamente extendida", 10000, 100000
) Tramos
JOIN (
	SELECT 	Lengua, COUNT(*) NumeroPaises
	FROM 		LenguaPais
	WHERE 	EsOficial = "T"
    GROUP BY	Lengua 
) Datos
ON  				NumeroPaises BETWEEN LimiteInferior AND LimiteSuperior
GROUP BY	NombreTramo; 

SELECT NombreTramo AS "Categorias", COUNT(Lengua) AS "Numero de lenguas" /*Porque te da un registro nulo y lo cuenta*/
FROM (
	SELECT  	"Muy Poco extendida" AS NombreTramo, 0 AS LimiteInferior, 1 AS LimiteSuperior
	UNION ALL
	SELECT 	"Poco extendida", 2, 3
	UNION ALL
	SELECT 	"Medianamente extendida", 4, 5
	UNION ALL
	SELECT 	"Bastante extendida", 6, 7
	UNION ALL
	SELECT 	"Muy extendida", 8, 10000
	UNION ALL
	SELECT 	"Extremadamente extendida", 10000, 100000
) Tramos
LEFT JOIN (
	SELECT 	Lengua, COUNT(*) NumeroPaises
	FROM 		LenguaPais
	WHERE 	EsOficial = "T"
    GROUP BY	Lengua 
) Datos
ON  				NumeroPaises BETWEEN LimiteInferior AND LimiteSuperior
GROUP BY	LimiteInferior
ORDER BY 	LimiteInferior;

-- 40. Listado con las lenguas oficiales y su extensión (número de países en los que se habla como lengua oficial) según la siguiente tabla
/*
+------------------------+----------------+----------------+
| NombreTramo            | LimiteInferior | LimiteSuperior |
+------------------------+----------------+----------------+
| Muy Poco extendida     |              0 |              1 |
| Poco extendida         |              2 |              3 |
| Medianamente extendida |              4 |              5 |
| Bastante extendida     |              6 |              7 |
| Muy extendida          |              8 |          10000 |
+------------------------+----------------+----------------+
*/

SELECT Lengua, NombreTramo AS "Extension como oficial"
FROM (
	SELECT  	"Muy Poco extendida" AS NombreTramo, 0 AS LimiteInferior, 1 AS LimiteSuperior
	UNION ALL
	SELECT 	"Poco extendida", 2, 3
	UNION ALL
	SELECT 	"Medianamente extendida", 4, 5
	UNION ALL
	SELECT 	"Bastante extendida", 6, 7
	UNION ALL
	SELECT 	"Muy extendida", 8, 10000
) Tramos
JOIN (
	SELECT 	Lengua, COUNT(*) NumeroPaises
	FROM 		LenguaPais
	WHERE 	EsOficial = "T"
    GROUP BY	Lengua 
) Datos
ON  				Datos.NumeroPaises BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior;

-- 41. Según el número de países en los que se habla una lengua, queremos agruparlas según los tramos definidos en la siguiente tabla. Para ello sólo tendremos en cuenta las lenguas oficiales
/*
+------------------------+----------------+----------------+
| NombreTramo            | LimiteInferior | LimiteSuperior |
+------------------------+----------------+----------------+
| Muy Poco extendida     |              0 |              1 |
| Poco extendida         |              2 |              3 |
| Medianamente extendida |              4 |              5 |
| Bastante extendida     |              6 |              7 |
| Muy extendida          |              8 |          10000 |
+------------------------+----------------+----------------+
*/

SELECT NombreTramo AS "Categorias", COUNT(Lengua) AS "Numero de lenguas" 
FROM (
	SELECT  	"Muy Poco extendida" AS NombreTramo, 0 AS LimiteInferior, 1 AS LimiteSuperior
	UNION ALL
	SELECT 	"Poco extendida", 2, 3
	UNION ALL
	SELECT 	"Medianamente extendida", 4, 5
	UNION ALL
	SELECT 	"Bastante extendida", 6, 7
	UNION ALL
	SELECT 	"Muy extendida", 8, 10000
) Tramos
JOIN (
	SELECT 	Lengua, COUNT(*) NumeroPaises
	FROM 		LenguaPais
	WHERE 	EsOficial = "T"
    GROUP BY	Lengua 
) Datos
ON  				NumeroPaises BETWEEN LimiteInferior AND LimiteSuperior
GROUP BY	LimiteInferior
ORDER BY 	LimiteInferior;

-- 42. Definimos el índice de crecimiento de un país como PNB/PNBAnt. Según sea el índice de crecimiento: menor que 0,55; entre 0,55 y 0,85; entre 0,85 y 1,15; entre 1,15 y 1,45 y mayor que 1,45 se catalogará al país como en “gran recesión”, “recesión”, “estable”, “crecimiento” y “gran crecimiento”. Elabora una tabla donde aparezcan el número de países de cada tramo
/*
+------------------+----------------+----------------+
| NombreTramo      | LimiteInferior | LimiteSuperior |
+------------------+----------------+----------------+
| Gran recesión    |          -1.00 |           0.55 |
| Recesión         |           0.55 |           0.85 |
| Estable          |           0.85 |           1.15 |
| Crecimiento      |           1.15 |           1.45 |
| Gran crecimiento |           1.45 |       10000.00 |
+------------------+----------------+----------------+
*/

-- Paso 1. Crear la tabla de tramos
-- Paso 2. Crear la tabla de datos
-- Paso 3. Poner un SELECT *, el LEFT JOIN y el ON
-- En este paso hay que decidir si se pone BETWEEN o >=, <=
-- Paso 4. Decidir qué tipo de consulta hay que hacer
-- Si el del primer tipo, solo hay que cambiar el SELECT *
-- Si es del segundo tipo:
    -- En el SELECT mostrar el NombreTramo y hacer un COUNT de Datos.Codigo
    -- Agrupar y ordenar por LimiteInferior

SELECT "Gran recesion" NombreTramo,  -1 LimiteInferior, .55 LimiteSuperior
UNION ALL
SELECT "Recesion", .55,.85
UNION ALL
SELECT "Estable", .55,.85
UNION ALL
SELECT "Recesion", .85,1.15
UNION ALL
SELECT "Crecimiento", 1.15,1.45
UNION ALL
SELECT "Gran Crecimiento", 1.45, 10000;

SELECT 	PNB /	PNBAnt AS IndiceCrecimiento
FROM 		Pais
WHERE 	PNB /	PNBAnt IS NOT NULL;

SELECT NombreTramo AS "Categoria", COUNT(Codigo) AS "Numero de paises"
FROM (
	SELECT "Gran recesion" NombreTramo,  -1 LimiteInferior, .55 LimiteSuperior
	UNION ALL
	SELECT "Recesion", .55,.85
	UNION ALL
	SELECT "Estable", .55,.85
	UNION ALL
	SELECT "Recesion", .85,1.15
	UNION ALL
	SELECT "Crecimiento", 1.15,1.45
	UNION ALL
	SELECT "Gran Crecimiento", 1.45, 10000
) Tramos
LEFT JOIN (
	SELECT 	Codigo, PNB /	PNBAnt AS IndiceCrecimiento
	FROM 		Pais
	WHERE 	PNB /	PNBAnt IS NOT NULL
) Datos
ON  IndiceCrecimiento >= LimiteInferior AND IndiceCrecimiento < LimiteSuperior
GROUP BY LimiteInferior
ORDER BY LimiteInferior;

-- 43. Según el número de ciudades que tiene cada región de cada continente realizamos la siguiente clasificación: entre 0 y 10, entre 11 y 100, entre 101 y 200, entre 201 y 500, de 501 en adelante; que se corresponden con Muy bajo, Bajo, Medio, Alto y Muy alto respectivamente. Queremos saber cuántas regiones hay en cada tramo de número de ciudades.
/*
+-------------+----------------+----------------+
| NombreTramo | LimiteInferior | LimiteSuperior |
+-------------+----------------+----------------+
| Muy bajo    |              0 |             10 |
| Bajo        |             11 |            100 |
| Medio       |            101 |            200 |
| Alto        |            201 |            500 |
| Muy alto    |            501 |       10000000 |
+-------------+----------------+----------------+
*/

-- Partimos de la consulta 31 que ya hemos hecho: De cada continente y cada región queremos saber el número de ciudades ordenado de las regiones con más ciudades a las que menos tienen.
SELECT   Continente, Region, COUNT(Ciudad.Id) AS NumeroDeCiudades
FROM     Pais LEFT JOIN Ciudad
ON       Pais.Codigo = Ciudad.CodigoPais
GROUP BY Continente, Region
ORDER BY NumeroDeCiudades DESC;

SELECT "Muy bajo" NombreTramo,  0 LimiteInferior, 10 LimiteSuperior
UNION ALL
SELECT "Bajo", 11, 100
UNION ALL
SELECT "Medio",  101, 200
UNION ALL
SELECT "Alto", 201,500
UNION ALL
SELECT "Muy alto", 501,10000000;

SELECT NombreTramo AS "Numero de ciudades", COUNT(Region) AS "Numero de regiones"
FROM (
	SELECT "Muy bajo" NombreTramo,  0 LimiteInferior, 10 LimiteSuperior
	UNION ALL
	SELECT "Bajo", 11, 100
	UNION ALL
	SELECT "Medio",  101, 200
	UNION ALL
	SELECT "Alto", 201,500
	UNION ALL
	SELECT "Muy alto", 501,10000000
) Tramos
LEFT JOIN (
	SELECT   Continente, Region, COUNT(Ciudad.Id) AS NumeroDeCiudades
	FROM     Pais LEFT JOIN Ciudad
	ON       Pais.Codigo = Ciudad.CodigoPais
	GROUP BY Continente, Region
	ORDER BY NumeroDeCiudades DESC
) Datos
ON  		NumeroDeCiudades BETWEEN LimiteInferior AND LimiteSuperior
GROUP BY LimiteInferior
ORDER BY LimiteInferior;

-- 44. Según el número de países en los que se habla una lengua, queremos agruparlas según los tramos definidos en la siguiente tabla. Para ello sólo tendremos en cuenta las lenguas oficiales. Usa funciones de control de flujo
/*
+------------------------+----------------+----------------+
| NombreTramo            | LimiteInferior | LimiteSuperior |
+------------------------+----------------+----------------+
| Muy Poco extendida     |              0 |              1 |
| Poco extendida         |              2 |              3 |
| Medianamente extendida |              4 |              5 |
| Bastante extendida     |              6 |              7 |
| Muy extendida          |              8 |          10000 |
+------------------------+----------------+----------------+
*/

-- Partimos de la subconsulta:
SELECT Lengua, COUNT(*) AS NumeroPaises
FROM   LenguaPais
WHERE  EsOficial = 'T'
GROUP BY Lengua;

SELECT 	Lengua, 
				NumeroPaises,
				CASE 
					WHEN  NumeroPaises >= 8 THEN "Muy extendida"
					WHEN  NumeroPaises >= 6 THEN "Bastante extendida"
                    WHEN  NumeroPaises >= 4 THEN "Medianamente extendida"
					WHEN  NumeroPaises >= 2 THEN "Poco extendida"   
					ELSE "Muy poco extendida"
                END  AS "Categorias"
FROM (
	SELECT 	Lengua, COUNT(*) AS NumeroPaises
	FROM   	LenguaPais
	WHERE  	EsOficial = 'T'
	GROUP BY Lengua
) Datos;

SELECT 	
				CASE 
					WHEN  NumeroPaises >= 8 THEN "Muy extendida"
					WHEN  NumeroPaises >= 6 THEN "Bastante extendida"
                    WHEN  NumeroPaises >= 4 THEN "Medianamente extendida"
					WHEN  NumeroPaises >= 2 THEN "Poco extendida"   
					ELSE "Muy poco extendida" /*Podria entrar nulos*/
                END  AS "Categorias", 
                COUNT(*) as "Numero de Lenguas"
FROM (
	SELECT 	Lengua, COUNT(*) AS NumeroPaises
	FROM   	LenguaPais
	WHERE  	EsOficial = 'T'
	GROUP BY Lengua
) Datos
GROUP BY Categorias;


-- ----------------------------------------------------------------------------
-- Otras consultas
-- ----------------------------------------------------------------------------

-- 45.  Lenguas oficiales que se hablan en los países de las 10 capitales más pobladas del mundo
-- Partimos de:
SELECT Pais.Codigo, Pais.Nombre, Ciudad.Nombre, Ciudad.Poblacion
FROM   Pais JOIN Ciudad
ON     Pais.Capital = Ciudad.Id
ORDER BY Ciudad.Poblacion DESC
LIMIT 10;

SELECT 	DISTINCT Lengua AS "Lenguas"
FROM 		LenguaPais JOIN (
	SELECT 	Pais.Codigo
	FROM   	Pais JOIN Ciudad
	ON     		Pais.Capital = Ciudad.Id
	ORDER BY Ciudad.Poblacion DESC
	LIMIT 10
)  AS CapitalesMasPobladas
ON  			LenguaPais.CodigoPais = CapitalesMasPobladas.Codigo
WHERE 	LenguaPais.EsOficial = "T";

-- 46. Queremos crear una gráfica en Calc para saber si existe alguna relación entre la esperanza de vida y el PNB per cápita de un país
-- Primero hacemos la consulta
SELECT Nombre AS 'País',
       EsperanzaVida AS 'Esperanza de Vida',
       (PNB/Poblacion)*1000000 AS 'PIB per cápita'
FROM  Pais
WHERE EsperanzaVida IS NOT NULL AND         -- Debe tener introducida una esperanza de vida.
      PNB IS NOT NULL AND                   -- Debe tener introducido un PNB.
      Poblacion > 0 AND                     -- No puede existir población negativa.
      EsperanzaVida > 0 AND                 -- No puede existir esperanza de vida negativa.
      PNB > 0;                              -- No puede existir un PNB negativo.
      
-- 47. Queremos saber el incremento del PNB (PNB-PNBAnt) de cada continente
SELECT Continente, SUM(PNB - PNBAnt) AS 'Incremento PNB'
FROM   Pais
GROUP BY Continente; /*Correcta*/

SELECT Continente, SUM(PNB) - SUM(PNBAnt) AS 'Incremento PNB'
FROM   Pais
GROUP BY Continente;

-- Código PNB  PNBAnt PNB–PNBAnt
-- ESP    10       5           5
-- FRA    15      20          -5
-- ITA     5    NULL        NULL
-- -----------------------------
--          30      25               	SUM(PNB) - SUM(PNBAnt)   = 5
--                                	0		SUM(PNB – PNBAnt)  = 0 /* CORRECTA*/

-- 48.  De cada continente queremos saber el número medio de lenguas habladas por país, es decir, el número de lenguas que se hablan en el continente partido por el número de países de ese continente
SELECT Continente, ROUND(COUNT(DISTINCT Lengua)  /  COUNT(DISTINCT Codigo),  1) AS "Número medio de lenguas habladas por país"
FROM Pais LEFT JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
GROUP BY Continente;

-- Solución usando consutlas correlacionadas. Bastante más compleja.
SELECT DISTINCT PaisExt.Continente,
      (
      ROUND(
            (            -- Número de lenguas que se hablan en un continente.
            SELECT COUNT(DISTINCT LenguaPais.Lengua)
            FROM LenguaPais JOIN Pais
            ON LenguaPais.CodigoPais = Pais.Codigo
            WHERE PaisExt.Continente =  Pais.Continente) 
            /
            (            -- Dividido entre el número de paises de ese continente.
            SELECT COUNT(*)
            FROM Pais
            WHERE PaisExt.Continente = Pais.Continente)
            , 1)
      ) AS 'Lenguas por pais'
FROM Pais AS PaisExt;

-- 49. Listado de los países y el número de ciudades de ese país para los países que tienen más ciudades que España
SELECT COUNT(*)
FROM Ciudad JOIN Pais
ON CodigoPais = Codigo
WHERE Pais.Nombre = "Spain";

SELECT Pais.Nombre, COUNT(*) AS "Numero de ciudades"
FROM 	Ciudad JOIN Pais
ON 			CodigoPais = Codigo
GROUP BY Codigo
HAVING `Numero de ciudades` > (
	SELECT 	COUNT(*)
	FROM 		Ciudad JOIN Pais
	ON 				CodigoPais = Codigo
	WHERE 		Pais.Nombre = "Spain"
) ;

-- -----------------------------------------------------------------------------
-- Consultas de filas repetidas 
-- -----------------------------------------------------------------------------

