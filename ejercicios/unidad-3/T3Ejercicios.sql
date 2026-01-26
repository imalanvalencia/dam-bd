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


-- --------------------------------------------------------------------------------------
-- Consulta 10. De cada capital queremos saber el número de ciudades que pertenecen al país del que es capital.
SELECT  Capitales.Nombre AS "Capitales",
        COUNT(Ciudad.Nombre) AS "Numero de Ciudades"
FROM    Ciudad Capitales JOIN Pais JOIN Ciudad
ON      Capitales.Id = Pais.Capital
        AND Ciudad.CodigoPais = Pais.Codigo
GROUP BY Capitales.Id;

SELECT  Ciudad.Nombre AS "Capital",
        ( SELECT COUNT(*) FROM Ciudad WHERE Ciudad.CodigoPais = Pais.Codigo) AS "Numero de Ciudades"
FROM    Ciudad JOIN Pais
ON      Ciudad.Id = Pais.Capital;

-- --------------------------------------------------------------------------------------
-- Consulta 11. De cada lengua oficial queremos saber su número de hablantes (como lengua oficial).

-- --------------------------------------------------------------------------------------
-- Consulta 12. De cada continente, queremos saber el número de lenguas oficiales y no oficiales distintas que se hablan.

-- --------------------------------------------------------------------------------------
-- Consulta 13. Vamos a establecer tramos por decenas en el porcentaje de hablantes de una legua: del 0% al 10%; del 10% al 20% y así. De cada lengua y cada tramo, queremos saber el número de países en los que se habla y el número total de hablantes de esa lengua.

-- --------------------------------------------------------------------------------------
-- Consulta 14. Queremos saber el número de ciudades que hay en cada tramo de la esperanza de vida organizada por decenas.

-- --------------------------------------------------------------------------------------
-- Consulta 15. Número de países que comienzan por la A, por la B y así.

-- --------------------------------------------------------------------------------------
-- Consulta 16. De cada continente y cada región, queremos saber el número de países que lo componen y el número de países que no tienen año de independencia, con totales.

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

-- --------------------------------------------------------------------------------------
-- Consulta 19. De acuerdo con la tabla anterior queremos saber cómo de extendidas están las lenguas oficiales. Para ello crearemos una tabla en la que aparecerán los tramos en la primera columna y el número de lenguas que se hablan según los límites de ese tramo. Por ejemplo aparecerá: Muy poco extendida y en la siguiente columna el número de lenguas que se hablan de manera oficial en cero o un país.

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

-- --------------------------------------------------------------------------------------
-- Consulta 22. De cada continente queremos saber el número total de habitantes partido el número de lenguas que se hablan.

-- --------------------------------------------------------------------------------------
-- Consulta 23. Listado del los países y el número de ciudades de ese país para los países que tienen más ciudades que España.

-- --------------------------------------------------------------------------------------
-- Consulta 24. Listado de países y el número de lenguas de ese país para los países que tienen más lenguas que España con código de país "ESP".

-- --------------------------------------------------------------------------------------
-- Consulta 25. Capitales de países que tienen más lenguas oficiales que Canadá con código de país "CAN" y las mismas o menos que Suiza con código de país "CHE".

-- --------------------------------------------------------------------------------------
-- Consulta 26. Obtener un listado de nombre de capitales que son capital de más de un país (que dos países tengan la misma capital no tiene porqué ser un error, pueden ser capitales diferentes con el mismo nombre). 

-- -------------------------------------------------------------------------------------- 
-- Consulta 27. Obtener un listado de nombre de países repetidos. Consideramos que el nombre de un país está repetido si tenemos al mismo país con el mismo nombre más de una vez dentro del mismo continente. 

-- --------------------------------------------------------------------------------------
-- Consulta 28. Obtener un listado de nombre de países repetidos. Consideramos que el nombre de un país está repetido si aparece más de una vez en nuestra BD. 

-- --------------------------------------------------------------------------------------
-- Consulta 29. Realiza la consulta adecuada para saber si existe algún Codigo2 repetido

-- --------------------------------------------------------------------------------------
-- Consulta 30. Queremos cinco países aleatorios. De cada país saca su nombre, su población en millones de habitantes con un decimal y su esperanza de vida (sin decimales). 

-- --------------------------------------------------------------------------------------
-- Consulta 31. Queremos cuatro países aleatorios junto con las lenguas que se hablan en esos países (dependiendo de las lenguas habladas en cada país la consulta tendrá más o menos registros. Por ejemplo, si en cada país se habla dos lenguas, la consulta tendrá ocho registros) 

-- ----------------------------------------------------------------------------------------------
-- Consultas sobre Neptuno
-- ----------------------------------------------------------------------------------------------
-- Salvo que se indique lo contrario, en los pedidos, los costes de envío no se tendrán en cuenta en ninguna consulta, pero sí habrá que tener en cuenta el descuento, aunque no hay ningún registro que tenga descuento en DetallesPedido.
-- Para calcular el importe de un producto de un pedido, usaremos la fórmula: PrecioUnitario * Cantidad * (1 - Descuento), es decir, suponemos que el descuento está expresado en tantos por uno (por ejemplo, 0.1 es un descuento de un 10%)

