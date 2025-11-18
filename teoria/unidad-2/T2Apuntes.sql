/*
Bases de Datos
Tema 2. SQL avanzado I

An�lisis de los nulos: todas las consultas llevar�n el mismo an�lisis de nulos realizado en clase.
En este tema el tratamiento de nulos s�lo es obligatorio cuando afectan negativamente. Si no hay nulos o no afectan negativamente no hace falta decir nada. Todo ello con las excepciones que comentaremos en clase ya que en alg�n tipo de consulta ser� obligatorio hacer an�lisis de nulos.
*/

-- -----------------------------------------------------------------
-- Tema 2. SQL avanzado I. Consultas de clase
-- -----------------------------------------------------------------

-- calve primaria es el id unico y no null de un registro
-- clave ajena hace referencia a una clave primaria null y repetida

SELECT *
FROM Videojuegos LEFT JOIN Generos 
ON Videojuegos.IdGenero = Generos.IdGenero;
	
SELECT * 
FROM Generos LEFT JOIN Videojuegos 
ON Videojuegos.IdGenero = Generos.IdGenero;


SELECT Videojuegos.*, Generos.* 					
FROM Generos LEFT JOIN Videojuegos 
ON Videojuegos.IdGenero = Generos.IdGenero;	

SELECT Videojuegos.*, Generos.* 					
FROM Generos LEFT JOIN Videojuegos  
ON 		Videojuegos.IdGenero = Generos.IdGenero
WHERE Videojuegos.Id IS NULL; -- WHERE clave primaria (id) de la tabla derecha(este caso videojuegos) is null

SELECT *
FROM   Videojuegos LEFT JOIN Generos 
ON 	   Videojuegos.IdGenero = Generos.IdGenero
UNION ALL 
SELECT Videojuegos.*, Generos.* 					
FROM   Generos LEFT JOIN Videojuegos  
ON 	   Videojuegos.IdGenero = Generos.IdGenero
WHERE  Videojuegos.Id IS NULL;

/*
SELECT *
FROM Videojuegos LEFT JOIN Generos
ON Videojuegos.IdGenero = Generos.IdGenero
UNION ALL
SELECT *
FROM Generos LEFT JOIN Videojuegos
ON Videojuegos.IdGenero = Generos.IdGenero
WHERE Videojuegos.Id IS NULL;  
*/ -- No funciona bien hay que organizarlo y el AS se usa en la primera consulta



-----------------------------------------------------------------
-- JOIN
-----------------------------------------------------------------
-- Producto: Todas las combinaciones entre dos tablas
-- JOIN b�sico: 
SELECT *
FROM Izquierda JOIN Derecha; 
-- Esto realiza el producto cartesiano entre la tabla Izquierda y la tabla Derecha
-----------------------------------------------------------------

-- JOIN con condici�n:
SELECT *
FROM Izquierda JOIN Derecha
ON Ciudad.CodigoPais = Pais.Codigo;
-- Devuelve solo los registros que cumplen la condici�n ON
-- La cl�usula ON se usa para filtrar las combinaciones antes de aplicar un WHERE
-----------------------------------------------------------------

-- LEFT JOIN:
SELECT *
FROM Izquierda LEFT JOIN Derecha
ON Izquierda.x = Derecha.Y; 
-- Devuelve todos los registros de la tabla Izquierda
-- y los registros coincidentes de la tabla Derecha (NULL si no hay coincidencia)
-----------------------------------------------------------------

-- RIGHT JOIN (no soportado en todas las bases de datos, funciona en MariaDB y MySQL):
SELECT *
FROM Izquierda RIGHT JOIN Derecha
ON Izquierda.x = Derecha.Y; 
-- Devuelve todos los registros de la tabla Derecha
-- y los registros coincidentes de la tabla Izquierda (NULL si no hay coincidencia)


-- Alternativa en SQL est�ndar (equivalente a RIGHT JOIN):
SELECT Izquierda.*, Derecha.*
FROM Derecha LEFT JOIN Izquierda
ON Izquierda.x = Derecha.Y; 
-----------------------------------------------------------------

