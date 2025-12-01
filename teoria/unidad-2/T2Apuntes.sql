/*
Bases de Datos
Tema 2. SQL avanzado I

An�lisis de los nulos: todas las consultas llevar�n el mismo an�lisis de nulos realizado en clase.
En este tema el tratamiento de nulos s�lo es obligatorio cuando afectan negativamente. Si no hay nulos o no afectan negativamente no hace falta decir nada. Todo ello con las excepciones que comentaremos en clase ya que en alg�n tipo de consulta ser� obligatorio hacer an�lisis de nulos.
*/

-- -----------------------------------------------------------------
-- Tema 2. SQL avanzado I. Consultas de clase
-- -----------------------------------------------------------------

-- clave primaria es el id unico y no null de un registro
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
 
 -- 40. Nombre de las ciudades cuyo nombre comienza por 'Vale' o que tienen entre 730 mil y 740 mil habitantes. No usar OR, usar UNION

-- 41. Listado de países, ciudades y lenguas

-- 42. Listado de países, ciudades y lenguas indicando si es un país, una ciudad o una lengua

SELECT pcl AS 'País, ciudad o lengua', Tipo
FROM 
   (SELECT Nombre AS 'pcl', 'País' AS 'Tipo'
    FROM   Pais
    UNION ALL
    SELECT Nombre, 'Ciudad'
    FROM   Ciudad
    UNION ALL
    SELECT DISTINCT Lengua, 'Lengua'
    FROM   LenguaPais) AS tmp
WHERE  pcl IN (
   SELECT pcl
   FROM 
      (SELECT Nombre AS 'pcl', 'País' AS 'Tipo'
       FROM   Pais
       UNION ALL
       SELECT Nombre, 'Ciudad'
       FROM   Ciudad
       UNION ALL
       SELECT DISTINCT Lengua, 'Lengua'
       FROM   LenguaPais) AS tmp
   GROUP BY pcl
   HAVING COUNT(*)>1)
ORDER BY pcl;

-- FULL JOIN en Videojuegos
SELECT *
FROM   Videojuegos LEFT JOIN Generos
ON     Videojuegos.IdGenero = Generos.Idgenero
UNION ALL
SELECT Videojuegos.*, Generos.*
FROM   Generos LEFT JOIN Videojuegos
ON     Generos.Idgenero = Videojuegos.IdGenero
WHERE  Videojuegos.Id IS NULL;

/*
Fútbol

Equipos
Id Nombre       AnyoFundacion IdPatrocinador
1  Manchester   1878          1
2  Real Madrid  1902          1
3  FC Barcelona 1899          2
4  Albacete BP  1939          NULL

Patrocinadores
Id Nombre
1  Adidas
2  Nike
3  RedBull
*/

SELECT  Equipos.Nombre AS 'Equipos', Patrocinadores.Nombre AS 'Patrocinadores'
FROM    Equipos LEFT JOIN Patrocinadores
ON      Equipos.IdPatrocinador = Patrocinadores.Id
UNION ALL
SELECT  Equipos.Nombre, Patrocinadores.Nombre
FROM    Patrocinadores LEFT JOIN Equipos
ON      Equipos.IdPatrocinador = Patrocinadores.Id
WHERE   Equipos.Id IS NULL;

-- 43. MySQL no tiene la orden FULL JOIN por lo que nos ayudaremos de UNION. Listado de países con sus ciudades (sólo los nombres) en el que aparezcan todos los países, aunque no tengan ciudades y todas las ciudades, aunque no sean ciudad de ningún país

-- 44. Listado de todas las ciudades junto con el nombre del país del que son capital en el que salgan todos los países y todas las ciudades

-- 45. Listado de ciudades o países que tienen más de un millón de habitantes ordenado alfabéticamente. Nota: queremos saber cuándo se trata de una ciudad y cuándo se trata de un país

-- 46. Listado de los diez países más poblados junto las diez ciudades más pobladas ordenados por población de menor a mayor. Queremos identificar cuando es un país y cuando es una ciudad

