/* -----------------------------------------------------------------------------
Bases de Datos
Tema 3. SQL avanzado II

Grupo: 1ºDAM
----------------------------------------------------------------------------- */

-- -----------------------------------------------------------------------------
-- Tema 3. SQL avanzado II. Consultas de clase
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Subconsultas correlacionadas
-- -----------------------------------------------------------------------------

/*
Una subconsulta es correlacionada si en la subconsulta se hace referencia a algún campo que no aparece en ninguna de las tablas de la subconsulta y que aparece en alguna de las tablas de la consulta principal. En este caso la subconsulta depende de la consulta principal. Si la subconsulta hace referencia sólo a campos de sus tablas; las consultas son independientes o no correlacionadas
*/

-- Consulta no correlacionada:
SELECT Ciudad.Nombre, Ciudad.Poblacion
FROM   Ciudad JOIN Pais
ON     Ciudad.Id = Pais.Capital
WHERE  Ciudad.Poblacion > 10 * (
          SELECT Poblacion
          FROM   Ciudad
          Where  Nombre LIKE 'Alicante%');

-- ----------------------------------------------------------------------------------------
-- Consulta no correlacionada:
SELECT Nombre AS Pais        -- 185 registros
FROM   Pais
WHERE  AnyIndep * 4 > (
       SELECT COUNT(*)
       FROM Ciudad      );
      
-- Primero se hace la consulta interna
SELECT COUNT(*)              -- Resultado 4079
FROM   Ciudad;

-- Luego se le pasa el resultado a la consulta externa
SELECT Nombre AS Pais        -- 185 registros
FROM   Pais
WHERE  AnyIndep * 4 > 4079;

-- ----------------------------------------------------------------------------------------
-- Consulta correlacionada:
SELECT Nombre AS Pais        -- 189 Registros
FROM   Pais
WHERE  AnyIndep / 4 > (
       SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais = Pais.Codigo);

-- Ahora la consulta interna no se puede ejecutar de manera independiente, como antes...
SELECT COUNT(*)              -- #1054 - Unknown column 'Pais.Codigo' in 'where clause'
FROM   Ciudad
WHERE  Ciudad.CodigoPais = Pais.Codigo

-- ----------------------------------------------------------------------------------------
-- Consulta es errónea:
SELECT Nombre AS Pais        -- #1054 - Unknown column 'LenguaPais.CodigoPais' in 'where clause' 
FROM   Pais
WHERE  AnyIndep / 4 > (
       SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais = LenguaPais.CodigoPais);

-- ----------------------------------------------------------------------------------------
-- Ejercicio: indica qué consultas son correlacionadas, no correlacionadas o erróneas
-- ----------------------------------------------------------------------------------------

SELECT Nombre           -- Consulta correlacionada
FROM   Pais
WHERE  EXISTS(
       SELECT *         
       FROM LenguaPais
       WHERE CodigoPais = Codigo);
       
SELECT Nombre           -- Consulta correlacionada
FROM   Pais
WHERE  EXISTS(
       SELECT *         
       FROM LenguaPais
       WHERE LenguaPais.CodigoPais = Pais.Codigo);
      
SELECT Nombre           -- Consulta no correlacionada
FROM   Pais
WHERE  EXISTS(
       SELECT *         
       FROM LenguaPais
       WHERE CodigoPais = 'AFG');
      
SELECT Nombre           -- Consulta errónea
FROM   Pais
WHERE  EXISTS(
       SELECT *           
       FROM LenguaPais
       WHERE CodigoPais = Ciudad.Id);      

SELECT Lengua           -- Consulta correlacionada
FROM   LenguaPais JOIN Pais
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE (SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais = Pais.Codigo)
             > 100 AND EsOficial = 'T';
            
SELECT Lengua           -- Consulta no correlacionada
FROM   LenguaPais JOIN Pais
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE (SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais > 'JJJ')
             > 100 AND EsOficial = 'T';
             
SELECT Lengua           -- Consulta no correlacionada
FROM   LenguaPais JOIN Pais
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE  EsOficial = 'T' AND
      (SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais > 'JJJ') > 100;
            
SELECT Nombre AS 'Pais' -- Consulta errónea
FROM   Pais
WHERE (SELECT SUM(Ciudad.Poblacion)
       FROM Ciudad
       WHERE Poblacion = LenguaPais.Porcentaje)
             > Pais.Poblacion;
             
-- -----------------------------------------------------------------------------
-- Ejecución de una consulta correlacionada
-- -----------------------------------------------------------------------------

SELECT Nombre AS Pais        -- 189 Registros
FROM   Pais
WHERE  AnyIndep / 4 > (
       SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais = Pais.Codigo);
       
SELECT Codigo, Nombre, AnyIndep FROM Pais LIMIT 10;

SELECT COUNT(*)
FROM Ciudad
WHERE Ciudad.CodigoPais = 'ABW';

-- Ahora la consulta interna no se puede ejecutar de manera independiente, como antes...
SELECT COUNT(*)              -- #1054 - Unknown column 'Pais.Codigo' in 'where clause'
FROM   Ciudad
WHERE  Ciudad.CodigoPais = Pais.Codigo;

/* Para ejecutar esta consulta debemos coger el primer país 

Codigo      Nombre                  Continente          Region                          Superficie
ABW         Aruba                   North America       Caribbean                       193.00
AFG         Afghanista              Asia                Southern and Central Asia       652090.00
AGO         Angola                  Africa              Central Africa                  1246700.00

que es Aruba, de código ABW y con estos datos, ejecutar la subconsulta */
SELECT COUNT(*)               -- Resultado 1
FROM   Ciudad
WHERE  Ciudad.CodigoPais = 'ABW'
/* Ahora ya podemos calcular si AnyIndep (de Aruba) / 4 > 1

A continuación se selecciona el segundo país: Afghnistan, con código AFG y volvemos a ejecutar la subconsulta */
SELECT COUNT(*)               -- Resultado 4
FROM   Ciudad
WHERE  Ciudad.CodigoPais = 'AFG'
/* Ahora volvemos a calcular si AnyIndep (de Afganistán) / 4 > 4 */

