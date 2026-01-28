/*
Bases de Datos
Tema 3. SQL avanzado II
Realiza las siguientes consultas SQL
Nombre: Alan Smith Valencia Izquierdo
Grupo: 1 DAM-B

Deberás entregar el resultado en un documento .sql (puedes usar este mismo documento)
Se valorará además de que las solución de los ejercicios sea correcta, la correcta indentación,
los comentarios en el código, nombres de columna correctos y la claridad del código en general.
Procura que en tu código no haya tabuladores, sólo espacios en blanco. Puedes ejecutar:
Menú > Configuración > Preferencias > Lenguajes > Tabuladores > (Tamaño: 4 y Indent using: Tab Character) y
Menú > Editar > Operciones de limpieza > TAB a espacio
Recuerda que no se puede copiar y pegar de ningún compañero. Ni si quiera un trozo pequeño
Se puede usar una IA para resolver dudas concretas, por ejemplo, podemos preguntar a una IA:
¿Cómo puedo obtener el siguiente carácter de un carácter en MySQL?
, pero no pedir a una IA que resuelva el ejercicio

Análisis de los nulos: realizaremos el mismo análisis de nulos hecho en clase.
*/

-- Se deben resolver como correlacionadas cinco consultas de tu elección
-- Recuerda que COUNT(*)=0 es NOT EXISTS y que COUNT(*)>0 O >=1 es EXISTS
-- y que las consultas con EXISTS y NOT EXISTS son mucho más eficientes que las de COUNT(*)
-- por lo que es obligatorio hacerlas como EXISTS y NOT EXISTS.

-- --------------------------------------------------------------------------------------
-- Consulta 1. Países que tienen exactamente dos ciudades
SELECT  Pais.Nombre AS "Paises"
FROM    Pais
WHERE   (
            SELECT  COUNT(*)
            FROM    Ciudad
            WHERE   Pais.Codigo = Ciudad.CodigoPais
        ) = 2;

-- --------------------------------------------------------------------------------------
-- Consulta 2. Países que tienen tres o más lenguas oficiales
SELECT  Pais.Nombre AS "Paises"
FROM    Pais
WHERE   (
            SELECT  COUNT(*)
            FROM    LenguaPais
            WHERE   Pais.Codigo = LenguaPais.CodigoPais
                    AND LenguaPais.EsOficial = "T"
        ) >= 3 ;
-- --------------------------------------------------------------------------------------
-- Consulta 3. Países que tienen más ciudades que el número de letras de su Nombre
SELECT  Pais.Nombre AS "Paises"
FROM    Pais
WHERE   CHAR_LENGTH(Pais.Nombre) > (
            SELECT  COUNT(*)
            FROM    Ciudad
            WHERE   Pais.Codigo = Ciudad.CodigoPais
        );
-- --------------------------------------------------------------------------------------
-- Consulta 4. Lenguas oficiales habladas en países con más de cien ciudades.
SELECT  DISTINCT Lengua AS "Lenguas"
FROM    LenguaPais JOIN Pais
ON      LenguaPais.CodigoPais = Pais.Codigo
WHERE   (
            SELECT  COUNT(*)
            FROM    Ciudad
            WHERE   Pais.Codigo = Ciudad.CodigoPais
        ) > 100;

-- --------------------------------------------------------------------------------------
-- Consulta 5. Nombre de los países que tienen por lo menos una lengua.
SELECT  Pais.Nombre AS "Paises"
FROM    Pais
WHERE   EXISTS (
            SELECT  *
            FROM    LenguaPais
            WHERE   Pais.Codigo = LenguaPais.CodigoPais
        );

-- --------------------------------------------------------------------------------------
-- Consulta 6. Nombre de los países que no tienen ninguna lengua.
SELECT  Pais.Nombre AS "Paises"
FROM    Pais
WHERE   NOT EXISTS (
            SELECT  *
            FROM    LenguaPais
            WHERE   Pais.Codigo = LenguaPais.CodigoPais
        );

-- --------------------------------------------------------------------------------------
-- Consulta 7. Países del continente africano que no tienen lengua oficial.
SELECT  Pais.Nombre AS "Paises"
FROM    Pais
WHERE   NOT EXISTS (
            SELECT  *
            FROM    LenguaPais
            WHERE   Pais.Codigo = LenguaPais.CodigoPais
                    AND EsOficial = "T"
        ) AND Continente = "Africa";

-- --------------------------------------------------------------------------------------
-- Consulta 8. Nombre de cada continente junto con el número de países que tiene.
SELECT  Continente AS "Continentes", COUNT(Nombre) AS "Numero de paises"
FROM    Pais
GROUP BY Continente;

-- --------------------------------------------------------------------------------------
-- Consulta 9. Número de países que se han independizado cada año (sólo para los años en los que se ha independizado algún país).
SELECT  AnyIndep AS "Año de independencia", 
        COUNT(*) AS "Numero de paises independizados"
FROM    Pais
WHERE   AnyIndep IS NOT NULL
GROUP BY AnyIndep;


-- --------------------------------------------------------------------------------------
-- Consulta 10. De cada capital queremos saber el número de ciudades que pertenecen al país del que es capital.
SELECT  Capitales.Nombre AS "Capitales",
        COUNT(Ciudad.Nombre) AS "Numero de Ciudades"
FROM    Ciudad Capitales JOIN Pais JOIN Ciudad
ON      Capitales.Id = Pais.Capital
        AND Ciudad.CodigoPais = Pais.Codigo
GROUP BY Capitales.Id;

SELECT  Ciudad.Nombre AS "Capitales",
        ( SELECT COUNT(*) FROM Ciudad WHERE Ciudad.CodigoPais = Pais.Codigo) AS "Numero de Ciudades"
FROM    Ciudad JOIN Pais
ON      Ciudad.Id = Pais.Capital;

-- --------------------------------------------------------------------------------------
-- Consulta 11. De cada lengua oficial queremos saber su número de hablantes (como lengua oficial).
SELECT  Lengua AS "Lenguas",
        porcentaje AS "Numero de hablantes"
