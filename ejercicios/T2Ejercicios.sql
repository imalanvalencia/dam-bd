/*
Bases de Datos
Tema 2. Ejercicios de SQL avanzado I
Realiza las siguientes consultas SQL
Nombre:
Grupo: 

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

-- --------------------------------------------------------------------------------------
-- Consulta 1. Indica si hay algún país sin capital

-- --------------------------------------------------------------------------------------
-- Consulta 2. Nombre del país y nombre de la capital de los países que tienen capital

-- --------------------------------------------------------------------------------------
-- Consulta 3. Nombre de todos los países junto con el nombre de su capital

-- --------------------------------------------------------------------------------------
-- Consulta 4. Explica el resultado de esta consulta. Elabora un enunciado:
SELECT Ciudad.Nombre AS "Ciudad", Pais.Nombre AS "País" 
FROM   Ciudad LEFT JOIN Pais 
ON     Ciudad.Id = Pais.Capital
-- Resultado: 4079 registros

-- --------------------------------------------------------------------------------------
-- Consulta 5. Explica el resultado de esta consulta. Elabora un enunciado:
SELECT Ciudad.Nombre AS "Ciudad", Pais.Nombre AS "País" 
FROM   Ciudad LEFT JOIN Pais 
ON     Ciudad.CodigoPais = Pais.Codigo
-- Resultado: 4079 registros

-- --------------------------------------------------------------------------------------
-- Consulta 6. Nombre de las ciudades que no son capital de ningún país

-- --------------------------------------------------------------------------------------
-- Consulta 7. Nombre de las ciudades y nombre del país al que pertenecen de las ciudades que no son capital de ningún país.

-- --------------------------------------------------------------------------------------
-- Consulta 8. Nombre de las lenguas junto con el país en el que se hablan

-- --------------------------------------------------------------------------------------
-- Consulta 9. Nombre de todas las lenguas junto con el país en el que se hablan

-- --------------------------------------------------------------------------------------
-- Consulta 10. Nombre de todos los países junto con las lenguas que se hablan en ese país.

-- --------------------------------------------------------------------------------------
-- Consulta 11. Nombre de las lenguas que no tienen asignado ningún país.

-- --------------------------------------------------------------------------------------
-- Consulta 12. Nombre de los países que no tienen asignada ninguna lengua.

-- --------------------------------------------------------------------------------------
-- Consulta 13. Listado de ciudades que pertenecen a países que tienen lenguas oficiales que sólo son habladas por menos de un 10% de la población.

-- --------------------------------------------------------------------------------------
-- Consulta 14. Listado de capitales que pertenecen a países que tienen lenguas oficiales que sólo son habladas por menos de un 10% de la población.

-- --------------------------------------------------------------------------------------
-- Consulta 15. Para detectar posibles errores en la base de datos queremos realizar la siguiente consulta: listado de ciudades y países en los que la población de la ciudad sea mayor que la del país al que pertenece. Analiza el resultado.

-- --------------------------------------------------------------------------------------
-- Consulta 16. Listado de las lenguas habladas en países con más de doscientos millones de habitantes.

-- --------------------------------------------------------------------------------------
-- Consulta 17. Capitales de países en los que el inglés sea lengua oficial.

-- --------------------------------------------------------------------------------------
-- Consulta 18. Capitales de los países en los que el inglés sea lengua oficial y el país tenga más de un millón de habitantes y la capital más de 200 mil habitantes.

-- --------------------------------------------------------------------------------------
-- Consulta 19. Capitales y lenguas de países que tienen una densidad de población mayor que mil habitantes por kilómetro cuadrado ordenados de mayor a menor densidad de población.

-- --------------------------------------------------------------------------------------
-- Consulta 20. Como sustituto de la orden FULL JOIN que no está en MySQL, podemos usar UNION. Listado de ciudades y países en el que aparezcan todas las ciudades, aunque no pertenezcan a ningún país y todos los países, aunque no tengan ninguna ciudad.

-- --------------------------------------------------------------------------------------
-- Consulta 21. Convierte la siguiente consulta a MySQL. Como no tenemos la BD no se puede ejecutar.
-- SELECT Productos.Nombre AS "Productos", Categoria.Descripcion AS "Categorías"
-- FROM   Productos FULL JOIN Categorias
-- ON     Productos.IdCategoria = Categorias.Id

-- --------------------------------------------------------------------------------------
-- Consulta 22. Definimos índice de densidad alfabética como la población de un país o ciudad dividido entre el número de letras del nombre del país o ciudad. El índice de las ciudades está multiplicado por 10. Listado de los 20 países o ciudades con mayor índice de densidad alfabética y su índice. Todo ordenado por su índice. Queremos saber cuándo se trata de un país o de una ciudad.

-- --------------------------------------------------------------------------------------
-- Consulta 23. Listado de los diez países con mayor densidad de población junto con las diez lenguas habladas por más población en su país; todo ordenado alfabéticamente. Queremos saber cuándo se trata de un país y cuándo se trata de una lengua.

-- --------------------------------------------------------------------------------------
-- Consulta 24. Listado del nombre de los países que se independizaron el mismo año que Somalia (con código de país SOM)

-- --------------------------------------------------------------------------------------
-- Consulta 25. Listado del nombre de los países que se independizaron el mismo año que Somalia (con código de país SOM). Nota: quita del listado a Somalia, que ya sabemos que se independizó ese año.

-- --------------------------------------------------------------------------------------
-- Consulta 26. Listado de países y su población que tienen una población mayor que la de España y menor que la de Francia, ordenado por población.

-- --------------------------------------------------------------------------------------
-- Consulta 27. Listado de ciudades que tienen una población mayor que la de Irlanda (con código de país IRL)

-- --------------------------------------------------------------------------------------
-- Consulta 28. Listado de capitales que tienen una población mayor que la de Irlanda (con código de país IRL)

-- --------------------------------------------------------------------------------------
-- Consulta 29. Listado de capitales que tienen una población diez veces mayor que la capital de Irlanda (con nombre en la BD: "Ireland")

-- Consulta 30. Listado de países en los que la lengua inglesa es oficial y se habla con un porcentaje mayor que el que el inglés tiene en Canadá (con código de país CAN).

-- --------------------------------------------------------------------------------------
-- Consulta 31. Listado de países, su esperanza de vida y su densidad de población cuya esperanza de vida es mayor que la de España (Código de país ESP) y cuya densidad de población es mayor que la de Japón (con código de país JPN); ordenado por esperanza de vida (de mayor a menor) y por densidad de población, también de mayor a menor.

-- --------------------------------------------------------------------------------------
-- Consulta 32. Países que tienen una población menor que la población de la capital más poblada.

-- --------------------------------------------------------------------------------------
-- Consulta 33. Países que tienen una población mayor que la media.

-- --------------------------------------------------------------------------------------
-- Consulta 34. Países que tienen una población menor que la población media de las ciudades.

-- --------------------------------------------------------------------------------------
-- Consulta 35. Países que tienen mayor población que la suma de las poblaciones de todas las ciudades de Brasil (con código de país BRA)

-- --------------------------------------------------------------------------------------
-- Consulta 36. Países que tienen mayor población que la suma de las poblaciones de todas las ciudades de Brasil. No usaremos el código del país, sino su nombre. Nota: hay dos soluciones, usando JOIN y sin usarlo. Pon las dos soluciones.

-- --------------------------------------------------------------------------------------
-- Consulta 37. Países con una superficie mayor que el mayor país de África ("Africa" en la BD).

-- --------------------------------------------------------------------------------------
-- Consulta 38. Países que tienen un año de independencia igual que el de los países cuya capital empieza por C.

-- --------------------------------------------------------------------------------------
-- Consulta 39. Países que tienen un año de independencia mayor que el de alguno de los países cuya capital empieza por C. Nota: obtener las dos soluciones (ANY-ALL-IN y MAX-MIN)

-- --------------------------------------------------------------------------------------
-- Consulta 40. Países que tienen un año de independencia igual que el de los países en los que el inglés es lengua oficial.

-- --------------------------------------------------------------------------------------
-- Consulta 41. Países que tienen un año de independencia distinto del de los países del continente Africano.

-- --------------------------------------------------------------------------------------
-- Consulta 42. Países con un año de independencia distinto que el de los países con capitales de más de un millón de habitantes.

-- --------------------------------------------------------------------------------------
-- Consulta 43. Número e países que no tienen ninguna ciudad.

-- --------------------------------------------------------------------------------------
-- Consulta 44. Listado de parejas de países que no se han independizado de manera que en el país de la izquierda se ha incrementado el PNB y en el de la derecha se ha decrementado.

-- --------------------------------------------------------------------------------------
-- Consulta 45. Países cuya lengua oficial es distinta de la lengua oficial de todos los países del continente africano

-- --------------------------------------------------------------------------------------
-- Consulta 46. Definimos el código de una ciudad como la primera letra de su nombre más la primera letra de su zona. Obtener un listado de ciudades cuyo código es distinto del código de todas las ciudades Europeas

-- --------------------------------------------------------------------------------------
-- Consulta 47. Países con una lengua oficial distinta de las lenguas (oficiales o no) habladas en los países que han incrementado su PNB

-- --------------------------------------------------------------------------------------
-- Consulta 48. Partiendo de una pequeña base de datos de marcas y modelos de bicicletas haz la siguiente consulta: listado de todas las marcas, aunque no tengan ningún modelo y todos los modelos, aunque no sean de ninguna marca.
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

-- --------------------------------------------------------------------------------------
-- Consulta 49. Proveedores que no proveen ningún producto de la categoría 'Beverages'
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

-- --------------------------------------------------------------------------------------
-- Consulta 50. Listado de empleados que no ha servido ningún pedido
/* Salida similar a
+-----------------------+
| Empleados sin pedidos |
+-----------------------+
| ACME ACME, ACME       |
+-----------------------+*/