-- -----------------------------------------------------------------------------
-- JOIN de una tabla consigo misma
-- -----------------------------------------------------------------------------

-- 47. Para elaborar un juego necesitamos un listado de parejas de países que tengan la misma población

-- 48. Para elaborar un juego, deseamos un listado de parejas de países del continente europeo (europe) con más de 50 millones de habitantes de manera que el año de independencia del primer país sea menor que el del segundo

-- 49. Listado de jefes de Neptuno

-- 50. Listado de subordinados de Neptuno

-- 51. Empleados cuyo jefe gana menos de 2000€

-- 52. Pedidos (indicar IdPedido) del año 1996 de empleados cuyo jefe trabaja con el territorio de New York

-- -----------------------------------------------------------------------------
-- Consultas de LEFT JOIN con Neptuno
-- -----------------------------------------------------------------------------

/*
Productos que no tienen proveedor
Proveedores que no proveen ningún producto
Productos que no pertenecen a ninguna categoría
Categorías que no tienen ningún producto
Pedidos que no tienen ningún producto
Productos que no han sido pedidos nunca
Proveedores que tienen algún producto que no ha sido pedido nunca
Pedidos sin cliente
Pedidos sin empleado
Clientes sin pedidos
Empleados sin pedidos
*/

-- -----------------------------------------------------------------------------
-- Subconsultas de Escalar
-- -----------------------------------------------------------------------------

--- Vamos a comprobar que solo existe la consulta Escalar

-- 53. Listado de las ciudades que tienen la misma población que la ciudad El Limón

SELECT Poblacion FROM Ciudad WHERE Nombre = "el limon";

SELECT Nombre AS "Ciudad" FROM Ciudad Where Poblacion = 90000;

SELECT Nombre AS "Ciudad" 
FROM   Ciudad 
Where  Poblacion = (
	SELECT Poblacion 
	FROM   Ciudad 
	WHERE  Nombre = "el limon");
	
	
SELECT Nombre AS "Ciudad" 
FROM   Ciudad 
Where  Poblacion = (
	SELECT Poblacion 
	FROM   Ciudad 
	WHERE  Nombre = "valencia"); -- No se puede da error
	

-- Forma correcta
SELECT Count(*) 
FROM   Ciudad 
WHERE  Nombre = "el limon"; --Debe dar uno para ejecutar la consulta principal


SELECT Nombre AS "Ciudades que tienen la isma poblacion que el limon" 
FROM   Ciudad 
Where  Poblacion = (
	SELECT Poblacion 
	FROM   Ciudad 
	WHERE  Nombre = "el limon"
	LIMIT 1 -- Es obligatorio en clase, es un seguro que se suele usar en bases de datos con altaas peticiones);
	
-- 54. Listado de las ciudades que tienen la misma población que la ciudad El Limón. Quita del resultado la ciudad de El Limón, que ya sabemos que tiene los mismos habitantes que El Limón

SELECT Count(*) 
FROM   Ciudad 
WHERE  Nombre = "El Limón"; --Debe dar uno para ejecutar la consulta principal


SELECT Nombre AS "Ciudades que tienen la isma poblacion que El Limón" 
FROM   Ciudad 
Where  Poblacion = (
	SELECT Poblacion 
	FROM   Ciudad 
	WHERE  Nombre = "El Limón"
	LIMIT 1) 
	AND Nombre <> "El Limón";
	
-- 55. Listado de las ciudades que tienen la misma población que la ciudad de Guadalupe

SELECT Count(*) 
FROM   Ciudad 
WHERE  Nombre = "Guadalupe"; -- Debe dar uno para ejecutar la consulta principal


SELECT Nombre AS "Ciudades que tienen la misma poblacion que Guadalupe" 
FROM   Ciudad 
Where  Poblacion = (
	SELECT Poblacion 
	FROM   Ciudad 
	WHERE  Nombre = "Guadalupe"
	LIMIT 1);
	
