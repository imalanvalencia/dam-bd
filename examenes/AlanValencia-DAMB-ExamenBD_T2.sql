-- --------------------------------------------------------------------------------------
-- Nombre: Alan Smith Valencia
-- 1DAM-B.  Bases de datos
-- Examen del Tema 2. SQL avanzado
-- 9-dic-2025
-- --------------------------------------------------------------------------------------

/*
Puntuación de las consultas: Cada consulta vale dos puntos.
Duración del examen: 40 minutos
Se valorará además de que las solución de los ejercicios sea correcta, la correcta indentación, los comentarios en el código, nombres de columna correctos y la claridad y simplicidad del código en general. 
No entregues dos soluciones a la misma consulta. Cada consulta debe tener una única solución, aunque puedes añadir todos los comentarios que creas conveniente.
No es obligatorio realizar análisis de nulos en las consultas, aunque se puede hacer si se cree conveniente.
Se debe realizar el mismo análisis de subconsultas realizado en clase.
*/

-- --------------------------------------------------------------------------------------
-- CONSULTA 1:
DROP DATABASE IF EXISTS SeriesDB;
CREATE DATABASE IF NOT EXISTS SeriesDB;
USE SeriesDB;

CREATE TABLE Plataformas (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE);

CREATE TABLE Series (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(100) NOT NULL,
    AnyoEstreno INT NOT NULL,
    Temporada_actual VARCHAR(20) NOT NULL,
    Plataforma INT DEFAULT NULL);

INSERT INTO Plataformas VALUES (1, 'Netflix'), (2, 'Amazon Prime Video'), (3, 'HBO Max');
INSERT INTO Series VALUES (1, 'Adolescencia', 2025, '1', 1), (2, 'Olympo', 2025, '1', 1),
                          (3, 'Memento Mori', 2023, '3', 2), (4, 'Rage', 2025, '1', NULL);
						  
SELECT 	Series.Titulo, PlataformaS.Nombre
FROM 	Series LEFT JOIN Plataformas
ON		Series.Plataforma = Plataformas.Id
UNION DISTINCT
SELECT 	Series.Titulo, PlataformaS.Nombre
FROM 	Plataformas LEFT JOIN Series
ON		Plataformas.Id = Series.Plataforma

-- --------------------------------------------------------------------------------------
-- CONSULTA 2:
SELECT 	Lengua
FROM	LenguaPais JOIN Pais
ON 		LenguaPais.CodigoPais = Pais.Codigo
WHERE 	Nombre = 'Spain';


-- --------------------------------------------------------------------------------------
-- CONSULTA 3:
SELECT 	AVG(PrecioUnitario * UnidadesEnAlmacen)
FROM 	Productos;

SELECT 	NivelNuevoPedido
FROM 	Productos
WHERE	NombreProducto = 'Boston Crab Meat';

SELECT 	NombreProducto AS 'Producto'
FROM 	Productos
WHERE	PrecioUnitario * UnidadesEnAlmacen > (
			SELECT 	AVG(PrecioUnitario * UnidadesEnAlmacen)
			FROM 	Productos
		) AND NivelNuevoPedido >= (
				SELECT 	NivelNuevoPedido
				FROM 	Productos
				WHERE	NombreProducto = 'Boston Crab Meat'
		);



-- --------------------------------------------------------------------------------------
-- CONSULTA 4:
SELECT 	Clientes.NombreEmpresa AS 'Clientes'
FROM 	Clientes LEFT JOIN Pedidos
ON		Clientes.IdCliente = Pedidos.IdCliente
WHERE	Pedidos.IdPedido IS NULL;


-- --------------------------------------------------------------------------------------
-- CONSULTA 5:
SELECT 	Nombre, CHAR_LENGTH(Nombre) AS Letras, 'pais' AS TIPO
FROM	Pais
ORDER BY `Letras` DESC
LIMIT 1;

SELECT 	Nombre, CHAR_LENGTH(Nombre) AS Letras, 'ciudad' AS TIPO
FROM	Ciudad
ORDER BY `Letras` DESC
LIMIT 1;

SELECT 	DISTINCT Lengua, CHAR_LENGTH(Lengua) AS Letras, 'lengua' AS TIPO
FROM	LenguaPais
WHERE 	CHAR_LENGTH(Lengua) = (
			SELECT 	MAX(CHAR_LENGTH(Lengua))
			FROM	LenguaPais
		);


SELECT Nombre AS 'Nombres mas largos',  CONCAT('ES un ', Tipo, ' y tiene ', Letras, ' Letras') AS Informacion
FROM (
	(
		SELECT 	Nombre, CHAR_LENGTH(Nombre) AS Letras, 'pais' AS TIPO
		FROM	Pais
		ORDER BY `Letras` DESC
		LIMIT 1
	)
	UNION ALL
	(
		SELECT 	Nombre, CHAR_LENGTH(Nombre) AS Letras, 'ciudad' AS TIPO
		FROM	Ciudad
		ORDER BY `Letras` DESC
		LIMIT 1
	)
	UNION ALL
	(
		SELECT DISTINCT	Lengua, CHAR_LENGTH(Lengua) AS Letras, 'lengua' AS TIPO
		FROM	LenguaPais
		WHERE 	CHAR_LENGTH(Lengua) = (
					SELECT 	MAX(CHAR_LENGTH(Lengua))
					FROM	LenguaPais
				)
	)
) AS T;