-- FULL JOIN (no soportado directamente en MySQL, se simula con UNION ALL):
SELECT *
FROM Izquierda LEFT JOIN Derecha
ON Izquierda.x = Derecha.Y
UNION ALL
SELECT Izquierda.*, Derecha.*
FROM Derecha LEFT JOIN Izquierda
ON Izquierda.x = Derecha.Y
WHERE Izquierda.x IS NULL; 
-- Devuelve todos los registros relacionados
-- m�s los registros no relacionados de ambas tablas
-----------------------------------------------------------------



-------------
-- Registros relacionados + registros no relacionados de la tabla derecha + registros no relacionados de la tabla izquierda
-------------

--- COUNT(select opcion) cuenta los registros

-- 1. Realiza el producto de las tablas Pais y Ciudad. �Es el n�mero de registros que sale correcto? Justifica tu respuesta
SELECT * FROM Pais JOIN Ciudad; -- hay nulos pero no afectan negativamente

-- 2. Del producto anterior selecciona los registros correctos. ¿Es el número de registros que sale correcto? Justifica tu respuesta
SELECT * FROM Ciudad WHERE CodigoPais IS NULL; -- hay nulos pero no afectan negativamente

-- 3. ¿Recuerdas que entre las tablas Ciudad y Pais hay dos relaciones? Filtra el producto utilizando la relación capital. ¿Es el número de registros que sale correcto? Justifica tu respuesta
SELECT 
	 * 
FROM Pais JOIN Ciudad
ON Pais.capital == ciudad.Id; -- No hay nulos

-- 4. Listado de lenguas oficiales habladas en países con una densidad de población mayor que 1000 habitantes por kilómetro cuadrado
SELECT 
	 Lengua
FROM LenguaPais JOIN Pais
ON Lengua.CodigoPais = Pais.Codigo
WHERE IsOficial = 'T' 
	AND  Poblacion / Superficie > 1000; --No hay nulos

SELECT 
	DISTINCT Lengua -- Elimina registros repetidos
FROM LenguaPais JOIN Pais
ON Lengua.CodigoPais = Pais.Codigo
WHERE IsOficial = 'T'  
	AND  Poblacion / Superficie > 1000; --No hay nulos
	
-- 5. Listado de países que tienen alguna ciudad con más de 8 millones de habitantes
SELECT 
	DISTINCT Pais.Nombre AS 'Pais'
FROM  Ciudad JOIN Pais
ON 	  Ciudad.CodigoPais = Pais.Codigo
WHERE Ciudad.Poblacion > 8000000; -- No hay nulos

-- 6. Listado de capitales de los países que han aumentado su PNB
SELECT 
	  Ciudad.Nombre AS 'Capitales'
FROM  Ciudad JOIN Pais
ON 	  Ciudad.Id = Pais.Capital
WHERE PNB > PNBAnt; -- No hay nulos

-- 7. Nombre de las capitales de los diez países más poblados
SELECT 
	  Ciudad.Nombre AS 'Capitales'
FROM  Ciudad JOIN Pais
ON 	  Ciudad.Id = Pais.Capital
ORDER BY Pais.Poblacion DESC
LIMIT 10; -- No hay nulos

-- ---------------------------------------------------------------------------------------
-- JOIN de más de dos tablas
-- ---------------------------------------------------------------------------------------

-- Estructura
SELECT *
FROM   Tabla1 JOIN Tabla2 JOIN Tabla3
ON     Tabla1.CAJ = Tabla2.CP AND
       Tabla2.CAJ = Tabla3.CP;
       
-- 8. Nombre de las Ciudades que pertenecen a países en las que el inglés es lengua oficial hablada por más del 50% de la población
SELECT 
	  Ciudad.Nombre AS 'Ciudades que hablan ingles'
