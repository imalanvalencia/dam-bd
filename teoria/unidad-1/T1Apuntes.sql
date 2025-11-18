/*
Bases de Datos
Tema 1. SQL B�sico
Consultas de clase. Apuntes.

Grupo: 1�DAM

El tratamiento de nulos y consultas vac�as ser� el mismo que hemos hecho en clase.
   
-- Ejemplo de consulta
-- 10. Listado de pa�ses del continente europeo
 SELECT Nombre AS 'Pa�ses del continente europeo'
 FROM   Pais
 WHERE  Continente = 'Europe'
*/

-- -----------------------------------------------------------------
-- Tema 1. SQL B�sico. Consultas de clase. Apuntes.
-- -----------------------------------------------------------------

-- 1. Listado con el nombre y continente de los pa�ses

SELECT Nombre AS 'Pais', Continente
FROM   Pais;
-- No hay nulos

-- 2. Listado del c�digo de los pa�ses

SELECT Codigo AS 'C�digo'
FROM   Pais;
-- No hay nulos

-- 3. Listado del nombre y continente de los diez primeros pa�ses

SELECT Nombre AS 'Pa�s', Continente
FROM   Pais
LIMIT  10; -- Limitar la busqueda a los 10 primeros paises
-- No hay nulos

-- 4. Listado de todos los campos de los cien primeros registros de la tabla Ciudad

SELECT  * 
FROM    Ciudad
LIMIT   100;
-- No hay nulos

-- 5. Obtener un listado con el c�digo del pa�s, vuestro nombre, la esperanza de vida en d�as y el nombre local en may�sculas

SELECT Codigo               AS 'C�digo del Pa�s',
       'Carlos'             AS 'Mi nombre',
       EsperanzaVida * 365  AS 'Esperanza de Vida', 
UPPER (NombreLocal)         AS 'Nombre Local'
FROM   Pais;
-- Hay nulos y afectan negativamente la consulta

-- Esta cosulta tambi�n funciona bien

        SELECT Codigo
AS 'C�digo del pa�s'
      ,
'Sim�n' 
AS 'Mi nombre', EsperanzaVida 
* 365 AS
'Esperanza de vida en d�as',
       UPPER(NombreLocal) AS
'Nombre local en may�sculas' FROM   Pais;
-- Hay nulos y afectan negativamente la consulta

-- 6. Listado de todos los continentes

SELECT DISTINCT Continente -- Etiqueta DISTINCT para no repetir valores
FROM            Pais;
-- No hay nulos


-- Para que no se repita una linea con el mismo Continente + Nombre pero s� se repite continente seg�n el pa�s.

SELECT DISTINCT Continente, Nombre AS "Nombre del Pa�s" 
FROM            Pais;

-- No hay nulos

-- 7. Listado de lenguas y si es oficial o no

SELECT DISTINCT Lengua, EsOficial AS "Es Oficial"
FROM LenguaPais;
-- No hay nulos

-- 8. Ciudades y su poblaci�n

SELECT Nombre AS "Ciudad", Poblacion AS "Poblaci�n"
FROM Ciudad;
-- No hay nulos

-- 9. Listado de pa�ses del continente europeo

SELECT Nombre AS 'Paises del continente Europeo'
FROM Pais
WHERE Continente = 'Europe';
-- No hay nulos

-- 10. Nombre local de los pa�ses de continente europeo con fecha de independencia menor que 1900

SELECT NombreLocal AS 'Pa�s', AnyIndep AS 'A�o en el que se independiz�'
FROM Pais
Where Continente = 'Europe' AND AnyIndep < 1900;
-- Hay nulos pero no afectan negativamente la consulta

-- 11. Ciudades con m�s de cinco millones de habitantes

SELECT Nombre AS "Ciudad con m�s de 5M habitantes"
FROM Ciudad WHERE Poblacion > 5000000
ORDER BY 1;
-- Hay nulos pero no afectan negativamente la consulta

-- WARNING AL PEGAR "multiLinePasteWarning": false

