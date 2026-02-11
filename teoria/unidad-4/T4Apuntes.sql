DROP PROCEDURE IF EXISTS P1;
DELIMITER //
CREATE PROCEDURE P1()
BEGIN
   SELECT 'Hola, mundo';
END// 
DELIMITER ;
CALL P1();


-- 1. Crea un procedimiento que nos de el nombre y la población de las diez ciudades más pobladas

DROP PROCEDURE IF EXISTS CiudadesMasPobladas;
DELIMITER //

//
CREATE PROCEDURE CiudadesMasPobladas()
BEGIN
	SELECT Nombre, Poblacion FROM Ciudad
	ORDER BY Poblacion DESC LIMIT 10;
END
//


DELIMITER ;
CALL CiudadesMasPobladas();

-- Realmete esto se haría así:
CREATE VIEW  CiudadesMasPobladas AS (
   SELECT Nombre, Poblacion FROM Ciudad
   ORDER BY Poblacion DESC LIMIT 10);

/*
Razones para usar procedimientos almacenados:
- Bases de datos más seguras (normalización)
- Se mejora el mantenimiento del software ya que ante actualizaciones no hay que cambiar el código de todos los clientes sino sólo el código del servidor.
- Reducen el tráfico de la red ya que el trabajo con los datos se realiza en el servidor

Razones para no usarlos:
- Aumenta la carga de trabajo del servidor */

-- -----------------------------------------------------------------
-- Variables
-- -----------------------------------------------------------------
/*
DECLARE var_name[,...] type [DEFAULT value] 
El valor por defecto para una variable es NULL

Podemos ver los tipos de datos permitidos en el manual de MySQL v5,0 castellano: Capítulo 11. Tipos de columna

SET var_name = expr [, var_name = expr] ... 

SELECT ValorEscalar[,...] INTO var_name[,...] FROM...

DECLARE puede usarse sólo dentro de comandos compuestos BEGIN ... END y deben ser su inicio, antes de cualquier otro comando.
*/

-- 2. Crea un procedimiento en el que asignemos variables de los tipos principales. Un tercio, más o menos, de las variables las iniciaremos en su creación, otro tercio con sentencias SET y el último tercio con sentencias SELECT INTO. Por último mostraremos en pantalla el valor de todas las variables. También dejaremos una variable sin inicializar y sin asignar. Tipos de datos: INT, VARCHAR(50), BOOLEAN, CHAR, FLOAT, DOUBLE, DATE, DATETIME, TIME, YEAR, TEXT, ENUM() y DECIMAL().
DROP PROCEDURE IF EXISTS VariablesYTipos;
DELIMITER //

//
CREATE PROCEDURE VariablesYTipos()
BEGIN
		DECLARE Var1  INT         			DEFAULT 10;
		DECLARE Var2  VARCHAR(50) 	DEFAULT 'Hola ola';
		DECLARE Var3  BOOLEAN     	DEFAULT TRUE;
		DECLARE Var4  CHAR        		DEFAULT 'A';
		DECLARE Var5  FLOAT;
		DECLARE Var6  DOUBLE;
		DECLARE Var7  DATE;
		DECLARE Var8  DATETIME;
		DECLARE Var9  TIME; 
		DECLARE Var10 YEAR;
		DECLARE Var11 TEXT;
		DECLARE Var12 ENUM('T','F');
		DECLARE Var13 DECIMAL(10,2);
		DECLARE Var14 INT;
        
        SET Var5  = 5.6;
		SET Var6  = 5.6;
		SET Var7 = CURDATE();
		SET Var8 = '2015-02-02 11:41:30';
		SET Var9 = '11:41:30';
		SELECT AnyIndep   INTO Var10
		FROM Pais WHERE Codigo='AGO'; -- YEAR sólo permite desde 1900 hasta 2155 Angola 1975
		SELECT 'Hola ola' INTO Var11;
		SELECT EsOficial  INTO Var12
		FROM LenguaPais
		WHERE codigoPais = 'ESP' AND Lengua = 'Spanish';
		SELECT PNB  INTO Var13
		FROM Pais
		WHERE codigo = 'ESP'; 

		SELECT Var1 AS  'Var1 -> INT',
		Var2 AS  'Var2 -> VARCHAR',
		Var3 AS  'Var3 -> BOOLEAN',
		Var4 AS  'Var4 -> CHAR';
		SELECT Var5 AS  'Var5 -> FLOAT',
		Var6 AS  'Var6 -> DOUBLE',
		Var7 AS  'Var7 -> DATE',
		Var8 AS  'Var8 -> DATETIME';
		SELECT Var9 AS  'Var9 -> TIME',
		Var10 AS 'Var10 -> YEAR',
		Var11 AS 'Var11 -> TEXT',
		Var12 AS 'Var12 -> ENUM',
		Var13 AS 'Var13 -> DECIMAL',
		Var14 AS 'Var14 -> INT sin valor';
