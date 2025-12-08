/*
Bases de Datos
Tema 2. Ejercicios de SQL avanzado I
Realiza las siguientes consultas SQL
Nombre: Alan Smith Valencia Izquierdo
Grupo: DAM 1-B Doctor Balmis

Deber�s entregar el resultado en un documento .sql (puedes usar este mismo documento)
Se valorar� adem�s de que las soluci�n de los ejercicios sea correcta, la correcta indentaci�n,
los comentarios en el c�digo, nombres de columna correctos y la claridad del c�digo en general.
Procura que en tu c�digo no haya tabuladores, s�lo espacios en blanco. Puedes ejecutar:
Men� > Configuraci�n > Preferencias > Lenguajes > Tabuladores > (Tama�o: 4 y Indent using: Tab Character) y
Men� > Editar > Operciones de limpieza > TAB a espacio
Recuerda que no se puede copiar y pegar de ning�n compa�ero. Ni si quiera un trozo peque�o
Se puede usar una IA para resolver dudas concretas, por ejemplo, podemos preguntar a una IA:
�C�mo puedo obtener el siguiente car�cter de un car�cter en MySQL?
, pero no pedir a una IA que resuelva el ejercicio

An�lisis de los nulos: realizaremos el mismo an�lisis de nulos hecho en clase.
*/
-- --------------------------------------------------------------------------------------
-- Consulta 1. Indica si hay alg�n Pais sin capital
SELECT Nombre AS 'Paises sin capital'
FROM   Pais 
WHERE  Capital IS NULL;

-- --------------------------------------------------------------------------------------
-- Consulta 2. Nombre del Pais y nombre de la capital de los Paises que tienen capital
SELECT Pais.Nombre AS 'Pais', Ciudad.Nombre AS 'Capital'
FROM   Pais JOIN Ciudad
ON     Ciudad.Id = Pais.Capital;

-- --------------------------------------------------------------------------------------
-- Consulta 3. Nombre de todos los Paises junto con el nombre de su capital
SELECT Pais.Nombre AS 'Pais', Ciudad.Nombre AS 'Capital'
FROM   Pais LEFT JOIN Ciudad
ON     Ciudad.Id = Pais.Capital;

-- --------------------------------------------------------------------------------------
-- Consulta 4. Explica el resultado de esta consulta. Elabora un enunciado:
SELECT Ciudad.Nombre AS 'Ciudad', Pais.Nombre AS 'Pais' 
FROM   Ciudad LEFT JOIN Pais 
ON     Ciudad.Id = Pais.Capital; -- FALTA ';'
-- Resultado: 4079 registros

-- Los registros resultantes seran las relaciones y las no relaciones que tiene la tabla Pais(tabla izquierda) con respecto a la tabla Ciudad(tabla derecha) los registro sin ninguna conicidencia seran NULL; en este caso se busca relacionar las ciudades con sus paises y saber cuales son sus capitales

-- --------------------------------------------------------------------------------------
-- Consulta 5. Explica el resultado de esta consulta. Elabora un enunciado:
SELECT Ciudad.Nombre AS 'Ciudad', Pais.Nombre AS 'Pais' 
FROM   Ciudad LEFT JOIN Pais 
ON     Ciudad.CodigoPais = Pais.Codigo; -- FALTA ';'
-- Resultado: 4079 registros

-- Los registros resultantes seran las relaciones y las no relaciones que tiene la tabla ciudad(tabla izquierda) con respecto a la tabla pais(tabla derecha) los registro sin ninguna conicidencia seran NULL; en este caso se busca saber a que pais pertenece cada ciudad

-- --------------------------------------------------------------------------------------
-- Consulta 6. Nombre de las ciudades que no son capital de ning�n Pais
SELECT  Ciudad.Nombre AS 'Ciudades que no son capital'
FROM    Ciudad LEFT JOIN Pais
ON      Ciudad.Id = Pais.Capital
WHERE   Pais.Codigo IS NULL;

-- --------------------------------------------------------------------------------------
-- Consulta 7. Nombre de las ciudades y nombre del Pais al que pertenecen de las ciudades que no son capital de ning�n Pais.
SELECT  Ciudad.Nombre AS 'Ciudad', Pais.Nombre AS 'Pais' 
FROM    Ciudad JOIN Pais
ON      Ciudad.CodigoPais = Pais.Codigo
WHERE   Pais.Capital <> Ciudad.Id;

-- --------------------------------------------------------------------------------------
-- Consulta 8. Nombre de las lenguas junto con el Pais en el que se hablan
SELECT Lengua, Nombre AS 'Pais' 
FROM   LenguaPais JOIN Pais 
ON     LenguaPais.CodigoPais = Pais.Codigo;

-- --------------------------------------------------------------------------------------
-- Consulta 9. Nombre de todas las lenguas junto con el Pais en el que se hablan
SELECT Lengua, Nombre AS 'Pais' 
FROM   LenguaPais LEFT JOIN Pais 
ON     LenguaPais.CodigoPais = Pais.Codigo;

-- --------------------------------------------------------------------------------------
-- Consulta 10. Nombre de todos los Paises junto con las lenguas que se hablan en ese Pais.
SELECT Nombre AS 'Pais', Lengua
FROM   Pais LEFT JOIN LenguaPais
ON     LenguaPais.CodigoPais = Pais.Codigo AND Nombre IS NULL;