/*
Errores en MySQL

1. El error se marca en el mismo sitio en el que lo hemos cometido
SELECT Nombre AS 'Ciudades con m�s de cinco millones de habitantes'
FROM   Ciudad
WHERE  Poblacion ) 5000000;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near ') 5000000' at line 3

2. El error se marca m�s adelante del sitio en el que lo hemos cometido
SELECT Nombre AS 'Ciudades con m�s de cinco millones de habitantes'
FROM   Ciudad
WHERE  Poblacion ( 5000000
ORDER BY 1;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'ORDER BY 1' at line 4

3. El error se marca al final de la consulta
SELECT Nombre AS 'Ciudades con m�s de cinco millones de habitantes'
FROM   Ciudad
WHERE  Poblacion ( 5000000;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near '' at line 3
*/

-- 12. Pa�ses que siendo ricos, tienen una esperanza de vida peque�a. Nota: mirar los datos de las tablas y estimar unos valores de manera que nos salgan unos diez o quince pa�ses que siendo ricos tienen una esperanza de vida peque�a

SELECT Nombre AS 'Pa�s', EsperanzaVida AS 'Esperanza de Vida'
FROM Pais 
WHERE PNB > 75000 AND EsperanzaVida < 70
ORDER BY 2
LIMIT 15;
-- Hay nulos pero no afectan negativamente la consulta


-- 13. Realiza la misma consulta anterior, pero ahora, b�sate en la renta per c�pita para evaluar la riqueza de un pa�s

SELECT   Nombre AS 'Pa�s', EsperanzaVida AS 'Esperanza de Vida'
FROM     Pais 
WHERE    PNB / Poblacion * 1000000 > 5000 AND EsperanzaVida < 70
ORDER BY 2
LIMIT    15;
-- Hay nulos pero no afectan negativamente la consulta

-- 14. Ciudades con una poblaci�n entre cien mil y ciento veinte mil habitantes usando el operador BETWEEN y sin usarlo

SELECT   Nombre AS 'Ciudad'
FROM     Ciudad
WHERE    Poblacion >= 100000 AND Poblacion <= 120000
ORDER BY 1;
-- No hay nulos

-- Con BETWEEN

	SELECT   Nombre AS 'Ciudad' 
	FROM     Ciudad
	WHERE    Poblacion BETWEEN 100000 AND 120000
	ORDER BY 1;
	-- No hay nulos
	
-- 15. Pa�ses y su esperanza de vida ordenados por esperanza de vida

	SELECT   Nombre AS 'Pais', EsperanzaVida AS 'Esperanza de Vida'
	FROM     Pais
	ORDER BY EsperanzaVida;
	-- hay nulos pero no afectan  negativamente 

-- 16. Pa�ses y su esperanza de vida ordenados por esperanza de vida de mayor a menor

	SELECT   Nombre AS 'Pais', EsperanzaVida AS 'Esperanza de Vida'
	FROM     Pais
	ORDER BY EsperanzaVida DESC;
	-- hay nulos pero no afectan  negativamente 

-- 17. Nombre de los diez �ltimos pa�ses en independizarse

	SELECT   Nombre AS 'Diez �ltimos pa�ses en independizarse'
	FROM     Pais
	ORDER BY AnyIndep DESC
	LIMIT    10;
	-- hay nulos y afectan  negativamente la consulta


-- 18. Nombre de los diez primeros pa�ses en independizarse

	SELECT   Nombre AS 'Diez primeros pa�ses en independizarse'
		FROM     Pais
		WHERE    AnyIndep IS NOT NULL -- Para que no coja NULL
		ORDER BY AnyIndep
		LIMIT 10;
		-- hay nulos y afectan  negativamente la consulta por eso hemos usado "IS NOT NULL"  para exceptuarlos
		
-- NULL en expresiones:
-- No pondremos nunca = NULL, <> NULL, > NULL, + NULL, * NULL, etc
-- S�lo son v�lidas IS NULL o IS NOT NULL

-- 19. Pa�ses cuyo a�o de independencia fue 1960 ordenados por poblaci�n de mayor a menor poblaci�n
SELECT Nombre AS 'Paises que se independizaron en 1960' FROM Pais
Where AnyIndep = 1960
ORDER BY Poblacion DESC;
-- Hay nulos pero no afectan negativamente la consulta