INSERT INTO Empleados (IdEmpleado, Apellido, Nombre, Notas) VALUES (10, 'ACME ACME', 'ACME', 'A Company that Makes Everything');
DELETE FROM Empleados WHERE IdEmpleado = 10;

-- --------------------------------------------------------------------------------------
-- Consulta 51. Listado con los dos productos cuyo nombre es más largo junto con el nombre completo (Apellido, nombre) de los dos empleados cuyo apellido es más largo
-- Queremos saber cuándo se trata de un producto y de un empleado
/* Salida similar a
+----------------------------------+--------------+
| Nombre                           | Información  |
+----------------------------------+--------------+
| Louisiana Fiery Hot Pepper Sauce | Producto     |
| Jack's New England Clam Chowder  | Producto     |
| Dodsworth, Anne                  | Empleado     |
| Leverling, Janet                 | Empleado     |
+----------------------------------+--------------+*/


-- --------------------------------------------------------------------------------------
-- Consulta 52. Listado con los dos productos cuyo nombre es más largo junto con el nombre completo (Apellido, nombre) de los dos empleados cuyo apellido es más largo
-- No tan fácil: Queremos saber cuándo se trata de un producto y de un empleado y el número de letras
/* Salida similar a
+----------------------------------+---------------------------------------------+
| Nombre                           | Información                                 |
+----------------------------------+---------------------------------------------+
| Louisiana Fiery Hot Pepper Sauce | Es un producto y tiene 32 letras            |
| Jack's New England Clam Chowder  | Es un producto y tiene 31 letras            |
| Dodsworth, Anne                  | Es un empleado y su apellido tiene 9 letras |
| Leverling, Janet                 | Es un empleado y su apellido tiene 9 letras |
+----------------------------------+---------------------------------------------+*/

