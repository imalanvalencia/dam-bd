/*
Bases de Datos
Tema 1. Ejercicios de SQL b�sico
Realiza las siguientes consultas SQL
Nombre:
Grupo: 

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

Todas las consultas deben llevar an�lisis de nulos. 

 */

-- --------------------------------------------------------------------------------------

-- Consulta 1. Nombre de las ciudades que comienzan con X. 

SELECT
    Nombre AS 'Paises que inician con X'
FROM
    Pais
WHERE
    Nombre REGEXP BINARY '^X';

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 2. Nombre local y c�digo de dos letras de los pa�ses cuyo c�digo de dos letras no termina en A. 

SELECT
    Nombre AS 'Paises cuyo c�digo de dos letras no termina en A',
    Codigo2
FROM
    Pais
WHERE
    Codigo2 NOT LIKE BINARY '%A';

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 3. Nombre de las lenguas que contienen la letra W (en may�sculas). 

SELECT
    Lengua AS 'Nombre de las lenguas que contienen la letra W (en may�sculas)'
FROM
    LenguaPais
WHERE
    Lengua REGEXP BINARY 'W';

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 4. Nombre y c�digo de los pa�ses que tienen la Y como letra central de su c�digo (los c�digos de pa�s tienen tres letras). 

SELECT
    Nombre AS 'Pa�ses que tienen la Y como letra central de su c�digo',
    Codigo
FROM
    Pais
WHERE
    Codigo REGEXP BINARY '.Y.';

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 5. Nombre de las lenguas que son oficiales o muy habladas. Se considera que una lengua es muy hablada si la habla m�s del 75% de la poblaci�n. 

SELECT
    Lengua AS 'Lenguas que son oficiales o muy habladas',
    EsOficial AS "Es Oficial",
    Porcentaje AS "Porcentaje de hablantes"
FROM
    LenguaPais
WHERE
    EsOficial = 'T'
    OR Porcentaje > 75;

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 6. Nombre local de los pa�ses que han aumentado su producto nacional bruto (PNB) y que o son muy peque�os o tienen muy poca poblaci�n. Entendemos por peque�o una superficie menor que 100 kil�metros cuadrados y muy poca poblaci�n si es menor que 100 mil habitantes. 

SELECT
    Nombre AS 'Pa�ses que han aumentado su PNB y que o son muy peque�os o tienen muy poca poblaci�n'
FROM
    Pais
WHERE
    PNB > PNBAnt
    AND (
        Superficie < 100
        OR Poblacion < 100000
    );

-- Podria haber nulos pero (PNB, PNBAnt) no afecten negativamente la consulta

-- --------------------------------------------------------------------------------------

-- Consulta 7. Nombre local de los pa�ses que han aumentado su producto nacional bruto (PNB) m�s de un 10%. 

SELECT
    Nombre AS 'Pa�ses que han aumentado su PNB m�s de un 10%'
FROM
    Pais
WHERE
    PNB / PNBAnt > 1.10;

-- Podria haber nulos en PNB y PNBAnt pero no afectan negativamente

-- --------------------------------------------------------------------------------------

-- Consulta 8. Listado de ciudades, c�digo del pa�s y poblaci�n ordenador por el c�digo de los pa�ses y dentro de cada pa�s por poblaci�n. 

SELECT
    Lengua,
    CodigoPais AS "Codigo del pais",
    Porcentaje AS "Porcentaje de hablantes"
FROM
    Ciudad
ORDER BY
    CodigoPais,
    Poblacion;

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 9. Listado de leguas que se hablan en el mundo junto con el c�digo del pa�s y el porcentaje de hablantes. Ordenado por pa�ses y dentro de cada pa�s ordenado de la m�s hablada a la menos hablada. 

SELECT
    Lengua,
    CodigoPais AS "Codigo del pais",
    Porcentaje AS "Porcentaje de hablantes"
FROM
    LenguaPais
ORDER BY
    CodigoPais,
    Porcentaje DESC;

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 10. Nombre de los pa�ses, continente, regi�n y superficie ordenado por continente, dentro del mismo contienen por regi�n y dentro de la misma regi�n por superficie. Consulta ORDER BY BINARY en el manual de MySQL. 

SELECT
    Nombre AS "Pais",
    Continente,
    Region,
    Superficie
FROM
    Pais
ORDER BY
    BINARY Continente,
    Region,
    Superficie;

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 11. Nombre de los diez pa�ses con mayor PNB ordenados por PNB. 

SELECT
    Nombre "Los 10 paises con mayor PNB",
    PNB
FROM
    Pais
