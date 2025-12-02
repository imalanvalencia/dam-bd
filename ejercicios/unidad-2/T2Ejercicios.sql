/*
Bases de Datos
Tema 2. Ejercicios de SQL avanzado I
Realiza las siguientes consultas SQL
Nombre: Alan Smith Valencia Izquierdo
Grupo: DAM 1-B Doctor Balmis

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
*/

-- --------------------------------------------------------------------------------------
-- Consulta 1. Indica si hay alg�n pa�s sin capital
SELECT Nombre AS "Paises sin capital"
FROM   Pais 
WHERE  Capital IS NULL;

-- --------------------------------------------------------------------------------------
-- Consulta 2. Nombre del pa�s y nombre de la capital de los pa�ses que tienen capital
SELECT Pais.Nombre AS "Pais", Ciudad.Nombre AS "Capital"
FROM   Pais JOIN Ciudad
ON     Ciudad.Id = Pais.Capital;

-- --------------------------------------------------------------------------------------
-- Consulta 3. Nombre de todos los pa�ses junto con el nombre de su capital
SELECT Pais.Nombre AS "Pais", Ciudad.Nombre AS "Capital"
FROM   Pais LEFT JOIN Ciudad
ON     Ciudad.Id = Pais.Capital;

-- --------------------------------------------------------------------------------------
-- Consulta 4. Explica el resultado de esta consulta. Elabora un enunciado:
SELECT Ciudad.Nombre AS "Ciudad", Pais.Nombre AS "Pa�s" 
FROM   Ciudad LEFT JOIN Pais 
ON     Ciudad.Id = Pais.Capital -- FALTA ";"
-- Resultado: 4079 registros

-- Los registros resultantes seran las relaciones y las no relaciones que tiene la tabla Pais(tabla izquierda) con respecto a la tabla Ciudad(tabla derecha) los registro sin ninguna conicidencia seran NULL; en este caso se busca relacionar las ciudades con sus paises y saber cuales son sus capitales

-- --------------------------------------------------------------------------------------
-- Consulta 5. Explica el resultado de esta consulta. Elabora un enunciado:
SELECT Ciudad.Nombre AS "Ciudad", Pais.Nombre AS "Pa�s" 
FROM   Ciudad LEFT JOIN Pais 
ON     Ciudad.CodigoPais = Pais.Codigo -- FALTA ";"
-- Resultado: 4079 registros

-- Los registros resultantes seran las relaciones y las no relaciones que tiene la tabla ciudad(tabla izquierda) con respecto a la tabla pais(tabla derecha) los registro sin ninguna conicidencia seran NULL; en este caso se busca saber a que pais pertenece cada ciudad

-- --------------------------------------------------------------------------------------
-- Consulta 6. Nombre de las ciudades que no son capital de ning�n pa�s
SELECT  Ciudad.Nombre AS "Ciudades que no son capital"
FROM    Ciudad LEFT JOIN Pais
ON      Ciudad.Id = Pais.Capital
WHERE   Pais.Codigo IS NULL;

-- --------------------------------------------------------------------------------------
-- Consulta 7. Nombre de las ciudades y nombre del pa�s al que pertenecen de las ciudades que no son capital de ning�n pa�s.
SELECT  Ciudad.Nombre AS "Ciudad", Pais.Nombre AS "Pa�s" 
FROM    Ciudad JOIN Pais
ON      Ciudad.CodigoPais = Pais.Codigo
WHERE   Pais.Capital <> Ciudad.Id;

-- --------------------------------------------------------------------------------------
-- Consulta 8. Nombre de las lenguas junto con el pa�s en el que se hablan
SELECT Lengua, Nombre AS "Pais" 
FROM   LenguaPais JOIN Pais 
ON     LenguaPais.CodigoPais = Pais.Codigo;