-- --------------------------------------------------------------------------------------
-- Consulta 11. Nombre de las lenguas que no tienen asignado ning�n Pais.
SELECT Lengua
FROM   LenguaPais LEFT JOIN Pais 
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE  Pais.Codigo IS NULL;
-- --------------------------------------------------------------------------------------
-- Consulta 12. Nombre de los Paises que no tienen asignada ninguna lengua.
SELECT Nombre AS 'Pais', Lengua
FROM   Pais LEFT JOIN LenguaPais
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE  LenguaPais.Lengua IS NULL;


-- --------------------------------------------------------------------------------------
-- Consulta 13. Listado de ciudades que pertenecen a Paises que tienen lenguas oficiales que s�lo son habladas por menos de un 10% de la poblaci�n.
SELECT DISTINCT Nombre
FROM   Ciudad  JOIN LenguaPais
ON     Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  EsOficial = 'T' AND Porcentaje < 10;


-- --------------------------------------------------------------------------------------
-- Consulta 14. Listado de capitales que pertenecen a Paises que tienen lenguas oficiales que s�lo son habladas por menos de un 10% de la poblaci�n.
SELECT DISTINCT Ciudad.Nombre
FROM   Ciudad JOIN LenguaPais JOIN Pais
ON     Ciudad.Id = Pais.Capital AND 
       Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  EsOficial = 'T' AND Porcentaje < 10;

-- --------------------------------------------------------------------------------------
-- Consulta 15. Para detectar posibles errores en la base de datos queremos realizar la siguiente consulta: listado de ciudades y Paises en los que la poblaci�n de la ciudad sea mayor que la del Pais al que pertenece. Analiza el resultado.
SELECT Ciudad.Nombre AS 'Ciudad', Pais.Nombre AS 'Pais'
FROM   Ciudad JOIN Pais
ON     Ciudad.CodigoPais = Pais.Codigo
WHERE  Ciudad.Poblacion > Pais.Poblacion;
-- Resultado: 2 registros

-- Aparecen las ciudades Singapore y Gibraltar  y puede ser que la bases de datos tenga datos eroneos y que no se en un sola fuente de la verdad, o que se actualice un datos y no tener en cuenta el otro, ...

SELECT Ciudad.Nombre AS 'Ciudad', Pais.Nombre AS 'Pais', Ciudad.Poblacion, Pais.Poblacion
FROM   Ciudad JOIN Pais
ON     Ciudad.CodigoPais = Pais.Codigo
WHERE  Pais.Nombre IN ('Gibraltar', 'Singapore');


-- --------------------------------------------------------------------------------------
-- Consulta 16. Listado de las lenguas habladas en Paises con m�s de doscientos millones de habitantes.
SELECT DISTINCT Lengua
FROM   Ciudad  JOIN LenguaPais
ON     Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  Poblacion > 200000000;

-- --------------------------------------------------------------------------------------
-- Consulta 17. Capitales de Paises en los que el ingl�s sea lengua oficial.
SELECT Ciudad.Nombre
FROM   Ciudad JOIN LenguaPais JOIN Pais
ON     Ciudad.Id = Pais.Capital AND Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  EsOficial = 'T' AND Lengua = 'English';

-- --------------------------------------------------------------------------------------
-- Consulta 18. Capitales de los Paises en los que el ingl�s sea lengua oficial y el Pais tenga m�s de un mill�n de habitantes y la capital m�s de 200 mil habitantes.
SELECT Ciudad.Nombre
FROM   Ciudad JOIN LenguaPais JOIN Pais
ON     Ciudad.Id = Pais.Capital AND Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  EsOficial = 'T'
       AND Lengua = 'English'
       AND Pais.Poblacion > 1000000
       AND Ciudad.Poblacion > 200000;

-- --------------------------------------------------------------------------------------
-- Consulta 19. Capitales y lenguas de Paises que tienen una densidad de poblaci�n mayor que mil habitantes por kil�metro cuadrado ordenados de mayor a menor densidad de poblaci�n.
SELECT      DISTINCT Ciudad.Nombre, Lengua
FROM        Ciudad JOIN LenguaPais JOIN Pais
ON          Ciudad.Id = Pais.Capital AND 
            Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE       Pais.Poblacion / Pais.Superficie > 1000 
            AND Pais.Poblacion / Pais.Superficie IS NOT NULL
ORDER BY    Pais.Poblacion / Pais.Superficie DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 20. Como sustituto de la orden FULL JOIN que no est� en MySQL, podemos usar UNION. Listado de ciudades y Paises en el que aparezcan todas las ciudades, aunque no pertenezcan a ning�n Pais y todos los Paises, aunque no tengan ninguna ciudad.
SELECT  Ciudad.Nombre AS 'Ciudad', Pais.Nombre AS 'Pais'
FROM    Ciudad LEFT JOIN Pais
ON      Ciudad.CodigoPais = Pais.Codigo
UNION DISTINCT
SELECT  Ciudad.Nombre AS 'Ciudad', Pais.Nombre AS 'Pais'
FROM    Pais LEFT JOIN Ciudad
ON      Ciudad.CodigoPais = Pais.Codigo;

-- Primera parte → LEFT JOIN: todas las ciudades, aunque no tengan país.
-- Segunda parte → LEFT JOIN: todos los países, aunque no tengan ciudad.

