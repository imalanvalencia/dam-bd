-- --------------------------------------------------------------------------------------
-- Tema 4. Ejercicios de Programando con SQL. Soluciones
-- --------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- Ejercicio 1. Crea un programa almacenado que guarde en una tabla temporal la información del país más poblado, la ciudad más poblada y la lengua más hablada. Al final sacará la tabla por pantalla
/*Salida esperada:
MDB  > CALL Ejercicio1();
+-----------------+--------+
| Nombre          | Tipo   |
+-----------------+--------+
| China           | País   |
| Mumbai (Bombay) | Ciudad |
| Chinese         | Lengua |
+-----------------+--------+*/
CREATE TEMPORARY TABLE IF NOT EXISTS Informacion (
    Nombre VARCHAR(255),
    Tipo   VARCHAR(25)
) ENGINE=MEMORY;
INSERT INTO Informacion VALUES ('Spain', 'País');
SELECT * FROM InformacionSerie;
TRUNCATE TABLE InformacionSerie;
DROP TABLE IF EXISTS InformacionSerie;

-- --------------------------------------------------------------------------------------
-- Ejercicio 2. Vamos a hacer el mismo ejercicio anterior, pero ahora le pasaremos como parámetro el continente al que deben pertenecer el país, la ciudad y la lengua
/* Salida esperada:
MDB  > CALL Ejercicio2('South America');
+------------+--------+
| Nombre     | Tipo   |
+------------+--------+
| Brazil     | País   |
| São Paulo  | Ciudad |
| Portuguese | Lengua |
+------------+--------+*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 3. Crea un procedimiento al que le pasamos como parámetro un valor entre 2 y 9 creando la siguiente tabla. En el ejemplo se ha usado el valor 5 como parámetro
/* Salida esperada:
MDB  > CALL Ejercicio3(5);
+--------+
| Cadena |
+--------+
| *****  |
| *****  |
| *****  |
| *****  |
| *****  |
+--------+*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 4. Crea un procedimiento al que le pasamos como parámetro un valor entre 2 y 9 creando la siguiente tabla. En el ejemplo se ha usado el valor 5 como parámetro
/* Salida esperada:
MDB  > CALL Ejercicio4(5);
+--------+
| Cadena |
+--------+
| 12345  |
| 2345   |
| 345    |
| 45     |
| 5      |
+--------+*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 5. Crea un procedimiento al que le pasamos como parámetro un valor entre 2 y 9 creando la siguiente tabla. En el ejemplo se ha usado el valor 5 como parámetro
/* Salida esperada:
MDB  > CALL Ejercicio5(5);
+---------+
| Cadena  |
+---------+
| ******* |
| *1    * |
| *12   * |
| *123  * |
| *1234 * |
| *12345* |
| ******* |
+---------+
IMPORTANTE: Seguramente en WorkBench verás algo similar a:
*******
*1 *
*12 *
*123 *
*1234*
*12345*
Se debe a que WorkBench usa una funete de "espaciado proporcional' lo que significa que el carácter espacio es menos ancho (ocupa menos) que otros caracteres
Para comprobar que tu consulta sale bien puedes hacer dos cosas:
1. Hacer el CALL Ejercicio5(5) desde el intérprete de comandos
2. Cambiar la fuente a una monoespaciado en el menú Edit > preferences > Fonts & Colors > Resultset Grid: Consolas 10
*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 6. Crea un procedimiento al que le pasamos como parámetro un valor mínimo y otro máximo como parámetros y guardará en una tabla todos los caracteres ASCCII comprendidos entre los dos valores que le hemos pasado
/* Salida esperada:
MDB  > CALL Ejercicio6(32, 126);
+------------+----------+
| ValorASCII | Caracter |
+------------+----------+
|         32 |          |
|         33 | !        |
|         34 | "        |
...
|         47 | /        |
|         48 | 0        |
|         49 | 1        |
...
|         64 | @        |
|         65 | A        |
...
|         96 | `        |
|         97 | a        |
|         98 | b        |
...
|        125 | }        |
|        126 | ~        |
+------------+----------+
Nota: dependiendo de la fuente, la colación y otros parámetros, la salida puede variar. Valores menores que 32 son caracteres ASCII de control. Valores > 126 pueden no imprimirse correctamente en pantalla.
*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 7. En el Tema 3 realizamos la siguiente consulta: 2. Nombre de los países que tienen dos o más ciudades con dos millones de habitantes como mínimo. Parametriza la consulta para que podamos cambiar tanto el número de ciudades como el número de habitantes. Chequea errores en los parámetros y muestra mensajes descritivos. 

-- --------------------------------------------------------------------------------------
-- Ejercicio 8. En el Tema 3 realizamos la siguiente consulta: Listado de los países y el número de ciudades de ese país para los países que tienen más ciudades que España. Parametriza la consulta para que podamos cambiar el país. Chequea errores en el parámetro y muestra mensajes descritivos. 

-- --------------------------------------------------------------------------------------
-- Ejercicio 9. Crea una función que nos indique el número de palabras de una cadena. Para ello recorreremos la cadena de entrada. Entendemos como palabra cualquier secuencia segida de letras, letras acentuadas y dígitos; cualquier otra secuencia de uno o más carácteres es un separador: espacio, coma, punto, etc.

-- --------------------------------------------------------------------------------------
-- Ejercicio 10. Crea una función que nos indique si la cadena introducida es palíndromo. Entendemos como palíndromos:  radar, reconocer, rotor, salas, seres, etc.

-- --------------------------------------------------------------------------------------
-- Ejercicio 11. Crea una función que nos indique si la cadena introducida es palíndromo. Entendemos como palíndromos:  radar, reconocer, rotor, salas, seres, etc. USA un bucle y la funión SUBSTR() para comprobar el carácter de una posición concreta en la cadena.

-- --------------------------------------------------------------------------------------
-- Ejercicio 12. Crea una función que nos indique si la cadena introducida es palíndromo sin tener en cuenta los espacios en blanco y signos de puntuación. En este caso serían palíndromos: "Añora la Roña", "La ruta, natural", etc.

-- --------------------------------------------------------------------------------------
-- Ejercicio 13. Crea una fución que nos indique si el número que le pasamos como parámetro es primo. un número primo es un número natural mayor que 1 que tiene únicamente dos divisores distintos: él mismo y el 1. 

-- --------------------------------------------------------------------------------------
-- Ejercicio 14. Crea un procedimiento que de un listado de ciudades ordenado por poblacion ascendente, nos de la ciudades que ocupan las posiciones 1, 10, 20, 30 ,..., 980, 990, 1000 (acabará aquí). Usa un cursor.

-- --------------------------------------------------------------------------------------
-- Ejercicio 15. Crea un procedimiento que de un listado de países ordenado por fecha de independencia de manera que para cada país muestre el incremento o decremento del PNB entre ese país y el país anterior de la lista. Para el primer país y cuando uno de los PNB sea nulo, mostrará n/a.

-- --------------------------------------------------------------------------------------
-- Ejercicio 16. Vamos a añadir un campo a la tabla país que indique la suma de la población de sus ciudades, actualizaremos este campo con los valores reales, añadiremos también los diparadores necesarios para mantener este nuevo campo actualizado antes modificaciones de la tabla de ciudades e incluiremos el código necesario para probarlo todo.

-- --------------------------------------------------------------------------------------
-- Ejercicio 17. Queremos realizar una auditoría sobre los cambios realizados en el código y el nombre de los países. Incluye el código que crea la tabla, los disparadores y las pruebas realizadas para ver que todo va bien.

-- --------------------------------------------------------------------------------------
-- Ejercicio 18. De un listado de ciudades ordenado alfabéticamente y, si dos ciudades tienen el mismo nombre, ordenado por población; necesitamos saber cuántos grupos hay en los que cuatro o más ciudades pertenecen al mismo país.

-- --------------------------------------------------------------------------------------
-- Ejercicio 19.  Parametrizar el procedimiento anterior para que le podamos indicar el número máximo de repeticiones

-- --------------------------------------------------------------------------------------
-- Ejercicio 20. Crea una tabla temporal donde se guardarán los datos de las repeticiones. Esta tabla será el resultado que devolverá el procedimiento

CREATE TEMPORARY TABLE CiudadPais (
  `Codigo` char(3) NOT NULL DEFAULT '',
  `Nombre` char(52) NOT NULL DEFAULT '',
) ENGINE=MEMORY;
  
INSERT INTO CiudadPais VALUES ('XXX','País de prueba');
DROP TABLE CiudadPais;

-- --------------------------------------------------------------------------------------
-- Ejercicio 21. Modificar el procedimiento anterior para comprobar que el número de repeticiones sea mayor o igual que dos. Si no lo es se mostrará un error descriptivo.

-- --------------------------------------------------------------------------------------
-- Ejercicio 22. Calcula la suma de todos los dígitos de todos los número presentes en una base de datos de números enteros positivos. Para probar el algoritmo llenaremos la BD con números enteros aleatorios positivos. Por ejemplo, si la base de datos contiene los número 12, 33 y 67 el resultado será 1+2 + 3+3 + 6+7= 22.

-- --------------------------------------------------------------------------------------
-- Ejercicio 23. Dada una BD de palabras, realiza un procedimiento que guarde en otra tabla con las letras del abecedario el número de apariciones de cada letra. Todas las letras se pasarán a minúsculas. No se tendrán en cuenta los caracteres que aparezcan en las palabras pero que no estén en la tabla Letras.
-- Código que se da a los alumnos

-- Enlaces a las fuentes utilizadas para los ejercicios numéricos:
-- Matemática recreativa: https://es.wikipedia.org/wiki/Categor%C3%ADa:Matem%C3%A1tica_recreativa
-- Tipos de números: https://www.gaussianos.com/tipos-de-numeros/
-- The On-Line Encyclopedia of Integer Sequences. Lucky numbers
-- http://oeis.org/A000959
-- Proyecto Euler. Muy interesante para problemas matemáticos: https://projecteuler.net/about cuenta creada con leonomis

-- --------------------------------------------------------------------------------------
-- Ejercicio 24. Crea subprograma (procedimiento o función alamacenados) que nos indique si un número es perfecto:
/*
Número perfecto: todo número natural que es igual a la suma de sus divisores propios (es decir, todos sus divisores excepto el propio número). Por ejemplo, 6 es un número perfecto ya que sus divisores propios son 1, 2, y 3 y se cumple que 1+2+3=6. Los números 28, 496 y 8128 también son perfectos.
*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 25. Crea un subprograma que nos saque por pantalla los números perfectos comprendidos entre un rango de números que le pasaremos como parámetro

-- --------------------------------------------------------------------------------------
-- Ejercicio 26. Crea un subprograma que alamacene en una tabla los números perfectos comprendidos entre un rango de números que le pasaremos como parámetro

-- --------------------------------------------------------------------------------------
-- Ejercicio 27.  Crea subprograma que nos indique si un número es abundante:
/*
Número abundante: todo número natural que cumple que la suma de sus divisores propios es mayor que el propio número. Por ejemplo, 12 es abundante ya que sus divisores son 1, 2, 3, 4 y 6 y se cumple que 1+2+3+4+6=16, que es mayor que el propio 12.
*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 28. Crea un subprograma que nos saque por pantalla los números abundantes comprendidos entre un rango de números que le pasaremos como parámetro

-- --------------------------------------------------------------------------------------
-- Ejercicio 29. Crea un subprograma que alamacene en una tabla los números abundantes comprendidos entre un rango de números que le pasaremos como parámetro

-- --------------------------------------------------------------------------------------
-- Ejercicio 30. Crea un subprograma que alamacene en una tabla los números deficientes comprendidos entre un rango de números que le pasaremos como parámetro
/*
Número deficiente: todo número natural que cumple que la suma de sus divisores propios es menor que el propio número. Por ejemplo, 16 es un número deficiente ya que sus divisores propios son 1, 2, 4 y 8 y se cumple que 1+2+4+8=15, que es menor que 16.
*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 31. Crea subprograma que nos indique si un número es apocalíptico:
/*
Número apocalíptico: todo número natural n que cumple que 2^n contiene la secuencia 666. Por ejemplo, los números 157 y 192 son números apocalípticos.  Nota: el número 2^192 es tan grande que aunque es apocalíptico, MySQL dice que no lo es, incluso aunque se declaren las variables como DECIMAL(65)
*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 32. Crea un subprograma que nos saque por pantalla los números apocalípticos comprendidos entre un rango de números que le pasaremos como parámetro

-- --------------------------------------------------------------------------------------
-- Ejercicio 33. Crea un subprograma que alamacene en una tabla los números apocalípticos comprendidos entre un rango de números que le pasaremos como parámetro

-- --------------------------------------------------------------------------------------
-- Ejercicio 34. Crea un subprograma que alamacene en una tabla todos los números entre un rango de números que le pasaremos como parámetro y que indicará en la misma tabla si cada número es feliz o infeliz:
/*
Número feliz: todo número natural que cumple que si sumamos los cuadrados de sus dígitos y seguimos el proceso con los resultados obtenidos el resultado es 1. Por ejemplo, el número 203 es un número feliz ya que 2^2+0^2+3^2=13; 1^2+3^2=10; 1^2+0^2=1.
Número infeliz: todo número natural que no es un número feliz. Por ejemplo, el número 16 es un número infeliz.
*/

-- --------------------------------------------------------------------------------------
-- Ejercicio 35. Crea un subprograma que alamacene en una tabla todos los números afortunados comprendidos entre uno y un números que le pasaremos como parámetro.
/*
Número afortunado: Tomemos la secuencia de todos los naturales a partir del 1: 1, 2, 3, 4, 5,… Tachemos los que aparecen en las posiciones pares. Queda: 1, 3, 5, 7, 9, 11, 13,… Como el segundo número que ha quedado es el 3 tachemos todos los que aparecen en las posiciones múltiplo de 3 empezando desde la posición 1. Queda: 1, 3, 7, 9, 13,… Como el siguiente número que quedó es el 7 tachamos ahora todos los que aparecen en las posiciones múltiplos de 7. Así sucesivamente. Los números que sobreviven se denominan números afortunados.
*/

-- The On-Line Encyclopedia of Integer Sequences. Lucky numbers
-- http://oeis.org/A000959