-- --------------------------------------------------------------------------------------
-- Consulta 9. Nombre de todas las lenguas junto con el pa�s en el que se hablan
SELECT Lengua, Nombre AS "Pais" 
FROM   LenguaPais LEFT JOIN Pais 
ON     LenguaPais.CodigoPais = Pais.Codigo;

-- --------------------------------------------------------------------------------------
-- Consulta 10. Nombre de todos los pa�ses junto con las lenguas que se hablan en ese pa�s.
SELECT Nombre AS "Pais", Lengua
FROM   Pais LEFT JOIN LenguaPais
ON     LenguaPais.CodigoPais = Pais.Codigo AND Nombre IS NULL;

-- --------------------------------------------------------------------------------------
-- Consulta 11. Nombre de las lenguas que no tienen asignado ning�n pa�s.
SELECT Lengua
FROM   LenguaPais LEFT JOIN Pais 
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE  Pais.Codigo IS NULL;
-- --------------------------------------------------------------------------------------
-- Consulta 12. Nombre de los pa�ses que no tienen asignada ninguna lengua.
SELECT Nombre AS "Pais", Lengua
FROM   Pais LEFT JOIN LenguaPais
ON     LenguaPais.CodigoPais = Pais.Codigo
WHERE  LenguaPais.Lengua IS NULL;


-- --------------------------------------------------------------------------------------
-- Consulta 13. Listado de ciudades que pertenecen a pa�ses que tienen lenguas oficiales que s�lo son habladas por menos de un 10% de la poblaci�n.
SELECT DISTINCT Nombre
FROM   Ciudad  JOIN LenguaPais
ON     Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  EsOficial = "T" AND Porcentaje < 10;


-- --------------------------------------------------------------------------------------
-- Consulta 14. Listado de capitales que pertenecen a pa�ses que tienen lenguas oficiales que s�lo son habladas por menos de un 10% de la poblaci�n.
SELECT DISTINCT Ciudad.Nombre
FROM   Ciudad JOIN LenguaPais JOIN Pais
ON     Ciudad.Id = Pais.Capital AND Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  EsOficial = "T" AND Porcentaje < 10;

-- --------------------------------------------------------------------------------------
-- Consulta 15. Para detectar posibles errores en la base de datos queremos realizar la siguiente consulta: listado de ciudades y pa�ses en los que la poblaci�n de la ciudad sea mayor que la del pa�s al que pertenece. Analiza el resultado.
SELECT Ciudad.Nombre AS "Ciudad", Pais.Nombre AS "Pais"
FROM   Ciudad JOIN Pais
ON     Ciudad.CodigoPais = Pais.Codigo
WHERE  Ciudad.Poblacion > Pais.Poblacion;
-- Resultado: 2 registros

-- Aparecen las ciudades Singapore y Gibraltar  y puede ser que la bases de datos tenga datos eroneos y que no se en un sola fuente de la verdad, o que se actualice un datos y no tener en cuenta el otro, ...

SELECT Ciudad.Nombre AS "Ciudad", Pais.Nombre AS "Pais", Ciudad.Poblacion, Pais.Poblacion
FROM   Ciudad JOIN Pais
ON     Ciudad.CodigoPais = Pais.Codigo
WHERE  Pais.Nombre IN ("Gibraltar", "Singapore");


-- --------------------------------------------------------------------------------------
-- Consulta 16. Listado de las lenguas habladas en pa�ses con m�s de doscientos millones de habitantes.
SELECT DISTINCT Lengua
FROM   Ciudad  JOIN LenguaPais
ON     Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  Poblacion > 200000000;

-- --------------------------------------------------------------------------------------
-- Consulta 17. Capitales de pa�ses en los que el ingl�s sea lengua oficial.
SELECT DISTINCT Ciudad.Nombre
FROM   Ciudad JOIN LenguaPais JOIN Pais
ON     Ciudad.Id = Pais.Capital AND Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  EsOficial = "T" AND Lengua = "English";