-- --------------------------------------------------------------------------------------
-- Consulta 21. Convierte la siguiente consulta a MySQL. Como no tenemos la BD no se puede ejecutar.
SELECT Productos.Nombre AS 'Productos', Categoria.Descripcion AS 'Categor�as'
FROM   Productos FULL JOIN Categorias
ON     Productos.IdCategoria = Categorias.Id;

SELECT  Productos.Nombre AS 'Productos', Categorias.Descripcion AS 'Categorías'
FROM    Productos LEFT JOIN Categorias 
ON      Productos.IdCategoria = Categorias.Id
UNION DISTINCT
SELECT  Productos.Nombre AS 'Productos', Categorias.Descripcion AS 'Categorías'
FROM    Categorias LEFT JOIN Productos 
ON      Productos.IdCategoria = Categorias.Id;

-- --------------------------------------------------------------------------------------
-- Consulta 22. Definimos �ndice de densidad alfab�tica como la poblaci�n de un Pais o ciudad dividido entre el n�mero de letras del nombre del Pais o ciudad. El �ndice de las ciudades est� multiplicado por 10. Listado de los 20 Paises o ciudades con mayor �ndice de densidad alfab�tica y su �ndice. Todo ordenado por su �ndice. Queremos saber cu�ndo se trata de un Pais o de una ciudad.
SELECT  Nombre AS Entidad,
        Poblacion / CHAR_LENGTH(Nombre) AS Indice,
       'Pais' AS Tipo
FROM    Pais
UNION ALL
SELECT  Nombre AS Entidad,
        (Poblacion  / CHAR_LENGTH(Nombre))* 10 AS Indice,
        'Ciudad' AS Tipo
FROM    Ciudad

ORDER BY `Indice` DESC
LIMIT 20;

-- --------------------------------------------------------------------------------------
-- Consulta 23. Listado de los diez Paises con mayor densidad de poblaci�n junto con las diez lenguas habladas por m�s poblaci�n en su Pais; todo ordenado alfab�ticamente. Queremos saber cu�ndo se trata de un Pais y cu�ndo se trata de una lengua.
(SELECT  Nombre AS 'Respuesta', 'Pais' AS Tipo
FROM    Pais
ORDER BY Poblacion / Superficie DESC
LIMIT 10)
UNION ALL
(SELECT  Lengua AS 'Respuesta', 'Lengua' AS Tipo
FROM    LenguaPais JOIN Pais 
ON      LenguaPais.CodigoPais = Pais.Codigo
ORDER BY Pais.Poblacion DESC
LIMIT 10)

ORDER BY `Respuesta`;

-- --------------------------------------------------------------------------------------
-- Consulta 24. Listado del nombre de los Paises que se independizaron el mismo a�o que Somalia (con c�digo de Pais SOM)
SELECT Count(*) FROM Pais WHERE Codigo = 'SOM'; -- Debe dar 1 para ejecutar la consulta principal

SELECT AnyIndep FROM Pais WHERE Codigo = 'SOM';

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   AnyIndep = (
            SELECT AnyIndep 
            FROM    Pais 
            WHERE   Codigo = 'SOM'
            LIMIT   1
        );

-- --------------------------------------------------------------------------------------
-- Consulta 25. Listado del nombre de los Paises que se independizaron el mismo a�o que Somalia (con c�digo de Pais SOM). Nota: quita del listado a Somalia, que ya sabemos que se independiz� ese a�o.
SELECT Count(*) FROM Pais WHERE Codigo = 'SOM'; -- Debe dar 1 para ejecutar la consulta principal

SELECT AnyIndep FROM Pais WHERE Codigo = 'SOM';

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   AnyIndep = (
            SELECT  AnyIndep 
            FROM    Pais 
            WHERE   Codigo = 'SOM'
            LIMIT   1)
        AND Codigo <> 'SOM';

-- --------------------------------------------------------------------------------------
-- Consulta 26. Listado de Paises y su poblaci�n que tienen una poblaci�n mayor que la de Espa�a y menor que la de Francia, ordenado por poblaci�n.
SELECT (
        SELECT COUNT(*) = 1
        FROM Pais
        WHERE Nombre = 'Spain') 
    AND (
        SELECT COUNT(*) = 1
        FROM Pais
        WHERE Nombre = 'France'
    ) AS Validacion; -- Debe dar TRUE para ejecutar la consulta principal

SELECT Poblacion FROM Pais WHERE Nombre = 'Spain';
SELECT Poblacion FROM Pais WHERE Nombre = 'France';

SELECT  Nombre AS 'Pais', Poblacion
FROM    Pais
WHERE   Poblacion > (
            SELECT  Poblacion
            FROM    Pais
            WHERE   Nombre = 'Spain'
            LIMIT   1
        )
        AND Poblacion < (
            SELECT  Poblacion
            FROM    Pais
            WHERE   Nombre = 'France'
            LIMIT   1
        )

ORDER BY Poblacion;

-- --------------------------------------------------------------------------------------
-- Consulta 27. Listado de ciudades que tienen una poblaci�n mayor que la de Irlanda (con c�digo de Pais IRL)
SELECT COUNT(*) = 1 FROM Pais WHERE Codigo = 'IRL'; -- Debe dar TRUE para ejecutar la consulta principal