ORDER BY
    PNB DESC
LIMIT
    10;

-- Podria haber nulos en PNB pero no afectar negativamente la consulta 

-- --------------------------------------------------------------------------------------

-- Consulta 12. Nombre de los diez pa�ses con menor PNBAnt. 

SELECT
    Nombre "Los 10 paises con menor PNBAnt"
FROM
    Pais
WHERE
    PNBAnt IS NOT NULL
ORDER BY
    PNBAnt
LIMIT
    10;

-- Hay nulos en PNB y PNBAnt que podrian afectar negativamente la consulta pero los he eliminado con ISNOTNULL

-- --------------------------------------------------------------------------------------

-- Consulta 13. Nombre de los pa�ses y su a�o de independencia para los pa�ses con a�o de independencia al inicio de cada decenio del sigo XX (1900, 1910, 1920, �, 1990) ordenado por el nombre del pa�s. Nota: usar IN. 

SELECT
    Nombre AS "Paises que se han independizado al inicio del decenio",
    AnyIndep AS "Año independencia"
FROM
    Pais
WHERE
    AnyIndep IN (
        1900,
        1910,
        1920,
        1930,
        1940,
        1950,
        1960,
        1970,
        1980,
        1990
    )
ORDER BY
    Nombre;

-- Podria haber nulos en AnyIndep pero no afectan negativamente la consulta

-- --------------------------------------------------------------------------------------

-- Consulta 14. Nombre de los pa�ses y su a�o de independencia para los pa�ses con a�o de independencia entre 1900 y 1950 ordenado por a�o de independencia. Nota: usar BETWEEN. 

SELECT
    Nombre AS "Paises que se han independizado entre 1900 y 1950",
    AnyIndep AS "Año independencia"
FROM
    Pais
WHERE
    AnyIndep BETWEEN 1900 AND 1950
ORDER BY
    AnyIndep;

-- Podria haber nulos en AnyIndep pero no afectan negativamente la consulta

-- --------------------------------------------------------------------------------------

-- Consulta 15. Nombre de los pa�ses y su porcentaje de incremento o decremento del PNB sobre el PNB antiguo. 

SELECT
    Nombre AS "Pais",
    CONCAT (ROUND((PNB - PNBAnt) / PNBAnt * 100, 2), '%') AS "Porcentaje de incremento/decremento del PNB"
FROM
    Pais
WHERE
    PNB IS NOT NULL
    AND PNBAnt IS NOT NULL;

-- Hay nulos y afectan negativamente la consulta los quito con ISNOTNULL a PNB y PNBAnt

-- --------------------------------------------------------------------------------------

-- Consulta 16. Nombre de los pa�ses y su a�o de independencia para los pa�ses con a�o de independencia que acabe en 30,31,32,...,39. Nota: usar LIKE. 

SELECT
    Nombre AS 'Paises que su años de independencia termina en una decena del 30',
    AnyIndep AS 'Año Independencia'
FROM
    Pais
WHERE
    AnyIndep LIKE '%3_';

-- Podria haber nulos en AnyIndep pero no mafectan negativamente la consulta

-- --------------------------------------------------------------------------------------

-- Consulta 17. Nombre de los pa�ses y su a�o de independencia para los pa�ses con a�o de independencia que acabe en 30,31,32,...,39. Nota: usar REGEXP. 

SELECT
    Nombre AS 'Paises que su años de independencia termina en una decena del 30',
    AnyIndep AS 'Año Independencia'
FROM
    Pais
WHERE
    AnyIndep REGEXP '3.$';

-- Podria haber nulos en AnyIndep pero no mafectan negativamente la consulta

-- --------------------------------------------------------------------------------------

-- Consulta 18. Listado de los nombres de los pa�ses del continente Oceania que tienen a�o de independencia. 

SELECT
    Nombre AS 'Paise de Oceania que sabemos su año de independencia'
FROM
    Pais
WHERE
    Continente = 'Oceania'
    AND AnyIndep IS NOT NULL;


-- --------------------------------------------------------------------------------------

-- Consulta 19. Ciudades cuyo nombre es pal�ndromo

SELECT
    Nombre AS 'Ciudad'
FROM
    Ciudad
WHERE
    Nombre REGEXP REVERSE (Nombre);


-- --------------------------------------------------------------------------------------

-- Consulta 20. Listado de pa�ses que tienen alg�n campo con valor NULL. Muestra dos soluciones usando el operador y la funci�n.  Para la funci�n, mirar el manual de mysql v5.0 en castellano en 12.1.3 la funci�n ISNULL(expr)

SELECT
    Nombre
FROM
    Pais