FROM    LenguaPais JOIN Pais
ON      LenguaPais.CodigoPais = Pais.Codigo
WHERE   EsOficial = "T"
GROUP BY Lengua;

-- --------------------------------------------------------------------------------------
-- Consulta 12. De cada continente, queremos saber el número de lenguas oficiales y no oficiales distintas que se hablan.
SELECT  Continente, 
        Count(IF(EsOficial = "T", 1, NULL)) AS "Numero de lenguas oficiales", 
        Count(IF(EsOficial = "F", 1, NULL)) AS "Numero de lenguas oficiales"
FROM    LenguaPais LEFT JOIN Pais
ON      LenguaPais.CodigoPais = Pais.Codigo
GROUP BY Continente;


-- --------------------------------------------------------------------------------------
-- Consulta 13. Vamos a establecer tramos por decenas en el porcentaje de hablantes de una legua: del 0% al 10%; del 10% al 20% y así. De cada lengua y cada tramo, queremos saber el número de países en los que se habla y el número total de hablantes de esa lengua.
SELECT  Lengua AS "Lenguas",
        CASE 
            WHEN Porcentaje >= 0 AND Porcentaje < 10 THEN '0%-10%'
            WHEN Porcentaje >= 10 AND Porcentaje < 20 THEN '10%-20%'
            WHEN Porcentaje >= 20 AND Porcentaje < 30 THEN '20%-30%'
            WHEN Porcentaje >= 30 AND Porcentaje < 40 THEN '30%-40%'
            WHEN Porcentaje >= 40 AND Porcentaje < 50 THEN '40%-50%'
            WHEN Porcentaje >= 50 AND Porcentaje < 60 THEN '50%-60%'
            WHEN Porcentaje >= 60 AND Porcentaje < 70 THEN '60%-70%'
            WHEN Porcentaje >= 70 AND Porcentaje < 80 THEN '70%-80%'
            WHEN Porcentaje >= 80 AND Porcentaje < 90 THEN '80%-90%'
            WHEN Porcentaje >= 90 AND Porcentaje <= 100 THEN '90%-100%'
        END AS "Tramo Porcentaje",
        COUNT(*) AS "Numero de paises",
        SUM(Porcentaje) AS "Total porcentaje"
FROM    LenguaPais
GROUP BY Lengua, 
        CASE 
            WHEN Porcentaje >= 0 AND Porcentaje < 10 THEN '0%-10%'
            WHEN Porcentaje >= 10 AND Porcentaje < 20 THEN '10%-20%'
            WHEN Porcentaje >= 20 AND Porcentaje < 30 THEN '20%-30%'
            WHEN Porcentaje >= 30 AND Porcentaje < 40 THEN '30%-40%'
            WHEN Porcentaje >= 40 AND Porcentaje < 50 THEN '40%-50%'
            WHEN Porcentaje >= 50 AND Porcentaje < 60 THEN '50%-60%'
            WHEN Porcentaje >= 60 AND Porcentaje < 70 THEN '60%-70%'
            WHEN Porcentaje >= 70 AND Porcentaje < 80 THEN '70%-80%'
            WHEN Porcentaje >= 80 AND Porcentaje < 90 THEN '80%-90%'
            WHEN Porcentaje >= 90 AND Porcentaje <= 100 THEN '90%-100%'
        END
ORDER BY Lengua, "Tramo Porcentaje";


-- --------------------------------------------------------------------------------------
-- Consulta 14. Queremos saber el número de ciudades que hay en cada tramo de la esperanza de vida organizada por decenas.
SELECT  CASE 
            WHEN Pais.EsperanzaVida >= 0 AND Pais.EsperanzaVida < 10 THEN '0-9'
            WHEN Pais.EsperanzaVida >= 10 AND Pais.EsperanzaVida < 20 THEN '10-19'
            WHEN Pais.EsperanzaVida >= 20 AND Pais.EsperanzaVida < 30 THEN '20-29'
            WHEN Pais.EsperanzaVida >= 30 AND Pais.EsperanzaVida < 40 THEN '30-39'
            WHEN Pais.EsperanzaVida >= 40 AND Pais.EsperanzaVida < 50 THEN '40-49'
            WHEN Pais.EsperanzaVida >= 50 AND Pais.EsperanzaVida < 60 THEN '50-59'
            WHEN Pais.EsperanzaVida >= 60 AND Pais.EsperanzaVida < 70 THEN '60-69'
            WHEN Pais.EsperanzaVida >= 70 AND Pais.EsperanzaVida < 80 THEN '70-79'
            WHEN Pais.EsperanzaVida >= 80 AND Pais.EsperanzaVida < 90 THEN '80-89'
            WHEN Pais.EsperanzaVida >= 90 AND Pais.EsperanzaVida <= 100 THEN '90-100'
        END AS "Tramo Esperanza Vida",
        COUNT(Ciudad.Id) AS "Numero de ciudades"
FROM    Pais LEFT JOIN Ciudad
ON      Pais.Codigo = Ciudad.CodigoPais
WHERE   Pais.EsperanzaVida IS NOT NULL
GROUP BY 
        CASE 
            WHEN Pais.EsperanzaVida >= 0 AND Pais.EsperanzaVida < 10 THEN '0-9'
            WHEN Pais.EsperanzaVida >= 10 AND Pais.EsperanzaVida < 20 THEN '10-19'
            WHEN Pais.EsperanzaVida >= 20 AND Pais.EsperanzaVida < 30 THEN '20-29'
            WHEN Pais.EsperanzaVida >= 30 AND Pais.EsperanzaVida < 40 THEN '30-39'
            WHEN Pais.EsperanzaVida >= 40 AND Pais.EsperanzaVida < 50 THEN '40-49'
            WHEN Pais.EsperanzaVida >= 50 AND Pais.EsperanzaVida < 60 THEN '50-59'
            WHEN Pais.EsperanzaVida >= 60 AND Pais.EsperanzaVida < 70 THEN '60-69'
            WHEN Pais.EsperanzaVida >= 70 AND Pais.EsperanzaVida < 80 THEN '70-79'
            WHEN Pais.EsperanzaVida >= 80 AND Pais.EsperanzaVida < 90 THEN '80-89'
            WHEN Pais.EsperanzaVida >= 90 AND Pais.EsperanzaVida <= 100 THEN '90-100'
        END
