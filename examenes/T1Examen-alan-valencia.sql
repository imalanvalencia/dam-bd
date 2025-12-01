-- ----------------------------------------------------------------------------
-- Nombre completo: Alan Valencia
-- 1DAM-B  Bases de datos
-- Examen del Tema 1. SQL básico
-- 29-oct-2024
-- ----------------------------------------------------------------------------

/*
Puntuación de las consultas: Cada consulta vale dos puntos.
Duración del examen: 40 minutos
Se valorará además de que las solución de los ejercicios sea correcta, la correcta indentación, los comentarios en el código, nombres de columna correctos y la claridad y simplicidad del código en general. Se debe realizar análisis de nulos en todas las consultas.
No entregues dos soluciones a la misma consulta. Cada consulta debe tener una única solución, aunque puedes añadir todos los comentarios que creas conveniente.
*/

-- Análisis de nulos: se debe realizar análisis de nulos de todas las consultas

-- ----------------------------------------------------------------------------
-- CONSULTA 1. 
SELECT Nombre AS 'Pais', Continente
FROM Pais;

-- ----------------------------------------------------------------------------
-- CONSULTA 2. 

SELECT CodigoPais AS 'Codigo del Pais'
FROM Pais;

-- ----------------------------------------------------------------------------
-- CONSULTA 3. 
SELECT Nombre AS 'Pais', Continente
FROM Pais
LIMIT 10;

-- ----------------------------------------------------------------------------
-- CONSULTA 4. 
SELECT Nombre AS 'Ciudad', ID, CodigoPais, Zona, Poblacion
FROM CIUDAD
LIMIT 100;

-- ----------------------------------------------------------------------------
-- CONSULTA 5. 
SELECT Nombre AS 'Ciudad', ID, CodigoPais, Zona, Poblacion
FROM CIUDAD
LIMIT 100;