FROM  Ciudad JOIN LenguaPais JOIN Pais
ON    Ciudad.CodigoPais = Pais.Codigo 
	  AND   LenguaPais.CodigoPais = Pais.Codigo
WHERE Lengua = "English" 
	  AND EsOficial = 'T' 
	  AND Porcentaje > 50;

-- Se puede pero no es recomendable	  
SELECT 
	  Ciudad.Nombre AS 'Ciudades que hablan ingles'
FROM  Ciudad JOIN LenguaPais JOIN Pais
ON    Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE Lengua = "English" 
	  AND EsOficial = 'T' 
	  AND Porcentaje > 50;

-- 9. Lenguas oficiales que se hablan en los países que han aumentado el PNB y cuyas capitales tienen más de 5 millones de habitantes
SELECT 
	DISTINCT Lengua AS "Lenguas Oficiales"
FROM  Ciudad JOIN LenguaPais JOIN Pais
ON    Ciudad.CodigoPais = Pais.Codigo 
	  AND   LenguaPais.CodigoPais = Pais.Codigo
WHERE PNB > PNBAnt
	  AND Ciudad.Poblacion > 5000000
	  AND EsOficial = 'T'; -- No hay nulos
	  
-- 10. Lenguas oficiales que se hablan en los países cuya capital tiene, como mínimo un décimo de la población del país al que pertenece
SELECT 
	DISTINCT Lengua AS "Lenguas Oficiales"
FROM  Ciudad JOIN LenguaPais JOIN Pais
ON    Ciudad.CodigoPais = Pais.Codigo 
	  AND   LenguaPais.CodigoPais = Pais.Codigo
WHERE Ciudad.Poblacion >= Pais.Poblacion / 10
	  AND EsOficial = 'T'; -- No hay nulos

-- 11. Capitales de países del continente sudamericano (South America) cuya lengua oficial es el inglés
SELECT 
	  Ciudad.Nombre AS 'Capitales que hablan ingles en sur america'
FROM  Ciudad JOIN LenguaPais JOIN Pais
ON    Ciudad.Id = Pais.Capital 
	  AND   LenguaPais.CodigoPais = Pais.Codigo
WHERE Lengua = "English" 
	  AND EsOficial = 'T' 
	  AND Pais.Continente = "South America";

-- ---------------------------------------------------------------------------------------
-- Base de datos de Neptuno
-- ---------------------------------------------------------------------------------------   

SHOW Tables; --Muestra el nombre de todas las tablas
DESCRIBE TABLE_Name; -- Muestra los campos de la tabla <Table_Name>

-- 12. Nombre de las empresas proveedoras de productos de la categoría Condiments
SELECT 
	  DISTINCT NombreEmpresa AS 'Proveedores'
FROM  Proveedores JOIN Categorias JOIN Productos
ON 	  Proveedores.IdProveedor = Productos.IdProveedor 
	  AND Categorias.IdCategoria = Productos.IdCategoria
WHERE NombreCategoria = 'Condiments';

-- 13. Nombre de las empresas proveedoras de alguno de los productos del pedido 10777
SELECT 
	  DISTINCT NombreEmpresa AS 'Proveedores'
FROM  Proveedores JOIN Productos JOIN DetallesPedido JOIN Pedidos
ON 	  Proveedores.IdProveedor = Productos.IdProveedor 
	  AND Productos.IdProducto =  DetallesPedido.IdProducto 
	  AND DetallesPedido.IdPedido = Pedidos.IdPedido
WHERE Pedidos.IdPedido =  10777;
-------
SELECT 
	  DISTINCT NombreEmpresa AS 'Proveedores'
FROM  Proveedores JOIN Productos JOIN DetallesPedido
ON 	  Proveedores.IdProveedor = Productos.IdProveedor 
	  AND Productos.IdProducto =  DetallesPedido.IdProducto 
WHERE DetallesPedido.IdPedido =  10777;

-- 14. Nombre de las empresas proveedoras de alguno de los productos de pedidos que ha servido la empleada con apellido Davolio
SELECT 
	  DISTINCT NombreEmpresa AS 'Proveedores'