SELECT Poblacion FROM Pais WHERE Codigo = 'IRL';

SELECT  Nombre AS 'Ciudad'
FROM    Ciudad 
WHERE   Poblacion > (
            SELECT  Poblacion 
            FROM    Pais 
            WHERE   Codigo = 'IRL'
        );

-- --------------------------------------------------------------------------------------
-- Consulta 28. Listado de capitales que tienen una poblaci�n mayor que la de Irlanda (con c�digo de Pais IRL)
SELECT COUNT(*) = 1 FROM Pais WHERE Codigo = 'IRL'; -- Debe dar TRUE para ejecutar la consulta principal

SELECT Poblacion FROM Pais WHERE Codigo = 'IRL';

SELECT  Ciudad.Nombre AS 'Capital'
FROM    Ciudad JOIN Pais
ON      Ciudad.Id = Pais.Capital
WHERE   Ciudad.Poblacion > (
            SELECT  Poblacion 
            FROM    Pais 
            WHERE   Codigo = 'IRL'
            LIMIT   1
        );

-- --------------------------------------------------------------------------------------
-- Consulta 29. Listado de capitales que tienen una poblaci�n diez veces mayor que la capital de Irlanda (con nombre en la BD: 'Ireland')
SELECT  COUNT(*) = 1 AS 'Capital'
FROM    Ciudad JOIN Pais
ON      Ciudad.Id = Pais.Capital 
WHERE   Pais.Nombre = 'Ireland'; -- Debe dar TRUE para ejecutar la consulta principal

SELECT  Ciudad.Poblacion
FROM    Ciudad JOIN Pais
ON      Ciudad.Id = Pais.Capital 
WHERE   Pais.Nombre = 'Ireland';

SELECT  Ciudad.Nombre AS 'C'
FROM    Ciudad JOIN Pais
ON      Ciudad.Id = Pais.Capital
WHERE   Ciudad.Poblacion * 10 > (
            SELECT  Ciudad.Poblacion
            FROM    Ciudad JOIN Pais
            ON      Ciudad.Id = Pais.Capital 
            WHERE   Pais.Nombre = 'Ireland'
            LIMIT   1
        );

-- Consulta 30. Listado de Paises en los que la lengua inglesa es oficial y se habla con un porcentaje mayor que el que el ingl�s tiene en Canad� (con c�digo de Pais CAN).
SELECT  COUNT(*) = 1
FROM    LenguaPais 
WHERE   CodigoPais = 'CAN' 
        AND Lengua = 'English'; -- Debe dar TRUE para ejecutar la consulta principal

SELECT  Porcentaje
FROM    LenguaPais 
WHERE   CodigoPais = 'CAN' 
        AND Lengua = 'English';

SELECT  Nombre AS 'Pais'
FROM    LenguaPais JOIN Pais
ON      LenguaPais.CodigoPais = Pais.Codigo
WHERE   LenguaPais.Porcentaje > (
            SELECT  Porcentaje
            FROM    LenguaPais 
            WHERE   CodigoPais = 'CAN' 
                    AND Lengua = 'English'
            LIMIT   1
        )
        AND LenguaPais.Lengua =  'English'
        AND LenguaPais.EsOficial = 'T';


-- --------------------------------------------------------------------------------------
-- Consulta 31. Listado de Paises, su esperanza de vida y su densidad de poblaci�n cuya esperanza de vida es mayor que la de Espa�a (C�digo de Pais ESP) y cuya densidad de poblaci�n es mayor que la de Jap�n (con c�digo de Pais JPN); ordenado por esperanza de vida (de mayor a menor) y por densidad de poblaci�n, tambi�n de mayor a menor.
SELECT (
        SELECT  COUNT(*) = 1
        FROM    Pais
        WHERE   Codigo = 'ESP'
    )
    AND (
        SELECT  COUNT(*) = 1
        FROM    Pais
        WHERE   Codigo = 'JPN'
    ) AS 'Validacion';
-- Debe dar TRUE para ejecutar la consulta principal


SELECT EsperanzaVida
FROM   Pais
WHERE  Codigo = 'ESP';

SELECT Poblacion / Superficie
FROM Pais
WHERE Codigo = 'JPN';

SELECT  Nombre AS 'Pais',
        EsperanzaVida AS 'Esperanza de Vida',
        Poblacion / Superficie AS 'Densidad'
FROM    Pais
WHERE   EsperanzaVida > (
            SELECT  EsperanzaVida
            FROM    Pais
            WHERE   Codigo = 'ESP'
            LIMIT   1
        )
        AND (Poblacion / Superficie) > (
                SELECT  Poblacion / Superficie
                FROM    Pais
                WHERE   Codigo = 'JPN'
                LIMIT   1
        )
ORDER BY EsperanzaVida DESC, 'Densidad' DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 32. Paises que tienen una poblaci�n menor que la poblaci�n de la capital m�s poblada.
SELECT  MAX(Ciudad.Poblacion)
FROM    Pais JOIN Ciudad 
ON      Pais.Capital = Ciudad.Id;

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   Poblacion < (
            SELECT  MAX(Ciudad.Poblacion)
            FROM    Pais JOIN Ciudad 
            ON      Pais.Capital = Ciudad.Id
        );