-- 56. Listado de las ciudades que tienen una población mayor que Madrid y menor que Berlín
SELECT Count(*) 
FROM   Ciudad 
WHERE  Nombre = "Madrid"; -- Debe dar uno para ejecutar la consulta principal

SELECT Count(*) 
FROM   Ciudad 
WHERE  Nombre = "Berlín"; -- Debe dar uno para ejecutar la consulta principal

-- Otra forma de consultar
SELECT (
	SELECT Count(*) = 1
	FROM   Ciudad 
	WHERE  Nombre = "Madrid")
	AND(
	SELECT Count(*) = 1 
	FROM   Ciudad 
	WHERE  Nombre = "Berlín") AS "Se puede ejecutar"; -- Debe dar verdadero(1) para ejecutar la consulta principal

SELECT Nombre AS "Ciudades que tienen la misma poblacion que Guadalupe" 
FROM   Ciudad 
Where  Poblacion > (
	SELECT Poblacion 
	FROM   Ciudad 
	WHERE  Nombre = "Madrid"
	LIMIT 1) 
	AND Poblacion < (
	SELECT Poblacion 
	FROM   Ciudad 
	WHERE  Nombre = "Berlín"
	LIMIT 1);
	
-- 57. Listado de países en los que el español (Spanish) es oficial y cuyo porcentaje de hablantes es mayor o igual que el del español España (ESP)
SELECT Nombre AS "Paises que hablan mas español que españa"
FROM   Pais JOIN LenguaPais
ON     Pais.Codigo = LenguaPais.CodigoPais
WHERE  LenguaPais.EsOficial = "T" 
	   AND Lengua = "Spanish" 
	   AND Porcentaje >= (
					  SELECT Porcentaje 
					  FROM   LenguaPais 
					  WHERE  CodigoPais = "ESP" 
							 AND Lengua = "Spanish"); 
		-- No puede devolver mas de un registro porque codigoPais es una clave primaria
							 
	-- No es necesario hacer porque tanto como CodigoPais coo Lengua son claves primarias en la tabla LenguaPais por lo tanto la subconsulta devuelve un escalar y no hace falta hacer comprobaciones

-- 58. Listado de capitales que tienen una población como mínimo 10 veces superior a la de la ciudad de Alicante
SELECT COUNT(*) FROM Ciudad WHERE Nombre LIKE "Alicante%"; -- Debe dar uno 

SELECT Ciudad.Nombre AS "Capitales con poblacion mayor a Alicante"
FROM Ciudad Join Pais
ON Paises.Capital = Ciudad.Id
WHERE Ciudad.Poblacion >= (SELECT Poblacion FROM Ciudad WHERE Nombre LIKE "Alicante%" LIMIT 1); 
 
-- 59. Capitales del continente africano con el mismo idioma oficial que el idioma oficial de Egipto (Egypt)
SELECT COUNT(*) 
FROM   LenguaPais JOIN Pais 
ON     Lengua.CodigoPais = Pais.Codigo 
WHERE  Pais.Nombre = "Egypto" 
	   AND LenguaPais.EsOficial = "T"; -- Debe dar uno 

SELECT Ciudad.Nombre AS "Capitales del continente africano con el mismo idioma oficial que el idioma oficial de Egipto"
FROM   Ciudad  JOIN Lengua Join Pais
ON     Paises.Capital = Ciudad.Id 
	   AND  LenguaPais.CodigoPais = Pais.Codigo
WHERE  Continente = "Africa" 
       AND EsOficial = "T" 
	   AND Lengua = (
				SELECT COUNT(*) 
				FROM   LenguaPais JOIN Pais 
				ON     Lengua.CodigoPais = Pais.Codigo 
				WHERE  Pais.Nombre = "Egypto" 
					   AND LenguaPais.EsOficial = "T" 
				LIMIT 1); 
 
-- 60. Listado de países, su año de independencia y su densidad de población para países con un año de independencia posterior al de España y con una densidad de población superior a la de Francia (France)
SELECT COUNT(*) FROM Pais WHERE Nombre = "España"; -- Debe dar uno