/*
En una subconsulta correlacionada se coge el primer registro de la consulta principal y con sus datos se ejecuta la subconsulta. A continuación se coge el segundo registro de la consulta principal y con sus datos se ejecuta la subconsulta y así hasta llegar al último registro de la consulta principal. Por tanto, la subconsulta se ejecutará tantas veces como registros tenga la consulta principal. */

-- Muchas veces el própio enunciado nos puede ayudar a saber si una subconsulta es correlacionada o no:

-- Nombre de los países cuyo año de independencia dividido entre cuatro es mayor que el número total de ciudades.
-- Nombre de los países cuyo año de independencia dividido entre cuatro es mayor que el número de ciudades de ese país.

-- El primer enunciado se corresponde con una consulta no correlacionada porque podemos calcular el número total de ciudades de manera independendiente
-- El segundo enunciado se corresponde con una consulta correlacionada porque para cada país hay que calcular su número de ciudades

-- 1. Nombre de los países en los que se hablan exactamente dos lenguas
SELECT Nombre AS 'País'
FROM Pais
WHERE (
    SELECT COUNT(*) 
    FROM LenguaPais
    WHERE LenguaPais.CodigoPais = Pais.Codigo) = 2;       
    
-- 2. Nombre de los países que tienen dos o más ciudades con dos millones de habitantes como mínimo
SELECT Nombre AS 'País'
FROM Pais
WHERE (
    SELECT COUNT(*)
    FROM Ciudad
    WHERE Ciudad.CodigoPais = Pais.Codigo
    AND Ciudad.Poblacion >= 2000000) >= 2;
    
-- 3. Para detectar posibles errores en nuestra base de datos vamos a ver si existe alguna ciudad que sea ciudad de más de un país a la vez
-- esta consulta no se puede ejecutar

-- 4. Para detectar posibles errores en nuestra base de datos vamos a ver si existe alguna ciudad que sea capital de más de un país a la vez
SELECT Ciudad.Nombre AS 'Capital'
FROM Ciudad
WHERE (SELECT COUNT(*)
        FROM Pais
        WHERE Ciudad.Id = Pais.Capital) > 1;
        
-- Podemos crear un país ficticio con una capital duplicada para comprobar que nuestra consulta funciona:
INSERT INTO Pais VALUES ('XXX','Spain2','Europe','SE',5,1492,3,7,5,5,'Españistán','XX','XX',653,'ES');

DELETE FROM Pais WHERE Codigo='XXX';

-- 5. Para detectar posibles errores en nuestra base de datos vamos a ver si existe algún país para el que la suma de las poblaciones de sus ciudades es mayor que la población del país
SELECT Pais.Nombre AS 'País'
FROM Pais
WHERE (SELECT SUM(Ciudad.Poblacion)
       FROM Ciudad
       WHERE Ciudad.CodigoPais = Pais.Codigo) 
       > Pais.Poblacion;

-- 6. Nombre de los países con más de tres lenguas oficiales
SELECT Pais.Nombre
FROM Pais
WHERE (SELECT COUNT(*)
       FROM LenguaPais
       WHERE Pais.Codigo = LenguaPais.CodigoPais
       AND EsOficial = 'T') > 3;
       
-- 7. Nombre y lenguas oficiales de los países con más de tres lenguas oficiales
SELECT Pais.Nombre AS 'Pais', Lengua
FROM Pais JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
WHERE LenguaPais.EsOficial = 'T'AND
      (SELECT COUNT(*)
      FROM LenguaPais
      WHERE LenguaPais.CodigoPais = Pais.Codigo
      AND LenguaPais.EsOficial = 'T') > 3;
      
-- 8. Nombre de los países y de su ciudad para los países que tienen sólo una ciudad
SELECT Pais.Nombre AS 'Pais', Ciudad.Nombre AS 'Ciudad'
FROM Pais JOIN Ciudad
ON Pais.Codigo = Ciudad.CodigoPais
WHERE (SELECT COUNT(*)
    FROM Ciudad
    WHERE Ciudad.CodigoPais = Pais.Codigo) = 1;


-- 9. Países en los que se hablan más de dos lenguas, pero que no tienen ninguna lengua oficial
SELECT Pais.Nombre AS 'Pais'
FROM   Pais
WHERE (SELECT COUNT(*)
       FROM LenguaPais
       WHERE LenguaPais.CodigoPais = Pais.Codigo) > 2
    AND (SELECT COUNT(*)
        FROM LenguaPais
        WHERE LenguaPais.CodigoPais = Pais.Codigo
        AND EsOficial = 'T') = 0;


-- 10. Lenguas que se hablan en más de 20 países
SELECT DISTINCT Lengua
FROM   LenguaPais AS LPExterna
WHERE (SELECT COUNT(*)
       FROM LenguaPais
       WHERE LenguaPais.Lengua = LPExterna.Lengua)
       > 20;

-- 11. Países del continente europeo que tienen exactamente dos lenguas oficiales
SELECT Pais.Nombre AS 'Pais'
FROM   Pais
WHERE  Continente = 'Europe' AND
      (SELECT COUNT(*)
       FROM LenguaPais
       WHERE LenguaPais.CodigoPais = Pais.Codigo
       AND EsOficial = 'T') = 2;

-- 12. Continentes que tienen una población mayor que 500 millones de habitantes
SELECT DISTINCT Continente
FROM   Pais AS PaisExterna
WHERE (SELECT SUM(Poblacion)
        FROM Pais
        WHERE Pais.Continente = PaisExterna.Continente)
        > 500000000;

-- 13. Lenguas habladas por más de cien millones hablantes como lengua materna
SELECT DISTINCT Lengua
FROM LenguaPais AS LenguaExterna
WHERE (SELECT SUM(Poblacion*Porcentaje/100)
    FROM LenguaPais JOIN Pais
    ON LenguaPais.CodigoPais = Pais.Codigo
    WHERE LenguaPais.Lengua = LenguaExterna.Lengua)
    > 100000000;