FROM  Proveedores JOIN Productos JOIN DetallesPedido JOIN Pedidos JOIN Empleados
ON 	  Proveedores.IdProveedor = Productos.IdProveedor 
	  AND Productos.IdProducto =  DetallesPedido.IdProducto 
	  AND DetallesPedido.IdPedido = Pedidos.IdPedido 
	  AND Pedidos.IdEmpleado = Empleados.IdEmpleado
WHERE Empleados.Apellido =  "Davolio";

-- 15. Nombre de las empresas proveedoras de alguno de los productos de pedidos servidos por empleados de la región meridional (southern)




-- 16. Nombre de las empresas proveedoras de alguno de los productos de la categoría condiments de pedidos servidos por empleados de la región septentrional (southern)


-- 17. Nombre de las empresas proveedoras de alguno de los productos de la categoría condiments de pedidos servidos por empleados de la región septentrional (southern) de pedidos del año 1996
SELECT 
	  DISTINCT NombreEmpresa AS 'Proveedores'

FROM  
	  Proveedores 
	  JOIN Productos 
	  JOIN DetallesPedido 
	  JOIN Pedidos 
	  JOIN Empleados 
	  JOIN Territorios
	  JOIN TerritoriosEmpleados
	  JOIN Region
	  JOIN Categorias

ON 	  Empleados.IdEmpleado = TerritoriosEmpleados.IdEmpleado
	  AND Proveedores.IdProveedor = Productos.IdProveedor 
	  AND TerritoriosEmpleados.IdEmpleado = Territorios.IdEmpleado
	  AND 
	  AND Productos.IdProducto =  DetallesPedido.IdProducto 
	  AND DetallesPedido.IdPedido = Pedidos.IdPedido 
	  AND Pedidos.IdEmpleado = Empleados.IdEmpleado
WHERE DescripcionRegion =  "Southern" 
	  AND NombreCategoria = "Condiments" 
	  AND YEAR(FechaPedido) = 1996;


-- -----------------------------------------------------------------------------
-- LEFT JOIN
-- -----------------------------------------------------------------------------

-- Repasamos la función COUNT(exp), COUNT(*) y COUNT(DISTINCT exp)
       
-- 18. ¿Cuantos países hay?
SELECT COUNT(*) AS "Numero de paises"
FROM Pais;

-- 19. Indica cuántos países hay que tienen capital. Nota: usa sólo la función COUNT() sin WHERE
SELECT COUNT(Capital) AS "Numero de paises con capital"
FROM Pais; --

-- 20. Indica cuántos países hay que no tienen capital. Nota: usa la función COUNT() sin WHERE
SELECT COUNT(*) - COUNT(Capital) AS "Numero de paises sin capital"
FROM Pais;

-- 21. Indica cuántos países hay que no tienen capital. Nota: usa la función COUNT(*), e IS NULL en el WHERE
SELECT COUNT(*) AS "Numero de paises sin capital"
FROM Pais
WHERE Capital IS NULL;

-- 22. Listado de países que no tienen capital
SELECT Nombre AS "Pais sin capital"
FROM Pais
WHERE Capital IS NULL;

-- 23. Listado de todos los países junto con el nombre de su capital
SELECT Pais.Nombre AS "Pais", Ciudad.Nombre AS "Capital"
FROM Pais JOIN Ciudad -- Registro relacionados
ON Pais.Capital = Ciudad.Id;

-- 24. Listado de todas las ciudades junto con el nombre del país del que son capital
SELECT Ciudad.Nombre AS "Capital", Pais.Nombre AS "Pais"
FROM Ciudad LEFT JOIN Pais -- Registro relacionados
ON Ciudad.Id = Pais.Capital;


-- Obtener nulos de derecha
SELECT *
FROM Izquierda JOIN Derecha
ON Izquierda.x = Derecha.x
WHERE Derecha.x IS NULL; -- donde la clave primaria de derecha is null