-- --------------------------------------------------------------------------------------
-- Consulta 32. Proveedores que proveen exáctamente tres productos

-- --------------------------------------------------------------------------------------
-- Consulta 33. Pedidos que piden exáctamente 6 productos

-- --------------------------------------------------------------------------------------
-- Consulta 34. Clientes que han realizado los pedidos que tienen exáctamente 6 productos

-- --------------------------------------------------------------------------------------
-- Consulta 35. Categorías con más de 10 procutos

-- --------------------------------------------------------------------------------------
-- Consulta 36. Productos de los que se han vendido más de 1000 unidades

-- --------------------------------------------------------------------------------------
-- Consulta 37. Clientes que han pedido más de 50 unidades de 'queso cabrales'

-- --------------------------------------------------------------------------------------
-- Consulta 38. Productos que han sido comprados por más de 30 clientes

-- --------------------------------------------------------------------------------------   
-- Consulta 39. Listado del cliente, fecha y coste de los pedidos (incluyendo los costes de envío), ordenados por cliente y fecha.
-- Puedes usar: DATE_FORMAT(FechaPedido, '%d-%m-%Y') AS 'Fecha de pedido'

-- --------------------------------------------------------------------------------------       
-- Consulta 40. Candidad facturada por cada cliente

-- --------------------------------------------------------------------------------------
-- Consulta 41. Cantidad facturada con cada producto

-- --------------------------------------------------------------------------------------
-- Consulta 42. Cantidad facturada con cada categoría

-- --------------------------------------------------------------------------------------
-- Consulta 43. Número de pedidos realizados por año y mes

-- --------------------------------------------------------------------------------------
-- Consulta 44. Ventas por territorio y región ordenado de mayor a menor ventas

-- --------------------------------------------------------------------------------------
-- Consulta 45. Número de pedidos realizados con 1 producto, con 2, con 3, etc.

-- --------------------------------------------------------------------------------------
-- Consulta 46. Relación de productos ordenada según la cantidad de ese producto que se ha pedido

-- --------------------------------------------------------------------------------------
-- Consulta 47. Número de proveedores de cada categoría para categorías que tienen más de diez proveedores y ordenados de mayor a menor número de proveedores

-- --------------------------------------------------------------------------------------
-- Consulta 48. Listado de proveedores y número de productos que provee cada uno ordenado del proveedor que más productos provee al que menos

-- --------------------------------------------------------------------------------------
-- Consulta 49. Número medio de productos que provee cada proveedor

-- --------------------------------------------------------------------------------------
-- Consulta 50. Número medio de productos diferentes que se piden en cada pedido (Si de un producto se piden cinco unidades, sólo se cuenta como ese producto se ha pedido una vez)

-- --------------------------------------------------------------------------------------
-- Consulta 51. Número medio de productos que se piden en cada pedido (Si de un producto se piden cinco unidades, se cuenta como que se han pedido cinco productos)

-- --------------------------------------------------------------------------------------
-- Consulta 52. Número de veces que se ha vendido cada producto (Si de un producto se venden cinco unidades, sólo se cuenta como ese producto se ha vendido una vez), ordenado del producto más vendido al que menos.

-- --------------------------------------------------------------------------------------
-- Consulta 53. Número de unidades vendidas de cada producto (Si de un producto se venden cinco unidades, se cuenta como que se han vendido cinco productos), ordenado del producto más vendido al que menos.

-- --------------------------------------------------------------------------------------
-- Consulta 54. Número de veces que se se pide cada producto por pedido (Si de un producto se venden cinco unidades, sólo se cuenta como ese producto se ha vendido una vez), ordenado del producto más vendido al que menos.

-- --------------------------------------------------------------------------------------
-- Consulta 55. Cantidad vendida de cada producto por pedido (Si de un producto se venden cinco unidades, cuentan las cinco unidades como cantidad vendida), ordenado del producto más vendido al que menos.

-- --------------------------------------------------------------------------------------
-- Consulta 56. Número de clientes que han comprado cada producto

-- --------------------------------------------------------------------------------------
-- Consulta 57. Ingresos obtenidos con los cinco productos más caros

-- --------------------------------------------------------------------------------------
-- Consulta 58. Ingresos obtenidos con los cinco productos más baratos

-- --------------------------------------------------------------------------------------
-- Consulta 59. Ingresos obtenidos con cada uno de los cinco productos más caros (aparecerá cada producto por separado con la cantidad ganada con ese producto)

-- --------------------------------------------------------------------------------------
-- Consulta 60. Ingresos obtenidos con cada uno de los cinco productos más baratos (aparecerá cada producto por separado con la cantidad ganada con ese producto)

-- --------------------------------------------------------------------------------------
-- Consulta 61. Ingresos obtenidos con los cinco productos más vendidos

-- --------------------------------------------------------------------------------------
-- Consulta 62. Ingresos obtenidos con los cinco productos menos vendidos

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