-- --------------------------------------------------------------------------------------
-- Consulta 33. Paises que tienen una poblaci�n mayor que la media.
SELECT AVG(Poblacion) FROM Pais;

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   Poblacion > (SELECT AVG(Poblacion) FROM Pais);

-- --------------------------------------------------------------------------------------
-- Consulta 34. Paises que tienen una poblaci�n menor que la poblaci�n media de las ciudades.
SELECT AVG(Poblacion) FROM Pais;

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   Poblacion < (SELECT AVG(Poblacion) FROM Pais);

-- --------------------------------------------------------------------------------------
-- Consulta 35. Paises que tienen mayor poblaci�n que la suma de las poblaciones de todas las ciudades de Brasil (con c�digo de Pais BRA)
SELECT  SUM(Poblacion)
FROM    Ciudad
WHERE   CodigoPais = 'BRA';


SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   Poblacion > (
            SELECT SUM(Poblacion)
            FROM Ciudad
            WHERE CodigoPais = 'BRA'
        );

-- --------------------------------------------------------------------------------------
-- Consulta 36. Paises que tienen mayor poblaci�n que la suma de las poblaciones de todas las ciudades de Brasil. No usaremos el c�digo del Pais, sino su nombre. Nota: hay dos soluciones, usando JOIN y sin usarlo. Pon las dos soluciones.

-- subconsulta Con JOIN
SELECT  SUM(Ciudad.Poblacion)
FROM    Ciudad JOIN Pais 
ON      Ciudad.CodigoPais = Pais.Codigo
WHERE   Pais.Nombre = 'Brazil';

-- subconsulta SIN JOIN
SELECT  SUM(Poblacion)
FROM    Ciudad
WHERE   CodigoPais = (
            SELECT Codigo
            FROM Pais
            WHERE Nombre = 'Brazil'
            LIMIT 1
        );


SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   Poblacion > (
            SELECT  SUM(Ciudad.Poblacion)
            FROM    Ciudad JOIN Pais 
            ON      Ciudad.CodigoPais = Pais.Codigo
            WHERE   Pais.Nombre = 'Brazil'
        );



-- --------------------------------------------------------------------------------------
-- Consulta 37. Paises con una superficie mayor que el mayor Pais de �frica ('Africa' en la BD).
SELECT MAX(Superficie)
FROM Pais
WHERE Continente = 'Africa';


SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   Superficie > (
            SELECT MAX(Superficie)
            FROM Pais
            WHERE Continente = 'Africa'
        );

-- --------------------------------------------------------------------------------------
-- Consulta 38. Paises que tienen un a�o de independencia igual que el de los Paises cuya capital empieza por C.
SELECT  Pais.AnyIndep
FROM    Pais JOIN Ciudad 
ON      Pais.Capital = Ciudad.Id
WHERE   Ciudad.Nombre LIKE 'C%'; -- Podrian haber nulos pero con ANY o IN NO AFECTA LA CONSULTA

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   AnyIndep IN /* = ANY */ (
            SELECT  DISTINCT AnyIndep
            FROM    Pais JOIN Ciudad 
            ON      Pais.Capital = Ciudad.Id
            WHERE   Ciudad.Nombre LIKE 'C%' 
                    AND AnyIndep IS NOT NULL
        );

-- --------------------------------------------------------------------------------------
-- Consulta 39. Paises que tienen un a�o de independencia mayor que el de alguno de los Paises cuya capital empieza por C. Nota: obtener las dos soluciones (ANY-ALL-IN y MAX-MIN)
-- CON ANY
SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   AnyIndep > ANY (
            SELECT  DISTINCT AnyIndep
            FROM    Pais JOIN Ciudad 
            ON      Pais.Capital = Ciudad.Id
            WHERE   Ciudad.Nombre LIKE 'C%' -- HAY NULOS PERO NO AFECTAN NEGATIVAMENTE
        );

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   AnyIndep > (
            SELECT  MIN(AnyIndep)
            FROM    Pais JOIN Ciudad 
            ON      Pais.Capital = Ciudad.Id
            WHERE   Ciudad.Nombre LIKE 'C%'
        );

-- --------------------------------------------------------------------------------------
-- Consulta 40. Paises que tienen un a�o de independencia igual que el de los Paises en los que el ingl�s es lengua oficial.
SELECT  CodigoPais
FROM    LenguaPais 
WHERE   EsOficial = 'T' AND Lengua = 'English';

SELECT  AnyIndep
FROM    Pais 
WHERE   Codigo IN (
            SELECT  DISTINCT CodigoPais
            FROM    LenguaPais 
            WHERE   EsOficial = 'T' AND Lengua = 'English'
        );

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   AnyIndep = ANY (
            SELECT DISTINCT AnyIndep
            FROM    Pais 
            WHERE   Codigo IN (
                        SELECT  DISTINCT CodigoPais
                        FROM    LenguaPais 
                        WHERE   EsOficial = 'T' AND Lengua = 'English'
                    )
        );

-- --------------------------------------------------------------------------------------
-- Consulta 41. Paises que tienen un a�o de independencia distinto del de los Paises del continente Africano.
SELECT COUNT(*) > 0 FROM Pais WHERE Continente = 'Africa'; -- Debe dar TRUE para ejecutar la consulta principal