ORDER BY "Tramo Esperanza Vida";

-- --------------------------------------------------------------------------------------
-- Consulta 15. Número de países que comienzan por la A, por la B y así.
SELECT  UPPER(LEFT(Nombre, 1)) AS "Inicial",
        COUNT(*) AS "Numero de paises"
FROM    Pais
GROUP BY UPPER(LEFT(Nombre, 1))
ORDER BY "Inicial";

-- --------------------------------------------------------------------------------------
-- Consulta 16. De cada continente y cada región, queremos saber el número de países que lo componen y el número de países que no tienen año de independencia, con totales.
SELECT  Continente,
        Region,
        COUNT(*) AS "Total paises",
        COUNT(IF(AnyIndep IS NULL, 1, NULL)) AS "Paises sin independencia"
FROM    Pais
GROUP BY Continente, Region WITH ROLLUP;

-- --------------------------------------------------------------------------------------
-- Consulta 17. Queremos saber el número de ciudades que hay en cada tramo de la esperanza de vida usando los siguientes tramos.
-- +-------------+----------------+----------------+
-- | NombreTramo | LimiteInferior | LimiteSuperior |
-- +-------------+----------------+----------------+
-- | Muy baja    |              0 |             40 |
-- | Baja        |             41 |             55 |
-- | Media       |             56 |             75 |
-- | Alta        |             76 |             85 |
-- | Muy alta    |             86 |            150 |
-- +-------------+----------------+----------------+
-- Cuidado que la esperanza de vida es un número con decimales
SELECT  CASE 
            WHEN Pais.EsperanzaVida >= 0 AND Pais.EsperanzaVida <= 40 THEN 'Muy baja'
            WHEN Pais.EsperanzaVida >= 41 AND Pais.EsperanzaVida <= 55 THEN 'Baja'
            WHEN Pais.EsperanzaVida >= 56 AND Pais.EsperanzaVida <= 75 THEN 'Media'
            WHEN Pais.EsperanzaVida >= 76 AND Pais.EsperanzaVida <= 85 THEN 'Alta'
            WHEN Pais.EsperanzaVida >= 86 AND Pais.EsperanzaVida <= 150 THEN 'Muy alta'
        END AS "NombreTramo",
        COUNT(Ciudad.Id) AS "Numero de ciudades"
FROM    Pais LEFT JOIN Ciudad
ON      Pais.Codigo = Ciudad.CodigoPais
WHERE   Pais.EsperanzaVida IS NOT NULL
GROUP BY 
        CASE 
            WHEN Pais.EsperanzaVida >= 0 AND Pais.EsperanzaVida <= 40 THEN 'Muy baja'
            WHEN Pais.EsperanzaVida >= 41 AND Pais.EsperanzaVida <= 55 THEN 'Baja'
            WHEN Pais.EsperanzaVida >= 56 AND Pais.EsperanzaVida <= 75 THEN 'Media'
            WHEN Pais.EsperanzaVida >= 76 AND Pais.EsperanzaVida <= 85 THEN 'Alta'
            WHEN Pais.EsperanzaVida >= 86 AND Pais.EsperanzaVida <= 150 THEN 'Muy alta'
        END
ORDER BY "NombreTramo";

-- --------------------------------------------------------------------------------------
-- Consulta 18. Queremos saber si una lengua se habla en muchos o pocos países de acuerdo con la siguiente tabla. Para ello sólo tendremos en cuenta las lenguas oficiales.
-- +------------------------+----------------+----------------+
-- | NombreTramo            | LimiteInferior | LimiteSuperior |
-- +------------------------+----------------+----------------+
-- | Muy Poco extendida     |              0 |              1 |
-- | Poco extendida         |              2 |              3 |
-- | Medianamente extendida |              4 |              5 |
-- | Bastante extendida     |              6 |              7 |
-- | Muy extendida          |              8 |          10000 |
-- +------------------------+----------------+----------------+
SELECT  Lengua AS "Lengua",
        COUNT(*) AS "Numero de paises",
        CASE 
            WHEN COUNT(*) >= 0 AND COUNT(*) <= 1 THEN 'Muy Poco extendida'
            WHEN COUNT(*) >= 2 AND COUNT(*) <= 3 THEN 'Poco extendida'
            WHEN COUNT(*) >= 4 AND COUNT(*) <= 5 THEN 'Medianamente extendida'
            WHEN COUNT(*) >= 6 AND COUNT(*) <= 7 THEN 'Bastante extendida'
            WHEN COUNT(*) >= 8 AND COUNT(*) <= 10000 THEN 'Muy extendida'
        END AS "NombreTramo"
FROM    LenguaPais
WHERE   EsOficial = "T"
GROUP BY Lengua
ORDER BY "Numero de paises" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 19. De acuerdo con la tabla anterior queremos saber cómo de extendidas están las lenguas oficiales. Para ello crearemos una tabla en la que aparecerán los tramos en la primera columna y el número de lenguas que se hablan según los límites de ese tramo. Por ejemplo aparecerá: Muy poco extendida y en la siguiente columna el número de lenguas que se hablan de manera oficial en cero o un país.
SELECT  CASE 
            WHEN num_paises >= 0 AND num_paises <= 1 THEN 'Muy Poco extendida'
            WHEN num_paises >= 2 AND num_paises <= 3 THEN 'Poco extendida'
            WHEN num_paises >= 4 AND num_paises <= 5 THEN 'Medianamente extendida'
            WHEN num_paises >= 6 AND num_paises <= 7 THEN 'Bastante extendida'
            WHEN num_paises >= 8 AND num_paises <= 10000 THEN 'Muy extendida'
        END AS "NombreTramo",
        COUNT(*) AS "Numero de lenguas"
FROM    (
            SELECT  Lengua, COUNT(*) AS num_paises
            FROM    LenguaPais
            WHERE   EsOficial = "T"
            GROUP BY Lengua
        ) AS Subconsulta