-- 20. Listado de pa�ses y su esperanza de vida ordenados por su densidad de poblaci�n
SELECT Nombre AS 'Pais', EsperanzaVida AS 'Esperanza Vida'
FROM Pais
ORDER BY  Poblacion / Superficie; -- Aparece los paises con valores NULL
-- Hay nulos y afectan negativamente la consulta



SELECT Nombre AS 'Pais', EsperanzaVida AS 'Esperanza Vida', Poblacion / Superficie AS 'Densidad de Poblacion'
FROM Pais
ORDER BY  Poblacion / Superficie; -- Aparece los paises con valores NULL
-- Hay nulos y afectan negativamente la consulta


SELECT Nombre AS 'Pais', 
		EsperanzaVida AS 'Esperanza Vida', 
		Poblacion / Superficie AS 'Densidad de Poblacion'
FROM Pais
WHERE Poblacion / Superficie IS NULL  -- !MANERA INCORRECTA: WHERE Poblacion IS NULL OR Superficie IS NULL
ORDER BY  Poblacion / Superficie; 

-- 21. Listado de pa�ses que o tienen una superficie muy grande; o tienen una superficie muy peque�a con una densidad de poblaci�n alta
SELECT Nombre AS 'Pais'		
FROM Pais
WHERE Superficie > 250000 OR Superficie < 1000 AND Poblacion / Superficie  > 800; 
-- Hay nulos pero no afectan negativamente la consulta


-- 22. Listado de los diez pa�ses m�s ricos. En este caso entendemos por pa�s rico aquel en el que cada kil�metro cuadrado de superficie tiene m�s valor (PNB)
SELECT Nombre as 'Los diez pa�ses m�s ricos', 
FROM Pais
WHERE PNB / Superficie IS NOT NULL
ORDER BY PNB / Superficie DESC
LIMIT 10;
-- los nulos s� afectan negativamente y los hemos quitado con IS NULL o IS NOT NULL

-- 23. Los diez pa�ses con menos densidad de poblaci�n
SELECT Nombre as 'Los diez pa�ses menos densidad de Poblacion', 
FROM Pais
ORDER BY Poblacion / Superficie -- Podria haber nulos
LIMIT 10;
-- Hay nulos y afectan negativamente la consulta
-- Aunque no tiene sentido un pa�s con superficie 0, podr�a haberlo debido a un error del usuario que ha introducido los datos
-- Las bases de datos son din�micas. El que una consulta salga bien hoy, no quiere decir que vaya a salir bien ma�ana

SELECT Nombre as 'Los diez pa�ses menos densidad de Poblacion', 
FROM Pais
WHERE Poblacion / Superficie IS NOT NULL
ORDER BY Poblacion / Superficie -- No hay nulos porque los hemos eliminado con "IS NOT NULL"
LIMIT 10;
-- los nulos s� afectan negativamente y los hemos quitado con IS NULL o IS NOT NULL

-- 24. Listado de pa�ses, continentes y regiones ordenados por continente y por regi�n
SELECT Nombre AS 'Pais',  Continente AS 'Continente', Region AS 'Region'
FROM Pais
ORDER BY Continente, Region; -- No afectan los nulos porque Nombre, Continente y Region no admiten null en su contrato
-- Tiene cierto problema con los caracteres (ver ASIA Y AFRICA)

SELECT Nombre AS 'Pais',  Continente AS 'Continente', Region AS 'Region'
FROM Pais
ORDER BY BINARY Continente, Region; --binary solo afecta a continente

-- 25. Listado de los diez mejores pa�ses teniendo en cuenta el �ndice de mejor pa�s. El �ndice de mejor pa�s se calcula teniendo en cuenta el �ndice de renta per c�pita (que pondera un 40%) que asigna 100 al pa�s con mayor renta per c�pita, el �ndice de incremento del PNB (que pondera un 30%), que asigna 100 al pais con mayor incremento del PNB y el �ndice de esperanza de vida (que pondera un 30%) que asigna 100 al pa�s con mayor esperanza de vida

-- IMP = IRPC