-- --------------------------------------------------------------------------------------
-- Consulta 18. Capitales de los pa�ses en los que el ingl�s sea lengua oficial y el pa�s tenga m�s de un mill�n de habitantes y la capital m�s de 200 mil habitantes.
SELECT DISTINCT Ciudad.Nombre
FROM   Ciudad JOIN LenguaPais JOIN Pais
ON     Ciudad.Id = Pais.Capital AND Ciudad.CodigoPais = LenguaPais.CodigoPais
WHERE  EsOficial = "T"
       AND Lengua = "English"
       AND Pais.Poblacion > 1000000
       AND Ciudad.Poblacion > 200000;

-- --------------------------------------------------------------------------------------
-- Consulta 19. Capitales y lenguas de pa�ses que tienen una densidad de poblaci�n mayor que mil habitantes por kil�metro cuadrado ordenados de mayor a menor densidad de poblaci�n.

-- --------------------------------------------------------------------------------------
-- Consulta 20. Como sustituto de la orden FULL JOIN que no est� en MySQL, podemos usar UNION. Listado de ciudades y pa�ses en el que aparezcan todas las ciudades, aunque no pertenezcan a ning�n pa�s y todos los pa�ses, aunque no tengan ninguna ciudad.

-- --------------------------------------------------------------------------------------
-- Consulta 21. Convierte la siguiente consulta a MySQL. Como no tenemos la BD no se puede ejecutar.
-- SELECT Productos.Nombre AS "Productos", Categoria.Descripcion AS "Categor�as"
-- FROM   Productos FULL JOIN Categorias
-- ON     Productos.IdCategoria = Categorias.Id

-- --------------------------------------------------------------------------------------
-- Consulta 22. Definimos �ndice de densidad alfab�tica como la poblaci�n de un pa�s o ciudad dividido entre el n�mero de letras del nombre del pa�s o ciudad. El �ndice de las ciudades est� multiplicado por 10. Listado de los 20 pa�ses o ciudades con mayor �ndice de densidad alfab�tica y su �ndice. Todo ordenado por su �ndice. Queremos saber cu�ndo se trata de un pa�s o de una ciudad.

-- --------------------------------------------------------------------------------------
-- Consulta 23. Listado de los diez pa�ses con mayor densidad de poblaci�n junto con las diez lenguas habladas por m�s poblaci�n en su pa�s; todo ordenado alfab�ticamente. Queremos saber cu�ndo se trata de un pa�s y cu�ndo se trata de una lengua.

-- --------------------------------------------------------------------------------------
-- Consulta 24. Listado del nombre de los pa�ses que se independizaron el mismo a�o que Somalia (con c�digo de pa�s SOM)

-- --------------------------------------------------------------------------------------
-- Consulta 25. Listado del nombre de los pa�ses que se independizaron el mismo a�o que Somalia (con c�digo de pa�s SOM). Nota: quita del listado a Somalia, que ya sabemos que se independiz� ese a�o.

-- --------------------------------------------------------------------------------------
-- Consulta 26. Listado de pa�ses y su poblaci�n que tienen una poblaci�n mayor que la de Espa�a y menor que la de Francia, ordenado por poblaci�n.

-- --------------------------------------------------------------------------------------
-- Consulta 27. Listado de ciudades que tienen una poblaci�n mayor que la de Irlanda (con c�digo de pa�s IRL)

-- --------------------------------------------------------------------------------------
-- Consulta 28. Listado de capitales que tienen una poblaci�n mayor que la de Irlanda (con c�digo de pa�s IRL)

-- --------------------------------------------------------------------------------------
-- Consulta 29. Listado de capitales que tienen una poblaci�n diez veces mayor que la capital de Irlanda (con nombre en la BD: "Ireland")

-- Consulta 30. Listado de pa�ses en los que la lengua inglesa es oficial y se habla con un porcentaje mayor que el que el ingl�s tiene en Canad� (con c�digo de pa�s CAN).

