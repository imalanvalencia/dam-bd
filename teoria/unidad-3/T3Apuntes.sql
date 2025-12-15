-- ----------------------------------------------------------------------------------------
-- Ejercicio: indica qu� consultas son correlacionadas, no correlacionadas o err�neas
-- ----------------------------------------------------------------------------------------

SELECT Nombre           -- Correlacionada
FROM   Pais
WHERE  EXISTS(
       SELECT *         
       FROM LenguaPais
       WHERE CodigoPais = Codigo); -- Poner nombre de tablas Pais.Codigo
      
SELECT Nombre           -- No Correlacionada (Independiente)
FROM   Pais
WHERE  EXISTS(
       SELECT *         
       FROM LenguaPais
       WHERE CodigoPais = 'AFG');
      
SELECT Nombre           -- Erronea
FROM   Pais
WHERE  EXISTS(
       SELECT *           
       FROM LenguaPais
       WHERE CodigoPais = Ciudad.Id);      

SELECT Lengua           -- Correlacionada
FROM   LenguaPais JOIN Pais
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE (SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais = Pais.Codigo)
             > 100 AND EsOficial = 'T';
            
SELECT Lengua           -- No Correlacionada
FROM   LenguaPais JOIN Pais
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE (SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais > 'JJJ')
             > 100 AND EsOficial = 'T';
            
SELECT Nombre AS 'Pais' -- Erronea
FROM   Pais
WHERE (SELECT SUM(Ciudad.Poblacion)
       FROM Ciudad
       WHERE Poblacion = LenguaPais.Porcentaje)
             > Pais.Poblacion;

-- -----------------------------------------------------------------------------
-- Ejecuci�n de una consulta correlacionada
-- -----------------------------------------------------------------------------

SELECT Nombre AS Pais        -- 189 Registros
FROM   Pais
WHERE  AnyIndep / 4 > (
       SELECT COUNT(*)
       FROM Ciudad
       WHERE Ciudad.CodigoPais = Pais.Codigo);


-- 1. Nombre de los pa�ses en los que se hablan exactamente dos lenguas
SELECT  Nombre 
FROM    Pais 
WHERE   (
            SELECT  COUNT(*) 
            FROM    LenguaPais 
            WHERE   LenguaPais.CodigoPais = Pais.Codigo
        ) = 2;

-- 2. Nombre de los pa�ses que tienen dos o m�s ciudades con dos millones de habitantes como m�nimo

SELECT  Nombre 
FROM    Pais 
WHERE   (
            SELECT  COUNT(*) 
            FROM    Ciudad 
            WHERE   Ciudad.CodigoPais = Pais.Codigo 
                    AND Ciudad.Poblacion >= 2000000
        ) >= 2;

-- 3. Para detectar posibles errores en nuestra base de datos vamos a ver si existe alguna ciudad que sea ciudad de m�s de un pa�s a la vez

-- No se puede hacer

-- 4. Para detectar posibles errores en nuestra base de datos vamos a ver si existe alguna ciudad que sea capital de m�s de un pa�s a la vez

-- Podemos crear un pa�s ficticio con una capital duplicada para comprobar que nuestra consulta funciona:
INSERT INTO Pais VALUES ('XXX','Spain2','Europe','SE',5,1492,3,7,5,5,'Espa�ist�n','XX','XX',653,'ES');

SELECT  COUNT(*)
FROM    Ciudad
WHERE   (
                SELECT COUNT(*)
                FROM Pais
                WHERE Pais.Capital = Ciudad.Id
        ) > 1;

DELETE FROM Pais WHERE Codigo='XXX';