GROUP BY 
        CASE 
            WHEN num_paises >= 0 AND num_paises <= 1 THEN 'Muy Poco extendida'
            WHEN num_paises >= 2 AND num_paises <= 3 THEN 'Poco extendida'
            WHEN num_paises >= 4 AND num_paises <= 5 THEN 'Medianamente extendida'
            WHEN num_paises >= 6 AND num_paises <= 7 THEN 'Bastante extendida'
            WHEN num_paises >= 8 AND num_paises <= 10000 THEN 'Muy extendida'
        END
ORDER BY "NombreTramo";

-- --------------------------------------------------------------------------------------
-- Consulta 20. De acuerdo con la siguiente tabla indica el número de países que están en cada tramo de riqueza.
-- +-------------+----------------+----------------+
-- | NombreTramo | LimiteInferior | LimiteSuperior |
-- +-------------+----------------+----------------+
-- | Muy Pobre   |              0 |           1000 |
-- | Pobre       |           1001 |           5000 |
-- | Normal      |           5001 |          10000 |
-- | Rico        |          10001 |          50000 |
-- | Muy Rico    |          50001 |      100000000 |
-- +-------------+----------------+----------------+
SELECT  CASE 
            WHEN PNB >= 0 AND PNB <= 1000 THEN 'Muy Pobre'
            WHEN PNB >= 1001 AND PNB <= 5000 THEN 'Pobre'
            WHEN PNB >= 5001 AND PNB <= 10000 THEN 'Normal'
            WHEN PNB >= 10001 AND PNB <= 50000 THEN 'Rico'
            WHEN PNB >= 50001 AND PNB <= 100000000 THEN 'Muy Rico'
        END AS "NombreTramo",
        COUNT(*) AS "Numero de paises"
FROM    Pais
WHERE   PNB IS NOT NULL
GROUP BY 
        CASE 
            WHEN PNB >= 0 AND PNB <= 1000 THEN 'Muy Pobre'
            WHEN PNB >= 1001 AND PNB <= 5000 THEN 'Pobre'
            WHEN PNB >= 5001 AND PNB <= 10000 THEN 'Normal'
            WHEN PNB >= 10001 AND PNB <= 50000 THEN 'Rico'
            WHEN PNB >= 50001 AND PNB <= 100000000 THEN 'Muy Rico'
        END
ORDER BY "NombreTramo";


-- --------------------------------------------------------------------------------------
-- Consulta 21. Definimos el PNB de una ciudad como el PNB del país al que pertenece dividido entre el número de ciudades de ese país. De esta forma el PNB per cápita de una ciudad es el PNB de la ciudad dividido entre su población. De acuerdo con la siguiente tabla indica el número de ciudades que están en cada tramo de riqueza. Nota: los límites se solapan, pero no es problema porque el resultado es un número real (deberemos cambiar el BETWEEN).
-- +-------------+----------------+----------------+
-- | NombreTramo | LimiteInferior | LimiteSuperior |
-- +-------------+----------------+----------------+
-- | Muy Pobre   |              0 |            100 |
-- | Pobre       |            100 |           1000 |
-- | Normal      |           1000 |          50000 |
-- | Rico        |          50000 |         500000 |
-- | Muy Rico    |         500000 |       10000000 |
-- +-------------+----------------+----------------+
SELECT  CASE 
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 0 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion < 100 THEN 'Muy Pobre'
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 100 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion < 1000 THEN 'Pobre'
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 1000 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion < 50000 THEN 'Normal'
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 50000 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion < 500000 THEN 'Rico'
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 500000 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion <= 10000000 THEN 'Muy Rico'
        END AS "NombreTramo",
        COUNT(Ciudad.Id) AS "Numero de ciudades"
FROM    Ciudad 
        JOIN Pais ON Ciudad.CodigoPais = Pais.Codigo
        JOIN (
            SELECT  CodigoPais, COUNT(*) AS num_ciudades
            FROM    Ciudad
            GROUP BY CodigoPais
        ) AS NumCiudades ON Ciudad.CodigoPais = NumCiudades.CodigoPais
WHERE   Pais.PNB IS NOT NULL 
        AND Ciudad.Poblacion > 0
GROUP BY 
        CASE 
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 0 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion < 100 THEN 'Muy Pobre'
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 100 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion < 1000 THEN 'Pobre'
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 1000 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion < 50000 THEN 'Normal'
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 50000 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion < 500000 THEN 'Rico'
            WHEN (Pais.PNB / num_ciudades) / Ciudad.Poblacion >= 500000 AND (Pais.PNB / num_ciudades) / Ciudad.Poblacion <= 10000000 THEN 'Muy Rico'
        END
ORDER BY "NombreTramo";

-- --------------------------------------------------------------------------------------
-- Consulta 22. De cada continente queremos saber el número total de habitantes partido el número de lenguas que se hablan.
SELECT  Continente,
        SUM(Poblacion) AS "Total habitantes",
        COUNT(DISTINCT Lengua) AS "Numero de lenguas",
        SUM(Poblacion) / COUNT(DISTINCT Lengua) AS "Habitantes por lengua"
FROM    Pais 
        LEFT JOIN LenguaPais ON Pais.Codigo = LenguaPais.CodigoPais
GROUP BY Continente
ORDER BY Continente;

-- --------------------------------------------------------------------------------------
-- Consulta 23. Listado del los países y el número de ciudades de ese país para los países que tienen más ciudades que España.
SELECT  Pais.Nombre AS "Paises",
        COUNT(Ciudad.Id) AS "Numero de ciudades"
FROM    Pais JOIN Ciudad
ON      Pais.Codigo = Ciudad.CodigoPais
GROUP BY Pais.Codigo, Pais.Nombre
HAVING COUNT(Ciudad.Id) > (
            SELECT COUNT(*)
            FROM Ciudad
            WHERE CodigoPais = 'ESP'
        )
ORDER BY "Numero de ciudades" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 24. Listado de países y el número de lenguas de ese país para los países que tienen más lenguas que España con código de país "ESP".
SELECT  Pais.Nombre AS "Paises",
        COUNT(LenguaPais.Lengua) AS "Numero de lenguas"