-- Renta per capital
SELECT Nombre AS 'Pais',  PNB * 100000 / Poblacion
FROM Pais
ORDER BY 2;

-- Renta per capital y Asignacion de puntos
SELECT Nombre AS 'Pais',  PNB * 100000 / Poblacion / INDICEDELMAYORPAIS
FROM Pais
ORDER BY 2;

-- Incremento de PNB

SELECT Nombre AS 'Pais', PNB / PNBAnt 
FROM Pais
ORDER BY  2;

-- Incremento de PNB y asignacion de los puntos

SELECT Nombre AS 'Pais', PNB / PNBAnt / INCREMENTODELMAYORPAIS * 100
FROM Pais
ORDER BY  2;

-- Indice de Esperanza de Vida 

SELECT Nombre,EsperanzaVida AS 'Pais'
FROM Pais
ORDER BY 2;

-- Indice de Esperanza de Vida y Asignacion del punto

SELECT Nombre,EsperanzaVida /  INDICEDELMAYORPAIS  * 100 AS 'Pais'
FROM Pais
ORDER BY 2;

-- Solucion 

SELECT Nombre,
		PNB * 100000 / Poblacion / INDICEDELMAYORPAIS 	* 0.4 +
		PNB / PNBAnt / INCREMENTODELMAYORPAIS * 100 	* 0.3 +
		EsperanzaVida / INDICEDELMAYORPAIS  * 100 		* 0.3
		AS 'Indice del mejor Pais'
FROM Pais
ORDER BY 2;

-- Solucion esta tabla y BUENAS PRACTICAS

SELECT Nombre,
		PNB * 100000 / Poblacion / 3745.926096 	* 0.4 + -- Indice de renta per capital
		PNB / PNBAnt / 2.814875 * 100 			* 0.3 + -- Indice incremento del PNB
		EsperanzaVida / 83.5  * 100 			* 0.3   -- Indice de esperanza de vida
		AS 'Indice del mejor Pais'
FROM Pais
ORDER BY 2;

-- Redondear

SELECT Nombre,
	ROUND (
		PNB * 100000 / Poblacion / 3745.926096 	* 0.4 + -- Indice de renta per capital
		PNB / PNBAnt / 2.814875 * 100 			* 0.3 + -- Indice incremento del PNB
		EsperanzaVida / 83.5  * 100 			* 0.3,   -- Indice de esperanza de vida
	2 )
		AS 'Indice del mejor Pais'
FROM Pais
ORDER BY 2;

-- Llamar por un Alias

SELECT Nombre,
	ROUND (
		PNB * 100000 / Poblacion / 3745.926096 	* 0.4 + -- Indice de renta per capital
		PNB / PNBAnt / 2.814875 * 100 			* 0.3 + -- Indice incremento del PNB
		EsperanzaVida / 83.5  * 100 			* 0.3,   -- Indice de esperanza de vida
	2 )
		AS 'Indice del mejor Pais'
FROM Pais
ORDER BY  `Indice del mejor Pais`  DESC; -- Hay nulos pero podrian llegar a afectar 

-- Eliminar nulos 

SELECT Nombre,
	ROUND (
		PNB * 100000 / Poblacion / 3745.926096 	* 0.4 + -- Indice de renta per capital
		PNB / PNBAnt / 2.814875 * 100 			* 0.3 + -- Indice incremento del PNB
		EsperanzaVida / 83.5  * 100 			* 0.3,   -- Indice de esperanza de vida
	2 )
		AS 'Indice del mejor Pais'
FROM Pais
WHERE 	PNB * 100000 / Poblacion / 3745.926096 	* 0.4 + -- Indice de renta per capital
		PNB / PNBAnt / 2.814875 * 100 			* 0.3 + -- Indice incremento del PNB
		EsperanzaVida / 83.5  * 100 			* 0.3   -- Indice de esperanza de vida
			IS NOT NULL
		-- Hay que hacerlo asi debido a que el where se ejecuta al inicio del todo 

		
ORDER BY  `Indice del mejor Pais`  DESC; -- No hay nulos

-- falto el limit