-- --------------------------------------------------------------------------------------
-- Consulta 31. Listado de pa�ses, su esperanza de vida y su densidad de poblaci�n cuya esperanza de vida es mayor que la de Espa�a (C�digo de pa�s ESP) y cuya densidad de poblaci�n es mayor que la de Jap�n (con c�digo de pa�s JPN); ordenado por esperanza de vida (de mayor a menor) y por densidad de poblaci�n, tambi�n de mayor a menor.

-- --------------------------------------------------------------------------------------
-- Consulta 32. Pa�ses que tienen una poblaci�n menor que la poblaci�n de la capital m�s poblada.

-- --------------------------------------------------------------------------------------
-- Consulta 33. Pa�ses que tienen una poblaci�n mayor que la media.

-- --------------------------------------------------------------------------------------
-- Consulta 34. Pa�ses que tienen una poblaci�n menor que la poblaci�n media de las ciudades.

-- --------------------------------------------------------------------------------------
-- Consulta 35. Pa�ses que tienen mayor poblaci�n que la suma de las poblaciones de todas las ciudades de Brasil (con c�digo de pa�s BRA)

-- --------------------------------------------------------------------------------------
-- Consulta 36. Pa�ses que tienen mayor poblaci�n que la suma de las poblaciones de todas las ciudades de Brasil. No usaremos el c�digo del pa�s, sino su nombre. Nota: hay dos soluciones, usando JOIN y sin usarlo. Pon las dos soluciones.

-- --------------------------------------------------------------------------------------
-- Consulta 37. Pa�ses con una superficie mayor que el mayor pa�s de �frica ("Africa" en la BD).

-- --------------------------------------------------------------------------------------
-- Consulta 38. Pa�ses que tienen un a�o de independencia igual que el de los pa�ses cuya capital empieza por C.

-- --------------------------------------------------------------------------------------
-- Consulta 39. Pa�ses que tienen un a�o de independencia mayor que el de alguno de los pa�ses cuya capital empieza por C. Nota: obtener las dos soluciones (ANY-ALL-IN y MAX-MIN)

-- --------------------------------------------------------------------------------------
-- Consulta 40. Pa�ses que tienen un a�o de independencia igual que el de los pa�ses en los que el ingl�s es lengua oficial.

-- --------------------------------------------------------------------------------------
-- Consulta 41. Pa�ses que tienen un a�o de independencia distinto del de los pa�ses del continente Africano.

-- --------------------------------------------------------------------------------------
-- Consulta 42. Pa�ses con un a�o de independencia distinto que el de los pa�ses con capitales de m�s de un mill�n de habitantes.

-- --------------------------------------------------------------------------------------
-- Consulta 43. N�mero e pa�ses que no tienen ninguna ciudad.

-- --------------------------------------------------------------------------------------
-- Consulta 44. Listado de parejas de pa�ses que no se han independizado de manera que en el pa�s de la izquierda se ha incrementado el PNB y en el de la derecha se ha decrementado.

-- --------------------------------------------------------------------------------------
-- Consulta 45. Pa�ses cuya lengua oficial es distinta de la lengua oficial de todos los pa�ses del continente africano

-- --------------------------------------------------------------------------------------
-- Consulta 46. Definimos el c�digo de una ciudad como la primera letra de su nombre m�s la primera letra de su zona. Obtener un listado de ciudades cuyo c�digo es distinto del c�digo de todas las ciudades Europeas

-- --------------------------------------------------------------------------------------
-- Consulta 47. Pa�ses con una lengua oficial distinta de las lenguas (oficiales o no) habladas en los pa�ses que han incrementado su PNB

-- --------------------------------------------------------------------------------------
-- Consulta 48. Partiendo de una peque�a base de datos de marcas y modelos de bicicletas haz la siguiente consulta: listado de todas las marcas, aunque no tengan ning�n modelo y todos los modelos, aunque no sean de ninguna marca.
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
-- Consulta 49. Proveedores que no proveen ning�n producto de la categor�a 'Beverages'
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
-- Consulta 50. Listado de empleados que no ha servido ning�n pedido
/* Salida similar a
+-----------------------+
| Empleados sin pedidos |
+-----------------------+
| ACME ACME, ACME       |
+-----------------------+*/

