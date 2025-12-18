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
        )

-- 15. Listado de continentes que no tienen ninguna ciudad
SELECT  DISTINCT Continente
FROM    Pais PaisExterno
WHERE   NOT EXISTS (
            SELECT  1
            FROM    Ciudad JOIN Pais 
            ON      Ciudad.CodigoPais = Pais.Codigo
            WHERE   Continente = PaisExterno.Continente
        )


-- 16. Listado de zonas con alguna ciudad de m�s de 5 millones habitantes. Poner las dos soluciones: COUNT(*) y EXISTS
SELECT  DISTINCT Continente
FROM    Ciudad CExt
WHERE   Poblacion (
            SELECT  1
            FROM    Ciudad 
            WHERE   Poblacion 
        )


SELECT  DISTINCT Zona
FROM    Pais PaisExterno
WHERE   EXISTS (
            SELECT  1
            FROM    Ciudad JOIN Pais 
            ON      Ciudad.CodigoPais = Pais.Codigo
            WHERE   Continente = PaisExterno.Continente
        )