FROM    Pais LEFT JOIN LenguaPais
ON      Pais.Codigo = LenguaPais.CodigoPais
GROUP BY Pais.Codigo, Pais.Nombre
HAVING COUNT(LenguaPais.Lengua) > (
            SELECT COUNT(*)
            FROM LenguaPais
            WHERE CodigoPais = 'ESP'
        )
ORDER BY "Numero de lenguas" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 25. Capitales de países que tienen más lenguas oficiales que Canadá con código de país "CAN" y las mismas o menos que Suiza con código de país "CHE".
SELECT  Ciudad.Nombre AS "Capitales",
        Pais.Nombre AS "Paises"
FROM    Ciudad JOIN Pais
ON      Ciudad.Id = Pais.Capital
WHERE   (
            SELECT COUNT(*)
            FROM LenguaPais
            WHERE CodigoPais = Pais.Codigo AND EsOficial = "T"
        ) > (
            SELECT COUNT(*)
            FROM LenguaPais
            WHERE CodigoPais = 'CAN' AND EsOficial = "T"
        )
        AND (
            SELECT COUNT(*)
            FROM LenguaPais
            WHERE CodigoPais = Pais.Codigo AND EsOficial = "T"
        ) <= (
            SELECT COUNT(*)
            FROM LenguaPais
            WHERE CodigoPais = 'CHE' AND EsOficial = "T"
        )
ORDER BY Ciudad.Nombre;

-- --------------------------------------------------------------------------------------
-- Consulta 26. Obtener un listado de nombre de capitales que son capital de más de un país (que dos países tengan la misma capital no tiene porqué ser un error, pueden ser capitales diferentes con el mismo nombre).
SELECT  Ciudad.Nombre AS "Nombre capital"
FROM    Ciudad JOIN Pais
ON      Ciudad.Id = Pais.Capital
GROUP BY Ciudad.Nombre
HAVING COUNT(*) > 1; 

-- -------------------------------------------------------------------------------------- 
-- Consulta 27. Obtener un listado de nombre de países repetidos. Consideramos que el nombre de un país está repetido si tenemos al mismo país con el mismo nombre más de una vez dentro del mismo continente.
SELECT  Nombre AS "Nombre pais repetido",
        Continente AS "Continente"
FROM    Pais
GROUP BY Nombre, Continente
HAVING COUNT(*) > 1; 

-- --------------------------------------------------------------------------------------
-- Consulta 28. Obtener un listado de nombre de países repetidos. Consideramos que el nombre de un país está repetido si aparece más de una vez en nuestra BD.
SELECT  Nombre AS "Nombre pais repetido"
FROM    Pais
GROUP BY Nombre
HAVING COUNT(*) > 1; 

-- --------------------------------------------------------------------------------------
-- Consulta 29. Realiza la consulta adecuada para saber si existe algún Codigo2 repetido
SELECT  Codigo2 AS "Codigo2 repetido"
FROM    Pais
GROUP BY Codigo2
HAVING COUNT(*) > 1;

-- --------------------------------------------------------------------------------------
-- Consulta 30. Queremos cinco países aleatorios. De cada país saca su nombre, su población en millones de habitantes con un decimal y su esperanza de vida (sin decimales).
SELECT  Nombre AS "Pais",
        ROUND(Poblacion / 1000000, 1) AS "Poblacion millones",
        ROUND(EsperanzaVida, 0) AS "Esperanza de vida"
FROM    Pais
ORDER BY RAND()
LIMIT 5; 

-- --------------------------------------------------------------------------------------
-- Consulta 31. Queremos cuatro países aleatorios junto con las lenguas que se hablan en esos países (dependiendo de las lenguas habladas en cada país la consulta tendrá más o menos registros. Por ejemplo, si en cada país se habla dos lenguas, la consulta tendrá ocho registros)
SELECT  Pais.Nombre AS "Pais",
        LenguaPais.Lengua AS "Lengua",
        LenguaPais.EsOficial AS "Es Oficial"
FROM    Pais LEFT JOIN LenguaPais
ON      Pais.Codigo = LenguaPais.CodigoPais
WHERE   Pais.Codigo IN (
            SELECT Codigo
            FROM Pais
            ORDER BY RAND()
            LIMIT 4
        )
ORDER BY Pais.Nombre, LenguaPais.Lengua; 

-- ----------------------------------------------------------------------------------------------
-- Consultas sobre Neptuno
-- ----------------------------------------------------------------------------------------------
-- Salvo que se indique lo contrario, en los pedidos, los costes de envío no se tendrán en cuenta en ninguna consulta, pero sí habrá que tener en cuenta el descuento, aunque no hay ningún registro que tenga descuento en DetallesPedido.
-- Para calcular el importe de un producto de un pedido, usaremos la fórmula: PrecioUnitario * Cantidad * (1 - Descuento), es decir, suponemos que el descuento está expresado en tantos por uno (por ejemplo, 0.1 es un descuento de un 10%)

-- --------------------------------------------------------------------------------------
-- Consulta 32. Proveedores que proveen exáctamente tres productos
SELECT  NombreEmpresa AS "Proveedores"
FROM    Proveedores
WHERE   (
            SELECT COUNT(DISTINCT IdProducto)
            FROM Productos
            WHERE IdProveedor = Proveedores.IdProveedor
        ) = 3;

-- --------------------------------------------------------------------------------------
-- Consulta 33. Pedidos que piden exáctamente 6 productos
SELECT  IdPedido AS "Pedidos"
FROM    Pedidos
WHERE   (
            SELECT COUNT(DISTINCT IdProducto)
            FROM DetallesPedido
            WHERE IdPedido = Pedidos.IdPedido
        ) = 6;

-- --------------------------------------------------------------------------------------
-- Consulta 34. Clientes que han realizado los pedidos que tienen exáctamente 6 productos
SELECT  DISTINCT NombreEmpresa AS "Clientes"
FROM    Clientes JOIN Pedidos
ON      Clientes.IdCliente = Pedidos.IdCliente
WHERE   (
            SELECT COUNT(DISTINCT IdProducto)
            FROM DetallesPedido
            WHERE IdPedido = Pedidos.IdPedido
        ) = 6;