SELECT COUNT(*) FROM Pais WHERE Nombre = "France"; -- Debe dar uno

SELECT 
		Nombre "Pais", 
		AnyIndep "Año de independencia", 
		ROUND(Poblacion/Superficie) AS "Densidad de poblacion"
FROM    Pais
WHERE   AnyIndep > (
				SELECT AnyIndep 
				FROM   Pais 
				WHERE  Nombre = "España" 
				LIMIT 1) 
	    AND Poblacion/Superficie > (
								SELECT Poblacion/Superficie 
								FROM   Pais 
								WHERE  Nombre = "France" 
								LIMIT 1);


-- -----------------------------------------------------------------------------
-- Subconsultas de columna convertida a escalar
-- ----------------------------------------------------------------------------- 
-- 61. Ciudades españolas con una población superior a la media (de la población de las ciudades españolas)

SELECT  Ciudad.Nombre AS "Ciudad"
FROM  	Ciudad JOIN Pais 
ON    	Ciudad.CodigoPais = Pais.Codigo 
WHERE 	Pais.Nombre = "Spain" 
		AND Ciudad.Poblacion > (
			SELECT AVG(Ciudad.Poblacion) 
			FROM   Ciudad JOIN Pais 
			ON     Ciudad.CodigoPais = Pais.Codigo 
			WHERE  Pais.Nombre = "Spain");
 
-- 62. Ciudades más pobladas que la ciudad de mayor población del continente europeo

SELECT Nombre 
FROM   Ciudad 
WHERE  Poblacion > (
			SELECT MAX(Ciudad.Poblacion) 
			FROM   Ciudad JOIN Pais 
			ON     Ciudad.CodigoPais = Pais.Codigo 
			WHERE  Continente = "Europe");

-- 63. Ciudades con más población que la población total de todas las ciudades de Francia
SELECT Nombre 
FROM   Ciudad 
WHERE  Poblacion > (
			SELECT SUM(Ciudad.Poblacion) 
			FROM   Ciudad JOIN Pais 
			ON     Ciudad.CodigoPais = Pais.Codigo 
			WHERE  Pais.Nombre = "France");

-- 64. Países con un PNB mayor que el país europeo con mayor PNB
SELECT Nombre 
FROM   Pais 
WHERE  PNB > (
			SELECT MAX(PNB) 
			FROM   Pais 
			WHERE  Continente = "Europe");


-- 65. Ciudades que pertenecen a países que tienen una renta per cápita mayor que la renta per cápita media de los países en los que el inglés es lengua oficial
SELECT Nombre 
FROM   LenguaPais JOIN Pais 
ON     LenguaPais.CodigoPais = Pais.Codigo 
WHERE  EsOficial = "T" 
	   AND Lengua = "English";
	  
SELECT PNB * 1000000 / poblacion AS "Renta per capita de paises que hablan ingles" 
FROM  LenguaPais JOIN Pais 
ON    LenguaPais.CodigoPais = Pais.Codigo 
WHERE EsOficial = "T" 
	  AND Lengua = "English";
	  
SELECT AVG(PNB * 1000000 / poblacion) AS "Media de Renta per capita de paises que hablan ingles" 
FROM   LenguaPais JOIN Pais 
ON     LenguaPais.CodigoPais = Pais.Codigo 
WHERE  EsOficial = "T" 
	   AND Lengua = "English";

SELECT Ciudad.Nombre 
FROM   Ciudad JOIN Pais 
ON     Ciudad.CodigoPais = Pais.Codigo 
WHERE  PNB * 1000000 / Pais.Poblacion > (
			SELECT AVG(PNB * 1000000 / Pais.poblacion)
			FROM LenguaPais JOIN Pais 
			ON LenguaPais.CodigoPais = Pais.Codigo 
			WHERE EsOficial = "T" 
				  AND Lengua = "English"); 


-- -----------------------------------------------------------------------------
-- Subconsultas de columna
-- -----------------------------------------------------------------------------

-- Manual de MySQL v8.4 15.2.15.3 Subqueries with ANY, IN, or SOME

