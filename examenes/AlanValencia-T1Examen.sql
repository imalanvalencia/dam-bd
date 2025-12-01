-- --------------------------------------------------------------------------------------
-- Nombre: Alan Smith Valencia Izquierdo
-- 1DAM-B.  Bases de datos
-- Examen del Tema 1. SQL básico
-- 21-oct-2025
-- --------------------------------------------------------------------------------------

/*
Puntuación de las consultas: Cada consulta vale dos puntos.
Duración del examen: 40 minutos
Se valorará además de que las solución de los ejercicios sea correcta, la correcta indentación, los comentarios en el código, nombres de columna correctos y la claridad y simplicidad del código en general. Se debe realizar análisis de nulos en todas las consultas.
No entregues dos soluciones a la misma consulta. Cada consulta debe tener una única solución, aunque puedes añadir todos los comentarios que creas conveniente.
*/

-- Análisis de nulos: se debe realizar análisis de nulos de todas las consultas

-- --------------------------------------------------------------------------------------
-- 1. 

SELECT
	INSERT(
		Nombre,
		CHAR_LENGTH(Nombre),
		1,
		CHAR(ORD(Right(Nombre, 1)) + 1)
	) AS "Pais"
FROM Pais; -- No hay nulos

-- --------------------------------------------------------------------------------------
-- 2. 

SELECT 
	CASE 
		WHEN RAND() < .1

		THEN UPPER(Nombre) 
		ELSE Nombre
	END AS "Pais"
FROM Pais; -- No hay nulos

-- --------------------------------------------------------------------------------------
-- 3. 

SELECT 
	Nombre AS "Pais", 
	CASE 
		WHEN PNBAnt < 1000 THEN "Bajo" 
		WHEN  PNBAnt BETWEEN 1000 AND 10000 THEN "Medio" 
		WHEN PNBAnt > 10000 THEN "Alto" 
		ELSE "N/A"
	END AS "PNBAnt"
FROM Pais; -- Hay nulos en PNBAnt pero no afectan negativamente la consulta

-- --------------------------------------------------------------------------------------
-- 4. 

SELECT Nombre
FROM Pais
WHERE Superficie / Poblacion IS NOT NULL
ORDER BY Superficie / Poblacion
LIMIT 5; -- Podria haber nulos en la operacion Superficie / Poblacion pero los elimino con IS NOT NULL

-- --------------------------------------------------------------------------------------
-- 5. 

---
-- LIKE
---

SELECT Nombre
FROM Ciudad
WHERE Nombre LIKE "fu%" -- empiece fu
	-- Validar fuc en algun lado --
	  AND Nombre NOT LIKE "fuc%"
	  AND Nombre NOT LIKE "%fuc%"
	  AND Nombre NOT LIKE "%fuc"
	-- Validar fuk en algun lado --
	  AND Nombre NOT LIKE "fuk%"
	  AND Nombre NOT LIKE "%fuk%"
	  AND Nombre NOT LIKE "%fuk";
-- No hay nulos	  
	  
---
-- REGEXP
---
	  
SELECT Nombre
FROM Ciudad
WHERE Nombre REGEXP "^fu" -- empiece fu
	-- Validar fuc en algun lado --
	  AND Nombre NOT REGEXP "fuc"
	-- Validar fuk en algun lado --
	  AND Nombre NOT REGEXP "fuk"; 
-- No hay nulos