-- --------------------------------------------------------------------------------------
-- Consulta 35. Categorías con más de 10 productos
SELECT  NombreCategoria AS "Categorias"
FROM    Categorias
WHERE   (
            SELECT COUNT(*)
            FROM Productos
            WHERE IdCategoria = Categorias.IdCategoria
        ) > 10;

-- --------------------------------------------------------------------------------------
-- Consulta 36. Productos de los que se han vendido más de 1000 unidades
SELECT  NombreProducto AS "Productos"
FROM    Productos
WHERE   (
            SELECT SUM(Cantidad)
            FROM DetallesPedido
            WHERE IdProducto = Productos.IdProducto
        ) > 1000;

-- --------------------------------------------------------------------------------------
-- Consulta 37. Clientes que han pedido más de 50 unidades de 'queso cabrales'
SELECT  DISTINCT Clientes.NombreEmpresa AS "Clientes"
FROM    Clientes 
        JOIN Pedidos ON Clientes.IdCliente = Pedidos.IdCliente
        JOIN DetallesPedido ON Pedidos.IdPedido = DetallesPedido.IdPedido
        JOIN Productos ON DetallesPedido.IdProducto = Productos.IdProducto
WHERE   Productos.NombreProducto = 'Queso cabrales'
GROUP BY Clientes.IdCliente, Clientes.NombreEmpresa
HAVING SUM(DetallesPedido.Cantidad) > 50;

-- --------------------------------------------------------------------------------------
-- Consulta 38. Productos que han sido comprados por más de 30 clientes
SELECT  NombreProducto AS "Productos"
FROM    Productos
WHERE   (
            SELECT COUNT(DISTINCT Pedidos.IdCliente)
            FROM DetallesPedido 
            JOIN Pedidos ON DetallesPedido.IdPedido = Pedidos.IdPedido
            WHERE DetallesPedido.IdProducto = Productos.IdProducto
        ) > 30;

-- --------------------------------------------------------------------------------------   
-- Consulta 39. Listado del cliente, fecha y coste de los pedidos (incluyendo los costes de envío), ordenados por cliente y fecha.
-- Puedes usar: DATE_FORMAT(FechaPedido, '%d-%m-%Y') AS 'Fecha de pedido'
SELECT  Clientes.NombreEmpresa AS "Cliente",
        DATE_FORMAT(Pedidos.FechaPedido, '%d-%m-%Y') AS 'Fecha de pedido',
        SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + Pedidos.CargoEnvio AS "Coste total"
FROM    Clientes 
        JOIN Pedidos ON Clientes.IdCliente = Pedidos.IdCliente
        JOIN DetallesPedido ON Pedidos.IdPedido = DetallesPedido.IdPedido
GROUP BY Clientes.NombreEmpresa, Pedidos.FechaPedido, Pedidos.CargoEnvio
ORDER BY Clientes.NombreEmpresa, Pedidos.FechaPedido;

-- --------------------------------------------------------------------------------------       
-- Consulta 40. Cantidad facturada por cada cliente
SELECT  Clientes.NombreEmpresa AS "Cliente",
        SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) AS "Cantidad facturada"
FROM    Clientes 
        JOIN Pedidos ON Clientes.IdCliente = Pedidos.IdCliente
        JOIN DetallesPedido ON Pedidos.IdPedido = DetallesPedido.IdPedido
GROUP BY Clientes.IdCliente, Clientes.NombreEmpresa
ORDER BY "Cantidad facturada" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 41. Cantidad facturada con cada producto
SELECT  Productos.NombreProducto AS "Producto",
        SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS "Cantidad facturada"
FROM    Productos JOIN DetallesPedido
ON      Productos.IdProducto = DetallesPedido.IdProducto
GROUP BY Productos.IdProducto, Productos.NombreProducto
ORDER BY "Cantidad facturada" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 42. Cantidad facturada con cada categoría
SELECT  Categorias.NombreCategoria AS "Categoria",
        SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS "Cantidad facturada"
FROM    Categorias 
        JOIN Productos ON Categorias.IdCategoria = Productos.IdCategoria
        JOIN DetallesPedido ON Productos.IdProducto = DetallesPedido.IdProducto
GROUP BY Categorias.IdCategoria, Categorias.NombreCategoria
ORDER BY "Cantidad facturada" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 43. Número de pedidos realizados por año y mes
SELECT  YEAR(FechaPedido) AS "Año",
        MONTH(FechaPedido) AS "Mes",
        COUNT(*) AS "Numero de pedidos"
FROM    Pedidos
GROUP BY YEAR(FechaPedido), MONTH(FechaPedido)
ORDER BY "Año", "Mes";

-- --------------------------------------------------------------------------------------
-- Consulta 44. Ventas por territorio y región ordenado de mayor a menor ventas
SELECT  Region.DescripcionRegion AS "Region",
        Territorios.DescripcionTerritorio AS "Territorio",
        SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS "Ventas"
FROM    Region 
        JOIN Territorios ON Region.IdRegion = Territorios.IdRegion
        JOIN TerritoriosEmpleados ON Territorios.IdTerritorio = TerritoriosEmpleados.IdTerritorio
        JOIN Empleados ON TerritoriosEmpleados.IdEmpleado = Empleados.IdEmpleado
        JOIN Pedidos ON Empleados.IdEmpleado = Pedidos.IdEmpleado
        JOIN DetallesPedido ON Pedidos.IdPedido = DetallesPedido.IdPedido
GROUP BY Region.IdRegion, Region.DescripcionRegion, Territorios.IdTerritorio, Territorios.DescripcionTerritorio
ORDER BY "Ventas" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 45. Número de pedidos realizados con 1 producto, con 2, con 3, etc.
SELECT  COUNT(DISTINCT IdProducto) AS "Numero de productos",
        COUNT(*) AS "Numero de pedidos"
FROM    DetallesPedido
GROUP BY IdPedido
ORDER BY "Numero de productos";

-- --------------------------------------------------------------------------------------
-- Consulta 46. Relación de productos ordenada según la cantidad de ese producto que se ha pedido
SELECT  NombreProducto AS "Producto",
        SUM(Cantidad) AS "Total cantidad pedida"