-- --------------------------------------------------------------------------------------
-- Subconsultas correlacionadas de EXISTS y NOT EXISTS
-- --------------------------------------------------------------------------------------

/*
Reescribimos la consulta 2: 
           Nombre de los países que tienen dos o más ciudades con dos millones de habitantes como mínimo.
De la siguiente manera:
           Nombre de los países que tienen al menos una ciudad con dos millones de habitantes como mínimo.
*/

SELECT Nombre AS 'País'
FROM Pais
WHERE (
    SELECT COUNT(*)
    FROM Ciudad
    WHERE Ciudad.CodigoPais = Pais.Codigo
    AND Ciudad.Poblacion >= 2000000) >= 1;

SELECT Nombre AS 'País'
FROM Pais
WHERE EXISTS(
    SELECT *
    FROM Ciudad
    WHERE Ciudad.CodigoPais = Pais.Codigo
          AND Ciudad.Poblacion >= 2000000);

-- 14. Listado de continentes que tienen alguna ciudad
SELECT DISTINCT Continente
FROM Pais AS PaisExterna
WHERE EXISTS(
    SELECT *
    FROM Pais Join Ciudad
    ON Ciudad.CodigoPais = Codigo
    WHERE Continente = PaisExterna.Continente);
    
-- 15. Listado de continentes que no tienen ninguna ciudad
SELECT DISTINCT Continente
FROM Pais AS PaisExterna
WHERE NOT EXISTS(
      SELECT *
      FROM Pais Join Ciudad
      ON Ciudad.CodigoPais = Codigo
      WHERE Continente = PaisExterna.Continente);

-- 16. Listado de zonas con alguna ciudad de más de 5 millones habitantes. Poner las dos soluciones: COUNT(*) y EXISTS
SELECT DISTINCT Zona, CodigoPais
FROM Ciudad AS CiudadExterna
WHERE EXISTS(
      SELECT 1
      FROM   Ciudad
      WHERE  Ciudad.Poblacion > 5000000 AND
             Ciudad.Zona = CiudadExterna.Zona AND
             Ciudad.CodigoPais = CiudadExterna.CodigoPais);
      
SELECT DISTINCT Zona, CodigoPais
FROM Ciudad AS CiudadExterna
WHERE (SELECT COUNT(*)
      FROM  Ciudad
      WHERE Ciudad.Poblacion > 5000000 AND
            Ciudad.Zona = CiudadExterna.Zona AND
            Ciudad.CodigoPais =CiudadExterna.CodigoPais) >= 1;
      
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
SELECT DISTINCT Continente
FROM Pais AS PaisExterna
WHERE NOT EXISTS (
    SELECT *
    FROM LenguaPais JOIN Pais
    ON LenguaPais.CodigoPais = Pais.Codigo
    WHERE Pais.Continente = PaisExterna.Continente);

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

SELECT  EXISTS (    
    SELECT *
    FROM   Pais
    WHERE  Superficie > 500000) AS 'Comprobación';

-- 19. Listado de nombres de países que son también nombres de ciudad
-- El enunciado de esta consulta se podría reescribir como:
-- Nombre de los países para los que existe alguna ciudad con el mismo nombre
SELECT Nombre AS 'Pais'
FROM   Pais
WHERE  EXISTS (
       SELECT 1
       FROM   Ciudad
       WHERE  Pais.Nombre = Ciudad.Nombre);
       

       
-- 20. Listado de países que son también una lengua
SELECT Nombre
FROM Pais
WHERE EXISTS (
        SELECT 1
        FROM LenguaPais
        WHERE Lengua = Pais.Nombre);

-- 21. Listado de países que no son nombres de lenguas
-- Operación diferencia
SELECT Nombre
FROM Pais
WHERE NOT EXISTS (
        SELECT 1
        FROM LenguaPais
        WHERE Lengua = Pais.Nombre);
        
-- 22. Listado de países y lenguas a excepción de los países que son también lenguas
-- Operación Diferencia simétrica
SELECT Nombre
FROM   Pais
WHERE  NOT EXISTS (
        SELECT 1
        FROM LenguaPais
        WHERE Lengua = Pais.Nombre)
UNION ALL
SELECT DISTINCT Lengua
FROM LenguaPais
WHERE NOT EXISTS (
    SELECT 1
    FROM Pais
    WHERE Pais.Nombre = Lengua);
    
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
SELECT Nombre
FROM   Empleados
WHERE  NOT EXISTS (
    SELECT 1
    FROM   Departamentos
    WHERE  NOT EXISTS (
        SELECT 1
        FROM   Trabaja
        WHERE  Trabaja.IdEmpleado = Empleados.IdEmpleado AND
               Trabaja.IdDepartamento = Departamentos.IdDepartamento));
               
-- Enunciado alternativo: Departamentos para los que no existe un Empleado donde no trabaje
SELECT Nombre
FROM   Departamentos
WHERE  NOT EXISTS (
    SELECT 1
    FROM   Empleados
    WHERE  NOT EXISTS (
        SELECT 1
        FROM   Trabaja
        WHERE  Trabaja.IdEmpleado = Empleados.IdEmpleado AND
               Trabaja.IdDepartamento = Departamentos.IdDepartamento));
               
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
           
/*Enero*/
-- ----------------------------------------------------------------------------
-- GROUP BY
-- ----------------------------------------------------------------------------
SELECT CodigoPais FROM Ciudad;
SELECT COUNT(*) FROM Ciudad;
SELECT CodigoPais, COUNT(*) FROM Ciudad;

SELECT CodigoPais, COUNT(*), SUM(Poblacion)
FROM Ciudad
GROUP BY CodigoPais;

SELECT CodigoPais, COUNT(*)
FROM Ciudad
WHERE Poblacion > 3000000
GROUP BY CodigoPais;