-- Creamos la siguiente BD
CREATE SCHEMA subconsultas;
USE subconsultas;
CREATE TABLE ta (c1 int(2));
INSERT INTO  ta VALUES (15);
INSERT INTO  ta VALUES (10);

CREATE TABLE tan (c1 int(2));
INSERT INTO  tan VALUES (15);
INSERT INTO  tan VALUES (10);
INSERT INTO  tan VALUES ();

CREATE TABLE tb (c1 int(2), c2 CHAR(10));
INSERT INTO  tb VALUES (10, 'v1');
INSERT INTO  tb VALUES (10, 'v2');
INSERT INTO  tb VALUES (5,  'v3');

SELECT * FROM ta;
SELECT * FROM tan;
SELECT * FROM tb;


/*
ANY y ALL
En subconsultas que devuelven una columna, ANY quiere decir alguno de los registros de la subconsulta y ALL todos los registros.
*/

-- Comportamiento de ANY y ALL con nulos y listas vacías
/*
-- ANY
¿10 = ANY (15, 10)?           TRUE 		SELECT 10 = ANY (SELECT C1 FROM Ta);
¿10 = ANY (15, 10, NULL)?  	  TRUE 		SELECT 10 = ANY (SELECT C1 FROM Tan);
¿30 = ANY (15, 10)?        	  FALSE 	SELECT 30 = ANY (SELECT C1 FROM Ta);
¿30 = ANY (15, 10, NULL)?     NULL 		SELECT 30 = ANY (SELECT C1 FROM Tan);
¿10 = ANY ()?                 FALSE 	SELECT 10 = ANY 
											(SELECT C1 
											 FROM Tan 
											 WHERE C1 = 666);

-- ALL
¿10 <> ALL (15, 10)?          FALSE 	SELECT 10 <> ALL (SELECT C1 FROM Ta);  
¿10 <> ALL (15, 10, NULL)?	  FALSE 	SELECT 10 <> ALL (SELECT C1 FROM Tan);
¿30 <> ALL (15, 10)?       	  TRUE 		SELECT 30 <> ALL (SELECT C1 FROM Ta);
¿30 <> ALL (15, 10, NULL)? 	  NULL 		SELECT 30 <> ALL (SELECT C1 FROM Tan);
¿10 <> ALL ()?                TRUE 		SELECT 10 <> ALL 
											(SELECT C1 
											 FROM Tan 
											 WHERE C1 = 666);
											 
											 
NO tiene MUCHO SENTIDO      DA SIEMPRE
¿10 =  ALL (15, 10)?  		  FALSE 	SELECT 10 = ALL (SELECT C1 FROM Ta);
¿10 <> ANY (15, 10)? 		  TRUE 		SELECT 10 <> ANY (SELECT C1 FROM Ta);
*/

/*
IN  	<=> = ANY
NOT IN 	<=> <> ALL
SOME 	<=> ANY (No lo usaremos en clase)
*/

SELECT * FROM tb WHERE c1 = ANY (SELECT c1 from ta);
SELECT * FROM tb WHERE c1 = ANY (SELECT c1 from tan);
SELECT * FROM tb WHERE c1 = ANY (SELECT c1 from ta WHERE c1 = 666);


SELECT * FROM tb WHERE c1 <> ALL (SELECT c1 from ta);
SELECT * FROM tb WHERE c1 <> ALL (SELECT c1 from tan);
SELECT * FROM tb WHERE c1 <> ALL (SELECT c1 from ta WHERE c1 = 666);