-- 25. Países que no tienen ninguna lengua
SELECT Pais.Nombre AS "Paises sin luengua"
FROM Pais LEFT JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais
WHERE LenguaPais.Lengua IS NULL;

-- 26. Número de países que no tienen ninguna lengua
SELECT COUNT(*) AS "Numero de paises sin lengua"
FROM Pais LEFT JOIN LenguaPais 
ON Pais.Codigo = LenguaPais.CodigoPais
WHERE LenguaPais.Lengua IS NULL;

-- 27. Número de países que tienen alguna lengua
SELECT  COUNT(DISTINCT CodigoPais) AS "Numero de paises con lengua"
FROM LenguaPais;


SELECT  COUNT(DISTINCT Codigo) AS "Numero de paises con lengua"
FROM Pais LEFT JOIN LenguaPais
ON Pais.Codigo = LenguaPais.CodigoPais;

-- 28. Número de ciudades que no pertenecen a ningún país
SELECT  COUNT(*) AS "Numero de ciudades independientes"
FROM Ciudad
WHERE CodigoPais IS NULL;

-- 29. Listado de países que no tienen ninguna ciudad
SELECT Pais.Nombre AS "Paises sin ciudades"
FROM Pais LEFT JOIN Ciudad
ON Pais.codigo = Ciudad.CodigoPais
WHERE Ciudad.Id IS NULL;

-- 30. Número de países que no tienen ninguna ciudad
SELECT COUNT(*) AS "Número de países sin ciudades"
FROM Pais LEFT JOIN Ciudad
ON Pais.codigo = Ciudad.CodigoPais
WHERE Ciudad.Id IS NULL;


-- 31. Ciudades que no son capital
SELECT Ciudad.Nombre AS "Ciudades que no son capital"
FROM Ciudad LEFT JOIN Pais
ON Ciudad.Id = Pais.Capital
WHERE Pais.Codigo IS NULL;

-- 32. Número de ciudades que no son capital
SELECT COUNT(*) AS "Ciudades que no son capital"
FROM Ciudad LEFT JOIN Pais
ON Ciudad.Id = Pais.Capital
WHERE Pais.Codigo IS NULL;

-- 33. Ciudades españolas (con código ESP) que no son capital
SELECT Ciudad.Nombre AS "Ciudades que no son capital de españa"
FROM Ciudad LEFT JOIN Pais
ON Ciudad.CodigoPais = Pais.Codigo
WHERE Pais.Codigo = "ESP" AND Ciudad.Id <> Pais.Capital;

SELECT COUNT(*) AS "Ciudades que no son capital"
FROM Ciudad LEFT JOIN Pais
ON Ciudad.Id = Pais.Capital
WHERE Pais.Codigo IS NULL AND Ciudad.CodigoPais = "ESP";


-- 34. Número de países que no tienen capital
SELECT COUNT(*) AS "Numero de paises sin capital"
FROM Pais
WHERE Capital IS NULL;

-- 35. Capitales que no son capital de ningún país
-- Esta consulta no se puede hacer porque no tenemos una tabla específica de Capitales

-- 36. Capitales que no son ciudad de ningún país
SELECT Ciudad.Nombre AS "Capitales que no son capital"
FROM Ciudad JOIN Pais
ON Ciudad.Id = Pais.Capital
WHERE Ciudad.CodigoPais IS NULL;

-- 37. Capitales que no son ciudad del país del que son capital
SELECT Ciudad.Nombre AS "Capitales que no son capital"
FROM Ciudad JOIN Pais
ON Ciudad.Id = Pais.Capital
WHERE Ciudad.CodigoPais <> Pais.Codigo;




SELECT Subordinados.IdEmpleado, Subordinados.Apellido, Subordinados.Superior,
	   Jefes.IdEmpleado, Jefes.Apellido
FROM Empleados AS Subordinados JOIN Empleados AS Jefes -- No puede haber tablas con nombres iguales
ON Subordinados.Superior = Jefes.IdEmpleado; 