-- Codigo de pais y numero de ciudades con numero de habitantes con mas de 3 mln de habitantes para paises que tienen mas de 3 ciudades con poblacion de 3 mln de habitantes
SELECT CodigoPais, COUNT(*)
FROM Ciudad
WHERE Poblacion > 3000000
GROUP BY CodigoPais
HAVING COUNT(*) > 3;

SELECT CodigoPais, COUNT(*)
FROM Ciudad
WHERE Poblacion > 3000000
GROUP BY  CodigoPais
HAVING COUNT(*) > 3;

-- Rellena los AS para que tengan sentido (las funciones agregadas)
SELECT MAX(AnyIndep)          AS 'Ultimo pais europeo de independizarse',
       MIN(EsperanzaVida)     AS 'Menor esperanza de vida de un pais europeo'
FROM   Pais
WHERE  Continente='Europe';

SELECT COUNT(AnyIndep)        AS 'Numero de paises europeos que se han independizado',
       COUNT(*)               AS 'Numero de paises europeos',
       COUNT(DISTINCT Region) AS 'Numero de regiones europeos'
FROM   Pais
WHERE  Continente='Europe';

SELECT AVG(Poblacion)         AS 'Poblacion media de los paises europeos',
       SUM(Superficie)        AS 'Superficie de Europa'
FROM   Pais
WHERE  Continente='Europe';

SELECT GROUP_CONCAT(Codigo2)  AS 'Lista del codigo de 2 letras de los paises europeos'
FROM   Pais
WHERE  Continente='Europe';

-- Revisamos las funciones agregadas con valores NULL. Mira la siguiente consulta y su resultado. Fíjate 
-- que hay un valor NULL. Mediante el uso de una consulta, explica cómo afectan los valores nulos a las funciones agregadas

SELECT Nombre, PNBAnt FROM Pais WHERE Nombre LIKE 'Ir%';

SELECT MAX(PNBAnt), MIN(PNBAnt), COUNT(PNBAnt), COUNT(*)
FROM Pais
WHERE Nombre LIKE 'Ir%';

SELECT AVG(PNBAnt), SUM(PNBAnt), GROUP_CONCAT(PNBAnt)
FROM Pais
WHERE Nombre LIKE 'Ir%';

SELECT COUNT(DISTINCT PNBAnt)
FROM Pais
WHERE Nombre LIKE 'Ir%';

-- Revisamos cómo actúa el operador + y la función SUM con nulos
SELECT PNBANT FROM Pais WHERE Nombre ='Austria';
SELECT PNBANT FROM Pais WHERE Nombre ='Monaco';
SELECT (SELECT PNBANT FROM Pais WHERE Nombre ='Austria')
       +
       (SELECT PNBANT FROM Pais WHERE Nombre ='Monaco') AS Resultado;
SELECT SUM(PNBANT) FROM Pais WHERE Nombre ='Austria' or Nombre ='Monaco';  -- las funciones agregadas no tienen en cuenta los nulos, sin embargo el signo '+' - sí

-- 26. De las lenguas que son habladas por más de un 20% de la población, queremos saber el nombre de la lengua y el número de países en los que se habla
SELECT Lengua AS 'Lenguas', COUNT(*) AS 'Numero de paises'
FROM LenguaPais 
WHERE Porcentaje > 20
GROUP BY Lengua;

SELECT Lengua, COUNT(*)
FROM LenguaPais
WHERE Porcentaje > 20
GROUP BY Lengua;

-- 27. Código del país y número de lenguas habladas por más de un 20% de la población para los países con lenguas habladas por más de un 20% de la población
SELECT CodigoPais AS 'País', COUNT(*) AS 'Número de lenguas habladas por más de un 20% de la población' 
FROM LenguaPais
WHERE Porcentaje > 20
GROUP BY CodigoPais;

-- 28. Nombre del país y número de lenguas habladas por más de un 20% de la población para los países con lenguas habladas por más de un 20% de la población
SELECT Pais.Nombre AS 'País', COUNT(*) AS 'Número de lenguas habladas por más de un 20% de la población' 
FROM Pais JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
WHERE Porcentaje > 20
GROUP BY CodigoPais;

-- 29. Nombre del país y número de lenguas habladas por más de un 20% de la población para los países con lenguas habladas por más de un 20% de la población del continente Europeo
SELECT Pais.Nombre AS 'País', COUNT(*) AS 'Número de lenguas habladas por más de un 20% de la población' 
FROM Pais JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
WHERE Porcentaje > 20 AND Continente = 'Europe'
GROUP BY CodigoPais;

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

-- pero no tiene sentido mostrar el pais porque no sabemos qué pais saldrá en los grupos que tienen más de un miembro (está mal)
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
SELECT Continente,
       COUNT(*) AS 'Número de países', 
       ROUND(MAX(Superficie), -5) AS 'Superficie del país más extenso', 
       ROUND(MIN(Superficie))     AS 'Superficie del país más pequeño', 
       ROUND(AVG(Poblacion),  -5) AS 'Media de población', 
       ROUND(SUM(PNB),        -5) AS 'PNB del continente'
FROM Pais
GROUP BY Continente;

-- 31. De cada año de independencia en el que se ha independizado algún país indicar cuántos países se independizaron ese año ordenados desde el año en que se han independizado más países al que menos
SELECT AnyIndep AS 'Año de independencia', COUNT(*) AS 'Número de países'
FROM Pais
WHERE AnyIndep IS NOT NULL
GROUP BY AnyIndep
ORDER BY `Número de países` DESC;
-- -----------------------------------------------------------------------------
-- Agrupando por varios campos
-- -----------------------------------------------------------------------------
-- 32. De cada continente y cada región queremos saber el número de países que lo componen y el número de países que no tienen datos de su esperanza de vida
SELECT Nombre, Continente, Region
FROM Pais
ORDER BY 2, 3;

SELECT Continente, Region, COUNT(*) AS 'Número de países', COUNT(*) - COUNT(EsperanzaVida) AS 'número de países que no tienen datos de su esperanza de vida'
FROM Pais
GROUP BY Continente, Region;