FROM    Productos JOIN DetallesPedido
ON      Productos.IdProducto = DetallesPedido.IdProducto
GROUP BY Productos.IdProducto, NombreProducto
ORDER BY "Total cantidad pedida" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 47. Número de proveedores de cada categoría para categorías que tienen más de diez proveedores y ordenados de mayor a menor número de proveedores
SELECT  NombreCategoria AS "Categoria",
        COUNT(DISTINCT IdProveedor) AS "Numero de proveedores"
FROM    Categorias 
        JOIN Productos ON Categorias.IdCategoria = Productos.IdCategoria
GROUP BY Categorias.IdCategoria, NombreCategoria
HAVING COUNT(DISTINCT IdProveedor) > 10
ORDER BY "Numero de proveedores" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 48. Listado de proveedores y número de productos que provee cada uno ordenado del proveedor que más productos provee al que menos
SELECT  NombreEmpresa AS "Proveedor",
        COUNT(*) AS "Numero de productos"
FROM    Proveedores JOIN Productos
ON      Proveedores.IdProveedor = Productos.IdProveedor
GROUP BY Proveedores.IdProveedor, NombreEmpresa
ORDER BY "Numero de productos" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 49. Número medio de productos que provee cada proveedor
SELECT  AVG(num_productos) AS "Numero medio de productos por proveedor"
FROM    (
            SELECT COUNT(*) AS num_productos
            FROM Productos
            GROUP BY IdProveedor
        ) AS Subconsulta;

-- --------------------------------------------------------------------------------------
-- Consulta 50. Número medio de productos diferentes que se piden en cada pedido (Si de un producto se piden cinco unidades, sólo se cuenta como ese producto se ha pedido una vez)
SELECT  AVG(num_productos) AS "Numero medio de productos diferentes por pedido"
FROM    (
            SELECT COUNT(DISTINCT IdProducto) AS num_productos
            FROM DetallesPedido
            GROUP BY IdPedido
        ) AS Subconsulta;

-- --------------------------------------------------------------------------------------
-- Consulta 51. Número medio de productos que se piden en cada pedido (Si de un producto se piden cinco unidades, se cuenta como que se han pedido cinco productos)
SELECT  AVG(SUM(Cantidad)) AS "Numero medio de productos por pedido"
FROM    DetallesPedido
GROUP BY IdPedido;

-- --------------------------------------------------------------------------------------
-- Consulta 52. Número de veces que se ha vendido cada producto (Si de un producto se venden cinco unidades, sólo se cuenta como ese producto se ha vendido una vez), ordenado del producto más vendido al que menos.
SELECT  NombreProducto AS "Producto",
        COUNT(*) AS "Numero de veces vendido"
FROM    Productos JOIN DetallesPedido
ON      Productos.IdProducto = DetallesPedido.IdProducto
GROUP BY Productos.IdProducto, NombreProducto
ORDER BY "Numero de veces vendido" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 53. Número de unidades vendidas de cada producto (Si de un producto se venden cinco unidades, se cuenta como que se han vendido cinco productos), ordenado del producto más vendido al que menos.
SELECT  NombreProducto AS "Producto",
        SUM(Cantidad) AS "Unidades vendidas"
FROM    Productos JOIN DetallesPedido
ON      Productos.IdProducto = DetallesPedido.IdProducto
GROUP BY Productos.IdProducto, NombreProducto
ORDER BY "Unidades vendidas" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 54. Número de veces que se se pide cada producto por pedido (Si de un producto se venden cinco unidades, sólo se cuenta como ese producto se ha vendido una vez), ordenado del producto más vendido al que menos.
SELECT  IdPedido AS "Pedido",
        COUNT(DISTINCT IdProducto) AS "Numero de productos distintos"
FROM    DetallesPedido
GROUP BY IdPedido
ORDER BY "Numero de productos distintos" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 55. Cantidad vendida de cada producto por pedido (Si de un producto se venden cinco unidades, cuentan las cinco unidades como cantidad vendida), ordenado del producto más vendido al que menos.
SELECT  IdPedido AS "Pedido",
        SUM(Cantidad) AS "Cantidad total vendida"
FROM    DetallesPedido
GROUP BY IdPedido
ORDER BY "Cantidad total vendida" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 56. Número de clientes que han comprado cada producto
SELECT  NombreProducto AS "Producto",
        COUNT(DISTINCT Pedidos.IdCliente) AS "Numero de clientes"
FROM    Productos 
        JOIN DetallesPedido ON Productos.IdProducto = DetallesPedido.IdProducto
        JOIN Pedidos ON DetallesPedido.IdPedido = Pedidos.IdPedido
GROUP BY Productos.IdProducto, NombreProducto
ORDER BY "Numero de clientes" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 57. Ingresos obtenidos con los cinco productos más caros
SELECT  SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS "Ingresos productos mas caros"
FROM    DetallesPedido 
        JOIN Productos ON DetallesPedido.IdProducto = Productos.IdProducto
WHERE   Productos.IdProducto IN (
            SELECT IdProducto
            FROM Productos
            ORDER BY PrecioUnitario DESC
            LIMIT 5
        );

-- --------------------------------------------------------------------------------------
-- Consulta 58. Ingresos obtenidos con los cinco productos más baratos
SELECT  SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS "Ingresos productos mas baratos"
FROM    DetallesPedido 
        JOIN Productos ON DetallesPedido.IdProducto = Productos.IdProducto
WHERE   Productos.IdProducto IN (
            SELECT IdProducto
            FROM Productos
            ORDER BY PrecioUnitario ASC
            LIMIT 5
        );

-- --------------------------------------------------------------------------------------
-- Consulta 59. Ingresos obtenidos con cada uno de los cinco productos más caros (aparecerá cada producto por separado con la cantidad ganada con ese producto)
SELECT  Productos.NombreProducto AS "Producto",
        SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS "Ingresos"
FROM    Productos JOIN DetallesPedido
ON      Productos.IdProducto = DetallesPedido.IdProducto
WHERE   Productos.IdProducto IN (
            SELECT IdProducto
            FROM Productos
            ORDER BY PrecioUnitario DESC
            LIMIT 5
        )