WHERE
    ISNULL (AnyIndep)
    OR ISNULL (EsperanzaVida)
    OR ISNULL (PNB)
    OR ISNULL (PNBAnt)
    OR ISNULL (CabezaEstado)
    OR ISNULL (Capital);


-- --------------------------------------------------------------------------------------

-- Consulta 21. Listado de pa�ses y el menor de: la renta per c�pita multiplicada por 100 o el PNB por kil�metro cuadrado. El PNB est� expresado en millones de d�lares. 

-- Los nulos podr�an afectar al PNB. Da la casualidad de que no hay ning�n nulo en PNB, pero podr�a haberlo
-- por eso filtramos los nulos

SELECT
    Nombre AS "Pais",
    IF (
        PNB * 1000000 / Poblacion < PNB / Superficie,
        PNB * 1000000 / Poblacion,
        PNB / Superficie
    ) AS "Valor Menor"
FROM
    Pais
WHERE
    PNB IS NOT NULL
    AND PNB <> 0;

-- Podria haber nulos en PNB pero los he elimininado con ISNOTNULL

-- --------------------------------------------------------------------------------------

-- Consulta 22. Listado de pa�ses y su �ndice de crecimiento que ser�: positivo, nulo o negativo seg�n su incremento del PNB haya sido mayor que un 10%, entre 10% positivo y 10% negativo o menor que un 10% negativo, respectivamente. Nota: ver funciones de control de flujo. El resutlado saldr� ordenado esg�n crecimiento positivo, nulo o negativo. 

SELECT
  Nombre AS "Pais",
  CASE
    WHEN (PNB - PNBAnt) / PNBAnt > 0.10  THEN 'Positivo'
    WHEN (PNB - PNBAnt) / PNBAnt BETWEEN -0.10 AND 0.10 THEN 'Nulo'
    WHEN (PNB - PNBAnt) / PNBAnt < 0.10  THEN 'Negativo' -- Tambien se puede usar else
  END AS "�ndice de crecimiento"
FROM Pais
WHERE PNBAnt IS NULL OR PNBAnt = 0 
ORDER BY 2; 
-- Podria haber nulos en PNB pero los he elimininado con ISNOTNULL

-- --------------------------------------------------------------------------------------

-- Consulta 23. Nombres de ciudades en los que el primer car�cter, el central y el �ltimo son el mismo. Para que una ciudad tenga car�cter central debe tener un n�mero impar de letras. 

-- Primero compruebo que s� seleccionar s�lo las que tienen un nombre con un n�mero de letras impar
SELECT Nombre AS "Ciudades que cumplen la condicion"
FROM Ciudad
WHERE (CHAR_LENGTH(Nombre) % 2) <> 0
  AND LOWER(LEFT(Nombre, 1)) = LOWER(SUBSTRING(Nombre, (CHAR_LENGTH(Nombre) + 1) / 2, 1))
  AND LOWER(LEFT(Nombre, 1)) = LOWER(RIGHT(Nombre,1)); 
-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consultas de funciones avanzadas

-- --------------------------------------------------------------------------------------


-- --------------------------------------------------------------------------------------

-- Consulta 24. Nombre de las ciudades de seis o m�s letras en las que sus tres primeros caracteres son iguales que los tres �ltimos, pero invertidos. Por ejemplo, la ciudad inventada Asidatisa deber�a salir porque sus tres primeros caracteres son los mismos que los tres �ltimos invertidos. 

SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    CHAR_LENGTH(Nombre) >= 6
    AND LOWER(LEFT (Nombre, 3)) = LOWER(REVERSE (RIGHT (Nombre, 3)));

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 25. Nombre de los pa�ses en los que ninguna de las dos primeras letras del c�digo del pa�s aparcen en el nombre del mismo pa�s. Por ejemplo, el pa�s inventado Hispania con c�digo, tambi�n inventado, OLE aparecer�a ya que ni la 'O' ni la 'L' est�n en el nombre del pa�s. 

SELECT
    Nombre "Paises que cumplen la condicion"
FROM
    Pais
WHERE
    LOWER(Nombre) NOT REGEXP CONCAT ('[', LOWER(LEFT (Codigo2, 2)), ']');

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 26. Nombre de las ciudades de m�s de cinco letras que tienen su primer, tercer y quinto caracteres iguales
SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    CHAR_LENGTH(Nombre) > 5
    AND LOWER(SUBSTRING(Nombre, 1, 1)) = LOWER(SUBSTRING(Nombre, 3, 1))
    AND LOWER(SUBSTRING(Nombre, 1, 1)) = LOWER(SUBSTRING(Nombre, 5, 1));

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 27. Nombre de las ciudades en las que la primera letra de la ciudad coincide con su �ltima letra y adem�s, coincide tambi�n con la primera y �ltima letra de la zona de dicha ciudad. Por ejemplo, la ciudad inventada Alisana de la zona (tambi�n inventada) Acena deber�a salir porque el nombre de la ciudad empieza y acaba con la letra 'a' y su zona tambi�n. 

SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    LOWER(LEFT (Nombre, 1)) = LOWER(RIGHT (Nombre, 1))
    AND LOWER(LEFT (Nombre, 1)) = LOWER(LEFT (Zona, 1))
    AND LOWER(LEFT (Zona, 1)) = LOWER(RIGHT (Zona, 1));

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 28. Nombre de las ciudades de cinco caracteres o m�s en las que el �ltimo, el antepen�ltimo y el quinto car�cter por la derecha son el mismo. Por ejemplo la ciudad inventada Melatasa saldr�a porque su �ltimo car�cter, el antepen�ltimo y el quinto por la derecha son el mismo: la letra a. 

SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    CHAR_LENGTH(Nombre) >= 5
    AND LOWER(RIGHT (Nombre, 1)) = LOWER(SUBSTRING(Nombre, -3, 1))
    AND LOWER(SUBSTRING(Nombre, -3, 1)) = LOWER(SUBSTRING(Nombre, -5, 1));

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 29. Nombre de las ciudades en las que su primer y �ltimo car�cter son a y tienen dos a adicionales por en medio. Por ejemplo la ciudad inventada Amelatasa saldr�a porque empieza y acaba por a y tiene dos caracteres a m�s por dentro de la palabra. Si una palabra tiene m�s letras a por medio tambi�n saldr�a porque cumple la condici�n. 

SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    LOWER(LEFT (Nombre, 1)) = 'a'
    AND LOWER(RIGHT (Nombre, 1)) = 'a'
    AND (
        CHAR_LENGTH(Nombre) - CHAR_LENGTH(REPLACE (LOWER(Nombre), 'a', ''))
    ) >= 4;

--FIXME:

-- --------------------------------------------------------------------------------------

-- Consulta 30. Nombre de las ciudades que cumplen las siguientes condiciones: el nombre de la cuidad y el de su zona, tienen cinco caracteres cada uno; adem�s, los caracteres segundo, tercero y cuarto del nombre de la ciudad coinciden con los mismos caracteres de su zona y, por �ltimo, el nombre de la ciudad es distinto del de la zona. Por ejemplo la ciudad inventada Caise de la zona, tambi�n inventada, Taiso saldr�a porque tanto la ciudad como la zona tienen 5 caracteres, los caracteres segundo, tercero y cuarto de la ciudad: 'ais' coninciden con el segundo, tercer y cuarto car�cter de la zona y, por �ltimo, el nobre de la ciudad y la zona son diferentes. 

SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    CHAR_LENGTH(Nombre) = 5
    AND CHAR_LENGTH(Zona) = 5
    AND LOWER(SUBSTRING(Nombre, 2, 3)) = LOWER(SUBSTRING(Zona, 2, 3))
    AND LOWER(Nombre) <> LOWER(Zona);

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 31. Listado con el nombre de los pa�ses. En un 10% de los pa�ses m�s o menos, sus dos primeras letras estar�n intercambiadas con las may�sculas y min�sculas correctas. Por ejemplo, si el pa�s se llama Spain pondr� Psain, pero esto s�lo pasar� en un 10% de los casos. 

SELECT
    CASE
        WHEN RAND () < 0.1 THEN CONCAT (
            UPPER(SUBSTRING(Nombre, 2, 1)),
            LOWER(SUBSTRING(Nombre, 1, 1)),
            SUBSTRING(Nombre, 3)
        )
        ELSE Nombre
    END AS "Pais"
FROM
    Pais;

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 32. Nombre de las ciudades de cinco caracteres o m�s en las que el primer caracter, el pen�ltimo y el cuarto por la derecha son iguales. Por ejemplo la ciudad inventada Aibonasal saldr�a porque su primer car�cter, pen�ltimo car�cter y el cuarto por la derecha son el mismo: la letra a. 

SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    CHAR_LENGTH(Nombre) >= 5
    AND LOWER(LEFT (Nombre, 1)) = LOWER(SUBSTRING(Nombre, -2, 1))
    AND LOWER(LEFT (Nombre, 1)) = LOWER(SUBSTRING(Nombre, -4, 1));

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 33. Listado con el nombre de los pa�ses. En un 10% de los pa�ses m�s o menos, las vocales 'a' estar�n cambiadas por la 'e' y la 'e' por la a. Por ejemplo, si el pa�s se llama Argentina y pertenece al 10% de pa�ses en los que se cambia su nombre, pondr� Ergantina. 