-- 33. De cada continente y cada región queremos saber el número de ciudades ordenado de las regiones con más ciudades a las que tienen menos
SELECT Continente, Region, COUNT(Ciudad.Id) AS 'Número de ciudades'
FROM Pais LEFT JOIN Ciudad
ON Pais.Codigo = Ciudad.CodigoPais
GROUP BY Continente, Region
ORDER BY `Número de ciudades` DESC;

-- -----------------------------------------------------------------------------
-- Agrupando por expresiones
-- -----------------------------------------------------------------------------
-- 34. Número de países que se han independizado cada siglo. Ordena la consulta de manera que obtengamos la mejor información
SELECT FLOOR((AnyIndep - 1) / 100) + 1 AS 'Siglo de independencia', COUNT(*) AS 'Número de paises'
FROM Pais
WHERE AnyIndep IS NOT NULL
GROUP BY `Siglo de independencia`
ORDER BY `Siglo de independencia`;

SELECT FLOOR((1910 - 1) / 100) + 1;

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
SELECT LEFT(Nombre, 1) AS 'Letra', COUNT(*) AS 'Número de ciudades'
FROM Ciudad
GROUP BY `Letra`
ORDER BY `Número de ciudades` DESC;

-- 36. Número de ciudades cuya población está en cada tramo de medio millón de habitantes (primer tramo, de 0 a medio millón, segundo tramo de medio a un millón, etc). Añadir las columnas desde y hasta de cada tramo

/* Este el el resultado esperado:
+----------+----------+--------------------+
| Desde    | Hasta    | Número de ciudades |
+----------+----------+--------------------+
|        0 |   500000 |               3539 |
|   500000 |  1000000 |                302 |
|  1000000 |  1500000 |                108 |
|  1500000 |  2000000 |                 38 | */

SELECT TRUNCATE(Poblacion / 500000, 0) * 500000 AS 'Desde',
       TRUNCATE(Poblacion / 500000, 0) * 500000 + 500000 AS 'Hasta',
       COUNT(*) AS 'Número de ciudades'
FROM Ciudad 
GROUP BY `Desde`
ORDER BY `Desde`;

-- 37 Número de países en cada tramo de incremento o decremento del PNB (PNB-PNBAnt) en decenas de miles de millones de dólares (el PNB se mide en millones de dólares)
SELECT FLOOR((PNB-PNBAnt) / 10000) * 10000 AS 'Desde',
       FLOOR((PNB-PNBAnt) / 10000) * 10000 + 10000 AS 'Hasta',
       COUNT(*) AS 'Número de países'
FROM Pais
WHERE PNB IS NOT NULL AND PNBAnt IS NOT NULL
GROUP BY `Desde`
ORDER BY `Desde`;

-- 38. De cada continente y cada región queremos saber el número de países, el PNB más alto y la media de población con totales
SELECT Continente, Region AS 'Región', 
       COUNT(*) AS 'número de países',
       ROUND(MAX(PNB)) AS 'PNB más alto', 
       ROUND(AVG(Poblacion)) AS 'media de población'
FROM   Pais
GROUP BY Continente, Region WITH ROLLUP;

-- 39. De cada pais del la región sur (Southern Europe) del continente europeo (Europe), queremos saber el número de lenguas que se hablan en este país y,
-- de ellas, cuántas son oficiales y cuántas no. También queremos saber el número de lenguas habladas por más de un veinte por ciento de la población en ese país

SELECT Pais.Nombre, LenguaPais.Lengua, EsOficial, 
       IF(EsOficial = 'T', 1, NULL) AS OficialT,
       IF(EsOficial = 'F', 1, NULL) AS OficialF,
       LenguaPais.Porcentaje, 
       IF(Porcentaje > 20, 1, NULL) AS PorcentajeMayor20
FROM Pais JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
WHERE Continente = 'Europe' AND Region = 'Southern Europe'
GROUP BY Pais.Codigo;

-- Cuando hay que agrupar por el pais, no usamos el nombre, siempre usamos codigo
SELECT Pais.Nombre, COUNT(*) AS 'Numero de lenguas',
       COUNT(IF(EsOficial = 'T', 1, NULL)) AS 'Oficiales',
       COUNT(IF(EsOficial = 'F', 1, NULL)) AS 'No oficiales',
       COUNT(IF(Porcentaje > 20, 1, NULL)) AS 'Con % > 20'
FROM Pais JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
WHERE Continente = 'Europe' AND Region = 'Southern Europe'
GROUP BY Pais.Codigo;

-- ----------------------------------------------------------------------------
-- Creando datos
-- ----------------------------------------------------------------------------
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

SELECT 'Muy Poco extendida' AS 'NombreTramo', 0 AS 'LimiteInferior', 1 AS 'LimiteSuperior'
UNION ALL
SELECT 'Poco extendida', 2, 3
UNION ALL
SELECT 'Medianamente extendida', 4, 5
UNION ALL
SELECT 'Bastante extendida', 6, 7
UNION ALL
SELECT 'Muy extendida', 8, 10000;

SELECT NombreTramo, LimiteInferior
FROM (SELECT 'Muy Poco extendida' AS 'NombreTramo', 0 AS 'LimiteInferior', 1 AS 'LimiteSuperior'
    UNION ALL
    SELECT 'Poco extendida', 2, 3
    UNION ALL
    SELECT 'Medianamente extendida', 4, 5
    UNION ALL
    SELECT 'Bastante extendida', 6, 7
    UNION ALL
    SELECT 'Muy extendida', 8, 10000) AS Tabla
WHERE LimiteSuperior > 4;

-- Listado de legunas oficiales y número de países en los que esa lengua es oficial
SELECT Lengua, COUNT(*)
FROM   LenguaPais
WHERE  EsOficial = 'T'
GROUP  BY Lengua;

SELECT *
FROM (SELECT 'Muy Poco extendida' AS 'NombreTramo', 0 AS 'LimiteInferior', 1 AS 'LimiteSuperior'
      UNION ALL
      SELECT 'Poco extendida', 2, 3
      UNION ALL
      SELECT 'Medianamente extendida', 4, 5
      UNION ALL
      SELECT 'Bastante extendida', 6, 7
      UNION ALL
      SELECT 'Muy extendida', 8, 10000) AS Tramos