SELECT Nombre,
	ROUND (
		PNB * 100000 / Poblacion / 3745.926096 	* 0.4 + -- Indice de renta per capital
		PNB / PNBAnt / 2.814875 * 100 			* 0.3 + -- Indice incremento del PNB
		EsperanzaVida / 83.5  * 100 			* 0.3,   -- Indice de esperanza de vida
	2 )
		AS 'Indice del mejor Pais'
FROM Pais
WHERE 	PNB * 100000 / Poblacion / 3745.926096 	* 0.4 + -- Indice de renta per capital
		PNB / PNBAnt / 2.814875 * 100 			* 0.3 + -- Indice incremento del PNB
		EsperanzaVida / 83.5  * 100 			* 0.3   -- Indice de esperanza de vida
			IS NOT NULL
		-- Hay que hacerlo asi debido a que el where se ejecuta al inicio del todo 

		
ORDER BY  `Indice del mejor Pais`  DESC
LIMIT 10; -- No hay nulos

-- ----------------------------------------------------------------------------
-- LIKE / NOT LIKE
-- ----------------------------------------------------------------------------

SELECT Nombre FROM Ciudad Where Nombre LIKE 'a_a%a'; --TE ENTREGA TODAS LAS CONSULTAS SIN IMPORTAR MINUSCULAS/MAYUSCULAS
SELECT Nombre FROM Ciudad Where Nombre LIKE BINARY 'a_a%a'; -- SOLO ENTREGA LAS COINCINDENCIA TENIENDO EN CUENTA LAS MINUSCULAS/MAYUSCULAS

SELECT Nombre FROM Ciudad Where Nombre LIKE '%i'; --TE ENTREGA TODAS LAS CONSULTAS SIN IMPORTAR TILDES
SELECT Nombre FROM Ciudad Where Nombre LIKE BINARY '%�'; -- SOLO ENTREGA LAS COINCINDENCIA TENIENDO EN CUENTA LAS ACENTOS