/*
Resumen:
Los nulos no afectan al ANY, pero sí a ALL
Si la subconsulta devuelve un conjunto vacío de registros, ANY devuelve siempre falso y la consulta principal no devolverá ningún registro (salvo que pongamos NOT); y ALL devuelve siempre verdadero y la consulta principal devolverá todos los registros (salvo que pongamos NOT). ANY no devuelve ninguno y ALL devuelve todos.

Lo de cual es el comportamiento deseado de ANY y ALL cuando la subconsulta devuelve un conjunto vacío de registros no está claro. Si cogemos a una persona que no sabe informática y le pedimos que seleccione a los alumnos de nuestra clase cuya edad es distinta de la de todos los alumnos de la clase de al lado y esta persona va a la clase de al lado y descubre que no hay nadie, seguramente volverá y en vez de coger a todos los alumnos de nuestra clase nos dirá que en la clase de al lado no había nadie, es decir, nos dará un error.

Parece ser que lo que no es lógico es que en una consulta de ANY o de ALL, la subconsulta de un conjunto vacío de registros. Por lo tanto, en los ejercicios que hagamos, lo importante es saber cómo se comportará la consulta principal en caso de que la subconsulta de un conjunto vacío de registros. Lo de si es lógico o no dependerá de cada caso y lo más normal sería sacar un aviso al usuario de que la subconsulta a dado un conjunto vacío de registros (expresado de manera inteligible para el usuario).
*/

-- Los NULL afectan a ALL pero no a ANY
-- Si la subconsulta es vaica con ANY dara empty set 
-- Si la subconsulta es vacia con ALL devuelve todos

-- ¡IMPORTANTE!
-- En todas las consultas de ANY, ALL, IN tenenmos que hacer tres cosas:
-- 1. Indicar qué pasa si hay nulos en la subconsulta
-- 2. Indicar qué pasa si la subconsulta devuelve un conjunto vacío de registros
-- 3. Comprobar que la subconsulta no devuelve un conjunto vacío de registros	


-- 66. Países con un año de independencia igual al de alguno de los países con una superficie mayor que 500000 kilómetros cuadrados
SELECT Nombre AS "Paises"  FROM Pais WHERE Superficie > 500000;

SELECT Nombre AS "Pais"
FROM Pais
WHERE AnyIndep IN /* = ANY */ ( 
				SELECT AnyIndep 
				FROM Pais 
				WHERE Superficie > 500000);
				
/*
ANY con las listas vacías:
Podemos ver como si ejecutamos la consulta con 500.000 km2 salen 115 registros
Si la hacemos con 5.000.000 km2 ya sólo hay tres países en la subconsulta y la consulta principal da menos registros
Si la hacemos con 50.000.000 km2 la subconsulta da un conjunto vacío de registros porque ya no hay países con esa superficie y la consulta principal da también un conjunto vacío de registros lo cual es lógico viendo la tendencia.
*/

-- 67 Países con un año de independencia distinto del de todos los países con una superficie mayor que 500000 kilómetros cuadrados
SELECT COUNT(*) > 0 AS "Paises"  
FROM Pais 
WHERE Superficie > 500000 
	  AND AnyIndep IS NOT NULL; 
-- Si en la subconsulta hay nulos (como en este caso) no saldra ningun registro asi que los tenemos que eliminar con IS NOT NULL, 
	  


SELECT Nombre AS "Pais"
FROM Pais
WHERE AnyIndep NOT IN /* <> ALL */ ( 
				SELECT AnyIndep 
				FROM Pais 
				WHERE Superficie > 500000 
					  AND AnyIndep IS NOT NULL /*Obligatorio */);

/*
ALL con las listas vacías:
Podemos ver como si ejecutamos la consulta con 500.000 km2 salen 77 registros
Si la hacemos con 5.000.000 km2 ya sólo hay tres países en la subconsulta y la consulta principal da más registros (167)
Si la hacemos con 50.000.000 km2 la subconsulta da un conjunto vacío de registros porque ya no hay países con esa superficie y la consulta principal da todos los registros lo cual es lógico viendo la tendencia.

Vemos como desde este punto de vista, el funcionamiento de ANY y ALL con las subconsultas que generan listas vacías parece lógico.
*/

/* Resumen:
= ANY 	-> Tiene sentido
<> ALL 	-> Tiene sentido
<> ANY 	-> No tiene sentido (Saldran todos)
= ALL 	-> No tiene sentido (No saldra ninguno)
> ANY 	-> Tiene sentido ( es igual > MIN() )
> ALL 	-> Tiene sentido ( es igual > MAX() )
< ANY 	-> Tiene sentido ( es igual < MAX() )
< ALL 	-> Tiene sentido ( es igual < MIN() )
*/