SELECT Nombre AS 'Pais'
FROM Pais
WHERE AnyIndep <> ALL (
    SELECT DISTINCT AnyIndep
    FROM Pais
    WHERE Continente = 'Africa'
);

-- --------------------------------------------------------------------------------------
-- Consulta 42. Paises con un a�o de independencia distinto que el de los Paises con capitales de m�s de un mill�n de habitantes.
SELECT  COUNT(*) > 0 
FROM    Pais JOIN Ciudad 
ON      Pais.Capital = Ciudad.Id 
WHERE   Ciudad.Poblacion > 1000000; -- Debe dar TRUE para ejecutar la consulta principal

SELECT  Nombre AS 'Pais'
FROM    Pais
WHERE   AnyIndep <> ALL (
            SELECT  DISTINCT Pais.AnyIndep
            FROM    Pais JOIN Ciudad 
            ON      Pais.Capital = Ciudad.Id 
            WHERE   Ciudad.Poblacion > 1000000
        );

-- --------------------------------------------------------------------------------------
-- Consulta 43. N�mero e Paises que no tienen ninguna ciudad.
SELECT  COUNT(*) AS 'Paises sin ciudades'
FROM    Pais LEFT JOIN Ciudad
ON      Pais.Codigo = Ciudad.CodigoPais
WHERE   Ciudad.Id IS NULL;

-- --------------------------------------------------------------------------------------
-- Consulta 44. Listado de parejas de Paises que no se han independizado de manera que en el Pais de la izquierda se ha incrementado el PNB y en el de la derecha se ha decrementado.
-- FORMA 1
SELECT  A.Nombre AS 'Pais con PNB incrementado', B.Nombre AS 'Pais con PNB decrementado'
FROM    Pais AS A JOIN Pais AS B
WHERE   A.AnyIndep IS NULL 
        AND B.AnyIndep IS NULL 
        AND A.PNBAnt < A.PNB 
        AND B.PNBAnt > B.PNB;

-- FORMA 2
SELECT  A.Nombre AS 'Pais con PNB incrementado',
        B.Nombre AS 'Pais con PNB decrementado'
FROM (
    SELECT  Nombre
    FROM    Pais
    WHERE   AnyIndep IS NULL 
            AND PNBAnt < PNB
) AS A,
(
    SELECT  Nombre
    FROM    Pais
    WHERE   AnyIndep IS NULL 
            AND PNBAnt > PNB
) AS B;


-- --------------------------------------------------------------------------------------
-- Consulta 45. Paises cuya lengua oficial es distinta de la lengua oficial de todos los Paises del continente africano
SELECT  DISTINCT Lengua
FROM    Pais JOIN LenguaPais
ON      Pais.Codigo = LenguaPais.CodigoPais
WHERE   EsOficial = 'T' 
        AND Continente = 'Africa';

SELECT  COUNT(*) > 0
FROM    Pais JOIN LenguaPais
ON      Pais.Codigo = LenguaPais.CodigoPais
WHERE   EsOficial = 'T' 
        AND Continente = 'Africa'; -- Debe dar TRUE para continuar con la consulta principal

SELECT  Nombre AS 'Pais'
FROM    Pais JOIN LenguaPais
ON      Pais.Codigo = LenguaPais.CodigoPais
WHERE   EsOficial = 'T' 
        AND Lengua NOT IN /* <> ALL */ (
            SELECT  DISTINCT Lengua
            FROM    Pais JOIN LenguaPais
            ON      Pais.Codigo = LenguaPais.CodigoPais
            WHERE   EsOficial = 'T' 
                    AND Continente = 'Africa'
        );

-- --------------------------------------------------------------------------------------
-- Consulta 46. Definimos el c�digo de una ciudad como la primera letra de su nombre m�s la primera letra de su zona. Obtener un listado de ciudades cuyo c�digo es distinto del c�digo de todas las ciudades Europeas
SELECT  CONCAT(LEFT(Ciudad.Nombre, 1), LEFT(Ciudad.Zona, 1)) 
FROM    Ciudad JOIN Pais 
ON      Ciudad.CodigoPais = Pais.Codigo
WHERE   Pais.Continente = 'Europe';

SELECT  COUNT(*) > 0
FROM    Ciudad JOIN Pais 
ON      Ciudad.CodigoPais = Pais.Codigo
WHERE   Pais.Continente = 'Europe'; -- Debe dar TRUE para continuar con la consulta principal

SELECT  Nombre AS 'Ciudad'
FROM    Ciudad
WHERE   CONCAT(LEFT(Nombre, 1), LEFT(Zona, 1)) <> ALL (
            SELECT  CONCAT(LEFT(Ciudad.Nombre, 1), LEFT(Ciudad.Zona, 1)) 
            FROM    Ciudad JOIN Pais 
            ON      Ciudad.CodigoPais = Pais.Codigo
            WHERE   Pais.Continente = 'Europe'
        );


-- --------------------------------------------------------------------------------------
-- Consulta 47. Paises con una lengua oficial distinta de las lenguas (oficiales o no) habladas en los Paises que han incrementado su PNB
SELECT  Lengua
FROM    Pais JOIN LenguaPais
ON      Pais.Codigo = LenguaPais.CodigoPais
WHERE   Pais.PNB > Pais.PNBAnt;