SELECT
    CASE
        WHEN RAND () < 0.1 THEN
        -- necesito un intercambio seguro  y por eso uso un marcador temporal '§'
        REPLACE (
            REPLACE (REPLACE (LOWER(Nombre), 'a', '§'), 'e', 'a'),
            '§',
            'e'
        )
        ELSE Nombre
    END AS "Pais"
FROM
    Pais;

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 34. Listado con el nombre de los pa�ses con todas sus letras en min�scula. En un 20% de los pa�ses m�s o menos, las vocales 'e' y las vocales 'i' estar�n cambiadas por la vocal 'a'. Por ejemplo, si el pa�s se llama 'Northern Mariana Islands' y pertenece al 20% de pa�ses en los que se cambia su nombre, pondr� 'northarn maraana aslands'. 

SELECT
    CASE
        WHEN RAND () < 0.2 THEN REPLACE (REPLACE (LOWER(Nombre), 'e', 'a'), 'i', 'a')
        ELSE LOWER(Nombre)
    END AS "Pais"
FROM
    Pais;

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 35. Nombre de las ciudades de siete o m�s letras en las que sus tres primeros caracteres son iguales que los caracteres cinco, seis y siete, pero invertidos. Por ejemplo, la ciudad inventada Tasisatonia deber�a salir porque sus tres primeros caracteres: 'Tas' son los mismos que los caracteres quinto, sexto y s�ptimo: 'sat' pero invertidos. 

SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    CHAR_LENGTH(Nombre) >= 7
    AND LEFT (Nombre, 3) = REVERSE (SUBSTRING(Nombre, 5, 3));

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 36. Listado con el nombre de los pa�ses en min�sculas. En un 10% de los pa�ses m�s o menos sus dos primeras letras estar�n intercambiadas
/* Salida similar a:
+---------------------+
| Pa�s                |
+---------------------+
| aruba               |
| afghanistan         |
| angola              |
| anguilla            |
| labania             | -- El nombre del pa�s es Albania
| andorra             |
 */

SELECT
    CASE
        WHEN RAND () < 0.10 THEN CONCAT (
            LOWER(SUBSTRING(Nombre, 2, 1)),
            LOWER(SUBSTRING(Nombre, 1, 1)),
            LOWER(SUBSTRING(Nombre, 3))
        )
        ELSE LOWER(Nombre)
    END AS "Pais"
FROM
    Pais;

-- No hay nulos
-- ----------------------------------------------------------------------------
-- Consulta 37. Listado de ciudades de m�s de 5 letras en las que el primer car�cter es igual al �ltimo y el tercero es igual al antepen�ltimo. El listado saldr� ordenado de las ciudades con menos caracteres a las que m�s tienen
/* Salida similar a:
+--------------------+
| Ciudad             |
+--------------------+
| Neuqu�n            |
| Ibaraki            |
| Obihiro            |*/

SELECT
    Nombre AS "Ciudades que cumplen la condicion"
FROM
    Ciudad
WHERE
    CHAR_LENGTH(Nombre) > 5
    AND LOWER(LEFT (Nombre, 1)) = LOWER(RIGHT (Nombre, 1))
    AND LOWER(SUBSTRING(Nombre, 3, 1)) = LOWER(SUBSTRING(Nombre, CHAR_LENGTH(Nombre) -2, 1))
ORDER BY
    CHAR_LENGTH(Nombre) ASC;

-- No hay nulos

-- --------------------------------------------------------------------------------------

-- Consulta 38. Listado con el nombre de los pa�ses en min�sculas. En un 10% de los pa�ses m�s o menos se intercambiar�n la primera y la �ltima letra
/* Salida similar a:
+---------------------+
| Pa�s                |
+---------------------+
| aruba               |
| nfghanistaa         | -- El nombre del pa�s es Afghanistan
| angola              |*/

SELECT
    CASE
        WHEN RAND () < 0.10
        AND CHAR_LENGTH(Nombre) >= 2 THEN CONCAT (
            LOWER(RIGHT (Nombre, 1)),
            LOWER(SUBSTRING(Nombre, 2, CHAR_LENGTH(Nombre) -2)),
            LOWER(LEFT (Nombre, 1))
        )
        ELSE LOWER(Nombre)
    END AS "Pais"
FROM
    Pais;

-- No hay nulos