END
//

DELIMITER ;
CALL VariablesYTipos();


-- -----------------------------------------------------------------
-- Variables de usuario
-- -----------------------------------------------------------------

-- Variables de usuario: empiezan por @. Solo duran la sesión
-- Resumen sobre las asignaciones de variables:
-- Forma de realizar asignaciones de variables en MySQL
-- Los ejemplos están hechos con variables de usuario, pero funcionan igual con variables declaradas en procedimientos

-- ORDEN SET
SET 	@a = 77;           -- Asiganción directa de una variable
SET 	@a = 77, @b = 22;    -- Asignación directa de dos variables
SET 	@a = (SELECT ROUND(EsperanzaVida) FROM Pais WHERE Codigo = 'ESP'), -- Asignación de dos variables con el resultado de dos SELECT
		@b = (SELECT AnyIndep            		 	FROM Pais WHERE Codigo='ESP');
SELECT @a, @b;

-- ORDEN SETECT Variable:=...
SELECT @a := ROUND(EsperanzaVida) FROM Pais WHERE Codigo='AND';     -- Asigna y muestra el valor de @a
SELECT @a := ROUND(EsperanzaVida),  @b := AnyIndep                    -- Igual, pero con dos variables
FROM   Pais WHERE Codigo = 'AND';
SELECT @a, @b;

-- ORDEN SELECT ... INTO
SELECT ROUND(EsperanzaVida) FROM Pais WHERE Codigo = 'AND' INTO @a; -- Sólo asigna el valor de @a, sin mostrar su valor
SELECT ROUND(EsperanzaVida),  AnyIndep INTO @a, @b                -- Igual, pero con dos variables
FROM   Pais WHERE Codigo = 'AND';
SELECT @a, @b;

-- -----------------------------------------------------------------
-- Parámetros
-- -----------------------------------------------------------------
/*
CREATE PROCEDURE sp_name ([parameter[,...]])
[characteristic ...] routine_body

parameter:
[ IN | OUT | INOUT ] param_name type

type:
Any valid MySQL data type

La lista de parámetros entre paréntesis debe estar siempre presente. Si no hay parámetros, se debe usar una lista de parámetros vacía () . Cada parámetro es un parámetro IN por defecto. Para especificar otro tipo de parámetro, use la palabra clave OUT o INOUT antes del nombre del parámetro. Especificando IN, OUT, o INOUT sólo es valido para un PROCEDURE.

Nosotros no omitiremos nunca el IN.
*/


-- 3. Crea un procedimiento que calcule las soluciones de una ecuación de segundo grado: ax^2+bx+c=0. Tenemos dos soluciones: x1=(-b+SQRT(b^2-4ac))/2a y x2=(-b-SQRT(b^2-4ac))/2a.
-- Procedimiento: Ecuacion2G. Parámetros A, B, C, X1, X2
DROP PROCEDURE IF EXISTS Ecuacion2G;

DELIMITER //