SELECT  Nombre AS 'Pais'
FROM    Pais JOIN LenguaPais
ON      Pais.Codigo = LenguaPais.CodigoPais
WHERE   EsOficial = 'T' 
        AND Lengua <> ALL (
            SELECT  DISTINCT Lengua
            FROM    Pais JOIN LenguaPais
            ON      Pais.Codigo = LenguaPais.CodigoPais
            WHERE   Pais.PNB > Pais.PNBAnt
        );
-- --------------------------------------------------------------------------------------
-- Consulta 48. Partiendo de una peque�a base de datos de marcas y modelos de bicicletas haz la siguiente consulta: listado de todas las marcas, aunque no tengan ning�n modelo y todos los modelos, aunque no sean de ninguna marca.
DROP SCHEMA IF EXISTS Ciclismo;
CREATE SCHEMA Ciclismo;
USE Ciclismo;
CREATE TABLE Marcas (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);
CREATE TABLE Modelos (
    IdModelo INT PRIMARY KEY,
    Nombre  VARCHAR(100) NOT NULL,
    IdMarca INT
);
INSERT INTO Marcas  VALUES (1, 'Trek'), (2, 'Specialized'), (3, 'Cannondale');
INSERT INTO Modelos VALUES (1, 'Roubaix', 2), (2, 'Trail 8', 3), (3, 'Bianchi Infinito', NULL);

/* Salida esperada:
+-------------+------------------+
| Marca       | Modelo           |
+-------------+------------------+
| Specialized | Roubaix          |
| Cannondale  | Trail 8          |
| Trek        | NULL             |
| NULL        | Bianchi Infinito |
+-------------+------------------+*/

SELECT Marcas.Nombre as "Marca", Modelos.Nombre AS "Modelo"
FROM Marcas LEFT JOIN  Modelos
ON Marcas.Id = Modelos.IdMarca
UNION DISTINCT
SELECT Marcas.Nombre as "Marca", Modelos.Nombre AS "Modelo"
FROM Modelos LEFT JOIN  Marcas
ON Marcas.Id = Modelos.IdMarca; 

-- --------------------------------------------------------------------------------------
-- Consulta 49. Proveedores que no proveen ning�n producto de la categor�a 'Beverages'
/* Salida similar a
+----------------------------------------+
| Proveedores                            |
+----------------------------------------+
| Cooperativa de Quesos 'Las Cabras'     |
| Escargots Nouveaux                     |
| Formaggi Fortini s.r.l.                |
...
+----------------------------------------+
21 rows in set (0,01 sec)
*/

SELECT  COUNT(*) > 0
FROM    Proveedores 
        LEFT JOIN Productos ON Proveedores.IdProveedor = Productos.IdProveedor
        LEFT JOIN Categorias ON Productos.IdCategoria = Categorias.IdCategoria
WHERE   NombreCategoria = 'Beverages';

SELECT  Proveedores.IdProveedor
FROM    Proveedores 
        LEFT JOIN Productos ON Proveedores.IdProveedor = Productos.IdProveedor
        LEFT JOIN Categorias ON Productos.IdCategoria = Categorias.IdCategoria
WHERE   NombreCategoria = 'Beverages';

SELECT  Proveedores.NombreEmpresa AS 'Proveedores'
FROM    Proveedores
WHERE   Proveedores.IdProveedor NOT IN (
            SELECT  DISTINCT Proveedores.IdProveedor
            FROM    Proveedores 
                    LEFT JOIN Productos ON Proveedores.IdProveedor = Productos.IdProveedor
                    LEFT JOIN Categorias ON Productos.IdCategoria = Categorias.IdCategoria
            WHERE   NombreCategoria = 'Beverages'
        );



-- --------------------------------------------------------------------------------------
-- Consulta 50. Listado de empleados que no ha servido ning�n pedido
/* Salida similar a
+-----------------------+
| Empleados sin pedidos |
+-----------------------+
| ACME ACME, ACME       |
+-----------------------+*/

INSERT INTO Empleados (IdEmpleado, Apellido, Nombre, Notas) VALUES (10, 'ACME ACME', 'ACME', 'A Company that Makes Everything');
DELETE FROM Empleados WHERE IdEmpleado = 10;

SELECT CONCAT(Apellido, ', ', Nombre) AS 'Empleados sin pedidos'
FROM Empleados LEFT JOIN Pedidos
ON Empleados.IdEmpleado = Pedidos.IdEmpleado
WHERE IdPedido IS NULL; 

-- --------------------------------------------------------------------------------------
-- Consulta 51. Listado con los dos productos cuyo nombre es m�s largo junto con el nombre completo (Apellido, nombre) de los dos empleados cuyo apellido es m�s largo
-- Queremos saber cu�ndo se trata de un producto y de un empleado
/* Salida similar a
+----------------------------------+--------------+
| Nombre                           | Informaci�n  |
+----------------------------------+--------------+
| Louisiana Fiery Hot Pepper Sauce | Producto     |
| Jack's New England Clam Chowder  | Producto     |
| Dodsworth, Anne                  | Empleado     |
| Leverling, Janet                 | Empleado     |
+----------------------------------+--------------+*/
SELECT NombreProducto AS 'Nombre', 'Producto' AS Informacion
FROM Productos
ORDER BY CHAR_LENGTH(NombreProducto) DESC
LIMIT 2