DROP PROCEDURE IF EXISTS Consulta66;
delimiter //
CREATE PROCEDURE Consulta66(ParamSup INT)
BEGIN
        FROM   Pais
    IF (SELECT COUNT(*)>0
        WHERE  Superficie > ParamSup AND AnyIndep IS NOT NULL)
   
   THEN
   	SELECT Pais.Nombre AS 'País', AnyIndep
	FROM   Pais  
	WHERE  AnyIndep <> ALL (    
		SELECT AnyIndep
		FROM   Pais
		WHERE  Superficie > ParamSup AND AnyIndep IS NOT NULL);
   
   ELSE
       SELECT CONCAT('No hay ningún país con una superficie mayor que ', ParamSup, ' kilómetros cuadrados') AS 'Error:';  
   END IF;
END //delimiter ;

CALL Consulta66(500000);

-- 68. Países con un año de independencia mayor que alguno de los países cuya capital tiene más de cinco millones de habitantes. Nota: obtener las dos soluciones (ANY-ALL-IN y MAX-MIN). Reescribe el enunciado para que MAX-MIN en vez de ANY-ALL-IN

-- Países con un año de independencia mayor que el menor año de independencia de los países cuya capital tienen más de cinco millones de habitantes.
-- Países con un año de independencia posterior al del  primer pais en independizarse con una capital de más de cinco millones de habitantes.

SELECT DISTINCT AnyIndep  --DISTINCT S3E PUEDE PONER SIEMPRE PERO NO CAMBIA
FROM Ciudad JOIN Pais 
ON Ciudad.Id = Pais.Capital 
WHERE Ciudad.Poblacion > 5000000;

SELECT DISTINCT Count(*) > 0 
FROM Ciudad JOIN Pais 
ON Ciudad.Id = Pais.Capital 
WHERE Ciudad.Poblacion > 5000000; -- Deberia ser true para poder usarla, Y SI es NULL en any no afecta pero en 

SELECT Nombre AS "Pais"
FROM Pais
WHERE AnyIndep > ANY(
				SELECT DISTINCT AnyIndep 
				FROM Ciudad JOIN Pais 
				ON Ciudad.Id = Pais.Capital 
				WHERE Ciudad.Poblacion > 5000000);
				
SELECT Nombre AS "Pais"
FROM Pais
WHERE AnyIndep >(
				SELECT MIN(AnyIndep) 
				FROM Ciudad JOIN Pais 
				ON Ciudad.Id = Pais.Capital 
				WHERE Ciudad.Poblacion > 5000000); -- Sin analisis e igual a la anterior
				
				
SELECT Nombre AS "Pais"
FROM Pais
WHERE AnyIndep > ALL(
				SELECT DISTINCT AnyIndep 
				FROM Ciudad JOIN Pais 
				ON Ciudad.Id = Pais.Capital 
				WHERE Ciudad.Poblacion > 5000000);
				
SELECT Nombre AS "Pais"
FROM Pais
WHERE AnyIndep >(
				SELECT MAX(AnyIndep)
				FROM Ciudad JOIN Pais 
				ON Ciudad.Id = Pais.Capital 
				WHERE Ciudad.Poblacion > 5000000);
				
SELECT Nombre AS "Pais"
FROM Pais
WHERE AnyIndep IN (
				SELECT AnyIndep 
				FROM Ciudad JOIN Pais 
				ON Ciudad.Id = Pais.Capital 
				WHERE Ciudad.Poblacion > 5000000);

-- 69. Ciudades del mundo que empiezan por una letra distinta que la letra inicial de las ciudades españolas (con código de país ESP)
SELECT DISTINCT LEFT(NOMBRE, 1) 
FROM CIUDAD 
WHERE CodigoPais = "ESP"; 
-- Si hay nulos afectaran negativamente pero no hay nulos (hacer siempre)