-- 38. Listado de nombre y apellidos de los empleados junto con el nombre y apellidos de su jefe
SELECT Subordinados.Nombre AS "Apellido Empleado", Subordinados.Apellido AS "Apellido Empleado",
	   Jefes.Nombre AS "Apellido Jefe", Jefes.Apellido AS "Apellido Jefe"
FROM   Empleados AS Subordinados LEFT JOIN Empleados AS Jefes
ON     Subordinados.Superior = Jefes.IdEmpleado; 

-- 39. Número de pedidos realizados por empleados de Buchanan
SELECT COUNT(*) AS "Número de pedidos realizados por empleados de Buchanan"
FROM   Pedidos JOIN Empleados AS Subordinados JOIN Empleados AS Jefes
ON     Pedidos.IdEmpleado = Subordinados.IdEmpleado AND Subordinados.Superior = Jefes.IdEmpleado  
WHERE  Jefes.Apellido = "Buchanan"; 

SELECT COUNT(*) AS "Número de pedidos realizados por empleados de Buchanan"
FROM   Pedidos JOIN (Empleados AS Subordinados LEFT JOIN Empleados AS Jefes ON Subordinados.Superior = Jefes.IdEmpleado)
ON     Pedidos.IdEmpleado = Subordinados.IdEmpleado    
WHERE  Jefes.Apellido = "Buchanan"; 

-- -----------------------------------------------------------------------------
-- UNION
-- -----------------------------------------------------------------------------
-- UNION DISTINCT:  Quita los registros repetidos (DEFAULT)
-- UNION ALL: Entrega toda la tabla 

-- SELECT DISTINCT: Quita los registros repetidos
-- SELECT ALL: Entrega todos los registros (DEFAULT)


SELECT Nombre AS "Pais" , AnyIndep AS "Año independencia"
FROM Pais 
WHERE Nombre LIKE "e%"
UNION
SELECT Nombre AS "Ciudad" , Poblacion AS "Poblacion" -- No se ponen AS AQUI NO HACEN NADA
FROM Ciudad
WHERE Nombre LIKE "%x";


SELECT Nombre AS "Pais" , AnyIndep AS "Año independencia"
FROM Pais 
WHERE Nombre LIKE "e%"
UNION
SELECT Nombre AS "Ciudad" , Poblacion AS "Poblacion" 
FROM Ciudad
WHERE Nombre LIKE "%x"
ORDER BY 1 LIMIT 5; -- Afecto a todo

SELECT Nombre AS "Pais" , AnyIndep AS "Año independencia"
FROM Pais 
WHERE Nombre LIKE "e%"
UNION
(SELECT Nombre AS "Ciudad" , Poblacion AS "Poblacion" 
 FROM   Ciudad
 WHERE  Nombre LIKE "%x"
 ORDER BY 1 LIMIT 5); -- solo afecta a los parentesis
 
(SELECT Nombre AS "Pais" , AnyIndep AS "Año independencia"
 FROM   Pais 
 WHERE  Nombre LIKE "e%"
 ORDER BY 1 LIMIT 5) -- solo afecta a los parentesis
UNION
(SELECT Nombre AS "Ciudad" , Poblacion AS "Poblacion" 
 FROM   Ciudad
 WHERE  Nombre LIKE "%x"
 ORDER BY 1 LIMIT 5); -- solo afecta a los parentesis
 
 (SELECT Nombre AS "Pais" , AnyIndep AS "Año independencia"
 FROM   Pais 
 WHERE  Nombre LIKE "e%"
 ORDER BY 1 LIMIT 5) -- solo afecta a los parentesis
UNION
(SELECT Nombre AS "Ciudad" , Poblacion AS "Poblacion" 
 FROM   Ciudad
 WHERE  Nombre LIKE "%x"
 ORDER BY 1 LIMIT 5) -- solo afecta a los parentesis
 ORDER BY 1 LIMIT 7; -- Afecto a todo 