GROUP BY Productos.IdProducto, Productos.NombreProducto
ORDER BY "Ingresos" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 60. Ingresos obtenidos con cada uno de los cinco productos más baratos (aparecerá cada producto por separado con la cantidad ganada con ese producto)
SELECT  Productos.NombreProducto AS "Producto",
        SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS "Ingresos"
FROM    Productos JOIN DetallesPedido
ON      Productos.IdProducto = DetallesPedido.IdProducto
WHERE   Productos.IdProducto IN (
            SELECT IdProducto
            FROM Productos
            ORDER BY PrecioUnitario ASC
            LIMIT 5
        )
GROUP BY Productos.IdProducto, Productos.NombreProducto
ORDER BY "Ingresos" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 61. Ingresos obtenidos con los cinco productos más vendidos
SELECT  SUM(Ingresos) AS "Ingresos productos mas vendidos"
FROM    (
            SELECT  SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS Ingresos
            FROM    Productos JOIN DetallesPedido
            ON      Productos.IdProducto = DetallesPedido.IdProducto
            GROUP BY Productos.IdProducto
            ORDER BY Ingresos DESC
            LIMIT 5
        ) AS TopProductos;

-- --------------------------------------------------------------------------------------
-- Consulta 62. Ingresos obtenidos con los cinco productos menos vendidos
SELECT  SUM(Ingresos) AS "Ingresos productos menos vendidos"
FROM    (
            SELECT  SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) AS Ingresos
            FROM    Productos JOIN DetallesPedido
            ON      Productos.IdProducto = DetallesPedido.IdProducto
            GROUP BY Productos.IdProducto
            ORDER BY Ingresos ASC
            LIMIT 5
        ) AS BottomProductos;

-- --------------------------------------------------------------------------------------
-- Consulta 63. Según la cantidad facturada a cada cliente y basándote en la siguiente tabla, obtener un listado de clientes y su clasifiación ordenado del mejor al peor cliente.
/*
+--------------------+----------------+----------------+
| NombreTramo        | LimiteInferior | LimiteSuperior |
+--------------------+----------------+----------------+
| Muy mal cliente    |              0 |           1000 |
| Mal cliente        |           1001 |           5000 |
| Cliente normal     |           5001 |          30000 |
| Buen cliente       |          30001 |          60000 |
| Muy buen cliente   |          60001 |       10000000 |
+--------------------+----------------+----------------+
*/
SELECT  Clientes.NombreEmpresa AS "Cliente",
        SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) AS "Cantidad facturada",
        CASE 
            WHEN SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) >= 0 
            AND SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) <= 1000 THEN 'Muy mal cliente'
            WHEN SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) >= 1001 
            AND SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) <= 5000 THEN 'Mal cliente'
            WHEN SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) >= 5001 
            AND SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) <= 30000 THEN 'Cliente normal'
            WHEN SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) >= 30001 
            AND SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) <= 60000 THEN 'Buen cliente'
            WHEN SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) >= 60001 
            AND SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) <= 10000000 THEN 'Muy buen cliente'
        END AS "Clasificacion"
FROM    Clientes 
        JOIN Pedidos ON Clientes.IdCliente = Pedidos.IdCliente
        JOIN DetallesPedido ON Pedidos.IdPedido = DetallesPedido.IdPedido
GROUP BY Clientes.IdCliente, Clientes.NombreEmpresa
ORDER BY "Cantidad facturada" DESC;

-- --------------------------------------------------------------------------------------
-- Consulta 64. Según la cantidad facturada a cada cliente y basándote en la siguiente tabla, obtener un listado con las diferentes categorías de clientes y el número de clientes que hay en cada categoría
/*
+--------------------+----------------+----------------+
| NombreTramo        | LimiteInferior | LimiteSuperior |
+--------------------+----------------+----------------+
| Muy mal cliente    |              0 |           1000 |
| Mal cliente        |           1001 |           5000 |
| Cliente normal     |           5001 |          30000 |
| Buen cliente       |          30001 |          60000 |
| Muy buen cliente   |          60001 |       10000000 |
+--------------------+----------------+----------------+
*/
SELECT  CASE 
            WHEN cantidad_facturada >= 0 AND cantidad_facturada <= 1000 THEN 'Muy mal cliente'
            WHEN cantidad_facturada >= 1001 AND cantidad_facturada <= 5000 THEN 'Mal cliente'
            WHEN cantidad_facturada >= 5001 AND cantidad_facturada <= 30000 THEN 'Cliente normal'
            WHEN cantidad_facturada >= 30001 AND cantidad_facturada <= 60000 THEN 'Buen cliente'
            WHEN cantidad_facturada >= 60001 AND cantidad_facturada <= 10000000 THEN 'Muy buen cliente'
        END AS "Categoria",
        COUNT(*) AS "Numero de clientes"
FROM    (
            SELECT  Clientes.IdCliente,
                    SUM(DetallesPedido.PrecioUnitario * DetallesPedido.Cantidad * (1 - DetallesPedido.Descuento)) + SUM(Pedidos.CargoEnvio) AS cantidad_facturada
            FROM    Clientes 
                    JOIN Pedidos ON Clientes.IdCliente = Pedidos.IdCliente
                    JOIN DetallesPedido ON Pedidos.IdPedido = DetallesPedido.IdPedido
            GROUP BY Clientes.IdCliente
        ) AS Subconsulta
GROUP BY 
        CASE 
            WHEN cantidad_facturada >= 0 AND cantidad_facturada <= 1000 THEN 'Muy mal cliente'
            WHEN cantidad_facturada >= 1001 AND cantidad_facturada <= 5000 THEN 'Mal cliente'
            WHEN cantidad_facturada >= 5001 AND cantidad_facturada <= 30000 THEN 'Cliente normal'
            WHEN cantidad_facturada >= 30001 AND cantidad_facturada <= 60000 THEN 'Buen cliente'
            WHEN cantidad_facturada >= 60001 AND cantidad_facturada <= 10000000 THEN 'Muy buen cliente'
        END
ORDER BY "Categoria";