JOIN (SELECT Lengua, COUNT(*) AS NumeroPaises
      FROM   LenguaPais
      WHERE  EsOficial = 'T'
      GROUP  BY Lengua) AS Datos
ON Datos.NumeroPaises BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior;

-- 1 consulta
SELECT Lengua, NombreTramo AS 'Extensión como oficial'
FROM (SELECT 'Muy Poco extendida' AS 'NombreTramo', 0 AS 'LimiteInferior', 1 AS 'LimiteSuperior'
      UNION ALL
      SELECT 'Poco extendida', 2, 3
      UNION ALL
      SELECT 'Medianamente extendida', 4, 5
      UNION ALL
      SELECT 'Bastante extendida', 6, 7
      UNION ALL
      SELECT 'Muy extendida', 8, 10000) AS Tramos
JOIN (SELECT Lengua, COUNT(*) AS NumeroPaises
      FROM   LenguaPais
      WHERE  EsOficial = 'T'
      GROUP  BY Lengua) AS Datos
ON Datos.NumeroPaises BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior;

-- 2 consulta
SELECT Tramos.NombreTramo AS 'Categorías', COUNT(*) AS 'Número de lenguas'
FROM (SELECT 'Muy Poco extendida' AS 'NombreTramo', 0 AS 'LimiteInferior', 1 AS 'LimiteSuperior'
      UNION ALL
      SELECT 'Poco extendida', 2, 3
      UNION ALL
      SELECT 'Medianamente extendida', 4, 5
      UNION ALL
      SELECT 'Bastante extendida', 6, 7
      UNION ALL
      SELECT 'Muy extendida', 8, 10000) AS Tramos
JOIN (SELECT Lengua, COUNT(*) AS NumeroPaises
      FROM   LenguaPais
      WHERE  EsOficial = 'T'
      GROUP  BY Lengua) AS Datos
ON Datos.NumeroPaises BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior
GROUP BY Tramos.NombreTramo;

-- mejor agrupar por un int y left Join para mostar todos los tramos
SELECT Tramos.NombreTramo AS 'Categorías', COUNT(Lengua) AS 'Número de lenguas'
FROM (SELECT 'Muy Poco extendida' AS 'NombreTramo', 0 AS 'LimiteInferior', 1 AS 'LimiteSuperior'
      UNION ALL
      SELECT 'Poco extendida', 2, 3
      UNION ALL
      SELECT 'Medianamente extendida', 4, 5
      UNION ALL
      SELECT 'Bastante extendida', 6, 7
      UNION ALL
      SELECT 'Muy extendida', 8, 10000
      UNION ALL
      SELECT 'Extramadamente extendida', 10000, 100000) AS Tramos
LEFT JOIN (
      SELECT Lengua, COUNT(*) AS NumeroPaises
      FROM   LenguaPais
      WHERE  EsOficial = 'T'
      GROUP  BY Lengua) AS Datos
ON Datos.NumeroPaises BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior
GROUP BY Tramos.LimiteInferior
ORDER BY Tramos.LimiteInferior;

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

SELECT Lengua, NombreTramo AS 'Extensión como oficial'
FROM (SELECT 'Muy Poco extendida' AS 'NombreTramo', 0 AS 'LimiteInferior', 1 AS 'LimiteSuperior'
      UNION ALL
      SELECT 'Poco extendida', 2, 3
      UNION ALL
      SELECT 'Medianamente extendida', 4, 5
      UNION ALL
      SELECT 'Bastante extendida', 6, 7
      UNION ALL
      SELECT 'Muy extendida', 8, 10000) AS Tramos
JOIN (SELECT Lengua, COUNT(*) AS NumeroPaises
      FROM   LenguaPais
      WHERE  EsOficial = 'T'
      GROUP  BY Lengua) AS Datos
ON Datos.NumeroPaises BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior;

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
SELECT Tramos.NombreTramo AS 'Categorías', COUNT(Lengua) AS 'Número de lenguas'
FROM (SELECT 'Muy Poco extendida' AS 'NombreTramo', 0 AS 'LimiteInferior', 1 AS 'LimiteSuperior'
      UNION ALL
      SELECT 'Poco extendida', 2, 3
      UNION ALL
      SELECT 'Medianamente extendida', 4, 5
      UNION ALL
      SELECT 'Bastante extendida', 6, 7
      UNION ALL
      SELECT 'Muy extendida', 8, 10000
      UNION ALL
      SELECT 'Extramadamente extendida', 10000, 100000) AS Tramos
LEFT JOIN (
      SELECT Lengua, COUNT(*) AS NumeroPaises
      FROM   LenguaPais
      WHERE  EsOficial = 'T'
      GROUP  BY Lengua) AS Datos
ON Datos.NumeroPaises BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior
GROUP BY Tramos.LimiteInferior
ORDER BY Tramos.LimiteInferior;

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
    
-- 1. Crear la tabla de tramos
SELECT 'Gran recesión' AS 'NombreTramo', -1.00 AS 'LimiteInferior', 0.55 AS 'LimiteSuperior'
UNION ALL
SELECT 'Recesión' AS 'NombreTramo', 0.55 AS 'LimiteInferior', 0.85 AS 'LimiteSuperior'
UNION ALL
SELECT 'Estable' AS 'NombreTramo', 0.85 AS 'LimiteInferior', 1.15 AS 'LimiteSuperior'
UNION ALL
SELECT 'Crecimiento' AS 'NombreTramo', 1.15 AS 'LimiteInferior', 1.45 AS 'LimiteSuperior'
UNION ALL
SELECT 'Gran crecimiento' AS 'NombreTramo', 1.45 AS 'LimiteInferior', 10000.00 AS 'LimiteSuperior';

-- 2. Preparamos la tabla de datos
SELECT Codigo, PNB / PNBAnt AS IndiceCrecimiento
      FROM   Pais
      WHERE  PNB / PNBAnt IS NOT NULL;
      