SELECT CONCAT(Apellido, ', ', Nombre) AS 'Nombre', 'Empleado' AS Informaciion 
FROM Empleados 
ORDER BY CHAR_LENGTH(Apellido) DESC
LIMIT 2

(
    SELECT  NombreProducto AS 'Nombre', 
            'Producto' AS Informacion
    FROM    Productos
    ORDER BY  CHAR_LENGTH(NombreProducto) DESC
    LIMIT 2
)
UNION ALL
(
    SELECT  CONCAT(Apellido, ', ', Nombre) AS 'Nombre', 
            'Empleado' AS Informacion 
    FROM    Empleados 
    ORDER BY CHAR_LENGTH(Apellido) DESC 
    LIMIT 2
);

-- --------------------------------------------------------------------------------------
-- Consulta 52. Listado con los dos productos cuyo nombre es m�s largo junto con el nombre completo (Apellido, nombre) de los dos empleados cuyo apellido es m�s largo
-- No tan f�cil: Queremos saber cu�ndo se trata de un producto y de un empleado y el n�mero de letras
/* Salida similar a
+----------------------------------+---------------------------------------------+
| Nombre                           | Informaci�n                                 |
+----------------------------------+---------------------------------------------+
| Louisiana Fiery Hot Pepper Sauce | Es un producto y tiene 32 letras            |
| Jack's New England Clam Chowder  | Es un producto y tiene 31 letras            |
| Dodsworth, Anne                  | Es un empleado y su apellido tiene 9 letras |
| Leverling, Janet                 | Es un empleado y su apellido tiene 9 letras |
+----------------------------------+---------------------------------------------+*/

SELECT Nombre,
        CONCAT('Es un ', Tipo,' y tiene ', Longitud,' letras') AS Informacion
FROM (
        (
            SELECT NombreProducto AS 'Nombre',
                    'Producto' AS Tipo,
                    CHAR_LENGTH(NombreProducto) AS Longitud
            FROM Productos
            ORDER BY 3 DESC
            LIMIT 2
        )
        UNION ALL
        (
            SELECT CONCAT(Apellido, ', ', Nombre) AS 'Nombre',
                    'Empleado' AS Tipo,
                    CHAR_LENGTH(Apellido) AS Longitud
            FROM Empleados
            ORDER BY 3 DESC
            LIMIT 2
        )
) AS T;

-- --------------------------------------------------------------------------------------
-- Consulta 53. Listado con los proveedores y clientes espa�ones 'Spain'. Indicar nombre de la empresa (NombreEmpresa), poblacion (Poblacion) y regi�n (Region)
/* Salida similar a
+-----------+--------------------------------------+-----------+----------+
| Tipo      | Empresa                              | Poblacion | Regi�n   |
+-----------+--------------------------------------+-----------+----------+
| proveedor | Cooperativa de Quesos 'Las Cabras'   | Oviedo    | Asturias |
| cliente   | Blido Comidas preparadas             | Madrid    | NULL     |
| cliente   | FISSA Fabrica Inter. Salchichas S.A. | Madrid    | NULL     |
...
+-----------+--------------------------------------+-----------+----------+
6 rows in set (0,00 sec)*/
SELECT  'proveedor' AS Tipo, NombreEmpresa AS 'Empresa', Poblacion, Region
FROM    Proveedores
WHERE   Pais = 'Spain';

SELECT  'cliente' AS Tipo, NombreEmpresa AS 'Empresa', Poblacion, Region
FROM    Clientes
WHERE   Pais = 'Spain';

SELECT  'proveedor' AS Tipo, NombreEmpresa AS 'Empresa', Poblacion, Region 
FROM    Proveedores
WHERE   Pais = 'Spain'
UNION ALL
SELECT  'cliente' AS Tipo, NombreEmpresa AS 'Empresa', Poblacion, Region
FROM    Clientes
WHERE   Pais = 'Spain';


-- --------------------------------------------------------------------------------------
-- Consulta 54. Listado con los proveedores y clientes espa�ones 'Spain'. Indicar nombre de la empresa (NombreEmpresa), poblacion (Poblacion) y regi�n (Region)
-- No tan f�cil: salida similar a (si la regi�n tiene valor NULL saldr� 'N/A') (2,25)
/* Salida similar a
+-----------+--------------------------------------+-----------+----------+
| Tipo      | Empresa                              | Poblacion | Regi�n   |
+-----------+--------------------------------------+-----------+----------+
| proveedor | Cooperativa de Quesos 'Las Cabras'   | Oviedo    | Asturias |
| cliente   | Blido Comidas preparadas             | Madrid    | N/A      |
| cliente   | FISSA Fabrica Inter. Salchichas S.A. | Madrid    | N/A      |
...
+-----------+--------------------------------------+-----------+----------+
6 rows in set (0,00 sec)*/

SELECT Tipo, Empresa, Poblacion, IF(Region IS NULL, 'N/A', Region) AS Region
FROM (
    SELECT  'proveedor' AS Tipo, NombreEmpresa AS 'Empresa', Poblacion, Region 
    FROM    Proveedores
    WHERE   Pais = 'Spain'
    UNION ALL
    SELECT  'cliente' AS Tipo, NombreEmpresa AS 'Empresa', Poblacion, Region
    FROM    Clientes
    WHERE   Pais = 'Spain'
) AS T;