SELECT Count(*) > 0 /* (hacer siempre) */
FROM CIUDAD 
WHERE CodigoPais = "ESP"; 
-- Si devuelve 0 sacaria todos los registros asi que nos aseguramos que no pase comprobandolo (hacer siempre)


SELECT Nombre 
FROM Ciudad 
WHERE LEFT(NOMBRE, 1) <> ALL(
						SELECT DISTINCT LEFT(NOMBRE, 1) 
						FROM CIUDAD 
						WHERE CodigoPais = "ESP");


-- -----------------------------------------------------------------------------
--  CONSULTAS DE INTERSECCIÓN DE CONJUNTOS
-- -----------------------------------------------------------------------------

-- 70. Países cuyo nombre coincide con el de alguna ciudad

SELECT Nombre FROM Ciudad; 
-- Si LA SUBCONSULTA DEVUELVE UN CONJUNTO VACIO DE REGISTRO NO SALDRA NINGUN Pais
-- LO NULOS NO AFECTAN. NO PUEDE HABER CIUDADES CON NOMBRES nulos

SELECT COUNT(*) FROM Ciudad; -- DEBE DAR MAYOR QUE 0

SELECT Nombre 
FROM  Pais 
WHERE Nombre IN ( SELECT Nombre FROM Ciudad);

-- 71. Países cuyo nombre no coincide con el de ninguna ciudad

SELECT Nombre FROM Ciudad; 
-- Si LA SUBCONSULTA DEVUELVE UN CONJUNTO VACIO DE REGISTRO SALEN TODOS LOS PAISES
-- LO NULOS AFECTAN. NO PUEDE HABER CIUDADES CON NOMBRES nulos

SELECT COUNT(*) FROM Ciudad; -- DEBE DAR MAYOR QUE 0 (TRUE)

SELECT Nombre 
FROM  Pais 
WHERE Nombre NOT IN ( SELECT Nombre FROM Ciudad);


-- 72. Países cuyo nombre coincide con el de alguna lengua

SELECT Lengua FROM LenguaPais; 
-- Si LA SUBCONSULTA DEVUELVE UN CONJUNTO VACIO DE REGISTRO NO SALDRA NINGUN Pais
-- LO NULOS NO AFECTAN. NO PUEDE HABER CIUDADES CON NOMBRES nulos

SELECT COUNT(*) FROM LenguaPais; -- DEBE DAR MAYOR QUE 0

SELECT Nombre 
FROM  Pais 
WHERE Nombre NOT IN ( SELECT DISTINCT Lengua FROM LenguaPais);

-- 73. Países cuyo nombre no coincide con el de alguna lengua
-- no tiene sentido

SELECT Lengua FROM LenguaPais;
-- Si LA SUBCONSULTA DEVUELVE UN CONJUNTO VACIO DE REGISTRO SALEN TODOS LOS PAISES
-- LO NULOS AFECTAN. NO PUEDE HABER CIUDADES CON NOMBRES nulos

SELECT COUNT(*) FROM LenguaPais; -- DEBE DAR MAYOR QUE 0

SELECT Nombre 
FROM  Pais 
WHERE Nombre NOT IN (SELECT Lengua FROM LenguaPais);

-- 74. Lenguas cuyo nombre coincide con el de alguna ciudad

-- Si LA SUBCONSULTA DEVUELVE UN CONJUNTO VACIO DE REGISTRO SALEN TODOS LOS PAISES
-- LO NULOS AFECTAN. NO PUEDE HABER CIUDADES CON NOMBRES nulos

SELECT COUNT(*) FROM Ciudad;  -- DEBE DAR MAYOR QUE 0 (TRUE)

SELECT Lengua 
FROM  LenguaPais 
WHERE Lengua IN (SELECT DISTINCT Nombre FROM Ciudad);

SELECT Nombre 
FROM  Ciudad 
WHERE Nombre IN (SELECT DISTINCT Lengua FROM LenguaPais);
-- Son iguales ambas