-- 3. Las juntamos
SELECT Tramos.NombreTramo AS 'Categorías', Count(Datos.Codigo) AS 'Número de paises'
FROM (
SELECT 'Gran recesión' AS 'NombreTramo', -1.00 AS 'LimiteInferior', 0.55 AS 'LimiteSuperior'
UNION ALL
SELECT 'Recesión', 0.55, 0.85 
UNION ALL
SELECT 'Estable', 0.85, 1.15
UNION ALL
SELECT 'Crecimiento', 1.15, 1.45
UNION ALL
SELECT 'Gran crecimiento', 1.45, 10000.00) AS Tramos
LEFT JOIN (
     SELECT Codigo, PNB / PNBAnt AS IndiceCrecimiento
      FROM   Pais
      WHERE  PNB / PNBAnt IS NOT NULL) AS Datos
ON Datos.IndiceCrecimiento >= Tramos.LimiteInferior AND
   Datos.IndiceCrecimiento <= Tramos.LimiteSuperior
   GROUP BY Tramos.LimiteInferior
   ORDER BY Tramos.LimiteInferior;
   
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
SELECT   Continente, Region, COUNT(Ciudad.Id) AS 'Número de ciudades'
FROM     Pais LEFT JOIN Ciudad
ON       Pais.Codigo = Ciudad.CodigoPais
GROUP BY Continente, Region
ORDER BY NumeroDeCiudades DESC;   

SELECT 'Muy bajo' AS 'NombreTramo', 0 AS 'LimiteInferior', 10 AS 'LimiteSuperior'
UNION ALL
SELECT 'Bajo', 11, 100
UNION ALL
SELECT 'Medio', 101,200
UNION ALL
SELECT 'Alto', 201, 500
UNION ALL
SELECT 'Muy alto', 501, 10000000;

SELECT *
FROM (
    SELECT 'Muy bajo' AS 'NombreTramo', 0 AS 'LimiteInferior', 10 AS 'LimiteSuperior'
UNION ALL
SELECT 'Bajo', 11, 100
UNION ALL
SELECT 'Medio', 101, 200
UNION ALL
SELECT 'Alto', 201, 500
UNION ALL
SELECT 'Muy alto', 501, 10000000) AS Tramos
LEFT JOIN (
SELECT   Continente, Region, COUNT(Ciudad.Id) AS NumeroDeCiudades
FROM     Pais LEFT JOIN Ciudad
ON       Pais.Codigo = Ciudad.CodigoPais
GROUP BY Continente, Region) AS Datos
ON Datos.NumeroDeCiudades BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior;

SELECT Tramos.NombreTramo AS 'Número de ciudades', COUNT(Datos.Region) AS 'Número de regiones'
FROM (
    SELECT 'Muy bajo' AS 'NombreTramo', 0 AS 'LimiteInferior', 10 AS 'LimiteSuperior'
UNION ALL
SELECT 'Bajo', 11, 100
UNION ALL
SELECT 'Medio', 101, 200
UNION ALL
SELECT 'Alto', 201, 500
UNION ALL
SELECT 'Muy alto', 501, 10000000) AS Tramos
LEFT JOIN (
SELECT   Continente, Region, COUNT(Ciudad.Id) AS NumeroDeCiudades
FROM     Pais LEFT JOIN Ciudad
ON       Pais.Codigo = Ciudad.CodigoPais
GROUP BY Continente, Region) AS Datos
ON Datos.NumeroDeCiudades BETWEEN Tramos.LimiteInferior AND Tramos.LimiteSuperior
GROUP BY Tramos.LimiteInferior
ORDER BY Tramos.LimiteInferior;

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

SELECT CASE
        WHEN NumeroPaises <= 1            THEN 'Muy poco extendida'
        WHEN NumeroPaises BETWEEN 2 AND 3 THEN 'Poco extendida'
        WHEN NumeroPaises BETWEEN 4 AND 5 THEN 'Medianamente extendida'
        WHEN NumeroPaises BETWEEN 6 AND 7 THEN 'Bastante extendida'
        WHEN NumeroPaises >=8             THEN 'Muy extendida'
      END AS 'Categorías',
      COUNT(*) AS 'Número de lenguas'
FROM (SELECT Lengua, COUNT(*) AS NumeroPaises
      FROM   LenguaPais
      WHERE  EsOficial = 'T'
      GROUP BY Lengua) AS Datos
GROUP BY `Categorías`
ORDER BY `Categorías`;

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

SELECT DISTINCT Lengua AS 'Lenguas' 
FROM LenguaPais JOIN (
SELECT Pais.Codigo
FROM   Pais JOIN Ciudad
ON     Pais.Capital = Ciudad.Id
ORDER BY Ciudad.Poblacion DESC
LIMIT 10) AS CapitalesMasPobladas
ON LenguaPais.CodigoPais = CapitalesMasPobladas.Codigo
WHERE LenguaPais.EsOficial= 'T';

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
FROM Pais
GROUP BY Continente;  -- la corecta

SELECT Continente, SUM(PNB) - SUM(PNBAnt) AS 'Incremento PNB'
FROM Pais
GROUP BY Continente;

-- Código PNB  PNBAnt PNB–PNBAnt
-- ESP    10       5       5    
-- FRA    15      20      -5    
-- ITA     5    NULL       NULL 
-- -----------------------------
--        30      25       0      SUM(PNB) - SUM(PNBAnt)   = 5
--                                SUM(PNB – PNBAnt) = 0

-- 48.  De cada continente queremos saber el número medio de lenguas habladas por país, es decir, el número de lenguas que se hablan en el continente partido por el número de países de ese continente
SELECT Continente, COUNT(DISTINCT Lengua), COUNT(DISTINCT Codigo), ROUND(COUNT(DISTINCT Lengua) / COUNT(DISTINCT Codigo), 1)
FROM Pais LEFT JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
GROUP BY Continente;