//
CREATE PROCEDURE Ecuacion2G(IN A DOUBLE, IN B DOUBLE, IN C DOUBLE,  OUT X1 DOUBLE, OUT X2 DOUBLE)
BEGIN
		SET X1 = (-B + SQRT(POW(B, 2) - 4 * A * C))  /  2 * A ;
        SET X2 = (-B  - SQRT(POW(B, 2) - 4 * A * C))  /  2 * A ;
END
//

DELIMITER ;

SET @A = 3, @B = 6, @C = 2;
CALL Ecuacion2G (@A, @B, @C, @X1, @X2);

SELECT 	CONCAT(@A, 'x^2 + ',  @B, ' x + ', @C, ' = 0') AS 'Ecuacion',
				@X1 AS 'Solucion 1', @X2 AS 'Solucion 2';


CALL 	Ecuacion2G (3, 6, 2, @X1, @X2);
SELECT 	@X1 AS 'Solucion 1', @X2 AS 'Solucion 2';

CALL 	Ecuacion2G (3, 6, 2, @Solucion1, @Solucion2);
SELECT 	@Solucion1 AS 'Solucion 1', @Solucion2 AS 'Solucion 2';

-- 4. Disparamos un proyectil con una velocidad inicial V0 y con un ángulo Z. Calcula la altura máxima (ymax) y el alcance (xmax): xmax= V0^2 * sen(2*Z) / g    ymax= V0^2 * sen^2(Z) / 2g; donde es g es la aceleración de la gravedad: 9,81 m/s²
-- Procedimiento: Balistica. Parámetros: V0, ZGrados, XMax, YMax
DROP PROCEDURE IF EXISTS Balistica;
DELIMITER //

//
CREATE PROCEDURE Balistica(IN V0 DOUBLE, IN ZGrados DOUBLE, OUT XMax DOUBLE, OUT YMax DOUBLE)
BEGIN
		DECLARE g DOUBLE DEFAULT 9.81; -- m/s^2
        
		SET YMax = POW(V0, 2) * SIN(POW(2, Z)) / g;
        SET XMax = POW(V0, 2) * SIN(POW(2, Z)) / 2 * g;
END
//

-- -----------------------------------------------------------------
-- Constructores de control de flujo: IF, CASE
-- -----------------------------------------------------------------

-- -----------------------------------------------------------------
-- IF
-- -----------------------------------------------------------------
/*
IF
IF search_condition THEN statement_list
[ELSEIF search_condition THEN statement_list] ...
[ELSE statement_list]
END IF;
La sintaxis de la función IF() difiere de la del comando IF descrita aquí.
Sintaxis de la funión IF(): IF(expr1,expr2,expr3)

Manual MySQL v8.0: 13.6.5.2 IF Statement
*/

-- 5. Crea un procedimiento que nos diga (mediante un SELECT) si el primer número que le pasamos como parámetro es mayor, menor o igual que el segundo (usa IF)
-- Procedimiento:  EsMayorMenorIgualIF, Parámetros: IntA, IntB


DROP PROCEDURE IF EXISTS EsMayorMenorIgualIF;
DELIMITER //

//
CREATE PROCEDURE EsMayorMenorIgualIF(IN IntA INT, IN IntB INT)
BEGIN
		IF IntA > IntB THEN SELECT CONCAT(IntA, " es mayor que ", IntB);
        ELSEIF IntA > IntB THEN SELECT CONCAT(IntA, " es menor que ", IntB);
        ELSEIF IntA = IntB THEN SELECT CONCAT(IntA, " es igual que ", IntB);
        ELSE THEN SELECT "Algun valor es nulo" AS Resultado;
        END IF;
END
//

DELIMITER ;

CALL EsMayorMenorIgualIF(5, 5);
CALL EsMayorMenorIgualIF(5, NULL);
CALL EsMayorMenorIgualIF(5, 6);
CALL EsMayorMenorIgualIF(6, 5);