-- 26. Listado de las ciudades que empiezan por 'A' (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre LIKE BINARY 'A%'; -- No hay nulos

-- 27. Listado de ciudades que acaban por 'z' (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre LIKE  '%z'; -- No hay nulos

-- 28. Listado de ciudades que contienen los caracteres 'an' dentro de su nombre (tambi�n pueden empezar o acabar por 'an') (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre LIKE  '%an%'; -- No hay nulos

-- 29. Listado de ciudades que tienen tres caracteres (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre LIKE  '___'; -- No hay nulos

-- 30. Listado de ciudades que no contienen la letra a (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre NOT LIKE  '%a%'; -- No hay nulos

-- ----------------------------------------------------------------------------
-- REGEXP
-- ----------------------------------------------------------------------------
Select Nombre FROM Ciudad WHERE Nombre REGEXP 'ed';
Select Nombre FROM Ciudad WHERE Nombre LIKE 'ed'; -- son diferentes

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP '^ed'; -- empiezan por ed

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP 'ed$'; -- terminan por ed

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP 'ed'; -- contengan por ed

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP '.al'; -- Cualquier caracter

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP 'al*i'; -- que contengan a, 0 o muchas l e i (Tallinn, Tallinn, alllli, ...)

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP '(al)*i'; -- que contengan a, 0 o muchas l e i (i,ali,alali, alalalali, ...)

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP 'al+i'; -- que contengan a, 1 o muchas l e i (ali,alli, ...)

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP 'al?i'; -- que contengan a, 0 o 1 l e i (ali,alli, ...)

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP 'al | '; -- que contengan uno u otro exp

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP '^(al)i'; -- agrupar valores y tome una exp (que empiecen por al)

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP '^(al){1,}i'; -- min y max caractes de veces que se repite {min,max}	
-- � a*
-- Can be written as a{0,}.
-- � a+
-- Can be written as a{1,}.
-- � a?
-- Can be written as a{0,1}.

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP 'a[abcdefghir]i'; -- 
SELECT Nombre FROM Ciudad WHERE Nombre REGEXP 'a[a-ir]i'; -- 

SELECT Nombre FROM Ciudad WHERE Nombre NOT REGEXP '{[:space]}'; -- 

SELECT Nombre FROM Ciudad WHERE Nombre REGEXP '\\.'; -- exceptuar regexp


-- 31. Reescribe todas las consultas anteriores (las que usan LIKE) con expresiones regulares

-- 31.1- 26. Listado de las ciudades que empiezan por 'A' (LIKE)

SELECT Nombre 
FROM Ciudad 
Where Nombre REGEXP BINARY '^A'; -- No hay nulos

-- 31.2- 27. Listado de ciudades que acaban por 'z' (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre REGEXP  '$z'; -- No hay nulos

-- 31.3- 28. Listado de ciudades que contienen los caracteres 'an' dentro de su nombre (tambi�n pueden empezar o acabar por 'an') (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre REGEXP 'an'; -- No hay nulos

-- 31.4- 29. Listado de ciudades que tienen tres caracteres (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre REGEXP  '^.{3}$'; -- No hay nulos

-- 31.5- 30. Listado de ciudades que no contienen la letra a (LIKE)
SELECT Nombre 
FROM Ciudad 
Where Nombre NOT REGEXP  'a'; -- No hay nulos

-- 32. Nombre de las ciudades que s�lo incluyen las cinco primeras letras del abecedario (REGEXP)
SELECT Nombre AS 'Las ciudades que s�lo incluyen las cinco primeras letras del abecedario'
FROM Ciudad 
Where Nombre REGEXP  '^[a-e]+$'; -- No hay nulos

-- 33. Nombre de los pa�ses que incluyen en su nombre su c�digo de dos caracteres
SELECT Nombre AS 'Pais', Codigo2
FROM Pais 
WHERE Nombre REGEXP Codigo2; -- No hay nulos

SELECT Nombre AS 'Pais', Codigo2
FROM Pais 
WHERE Nombre LIKE CONCAT('%' ,Codigo2, '%'); -- No hay nulos



-- 34. Nombre de los pa�ses que incluyen en su nombre su c�digo de dos caracteres, pero no al principio de su nombre
SELECT Nombre AS 'Pais', Codigo2
FROM Pais 
WHERE Nombre REGEXP CONCAT('.' , Codigo2); -- No hay nulos

SELECT Nombre AS 'Pais', Codigo2
FROM Pais 
WHERE Nombre LIKE CONCAT('_%' ,Codigo2, '%'); -- No hay nulos

-- ----------------------------------------------------------------------------
-- IN
-- ----------------------------------------------------------------------------

-- 35. Pa�ses de los continentes de Antarctica o Ocean�a
SELECT Nombre AS 'Paises de Antarctica o Ocean�a'
FROM Pais
WhERE Continente = 'Antarctica' OR Continente = 'Oceania'; -- No hay nulos

SELECT Nombre AS 'Paises de Antarctica o Oceania'
FROM Pais
WhERE Continente IN ('Antarctica', 'Ocean�a') ; -- No hay nulos

-- 36.  Pa�ses que no son ni del continente Asi�tico ni del Europeo
SELECT Nombre AS 'Paises de Antarctica o Ocean�a'
FROM Pais
WHERE Continente NOT IN ('Asia', 'Europa'); -- No hay nulos

-- ----------------------------------------------------------------------------
-- FUNCIONES
-- ----------------------------------------------------------------------------
ROUND -- Redondea un numero
LEFT -- Selecciona las cadenas (cadena, n cadena a selecionar)
SQRT -- raiz cuadrada

-- se pueden combinar funciones
SELECT LEFT(LOWER('Hola, MUNDO Cruel'), ROUND(SQRT(120))) -- DEVOLVERA LOS 11 CARACTERES DE LA CADENA

-- 37. Listado de pa�ses en los que aparezca el continente, la regi�n y el nombre del pa�s en usa sola columna. Cada campo ira separado por � // �. El resultado saldr� ordenado

SELECT CONCAT(Continente, ' // ', Region,  ' // ', Nombre) AS 'Pais Formatiado (Continete, Region, Nombre Pais)' 
FROM Pais
Order BY `Pais Formatiado (Continete, Region, Nombre Pais)`; -- No hay nulos

SELECT CONCAT(Continente, ' // ', Region,  ' // ', Nombre) AS 'Pais Formatiado (Continete, Region, Nombre Pais)' 
FROM Pais
Order BY BINARY Continente, BINARY Region BINARY Nombre; -- No hay nulos

SELECT CONCAT_WS(' // ', Continete, Region, Nombre) AS 'Pais Formatiado (Continete, Region, Nombre Pais)' FROM Pais; -- No hay nulos

 
SELECT CONCAT_WS(' // ', Continete, Region, Nombre) AS 'Pais Formatiado (Continete, Region, Nombre Pais)' 
FROM Pais
Order BY `Pais Formatiado (Continete, Region, Nombre Pais)`; -- No hay nulos

-- 38. Realiza la misma consulta anterior, pero pon todas las letras de Continente y regi�n en may�sculas y todas las del pa�s en min�sculas
SELECT CONCAT(UPPER(Continente), ' // ', 
			  UPPER(Region),  	 ' // ', 
			  LOWER(Nombre)) 			 AS 'Pais Formatiado (Continete, Region, Nombre Pais)' 
FROM Pais
Order BY `Pais Formatiado (Continete, Region, Nombre Pais)`; -- No hay nulos

SELECT CONCAT_WS(' // ', UPPER(Continente), UPPER(Region), LOWER(Nombre)) AS 'Pais Formatiado (Continete, Region, Nombre Pais)' 
FROM Pais
Order BY `Pais Formatiado (Continete, Region, Nombre Pais)`; -- No hay nulos

-- 39. Realiza un listado de nombres de usuario y contrase�as. El nombre de usuario ser� el nombre del pa�s sin espacios en blanco. La contrase�a estar� formada por los tres primeros caracteres del continente, el c�digo 2 del pa�s y los tres �ltimos caracteres de su capital (del c�digo de la ciudad). Tanto el nombre de usuario como la contrase�a estar�n en min�sculas
SELECT  LOWER(REPLACE(Nombre, ' ')) AS 'Nombre de usuario', 
		LOWER(CONCAT(LEFT(Continente, 3), Codigo2, Right(Capital, 3))) AS 'Contrase�a'
		
FROM Pais
WHERE Capital IS NOT NULL; -- Podrian haber nulos y afectar la consulta negativamente pero los hemos quitado con IS NOT NULL

-- 40. Calcula el �ndice YQS de un pa�s. El resultado saldr� redondeado. Su f�rmula es:
-- YQS = ((Superficie + Ra�z cuadrada de ( PNB / 1000000)) partido por 
--        (Poblacion / 1000000 m�s el valor absoluto del a�o de independencia)) m�s 
--       (PNB / PNBAnt) elevado a la sexta potencia

SELECT Nombre AS 'Pais', 
	   ROUND(
	   (Superficie + SQRT( PNB / 1000000)) 
	   / (Poblacion / 1000000 + ABS(AnyIndep)) 
	   + POW(PNB / PNBAnt, 6)
	   )  AS 'Indice YQS'
	   
FROM Pais
WHERE AnyIndep IS NOT NULL AND  PNB IS NOT NULL AND  PNBAnt IS NOT NULL AND PNBAnt <> 0; -- Pueden haber nulos que afecten negativamente la consulta pero los hemos quitado con is not null y <> 0

-- 41. Queremos un listado de pa�ses y su poblaci�n. Queremos introducir un error en la poblaci�n de �10%. Es decir, si la poblaci�n de un pa�s es de 5000 habitantes nos saldr� una poblaci�n err�nea con un valor de entre 4500 y 5500
SELECT Nombre AS 'Pais',
	   ROUND(Poblacion * (RAND() / 5 + 0.9)) AS 'Poblacion eronea'
	   
FROM Pais; -- No hay nulos

-- 42. Listado de pa�ses en los que Codigo2 no son las dos primeras letras del c�digo del pa�s
SELECT Nombre AS 'Pais', Codigo, Codigo2
FROM Pais 
WHERE LEFT(Codigo, 2) <> COdigo2; -- No hay nulos

--- MIA Coregida ---
SELECT Nombre AS 'Pais', Codigo, Codigo2
FROM Pais
WHERE Codigo NOT REGEXP CONCAT('^', Codigo2); -- No hay nulos

-- 43. Listado de pa�ses que no tienen alguna de sus dos letras de Codigo2 en el Codigo del pa�s
SELECT Nombre AS 'Pais',Codigo, Codigo2
FROM Pais
WHERE NOT LOCATE(LEFT(Codigo2, 1), Codigo);  -- (Mala practica) No hay nulos

SELECT Nombre AS 'Pais',Codigo, Codigo2
FROM Pais
WHERE LOCATE(LEFT(Codigo2, 1), Codigo) = 0;  -- No hay nulos

SELECT Nombre AS 'Pais',Codigo, Codigo2
FROM Pais
WHERE LOCATE(RIGHT(Codigo2, 1), Codigo) = 0;  -- No hay nulos


SELECT Nombre AS 'Pais',Codigo, Codigo2
FROM Pais
WHERE LOCATE(LEFT(Codigo2, 1), Codigo) = 0 OR LOCATE(RIGHT(Codigo2, 1), Codigo) = 0;  -- No hay nulos

SELECT Nombre AS 'Pais',Codigo, Codigo2
FROM Pais
WHERE LOCATE(SUBSTR(Codigo2, 1, 1), Codigo) = 0 OR LOCATE(SUBSTR(Codigo2, 2, 1), Codigo) = 0;  -- (para asegurar a entregar una sola letra) No hay nulos

-- 44. Listado de lenguas, el c�digo del pa�s en el que se habla y si es oficial o no (texto 'Es Oficial' o 'No es oficial'), pero este �ltimo dato estar� equivocado en el 5% de las lenguas
SELECT Lengua, CodigoPais, EsOficial FROM LenguaPais; -- No hay nulos

SELECT Lengua, CodigoPais, 
		IF (EsOficial = 'T', 'Es Oficial', 'No es oficial') AS 'EO' 
FROM LenguaPais; -- No hay nulos

SELECT Lengua, CodigoPais, 
		IF (EsOficial = 'T', 
			IF(RAND() <= 0.005, 'No es oficial', 'Es Oficial'), 
			IF(RAND() >= 0.005, 'Es Oficial', 'No es oficial')) AS 'EO'
FROM LenguaPais; -- No hay nulos

-- 45. Listado de pa�ses que est�n en crecimiento econ�mico
SELECT Nombre AS 'Paises en crecimiento'
FROM Pais
Where PNB > PNBAnt; -- Podria haber nulos y afectar negativamente la consulta

SELECT Nombre AS 'Paises en crecimiento'
FROM Pais
Where PNBAnt <= PNB; -- Podria haber nulos y afectar negativamente la consulta

SELECT Nombre AS 'Paises en crecimiento'
FROM Pais
Where PNB - PNBAnt > 0; -- Podria haber nulos y afectar negativamente la consulta

SELECT Nombre AS 'Paises en crecimiento'
FROM Pais
Where PNB - PNBAnt + 1 > 1; -- Podria haber nulos y afectar negativamente la consulta

SELECT Nombre AS 'Paises en crecimiento'
FROM Pais
Where PNB / PNBAnt > 1; -- Podria haber nulos y afectar negativamente la consulta

/* 
Formas de comparar que ha aumentado el PNB:
PNB > PNBAnt --> mas rapidas en ejecucion
PNBAnt < PNB --> mas rapidas en ejecucion
PNB � PNBAnt > 0
PNB - PNBAnt + 1 > 1
PNB / PNBAnt > 1
(PNB / PNBAnt) - 1 > 0
(PNB * 100 / PNBAnt) � 100 > 0
PNB� > PNBAnt * PNB
PNB� * PNBAnt > PNBAnt� * PNB
*/

-- ----------------------------------------------------------------------------
-- NOTAS
-- ----------------------------------------------------------------------------
SELECT Nombre FROM CIUDAD INTO OUTFILE 'ciudades.txt'; -- EXPORTA A ARCHIVOS EXTERNOS ESTARAN EN C:\xampp\mysql\data\mundo (No se si solo en esta config)


-- ----------------------------------------------------------------------------
-- LIST
-- ----------------------------------------------------------------------------