-- --------------------------------------------------------------------------------------
-- Consulta 53. Listado con los proveedores y clientes españones 'Spain'. Indicar nombre de la empresa (NombreEmpresa), poblacion (Poblacion) y región (Region)
/* Salida similar a
+-----------+--------------------------------------+-----------+----------+
| Tipo      | Empresa                              | Poblacion | Región   |
+-----------+--------------------------------------+-----------+----------+
| proveedor | Cooperativa de Quesos 'Las Cabras'   | Oviedo    | Asturias |
| cliente   | Blido Comidas preparadas             | Madrid    | NULL     |
| cliente   | FISSA Fabrica Inter. Salchichas S.A. | Madrid    | NULL     |
...
+-----------+--------------------------------------+-----------+----------+
6 rows in set (0,00 sec)*/

-- --------------------------------------------------------------------------------------
-- Consulta 54. Listado con los proveedores y clientes españones 'Spain'. Indicar nombre de la empresa (NombreEmpresa), poblacion (Poblacion) y región (Region)
-- No tan fácil: salida similar a (si la región tiene valor NULL saldrá 'N/A') (2,25)
/* Salida similar a
+-----------+--------------------------------------+-----------+----------+
| Tipo      | Empresa                              | Poblacion | Región   |
+-----------+--------------------------------------+-----------+----------+
| proveedor | Cooperativa de Quesos 'Las Cabras'   | Oviedo    | Asturias |
| cliente   | Blido Comidas preparadas             | Madrid    | N/A      |
| cliente   | FISSA Fabrica Inter. Salchichas S.A. | Madrid    | N/A      |
...
+-----------+--------------------------------------+-----------+----------+
6 rows in set (0,00 sec)*/