INSERT INTO Empleados (IdEmpleado, Apellido, Nombre, Notas) VALUES (10, 'ACME ACME', 'ACME', 'A Company that Makes Everything');
DELETE FROM Empleados WHERE IdEmpleado = 10;

-- --------------------------------------------------------------------------------------
-- Consulta 51. Listado con los dos productos cuyo nombre es m�s largo junto con el nombre completo (Apellido, nombre) de los dos empleados cuyo apellido es m�s largo
-- Queremos saber cu�ndo se trata de un producto y de un empleado
/* Salida similar a
+----------------------------------+--------------+
| Nombre                           | Informaci�n  |
+----------------------------------+--------------+
| Louisiana Fiery Hot Pepper Sauce | Producto     |
| Jack's New England Clam Chowder  | Producto     |
| Dodsworth, Anne                  | Empleado     |
| Leverling, Janet                 | Empleado     |
+----------------------------------+--------------+*/


-- --------------------------------------------------------------------------------------
-- Consulta 52. Listado con los dos productos cuyo nombre es m�s largo junto con el nombre completo (Apellido, nombre) de los dos empleados cuyo apellido es m�s largo
-- No tan f�cil: Queremos saber cu�ndo se trata de un producto y de un empleado y el n�mero de letras
/* Salida similar a
+----------------------------------+---------------------------------------------+
| Nombre                           | Informaci�n                                 |
+----------------------------------+---------------------------------------------+
| Louisiana Fiery Hot Pepper Sauce | Es un producto y tiene 32 letras            |
| Jack's New England Clam Chowder  | Es un producto y tiene 31 letras            |
| Dodsworth, Anne                  | Es un empleado y su apellido tiene 9 letras |
| Leverling, Janet                 | Es un empleado y su apellido tiene 9 letras |
+----------------------------------+---------------------------------------------+*/

-- --------------------------------------------------------------------------------------
-- Consulta 53. Listado con los proveedores y clientes espa�ones 'Spain'. Indicar nombre de la empresa (NombreEmpresa), poblacion (Poblacion) y regi�n (Region)
/* Salida similar a
+-----------+--------------------------------------+-----------+----------+
| Tipo      | Empresa                              | Poblacion | Regi�n   |
+-----------+--------------------------------------+-----------+----------+
| proveedor | Cooperativa de Quesos 'Las Cabras'   | Oviedo    | Asturias |
| cliente   | Blido Comidas preparadas             | Madrid    | NULL     |
| cliente   | FISSA Fabrica Inter. Salchichas S.A. | Madrid    | NULL     |
...
+-----------+--------------------------------------+-----------+----------+
6 rows in set (0,00 sec)*/

-- --------------------------------------------------------------------------------------
-- Consulta 54. Listado con los proveedores y clientes espa�ones 'Spain'. Indicar nombre de la empresa (NombreEmpresa), poblacion (Poblacion) y regi�n (Region)
-- No tan f�cil: salida similar a (si la regi�n tiene valor NULL saldr� 'N/A') (2,25)
/* Salida similar a
+-----------+--------------------------------------+-----------+----------+
| Tipo      | Empresa                              | Poblacion | Regi�n   |
+-----------+--------------------------------------+-----------+----------+
| proveedor | Cooperativa de Quesos 'Las Cabras'   | Oviedo    | Asturias |
| cliente   | Blido Comidas preparadas             | Madrid    | N/A      |
| cliente   | FISSA Fabrica Inter. Salchichas S.A. | Madrid    | N/A      |
...
+-----------+--------------------------------------+-----------+----------+
6 rows in set (0,00 sec)*/