SELECT Continente, ROUND(COUNT(DISTINCT Lengua) / COUNT(DISTINCT Codigo), 1) AS 'Lenguas por pais'
FROM Pais LEFT JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
GROUP BY Continente;  -- la consulta final

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
SELECT Pais.Nombre, COUNT(*) AS 'Número de ciudades'
FROM Pais JOIN Ciudad
ON Pais.Codigo = Ciudad.CodigoPais
GROUP BY Codigo
HAVING `Número de ciudades` > (
SELECT COUNT(*)
FROM Pais JOIN Ciudad
ON Pais.Codigo = Ciudad.CodigoPais
WHERE Pais.Nombre = 'Spain');

SELECT COUNT(*)
FROM Pais JOIN Ciudad
ON Pais.Codigo = Ciudad.CodigoPais
WHERE Pais.Nombre = 'Spain';

-- -----------------------------------------------------------------------------
-- Consultas de campos repetidas 
-- -----------------------------------------------------------------------------

-- Estructura de este tipo de consultas:
SELECT   Campo1, COUNT(*) AS 'Repeticiones' 
FROM     Tabla1 
GROUP BY Campo1
HAVING   `Repeticiones` > 1
ORDER BY `Repeticiones` DESC;

-- 50. Obtener un listado de ciudades repetidas en el que aparezca el nombre de la ciudad y el número de veces que está repetida ordenado de la ciudad más repetida a la menos
SELECT   Nombre AS 'Ciudad', COUNT(*) AS 'Repeticiones' 
FROM     Ciudad
GROUP BY Nombre
HAVING   `Repeticiones` > 1
ORDER BY `Repeticiones` DESC;

-- 51. Obtener un listado de países que tienen más de una ciudad con el mismo nombre indicando el nombre del país, el nombre de la ciudad y el número de veces que ese país tiene esa ciudad con el mismo nombre
SELECT   Pais.Nombre AS 'Pais', Ciudad.Nombre AS 'Ciudad', 
         COUNT(*) AS 'Repeticiones' 
FROM     Ciudad JOIN Pais
ON       Ciudad.CodigoPais = Pais.Codigo
GROUP BY Pais.Codigo, Ciudad.Nombre
HAVING   `Repeticiones` > 1
ORDER BY Pais.Codigo, `Repeticiones` DESC;

-- 52. Para cada zona de un país, obtener un listado de zonas de países que tienen más de una ciudad con el mismo nombre indicando el nombre del país, el nombre de la zona, el nombre de la ciudad y el número de veces que esa zona tiene esa ciudad con el mismo nombre
SELECT   Pais.Nombre AS 'Pais', Ciudad.Zona AS 'Zona',
         Ciudad.Nombre AS 'Ciudad', COUNT(*) AS 'Repeticiones' 
FROM     Ciudad JOIN Pais
ON       Ciudad.CodigoPais = Pais.Codigo
GROUP BY Pais.Codigo, Ciudad.Zona, Ciudad.Nombre
HAVING   `Repeticiones` > 1
ORDER BY `Repeticiones`;

-- 53. Listado de ciudades repetidas, número de países en las que se repite y número de veces que esa ciudad se repite ordenado según el número de países
-- en los que esa ciudad aparece de más a menos y según las repeticiones de esa ciudad
SELECT   Ciudad.Nombre AS 'Ciudad',
         COUNT(DISTINCT CodigoPais) AS 'Países en los que está',
         COUNT(*) AS 'Repeticiones'
FROM     Ciudad
GROUP BY Ciudad.Nombre
HAVING   `Repeticiones` > 1
ORDER BY `Países en los que está` DESC, `Repeticiones` DESC;

-- 54. Comprueba si hay algún registro repetido en la tabla ciudad
SELECT  *, COUNT(*) AS 'Repeticiones' 
FROM     (SELECT * FROM Ciudad
          UNION ALL
          SELECT 1, 'Kabul', 'AFG', 'Kabol', 1780000) AS NuevasCiudades
GROUP BY ID, Nombre, CodigoPais, Zona, Poblacion
HAVING   `Repeticiones` > 1;

CREATE VIEW NuevasCiudades AS
    SELECT * FROM Ciudad
    UNION ALL
    SELECT 1, 'Kabul', 'AFG', 'Kabol', 1780000;
    
SELECT   *, COUNT(*) AS 'Repeticiones' 
FROM      NuevasCiudades
GROUP BY ID, Nombre, CodigoPais, Zona, Poblacion
HAVING   `Repeticiones` > 1;

-- -----------------------------------------------------------------------------
-- Consultas de registros aleatorios
-- -----------------------------------------------------------------------------
SELECT Nombre
FROM Pais
ORDER BY RAND() 
LIMIT 5; -- cada vez genera 5 paises aleatorias

-- 55. Obtener cinco ciudades junto con su población y el país al que pertenecen de manera aleatoria
SELECT Ciudad.Nombre AS 'Ciudad', Pais.Poblacion, Pais.Nombre AS 'Pais'
FROM Pais JOIN Ciudad
ON Pais.Codigo = Ciudad.CodigoPais
ORDER BY RAND() 
LIMIT 5;


--
SELECT ROUND(RAND() * 4078) + 1;

SELECT *
FROM Ciudad
WHERE Id = (SELECT TRUNCATE(RAND() * 4079, 0) + 1);

SELECT *, (SELECT TRUNCATE(RAND() * 4079, 0) + 1)
FROM Ciudad;

-- 56. Obtener todos los países de dos regiones aleatorias

SELECT Nombre AS 'Pais', Pais.Region AS 'Region'
FROM    Pais JOIN (
        SELECT DISTINCT Region 
        FROM Pais
        ORDER BY RAND()
        LIMIT 2) AS DosRegionesAleatorias
ON Pais.Region = DosRegionesAleatorias.Region
ORDER BY Region;

SELECT DISTINCT Region 
FROM Pais
ORDER BY RAND()
LIMIT 2;

-- -----------------------------------------------------------------------------
-- Fin del tema 
-- -----------------------------------------------------------------------------

