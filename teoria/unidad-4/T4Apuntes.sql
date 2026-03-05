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
		IF IntA > IntB THEN SELECT CONCAT(IntA, " es mayor que ", IntB) AS Resultado;
        ELSEIF IntA < IntB THEN SELECT CONCAT(IntA, " es menor que ", IntB) AS Resultado;
        ELSEIF IntA = IntB THEN SELECT CONCAT(IntA, " es igual que ", IntB) AS Resultado;
        ELSE SELECT "Algun valor es nulo" AS Resultado;
        END IF;
END
//

DELIMITER ;

CALL EsMayorMenorIgualIF(5, 5);
CALL EsMayorMenorIgualIF(5, NULL);
CALL EsMayorMenorIgualIF(5, 6);
CALL EsMayorMenorIgualIF(6, 5);

-- Otras formas de hacerlo
DROP PROCEDURE IF EXISTS EsMayorMenorIgualIF;
DELIMITER //
CREATE PROCEDURE EsMayorMenorIgualIF (IN IntA INT, IN IntB INT)
BEGIN
   IF IntA > IntB
       THEN SELECT CONCAT(IntA, ' es mayor que ', IntB) AS 'Resultado';
       ELSE
          IF IntA < IntB
              THEN SELECT CONCAT(IntA, ' es menor que ', IntB) AS Resultado;
              ELSE
                  IF IntA = IntB
                      THEN SELECT CONCAT(IntA, ' es igual a ',   IntB) AS Resultado;
                      ELSE SELECT ('Algún valor es nulo') AS Resultado;
                  END IF;
          END IF;
   END IF;
END// 
DELIMITER ;

DROP PROCEDURE IF EXISTS EsMayorMenorIgualIF;
DELIMITER //
CREATE PROCEDURE EsMayorMenorIgualIF (IN IntA INT, IN IntB INT)
BEGIN
   IF IntA > IntB THEN SELECT CONCAT(IntA, ' es mayor que ', IntB) AS 'Resultado';
       ELSE IF IntA < IntB THEN SELECT CONCAT(IntA, ' es menor que ', IntB) AS Resultado;
       ELSE IF IntA = IntB THEN SELECT CONCAT(IntA, ' es igual a ',   IntB) AS Resultado;
       ELSE SELECT ('Algún valor es nulo') AS Resultado;
   END IF; END IF; END IF; /* cuidado else if estan separados los cuentas como if independientes y hay que cerrarlos */
END// 
DELIMITER ;


-- -----------------------------------------------------------------
-- CASE
-- -----------------------------------------------------------------
/*
CASE
Tiene dos sintaxis:
CASE case_value
WHEN when_value THEN statement_list
[WHEN when_value THEN statement_list] ...
[ELSE statement_list]
END CASE;

CASE
WHEN search_condition THEN statement_list
[WHEN search_condition THEN statement_list] ...
[ELSE statement_list]
END CASE;

La sintaxis de la expresión CASE es distinta de la del comando CASE aquí descrito
Sintaxix de CASE:
CASE value WHEN [compare-value] THEN result [WHEN [compare-value] THEN result ...] [ELSE result] END 
CASE WHEN [condition] THEN result [WHEN [condition] THEN result ...] [ELSE result] END

Manual MySQL v8.0: 13.6.5.1 CASE Statement
*/

-- 6. Crea un procedimiento que nos diga si el primer número que le pasamos como parámetro es mayor, menor o igual que el segundo (usa CASE)
-- Procedimiento:  EsMayorMenorIgualCASE, Parámetros: IntA, IntB
DROP PROCEDURE IF EXISTS EsMayorMenorIgualCASE;
DELIMITER //

//
CREATE PROCEDURE EsMayorMenorIgualCASE(IN IntA INT, IN IntB INT)
BEGIN
		CASE 
		WHEN IntA > IntB THEN SELECT CONCAT(IntA, " es mayor que ", IntB) AS Resultado;
        WHEN IntA < IntB THEN SELECT CONCAT(IntA, " es menor que ", IntB) AS Resultado;
        WHEN IntA = IntB THEN SELECT CONCAT(IntA, " es igual que ", IntB) AS Resultado;
        ELSE SELECT "Algun valor es nulo" AS Resultado;
        END CASE;
END
//

DELIMITER ;

CALL EsMayorMenorIgualIF(5, 5);
CALL EsMayorMenorIgualIF(5, NULL);
CALL EsMayorMenorIgualIF(5, 6);
CALL EsMayorMenorIgualIF(6, 5);

-- Usaremos IF para una o dos opciones. Usaremos CASE para más de dos opciones

-- Diferencia entre los dos tipos de CASE
DROP PROCEDURE IF EXISTS EscribeEsOficial1;
DELIMITER //
CREATE PROCEDURE EscribeEsOficial1 (IN EsOficial ENUM('T','F'))
BEGIN
   CASE EsOficial
      WHEN 'T' THEN SELECT 'Es oficial';
      WHEN 'F' THEN SELECT 'No es oficial';
      ELSE SELECT 'Es nulo';
   END CASE;
END// 
DELIMITER ;

DROP PROCEDURE IF EXISTS EscribeEsOficial2;
DELIMITER //
CREATE PROCEDURE EscribeEsOficial2 (IN EsOficial ENUM('T','F'))
BEGIN
   CASE
      WHEN EsOficial = 'T' THEN SELECT 'Es oficial';
      WHEN EsOficial = 'F' THEN SELECT 'No es oficial';
      ELSE SELECT 'Es nulo';
   END CASE;
END// 
DELIMITER ;

CALL EscribeEsOficial1((SELECT EsOficial FROM LenguaPais WHERE CodigoPais='ESP' AND Lengua='Spanish'));
CALL EscribeEsOficial2((SELECT EsOficial FROM LenguaPais WHERE CodigoPais='ESP' AND Lengua='Spanish'));

-- -----------------------------------------------------------------
-- LOOP, LEAVE, ITERATE, REPEAT … UNTIL, WHILE
-- -----------------------------------------------------------------
/*
LOOP
[begin_label:] LOOP
statement_list
END LOOP [end_label];

LEAVE
LEAVE label
Abandona el BEGIN...END o bucle en el que está. (Tambien procedimientos )

ITERATE
ITERATE label
Sólo para comandos LOOP, REPEAT, y WHILE . Significa: vuelve a hacer el bucle.

En los bucles LOOP la etiqueta es obligatoria */

-- 7. Crea un procedimiento que diga “Hola ola” tantas veces como el número que le pasaremos como parámetro (usa un bucle LOOP)

-- Nota: en todos los bucles controlaremos que no haya errores de +-1 en el número de veces que se ejecuta y controlaremos que no se ejecute ninguna vez o que de un error si el parámetro es nulo o negativo.
-- Procedimiento:  HolaOlaLOOP, Parámetros: Numero

DROP PROCEDURE IF EXISTS HolaOlaLOOP;
DELIMITER //

//
CREATE PROCEDURE HolaOlaLOOP (IN Numero INT)
BEGIN   
	DECLARE Contador INT DEFAULT 0;

	Bucle: LOOP
	   IF Contador >= Numero OR Numero IS NULL THEN LEAVE Bucle; END IF;
	   SELECT "Hola ola" AS "Resultado";
       SET Contador = Contador + 1;
   END LOOP Bucle;
END
// 

DELIMITER ;

CALL HolaOlaLOOP(1);


-- -----------------------------------------------------------------
-- REPEAT … UNTIL
-- -----------------------------------------------------------------
/*
[begin_label:] REPEAT
statement_list
UNTIL search_condition
END REPEAT [end_label];
 Sin etiquetas poruqe no usaremos nunca la instruccion leave
*/

-- 8. Crea un procedimiento que diga “Hola ola” tantas veces como el número que le pasaremos como parámetro (usa un bucle REPEAT UNTIL)
DROP PROCEDURE IF EXISTS HolaOlaREAPEAT;
DELIMITER //

//
CREATE PROCEDURE HolaOlaREAPEAT (IN Numero INT)
BEGIN   
	DECLARE Contador INT DEFAULT 0;

	REPEAT
	   SELECT "Hola ola" AS "Resultado";
       SET Contador = Contador + 1;
   UNTIL  Contador >= Numero OR Numero IS NULL 
   END REPEAT;

END
// 

DELIMITER ;

CALL HolaOlaREAPEAT(-1);

-- Procedimiento:  HolaOlaREPEAT, Parámetros: Numero
-- Para evitar que el mínimo sea 1:
DROP PROCEDURE IF EXISTS HolaOlaREPEAT;
DELIMITER //
CREATE PROCEDURE HolaOlaREPEAT(IN Numero INT)
BEGIN
   DECLARE Contador INT DEFAULT 0;

   bucle: REPEAT
      IF Numero<=0 OR Numero IS NULL THEN LEAVE bucle; END IF;
      SELECT 'Hola ola' AS 'Resultado';
      SET Contador= Contador + 1;
   UNTIL Contador>=Numero END REPEAT bucle;
END// 
DELIMITER ;

/*
Etiquetas en procedimientos:
[begin_label:] BEGIN
[statement_list]
END [end_label] */

-- También podemos poner etiquetas al BEGIN ... END
DROP PROCEDURE IF EXISTS HolaOlaREPEAT;
DELIMITER //
CREATE PROCEDURE HolaOlaREPEAT (IN Numero INT)
HolaOlaREPEAT: BEGIN
    DECLARE Contador INT DEFAULT 0;

    IF Numero<=0 OR Numero IS NULL THEN LEAVE HolaOlaREPEAT; END IF;
    REPEAT
       SELECT 'Hola ola' AS 'Resultado';
       SET Contador= Contador+1;
    UNTIL Contador>=Numero END REPEAT;
END HolaOlaREPEAT// 
DELIMITER ;



-- -----------------------------------------------------------------
-- WHILE
-- -----------------------------------------------------------------
/*
[begin_label:] WHILE search_condition DO
statement_list
END WHILE [end_label];
*/

-- 9. Crea un procedimiento que diga “Hola ola” tantas veces como el número que le pasaremos como parámetro (usa un bulce WHILE)
-- Procedimiento:  HolaOlaWHILE, Parámetros: Numero

DROP PROCEDURE IF EXISTS HolaOlaWHILE;
DELIMITER //

//
CREATE PROCEDURE HolaOlaWHILE (IN Numero INT)
BEGIN   
	DECLARE Contador INT DEFAULT 0;

	WHILE Contador < Numero
    DO
	   SELECT "Hola ola" AS "Resultado";
       SET Contador = Contador + 1;
   END WHILE;

END
// 

DELIMITER ;

CALL HolaOlaWHILE(-1);

/*
Hemos visto: Variables en métodos y de usuario. IF, CASE, LOOP, WHILE DO, REPEAT...UNTIL, ITERATE, y LEAVE
Pueden contener un comando simple, o un bloque de comandos. Se pueden anidar. Los bucles FOR no están soportados.
*/

-- 10. Crea una consulta que muestre el nombre de los países que se han independizado entre dos años concretos (incluidos esos dos años). Crea un procedimiento que parametrice la consulta. Modifica el procedimiento para que de igual el orden en el que ponemos los años.
-- Consulta inicial:
SELECT Nombre AS 'País', AnyIndep AS 'Año de independencia'
FROM   Pais
WHERE  AnyIndep BETWEEN 300 AND 1970
ORDER BY AnyIndep;

-- Parametrizamos la consulta:
SET @AnyA= 300, @AnyB=1970;
SELECT Nombre AS 'País', AnyIndep AS 'Año de independencia'
FROM   Pais
WHERE  AnyIndep BETWEEN @AnyA AND @AnyB
ORDER BY AnyIndep;

-- Procedimieto:  PaisesIndependizadosEntreDosFechas. Parámetros: AnyA, AnyB
DROP PROCEDURE IF EXISTS PaisesIndependizadosEntreDosFechas;
DELIMITER //

//
CREATE PROCEDURE PaisesIndependizadosEntreDosFechas (IN AnyA INT, IN AnyB INT)
BEGIN   
	/*
    DECLARE AnyMin INT;
    DECLARE AnyMax INT;
    
    
    No funciona porque min y max usan filas no variables
	SET AnyMin =  MIN(AnyA, AnyB);
    SET AnyMax = MAX(AnyA, AnyB);
	*/
    DECLARE Imp INT;
    
    IF AnyA > AnyB THEN
		SET Imp = AnyA;
        SET AnyA = AnyB;
        SET AnyB = Imp;
	END IF;
    
	SELECT Nombre AS 'País', AnyIndep AS 'Año de independencia'
	FROM   Pais
	WHERE  AnyIndep BETWEEN AnyA AND AnyB
	ORDER BY AnyIndep;
END
// 

DELIMITER ;

CALL PaisesIndependizadosEntreDosFechas(300, 1970);


-- 11. Crea un procedimiento llamado OrdenaInt al que le pasamos dos números enteros y que nos deja el menor en el primer parámetro y el mayor en el segundo. Simplifica el procedimiento de la consulta anterior.
-- Procedimiento: OrdenaInt. Parámetros: IntA, IntB

DROP PROCEDURE IF EXISTS OrdenaInt;
DELIMITER //

//
CREATE PROCEDURE OrdenaInt (INOUT IntA INT, INOUT IntB INT)
BEGIN   
    DECLARE Imp INT;
    
    IF IntA > IntB THEN
		SET Imp = IntA;
        SET IntA = IntB;
        SET IntB = Imp;
	END IF;
    
END
// 

DELIMITER ;


SET @AnyA = 1970,  @AnyB = 300;
CALL OrdenaInt(@AnyA, @AnyB);
SELECT @AnyA, @AnyB;

-- 
DROP PROCEDURE IF EXISTS PaisesIndependizadosEntreDosFechas;
DELIMITER //

//
CREATE PROCEDURE PaisesIndependizadosEntreDosFechas (IN AnyA INT, IN AnyB INT)
BEGIN   
    DECLARE Imp INT;
    
	CALL OrdenaInt(AnyA, AnyB);
    
	SELECT Nombre AS 'País', AnyIndep AS 'Año de independencia'
	FROM   Pais
	WHERE  AnyIndep BETWEEN AnyA AND AnyB
	ORDER BY AnyIndep;
END
// 

DELIMITER ;

CALL PaisesIndependizadosEntreDosFechas(300, 1970);
CALL PaisesIndependizadosEntreDosFechas(1970, 300);


-- -- -----------------------------------------------------------------
-- Parametrizando consultas
-- -----------------------------------------------------------------

-- 12. En el Tema 2 realizamos la siguiente consulta. Parametriza la consulta para que acepte cualquier nombre de ciudad y comprueba que la ciudad existe y que sólo hay una ciudad con ese nombre. Muestra errores descriptivos
-- Listado de las ciudades que tienen la misma población que la ciudad El Limón. Quita del resultado la población de El Limón, que ya sabemos que tiene los mismos habitantes que El Limón.

SELECT Nombre AS 'Ciudades que tienen la misma población que la ciudad El Limón'
FROM   Ciudad
WHERE  Nombre <> 'El Limón' AND
       Poblacion = (SELECT Poblacion
                    FROM   Ciudad
                    WHERE  Nombre = 'El Limón'
                    LIMIT 1);

-- Prueba para comprobar que sólo hay una ciudad 'El Limón'. Cuidado que hacemos COUNT(*) =  0
-- mejor un EXISTS
-- Debe dar 1 para poder ejecutar la consulta anterior
SELECT COUNT(*)
FROM   Ciudad
WHERE  Nombre = 'El Limón';

-- Procedimiento:  CiudadesConIgualPoblacion. Parámetro: CiudadParam
DROP PROCEDURE IF EXISTS CiudadesConIgualPoblacion;
DELIMITER //

//
CREATE PROCEDURE CiudadesConIgualPoblacion (IN CiudadParam CHAR(35))
BEGIN   
    DECLARE NumCiudades INT;
    
    SET NumCiudades = (SELECT COUNT(*) FROM   Ciudad WHERE  Nombre = CiudadParam);
    
    CASE NumCiudades
		WHEN (NumCiudades) = 0 THEN SELECT CONCAT("No existe la ciudad", CiudadParam) AS "ERROR";
		WHEN (NumCiudades) > 1 THEN SELECT CONCAT("Existe mas de una ciudad con el mismo nombre, ", CiudadParam) AS "ERROR";
		ELSE 
				SELECT 	Nombre AS "Ciudades que tienen la misma población que la ciudad "
				FROM   	Ciudad
				WHERE  	Nombre <> CiudadParam 
								AND 	Poblacion = (
												SELECT Poblacion
												FROM   Ciudad
												WHERE  Nombre = CiudadParam
												LIMIT 1
											);
    END CASE;
END
// 

DELIMITER ;

CALL CiudadesConIgualPoblacion("El Limón");


-- -----------------------------------------------------------------
-- La sintaxis completa de procedimientos y funciones
-- -----------------------------------------------------------------
/*
Procedimientos
CREATE PROCEDURE sp_name ([parameter[,...]])
[characteristic ...] routine_body
Funciones
CREATE FUNCTION sp_name ([parameter[,...]])
RETURNS type
[characteristic ...] routine_body

parameter: [ IN | OUT | INOUT ] param_name type
type: Any valid MySQL data type
characteristic:
LANGUAGE SQL
| [NOT] DETERMINISTIC
| { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
| SQL SECURITY { DEFINER | INVOKER }
| COMMENT 'string'
routine_body: procedimientos almacenados o comandos SQL válidos

Las funciones sólo aceptan cero o más parámetros de entrada (IN) y no se pueden declarar de tipo OUT o INOUT. De echo, en funciones no podemos poner ni IN, ni OUT, ni INOUT. Usaremos una o más sentencias RETURN Valor para el valor que devuelve una función.*/

-- 13. Crea las funciones: ElMenorDeDos y ElMayorDeDos. Ambas funciones tienen dos parámetros de entrada de tipo entero. Una nos devolverá el menor de los dos valores que se le pasan y la otra el mayor. Si los valores son iguales, ambas funciones devolverán el valor que se le ha pasado
DROP FUNCTION IF EXISTS ElMenorDeDos;
DELIMITER //

//
CREATE FUNCTION ElMenorDeDos (Num1 INT, Num2 INT) RETURNS INT
BEGIN   
	IF Num1 IS NULL OR Num2 IS NULL THEN RETURN NULL; END IF;
    IF Num1 <= Num2 
		THEN RETURN Num1;
		ELSE RETURN Num2;
    END IF;
END
// 

DELIMITER ;

DROP FUNCTION IF EXISTS ElMayorDeDos;
DELIMITER //

//
CREATE FUNCTION ElMayorDeDos (Num1 INT, Num2 INT) RETURNS INT
BEGIN   
	IF Num1 IS NULL OR Num2 IS NULL THEN RETURN NULL; END IF;
    IF Num1 >= Num2 
		THEN RETURN Num1;
		ELSE RETURN Num2;
    END IF;
END
// 

DELIMITER ;

/*
CALL ElMayorDeDos(1, 2);  --> ESTO NO SE PUEDE HACER PORQUE EN MYSQL LAS FUNCIONES TIENEN QUE USARSE O GUARDARSE EN ALGUN LADO (Aunque hay ordenes donde no funciona por ejemplo en un LIMIT)
*/

SELECT ElMayorDeDos(1, 2), ElMayorDeDos(NULL, 2), ElMayorDeDos(1, NULL), ElMayorDeDos(NULL, NULL);
SELECT ElMenorDeDos(ROUND(PI()*2), ROUND(RAND()*10))+SIN(PI());
SELECT ElMayorDeDos(ROUND(PI()*2), ROUND(RAND()*10))+SIN(PI());


-- 14. Dado el siguiente procedimiento que devuelve la lista de países que están entre dos valores del PNB que se le pasan como parámetro. Si el primer valor es mayor que el segundo, el procedimiento no devuelve nada. Siguiendo el siguiente esquema: SET @A= Un_número_entero, @B= Otro_número_entero; CALL PaisesEntreDosPNB (…) y las funciones definidas anteriormente, realiza una llamada al procedimiento de manera que @A pueda ser mayor que @B.
DROP PROCEDURE IF EXISTS PaisesEntreDosPNB;
DELIMITER //
CREATE PROCEDURE PaisesEntreDosPNB (IN PNBA FLOAT(10,2), IN PNBB FLOAT(10,2))
BEGIN
   SELECT Nombre AS 'País', PNB
   FROM   Pais
   WHERE  PNB BETWEEN PNBA AND PNBB
   ORDER BY 2;
END// 
DELIMITER ;

CALL PaisesEntreDosPNB (1000,1200);
CALL PaisesEntreDosPNB (1200,1000);

-- Se usa FLOAT(10,2) porque es el tipo de datos con el que se define PNB en mundo.sql

SET @A=1000, @B=1200;
CALL PaisesEntreDosPNB(ElMenorDeDos(@A, @B), ElMayorDeDos(@A, @B));

-- Diferencias entre procedimientos y funciones:
-- Procedimiento
DROP PROCEDURE IF EXISTS PruebaProc;
DELIMITER //
CREATE PROCEDURE PruebaProc (OUT X INT)
BEGIN
   SET X= SIN(PI()*RAND());
END// 
DELIMITER ;

CALL PruebaProc(@A);
SELECT @A*2 AS 'Resultado';

-- Función:
DROP FUNCTION IF EXISTS PruebaFunc;
DELIMITER //
CREATE FUNCTION PruebaFunc ()
   RETURNS INT
BEGIN
   RETURN SIN(PI()*RAND());
END// 
DELIMITER ;

SELECT PruebaFunc()*2 AS Resultado;

-- 15. Crea la función Factorial que nos devuelve el factorial de un número
/*
El factorial de un entero positivo n, se define como el producto de todos los números enteros positivos desde 1  hasta n. Por ejemplo, 5! = 1 x 2 x 3 x 4 x 5 = 120

La operación de factorial aparece en muchas áreas de las matemáticas, particularmente en combinatoria y análisis matemático. De manera fundamental, el factorial de n representa el número de formas distintas de ordenar n objetos distintos (elementos sin repetición).

Definición: La función factorial es formalmente definida mediante el producto
n! = 1 x 2 x 3 x 4 x ... x (n-1) x n
Todas las definiciones anteriores incorporan la premisa de que
0! = 1

La función factorial es fácilmente implementable en distintos lenguajes de programación. Se pueden elegir dos métodos, el iterativo, es decir, realiza un bucle en el que se multiplica una variable temporal por cada número natural entre 1 y n, o el recursivo, por el cual la función factorial se llama a sí misma con un argumento cada vez menor hasta llegar al caso base 0!=1*/
-- Función: Factorial. Parámetros: IntA

DROP FUNCTION IF EXISTS Factorial;
DELIMITER //

//
CREATE FUNCTION Factorial (IntA INT)
   RETURNS DECIMAL(65)
BEGIN
	DECLARE Contador INT DEFAULT 1;
    DECLARE Resultado DECIMAL(65) DEFAULT 1;
    
    IF IntA < 0 OR IntA IS NULL OR IntA > 50 THEN RETURN NULL; END IF;
   
   WHILE  IntA >= Contador  DO
	SET Resultado = Resultado * Contador;
	SET Contador = Contador + 1;
   END WHILE;

   RETURN Resultado;
END
// 

DELIMITER ;

SELECT Factorial(51) AS Resultado;

-- 16. Crea una base de datos de factoriales de un número
-- La base de datos:
DROP DATABASE IF EXISTS FactorialesDB;
CREATE DATABASE IF NOT EXISTS FactorialesDB;
USE FactorialesDB;

DROP TABLE IF EXISTS `Factoriales`;
CREATE TABLE `Factoriales` (
    `Numero`    INTEGER NOT NULL,
    `Factorial` DECIMAL(65),
    PRIMARY KEY (`Numero`)
);

-- Órdenes para gestionar la BD:
INSERT INTO Factoriales VALUES(5, 120);
TRUNCATE TABLE Factoriales;
CALL LlenaFactoriales(50);              -- Este es el procedimiento que hay que hacer
SELECT * FROM Factoriales;

-- El procedimiento que llena la tabla con los resultados de los factoriales
-- Procedimiento: LlenaFactoriales. Parámetros: Numero

DROP PROCEDURE IF EXISTS LlenaFactoriales;
DELIMITER //

//
CREATE PROCEDURE LlenaFactoriales(IN Numero INT)
BEGIN
		DECLARE Contador INT DEFAULT 0;
        
        IF Numero < 0 OR Numero IS NULL OR Numero > 50 THEN SELECT "Valor incorrecto en el parametro" AS "ERROR"; END IF;
        
        TRUNCATE TABLE Factoriales;
		WHILE Numero >= Contador DO
			INSERT INTO Factoriales VALUES(Contador, Factorial(Contador));
			SET Contador = Contador + 1;
		END WHILE;
END
// 

DELIMITER ;

CALL LlenaFactoriales(50);              -- Este es el procedimiento que hay que hacer
SELECT * FROM Factoriales;


-- 17. De cada país que tenga lenguas oficiales, queremos saber el número posible de formas de ordenar sus lenguas oficiales. Usa la función factorial
SELECT Nombre AS 'País', COUNT(Lengua) AS 'Número de lenguas oficiales'
FROM   Pais LEFT JOIN LenguaPais
ON     Pais.Codigo = LenguaPais.CodigoPais
WHERE  EsOficial='T'
GROUP BY Pais.Codigo;

SELECT Nombre AS 'País', factorialesdb.Factorial(COUNT(Lengua)) AS 'Combinaciones de lenguas oficiales'
FROM   Pais LEFT JOIN LenguaPais
ON     Pais.Codigo = LenguaPais.CodigoPais
WHERE  EsOficial='T'
GROUP BY Pais.Codigo;

-- 18. De cada país, queremos saber el número posible de formas de ordenar sus ciudades. Usa la BD de Factoriales



SELECT 	Pais.Nombre AS 'País', 
				(SELECT 	Factorial 
				FROM 		factorialesdb.Factoriales 
				WHERE 	Numero = (COUNT(Ciudad.Nombre))
                ) AS 'Número posible de formas de ordenar sus ciudades'
FROM   Pais LEFT JOIN Ciudad
ON     Pais.Codigo = Ciudad.CodigoPais
GROUP BY Pais.Codigo;


-- -----------------------------------------------------------------
-- Ejercicio criba de Eratóstenes
-- -----------------------------------------------------------------
/*
Número primo:
Un número primo es aquel número natural mayor que uno que admite únicamente dos divisores diferentes: el mismo número y el 1. A diferencia de los números primos, los números compuestos son naturales que pueden factorizarse. La propiedad de ser primo se denomina primalidad. 

El algoritmo RSA se basa en la obtención de la clave pública mediante la multiplicación de dos números grandes (mayores que 10^200) que sean primos. La seguridad de este algoritmo radica en que no se conocen maneras rápidas de factorizar un número grande en sus factores primos utilizando computadoras tradicionales.

https://es.wikipedia.org/wiki/Criba_de_Erat%C3%B3stenes

Tests de primalidad
La criba de Eratóstenes fue concebida por Eratóstenes de Cirene, un matemático griego del siglo III a. C. Es un algoritmo sencillo que permite encontrar todos los números primos menores o iguales que un número dado. Se basa en confeccionar una lista de todos los números naturales desde el 2 hasta ese número y tachar repetidamente los múltiplos de los números primos ya descubiertos.

Criba de Erastótenes. Algoritmo en pseudocódigo:

Entrada: Un número natural n
Salida: El conjunto de números primos anteriores a n (incluyendo n)

   Escriba todos los números naturales desde 2 hasta n
   Para i desde 2 hasta raíz cuadrada de n haga lo siguiente:
      Si i no ha sido marcado entonces:
         Para j desde i hasta n/i haga lo siguiente:
            Ponga una marca en i x j
   El resultado es: Todos los números sin marca
*/


-- Código de apoyo:
DROP DATABASE IF EXISTS Primos;
CREATE DATABASE IF NOT EXISTS Primos;
USE Primos;

DROP TABLE IF EXISTS `NumerosPrimos`;
CREATE TABLE `NumerosPrimos` (
    `Numero` INTEGER NOT NULL,
    `Marcado` BOOLEAN,
    PRIMARY KEY (`Numero`)
) ENGINE = Memory;

TRUNCATE TABLE NumerosPrimos;
INSERT INTO NumerosPrimos VALUES(7, FALSE);
UPDATE NumerosPrimos SET Marcado= TRUE WHERE Numero=7;
SELECT * FROM NumerosPrimos;
SELECT * FROM NumerosPrimos WHERE Marcado;
SELECT Marcado FROM NumerosPrimos WHERE Numero=7;

-- 19. Realiza un procedimiento que implemente la parte “Escriba todos los números naturales desde 2 hasta n”. No es necesario controlar posibles errores en el parámetro de entrada
-- Procedimiento: LlenarTabla. Parámetros: ValorMaximo
DROP PROCEDURE IF EXISTS LlenarTabla;
DELIMITER //

//
CREATE PROCEDURE LlenarTabla(IN ValorMaximo INT)
BEGIN
		DECLARE Contador INT DEFAULT 2;
        
        TRUNCATE TABLE NumerosPrimos;
        
		WHILE Contador <=  ValorMaximo DO
			INSERT INTO NumerosPrimos VALUES(Contador, FALSE);
			SET Contador = Contador + 1;
		END WHILE;
END
// 

DELIMITER ;

CALL LlenarTabla(120);              -- Este es el procedimiento que hay que hacer
SELECT * FROM NumerosPrimos;


-- 20. Implementa el algoritmo de la criba de Eratóstenes
-- Procedimiento: CribaDeEratsotenes. Parámetros: ValorMaximo

DROP PROCEDURE IF EXISTS CribaEratostenes;
DELIMITER //

//
CREATE PROCEDURE CribaEratostenes(IN ValorMaximo INT)
BEGIN
		DECLARE i INT DEFAULT 2;
        DECLARE j INT;
        
		WHILE i <=  SQRT(ValorMaximo) DO
	
			IF NOT (SELECT Marcado FROM NumerosPrimos WHERE Numero = i) THEN 
				 set j = i;
	
                 WHILE j  <=  ValorMaximo / i DO
					UPDATE NumerosPrimos SET Marcado= TRUE WHERE Numero = i * j;
                    
                    SET j = j + 1;
				END WHILE;
            END IF;
            
            
			SET i = i + 1;  
		END WHILE;
END
// 

DELIMITER ;

CALL CribaEratostenes(120);              -- Este es el procedimiento que hay que hacer
SELECT * FROM NumerosPrimos;
SELECT * FROM NumerosPrimos WHERE  NOT Marcado;

-- 22. Crea un procedimiento que llamaremos TestDePrimalidad al que le pasaremos el valor máximo como parámetro y que llenará la tabla, llamará al algoritmo CribaDeEsrastotenes y mostrará en pantalla los números primos obtenidos
-- Procedimiento: TestDePrimalidad. Parámetros: ValorMaximo
DROP PROCEDURE IF EXISTS TestDePrimalidad;
DELIMITER //

//
CREATE PROCEDURE TestDePrimalidad(IN ValorMaximo INT)
BEGIN
	CALL LlenarTabla(ValorMaximo);    
	CALL CribaEratostenes(ValorMaximo);   
    
    SELECT Numero FROM NumerosPrimos WHERE  NOT Marcado;
END
// 

DELIMITER ;

CALL TestDePrimalidad(400000);

DROP TABLE IF EXISTS `NumerosPrimosHDD`;
CREATE TABLE `NumerosPrimosHDD`(SELECT Numero FROM NumerosPrimos WHERE  NOT Marcado);

SELECT * FROM NumerosPrimosHDD;

-- -----------------------------------------------------------------
-- Base de datos de la Liga
-- -----------------------------------------------------------------
-- 23. Queremos usar dos funciones: GolesLocal y GolesVisitante que nos de los goles marcados por el equipo local y por el equipo visitante de un partido. Crea la función GolesLocal
-- Resultado bien formado:
-- 3-2; 11-2; 03-2; 3-02; 03-02
-- Función: GolesLocal, parámetro: Resultado
DROP FUNCTION IF EXISTS GolesLocal;
DELIMITER //

//
CREATE FUNCTION GolesLocal(Resultado CHAR(15)) RETURNS INT
BEGIN
	DECLARE Goles INT;
    SET Goles = ASCII(LEFT(Resultado, 1)) - ASCII("0");
    IF SUBSTRING(Resultado, 2, 1) <> "-" THEN
		SET Goles = Goles * 10 + ASCII(SUBSTRING(Resultado, 2, 1)) - ASCII("0");
    END IF;
    RETURN Goles;
END
// 

DELIMITER ;

SELECT Resultado, GolesLocal(ResultadoBis) FROM Partidos;
DELETE FROM Partidos WHERE ID = 25578;

-- 23. Crea las funciones EsDigito que devuelve TRUE si el carácter que se le pasa es un dígito CaracterANumero que convierte un dígito en un número y simplifica la función GolesLocal2 que es una copia de la función GolesLocal
-- Función: EsDigito. Parámetros: Caracter
-- Función: CaracterANumero. Parámetros: Caracter
DROP FUNCTION IF EXISTS EsDigito;
DELIMITER //

//
CREATE FUNCTION EsDigito(Caracter CHAR) RETURNS BOOL
BEGIN
    RETURN Caracter BETWEEN '0' AND "9";
END
// 

DELIMITER ;

SELECT EsDigito("4");

DROP FUNCTION IF EXISTS CaracterANumero;
DELIMITER //

//
CREATE FUNCTION CaracterANumero(Caracter CHAR) RETURNS BOOL
BEGIN
    RETURN ASCII(Caracter) - ASCII("0");
END
// 

DELIMITER ;

SELECT CaracterANumero("6");

DROP FUNCTION IF EXISTS GolesLocal2;
DELIMITER //

//
CREATE FUNCTION GolesLocal2(Resultado CHAR(15)) RETURNS INT
BEGIN
	DECLARE Goles INT;
    SET Goles = CaracterANumero(LEFT(Resultado, 1));
    
    IF EsDigito(SUBSTRING(Resultado, 2, 1)) THEN
		SET Goles = Goles * 10 + CaracterANumero(SUBSTRING(Resultado, 2, 1));
    END IF;
    
    RETURN Goles;
END
// 

DELIMITER ;

SELECT Resultado, GolesLocal2(ResultadoBis) FROM Partidos;
SELECT Resultado, GolesLocal(ResultadoBis) FROM Partidos;

-- 24. Crea la función GolesVisitante
-- Función: GolesVisitante. Parámetros: Caracter
DROP FUNCTION IF EXISTS GolesVisitante;
DELIMITER //

//
CREATE FUNCTION GolesVisitante(Resultado CHAR(15)) RETURNS INT
BEGIN
	DECLARE Goles, Puntero INT;
    
    IF NOT EsDigito(SUBSTRING(Resultado, 2, 1)) 
		THEN SET Puntero = 3;
        ELSE SET Puntero = 4;
    END IF;
    
    SET Goles = CaracterANumero(SUBSTRING(Resultado, Puntero, 1));
    
    IF CHAR_LENGTH(Resultado) > Puntero THEN
		SET Goles = Goles * 10 + CaracterANumero(SUBSTRING(Resultado, Puntero + 1, 1));
	END IF;
    
    RETURN Goles;
END
// 

DELIMITER ;
SELECT Resultado, GolesLocal2(ResultadoBis), GolesVisitante(ResultadoBis) FROM Partidos;

-- 25. Partidos en los que un equipo ha ganado al otro por siete o más goles
SELECT  CONCAT(EquipoLocal," - " ,EquipoVisitante) AS Partidos, Temporada, Jornada, ResultadoBis
FROM Partidos
WHERE ABS(GolesLocal2(ResultadoBis) - GolesVisitante(ResultadoBis)) >= 7;


-- 26. Las 20 mayores goleadas de la historia de la liga
SELECT  CONCAT(EquipoLocal," - " ,EquipoVisitante) AS Partidos, Temporada, Jornada, ResultadoBis
FROM Partidos
ORDER BY ABS(GolesLocal2(ResultadoBis) - GolesVisitante(ResultadoBis)) DESC
LIMIT 20;

-- 27. Nombre de todos los equipos. Queremos ver cuántos equipos diferentes hay, no cuántos nombres han tenido todos los equipos (EquipoLocalX)
SELECT DISTINCT EquipoLocalX as "Equipos" FROM Partidos
UNION DISTINCT
SELECT DISTINCT EquipoVisitanteX as "Equipos" FROM Partidos;

-- -----------------------------------------------------------------
-- Modificación de la base de datos de la liga:
-- -----------------------------------------------------------------
-- En bases de datos no es normal que haya solo una tabla
ALTER TABLE Partidos ADD COLUMN GolesLocal TINYINT NOT NULL DEFAULT 0;
ALTER TABLE Partidos ADD COLUMN GolesVisitante TINYINT NOT NULL DEFAULT 0;

SELECT * FROM Partidos;

UPDATE Partidos
SET GolesLocal = GolesLocal(ResultadoBis);

UPDATE Partidos
SET GolesVisitante = GolesVisitante(ResultadoBis);

SELECT * FROM Partidos;

ALTER TABLE Partidos ADD COLUMN Alirones CHAR NOT NULL DEFAULT '';

UPDATE Partidos
SET Alirones = 'L'
WHERE Resultado LIKE '%(A.L.)%';

UPDATE Partidos
SET Alirones = 'V'
WHERE Resultado LIKE '%(A.V.)%';

ALTER TABLE Partidos DROP COLUMN ResultadoBis;
ALTER TABLE Partidos DROP COLUMN Resultado;

DROP TABLE Equipos;
CREATE TABLE Equipos AS 
	(SELECT DISTINCT EquipoLocalX as "NombreEquipo" FROM Partidos)
	UNION DISTINCT
	(SELECT DISTINCT EquipoVisitanteX as "NombreEquipo" FROM Partidos)
	ORDER BY NombreEquipo;

ALTER TABLE Equipos ADD COLUMN IdEquipo INT NOT NULL PRIMARY KEY AUTO_INCREMENT FIRST;

ALTER TABLE Partidos ADD COLUMN EL INT NOT NULL DEFAULT 0;
ALTER TABLE Partidos ADD COLUMN EV INT NOT NULL DEFAULT 0;

SELECT * 
FROM Partidos JOIN Equipos
ON Partidos.EquipoLocalX = Equipos.NombreEquipo; 

UPDATE Partidos JOIN Equipos
ON Partidos.EquipoLocalX = Equipos.NombreEquipo
SET Partidos.EL = Equipos.IdEquipo; 

UPDATE Partidos JOIN Equipos
ON Partidos.EquipoVisitanteX = Equipos.NombreEquipo
SET Partidos.EV = Equipos.IdEquipo; 


ALTER TABLE Partidos DROP COLUMN EquipoLocal;
ALTER TABLE Partidos DROP COLUMN EquipoLocalX;
ALTER TABLE Partidos DROP COLUMN EquipoLocalBis;
ALTER TABLE Partidos DROP COLUMN EquipoVisitante;
ALTER TABLE Partidos DROP COLUMN EquipoVisitanteX;
ALTER TABLE Partidos DROP COLUMN EquipoVisitanteBis;

ALTER TABLE Partidos CHANGE COLUMN EL EquipoLocal INT NOT NULL DEFAULT 0;
ALTER TABLE Partidos CHANGE COLUMN EV EquipoVisitante INT NOT NULL DEFAULT 0;

ALTER TABLE Partidos ADD CONSTRAINT
EquipoLocalFK FOREIGN KEY (EquipoLocal) REFERENCES Equipos(IdEquipo);

ALTER TABLE Partidos ADD CONSTRAINT
EquipoVisitanteFK FOREIGN KEY (EquipoVisitante) REFERENCES Equipos(IdEquipo);

SELECT * FROM Partidos WHERE Jornada = "PROMOCION";
SELECT * FROM Partidos WHERE Jornada NOT REGEXP "^[0-9][0-9]\\.$";


ALTER TABLE Partidos ADD COLUMN Promocion BOOL NOT NULL DEFAULT FALSE AFTER Jornada;
UPDATE Partidos
SET Promocion = (Jornada = "Promocion");

SELECT * FROM Partidos;
SELECT * FROM Equipos;

ALTER TABLE Partidos ADD COLUMN JornadaNueva INT NOT NULL DEFAULT 0 AFTER Jornada;
SELECT Jornada, CONVERT(LEFT(Jornada,2), SIGNED) FROM Partidos WHERE NOT PROMOCION;

UPDATE Partidos SET  JornadaNueva = CONVERT(LEFT(Jornada,2), SIGNED) WHERE NOT PROMOCION;

ALTER TABLE Partidos DROP COLUMN Jornada;
ALTER TABLE Partidos CHANGE COLUMN JornadaNueva Jornada INT NOT NULL DEFAULT 0;



SELECT 	Id, Temporada, Anyo as "Año", 
				IF(Promocion, "PROMOCIÓN", 
					IF( Jornada > 10, 
						CONCAT('0', Jornada, '.'), 
                        CONCAT(Jornada, '.')
                    )) AS "Jornada",
                    Equlocales.NombreEquipo AS "Equipo Local", 	EquVisitantes.NombreEquipo AS "Equipo Visitante" ,
                    CONCAT(GolesLocal, '-' ,GolesVisitante) AS "Resultado"

FROM 		Partidos JOIN Equipos Equlocales JOIN Equipos EquVisitantes
ON 			Partidos.EquipoLocal = Equlocales.IdEquipo 
				AND Partidos.EquipoVisitante = EquVisitantes.IdEquipo 
ORDER BY Id;

-- -----------------------------------------------------------------
-- Cursores
-- -----------------------------------------------------------------
/*
Tenemos toda la información en el manual de referencia de MySQL v8.0:  13.6.6 Cursors

Los cursores se declaran, se abren, se recorren y se cierran

DECLARE cursor_name CURSOR FOR select_statement;
Los cursores de declaran justo después de las variables

OPEN cursor_name;

FETCH cursor_name INTO var_name [, var_name] ...;
Este comando trata el siguiente registro (si existe) usando el cursor abierto que se especifique, y avanza el puntero del cursor.

CLOSE cursor_name;
cierra un cursor abierto préviamente

En los cursores hay que detectar cuando se llega al final de la tabla. Para ello usaremos un  manejador
DECLARE handler_type HANDLER FOR condition_value[,...] sp_statement;
Este comando especifica handlers que pueden tratar una o varias condiciones. Si una de estas condiciones ocurren, el comando especificado se ejecuta.
*/   


-- 29. Realizamos un cursor muy simple en el que creamos una tabla con una consulta SELECT en la que mostramos el nombre del equipo junto con el saldo total de goles que ha metido como equipo local menos el número de goles que le han metido los visitantes. Recorreremos esa tabla mostrando individualmente cada equipo y su saldo de goles
-- Primero creamos la consulta SELECT en la que se basa el cursor:
SELECT Equipos.NombreEquipo AS 'Nombre del equipo',
       SUM(GolesLocal-GolesVisitante) AS 'Saldo de goles'
FROM   Partidos JOIN Equipos
ON     Partidos.EquipoLocal = Equipos.IdEquipo
GROUP BY Equipos.IdEquipo
ORDER BY `Saldo de goles` DESC;

-- Procedimiento:  PruebaCursor
DROP PROCEDURE IF EXISTS PruebaCursor;
DELIMITER //

//
CREATE PROCEDURE PruebaCursor()
BEGIN

	DECLARE CEquipo VARCHAR(255);
    DECLARE CSaldoGoles INT;
    DECLARE FinCurEquipos BOOL DEFAULT FALSE;
    
	DECLARE CurEquipos CURSOR FOR
				SELECT Equipos.NombreEquipo AS 'Nombre del equipo',
					SUM(GolesLocal-GolesVisitante) AS 'Saldo de goles'
					FROM   Partidos JOIN Equipos
					ON     Partidos.EquipoLocal = Equipos.IdEquipo
					GROUP BY Equipos.IdEquipo
					ORDER BY `Saldo de goles` DESC
                    LIMIT 5;
					
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET FinCurEquipos = TRUE;
    
    
	OPEN		CurEquipos;
  
  /*
  Lo hace la cantida de veces que le digas (hay que repetirlos ps)
   FETCH		CurEquipos INTO CEquipo, CSaldoGoles;
	SELECT CONCAT("Equipo: ", CEquipo, ". Saldo de goles: ", CSaldoGoles) AS "Resultado";
   */
   
    BucleEquipos: LOOP
		FETCH		CurEquipos INTO CEquipo, CSaldoGoles;
         IF FinCurEquipos THEN LEAVE BUcleEquipos; END IF;
		SELECT CONCAT("Equipo: ", CEquipo, ". Saldo de goles: ", CSaldoGoles) AS "Resultado";
	END LOOP BucleEquipos;
    
	Close		CurEquipos;

END
//

DELIMITER ;

CALL PruebaCursor();

-- 30 De todos los partidos de la liga, queremos buscar series en las que el Barcelona ha ganado como equipo visitante durante ocho o más jornadas seguidas
-- La consulta
SELECT GolesLocal, GolesVisitante
FROM   Partidos
WHERE  EquipoVisitante = (
   SELECT IdEquipo
   FROM   Equipos
   WHERE  NombreEquipo = 'Barcelona')
ORDER BY Temporada, Promocion, Jornada;

/*
NumRepeticiones= 0
bucle
   obtener siguiente registro
   Si he llegado al final salir del bucle
   IF GVisitante > GLocal
       THEN
           Incrementamos NumRepeticiones
       ELSE
           IF NumRepeticiones >= 8
               THEN
                   Hemos encontrado una serie
           NumRepeticiones=0
fin bucle
*/


/*
NumRepeticiones= 0
bucle
   obtener siguiente registro
   IF GVisitante > GLocal y no hemos llegado al final
     THEN
         Incrementamos NumRepeticiones
     ELSE
         IF NumRepeticiones >= 8
             THEN
                 Hemos encontrado una serie
         NumRepeticiones=0
         Si he llegado al final salir del bucle        
fin bucle
*/

-- La estructura del cursor
-- El procedimiento se llama:  SeriesBarcelona
-- El cursor se llamará:  CurSeriesBarcelona
-- Las variables serán:  GLocal, Gvisitante y FinCurSeriesBarcelona

DROP PROCEDURE IF EXISTS SeriesBarcelona;
DELIMITER //

//
CREATE PROCEDURE SeriesBarcelona()
BEGIN
	DECLARE NumRepeticiones INT DEFAULT 0;
    DECLARE GLocal, GVisitante INT;
    DECLARE SJornada INT(11);
    DECLARE STemporada CHAR(15);
    DECLARE FinCurSeriesBarcelona BOOL DEFAULT FALSE;

	DECLARE CurSeriesBarcelona CURSOR FOR
					SELECT GolesLocal, GolesVisitante, Temporada, Jornada
					FROM   Partidos
					WHERE  EquipoVisitante = (
					   SELECT IdEquipo
					   FROM   Equipos
					   WHERE  NombreEquipo = 'Barcelona')
					ORDER BY Temporada, Promocion, Jornada;
						
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET FinCurSeriesBarcelona = TRUE;
    
    
	OPEN		CurSeriesBarcelona;
	BucleEquipos: LOOP
		FETCH		CurSeriesBarcelona INTO GLocal, GVisitante, STemporada, SJornada;
        
         IF  GVisitante > GLocal AND NOT FinCurSeriesBarcelona
         THEN SET NumRepeticiones = NumRepeticiones + 1;
         ELSE
			IF NumRepeticiones >= 8
				THEN SELECT CONCAT("Hemos Encontrado uina serie de ", NumRepeticiones, "repeticiones dek Barcelona como visitante que acabo la jornada ", SJornada, " de la temporada ", STemporada) AS "Resultado";
			END IF;
            
            SET NumRepeticiones = 0;
            IF FinCurSeriesBarcelona THEN LEAVE BucleEquipos; END IF;
         END IF;
	END LOOP BucleEquipos;
    
	Close		CurSeriesBarcelona;

END
//

DELIMITER ;

CALL SeriesBarcelona();

-- 31. Parametrizar el procedimiento para que admita cualquier tamaño de la serie y cualquier equipo. Si la serie es menor que 2 o el equipo no existe, mostrará un error

DROP PROCEDURE IF EXISTS SeriesEquipo;
DELIMITER //

//
CREATE PROCEDURE SeriesEquipo(IN ParamEquipo VARCHAR(255), IN TamSerie INT)
PSeriesEquipo: BEGIN
	DECLARE NumRepeticiones INT DEFAULT 0;
    DECLARE GLocal, GVisitante INT;
    DECLARE SJornada INT(11);
    DECLARE STemporada CHAR(15);
    DECLARE FinCurSeriesEquipo BOOL DEFAULT FALSE;

	DECLARE CurSeriesEquipo CURSOR FOR
					SELECT GolesLocal, GolesVisitante, Temporada, Jornada
					FROM   Partidos
					WHERE  EquipoVisitante = (
					   SELECT IdEquipo
					   FROM   Equipos
					   WHERE  NombreEquipo = ParamEquipo)
					ORDER BY Temporada, Promocion, Jornada;
						
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET FinCurSeriesEquipo = TRUE;
    
    IF TamSerie < 2 OR TamSerie IS NULL THEN 
		SELECT "La serie tiene que ser mayor de dos y no se nulo" AS "ERROR"; 
		LEAVE PSeriesEquipo;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Equipos WHERE NombreEquipo = ParamEquipo) THEN
		SELECT CONCAT("El equipo ", ParamEquipo, " no existe") AS "ERROR"; 
		LEAVE PSeriesEquipo;
    END IF;
    
	OPEN		CurSeriesEquipo;
	BucleEquipos: LOOP
		FETCH		CurSeriesEquipo INTO GLocal, GVisitante, STemporada, SJornada;
        
         IF  GVisitante > GLocal AND NOT FinCurSeriesEquipo
         THEN SET NumRepeticiones = NumRepeticiones + 1;
         ELSE
			IF NumRepeticiones >= TamSerie
				THEN SELECT CONCAT("Hemos Encontrado uina serie de ", NumRepeticiones, " repeticiones del  ", ParamEquipo, " como visitante que acabo la jornada ", SJornada, " de la temporada ", STemporada) AS "Resultado";
			END IF;
            
            SET NumRepeticiones = 0;
            IF FinCurSeriesEquipo THEN LEAVE BucleEquipos; END IF;
         END IF;
	END LOOP BucleEquipos;
    
	Close		CurSeriesEquipo;

END PSeriesEquipo
//

DELIMITER ;

CALL SeriesEquipo("Barcelona",8);



-- 32. Mostrar la información de los partidos de la serie

-- Para trabajar con tablas temporales:
CREATE TEMPORARY TABLE IF NOT EXISTS InformacionSerie (
  IdPartido INT(11) NOT NULL
) ENGINE = MEMORY;
INSERT INTO InformacionSerie VALUES (50);
INSERT INTO InformacionSerie VALUES (150);
SELECT * FROM InformacionSerie;
TRUNCATE TABLE InformacionSerie;
SELECT * FROM InformacionSerie;
DROP TABLE IF EXISTS InformacionSerie;

-- Para mostrar la información de la serie de partidos encontrados
INSERT INTO InformacionSerie VALUES (1);
INSERT INTO InformacionSerie VALUES (10);
INSERT INTO InformacionSerie VALUES (100);
INSERT INTO InformacionSerie VALUES (115);
INSERT INTO InformacionSerie VALUES (215);
INSERT INTO InformacionSerie VALUES (315); 

-- Para mostrar la información de los partidos de la serie (basada en la consulta 53)
SELECT Id, Temporada, Anyo AS 'Año',
       IF(Promocion, 'PROMOCIÓN',
          IF(Jornada < 10,
              CONCAT('0', Jornada, '.'),
              CONCAT(Jornada, '.'))) AS 'Jornada',
       EquipoLocal.NombreEquipo AS 'Equipo local',
       EquipoVisitante.NombreEquipo AS 'Equipo Visitante',
       CONCAT(GolesLocal, '-', GolesVisitante) AS 'Resultado'
FROM InformacionSerie JOIN
     Partidos JOIN Equipos AS EquipoLocal JOIN Equipos AS EquipoVisitante
ON   InformacionSerie.IdPartido = Partidos.Id AND
     Partidos.EquipoLocal = EquipoLocal.IdEquipo AND
     Partidos.EquipoVisitante = EquipoVisitante.IdEquipo
ORDER BY Id;

DROP PROCEDURE IF EXISTS SeriesEquipo;
DELIMITER //

//
CREATE PROCEDURE SeriesEquipo(IN ParamEquipo VARCHAR(255), IN TamSerie INT)
PSeriesEquipo: BEGIN
	DECLARE NumRepeticiones INT DEFAULT 0;
    DECLARE GLocal, GVisitante INT;
    DECLARE SJornada, SIdPartido  INT(11);
    DECLARE STemporada CHAR(15);
    DECLARE FinCurSeriesEquipo BOOL DEFAULT FALSE;

	DECLARE CurSeriesEquipo CURSOR FOR
					SELECT Id, GolesLocal, GolesVisitante, Temporada, Jornada
					FROM   Partidos
					WHERE  EquipoVisitante = (
					   SELECT IdEquipo
					   FROM   Equipos
					   WHERE  NombreEquipo = ParamEquipo)
					ORDER BY Temporada, Promocion, Jornada;
						
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET FinCurSeriesEquipo = TRUE;
    
    IF TamSerie < 2 OR TamSerie IS NULL THEN 
		SELECT "La serie tiene que ser mayor de dos y no se nulo" AS "ERROR"; 
		LEAVE PSeriesEquipo;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Equipos WHERE NombreEquipo = ParamEquipo) THEN
		SELECT CONCAT("El equipo ", ParamEquipo, " no existe") AS "ERROR"; 
		LEAVE PSeriesEquipo;
    END IF;
    
    DROP TABLE IF EXISTS InformacionSerie;
    CREATE TEMPORARY TABLE IF NOT EXISTS InformacionSerie (
		IdPartido INT(11) NOT NULL
	) ENGINE = MEMORY;
    
	OPEN		CurSeriesEquipo;
	BucleEquipos: LOOP
		FETCH CurSeriesEquipo INTO SIdPartido, GLocal, GVisitante, STemporada, SJornada;
        
         IF  GVisitante > GLocal AND NOT FinCurSeriesEquipo
			THEN 
				SET NumRepeticiones = NumRepeticiones + 1;
                INSERT INTO InformacionSerie VALUES (SIdPartido);
         ELSE
			IF NumRepeticiones >= TamSerie
				THEN 
					SELECT CONCAT("Hemos Encontrado uina serie de ", NumRepeticiones, " repeticiones del  ", ParamEquipo, " como visitante que acabo la jornada ", SJornada, " de la temporada ", STemporada) AS "Resultado";
                    
                    SELECT Id, Temporada, Anyo AS 'Año',
						   IF(Promocion, 'PROMOCIÓN',
							  IF(Jornada < 10,
								  CONCAT('0', Jornada, '.'),
								  CONCAT(Jornada, '.'))) AS 'Jornada',
						   EquipoLocal.NombreEquipo AS 'Equipo local',
						   EquipoVisitante.NombreEquipo AS 'Equipo Visitante',
						   CONCAT(GolesLocal, '-', GolesVisitante) AS 'Resultado'
					FROM InformacionSerie JOIN
						 Partidos JOIN Equipos AS EquipoLocal JOIN Equipos AS EquipoVisitante
					ON   InformacionSerie.IdPartido = Partidos.Id AND
						 Partidos.EquipoLocal = EquipoLocal.IdEquipo AND
						 Partidos.EquipoVisitante = EquipoVisitante.IdEquipo
					ORDER BY Id;
                    
			END IF;
            
            SET NumRepeticiones = 0;
            TRUNCATE TABLE InformacionSerie;
            
            IF FinCurSeriesEquipo THEN LEAVE BucleEquipos; END IF;
         END IF;
	END LOOP BucleEquipos;
    
	Close		CurSeriesEquipo;
    DROP TABLE IF EXISTS InformacionSerie; 

END PSeriesEquipo
//

DELIMITER ;

CALL SeriesEquipo("Barcelona",8);


-- -----------------------------------------------------------------
-- Disparadores
-- -----------------------------------------------------------------
/*
Tenemos toda la información en el manual de referencia de MySQL v8.0:  25.3.1 Trigger Syntax and Examples y en A.5 MySQL 8.0 FAQ: Triggers

Un disparador es programa almacenado que se ejecuta automáticamente como respuesta a un evento específico asociado a una tabla, por ejemplo, un INSERT, UPDATE o DELETE.*/

-- 33. Realizamos un disparador muy simple 
DROP TABLE IF EXISTS EquiposB;
CREATE TABLE EquiposB AS SELECT * FROM Equipos;

CREATE TRIGGER BeforeEquiposBDelete 
BEFORE DELETE ON EquiposB
FOR EACH ROW
SET @Borrados = @Borrados + 1;

SET @Borrados = 0;

DELETE FROM EquiposB WHERE NombreEquipo = "Barcelona";
SELECT @Borrados;

SELECT * FROM EquiposB WHERE NombreEquipo LIKE "%Madrid%";
SELECT @Borrados;

DELETE FROM EquiposB WHERE NombreEquipo LIKE "%Madrid%";
SELECT @Borrados;


/*
A diferencia de un procedimiento, a un diparador no podemos llamarlo. Para que se ejecute debemos ejecutar nosotros una instrucción INSERT, UPDATE o DELETE sobre la tabla en la cual está definido el disparador.

Ventajas:
permiten comprobar la integridad de los datos
permiten ejecutar tareas programadas (por ejemplo, incrementar un contador cada vez que se borra un registro)
son muy útiles para auditar cambios en las tablas

Inconvenientes:
no pueden realizar todas las comprobaciones de integridad. Algunas deberán hacerse en el lado del cliente
se les llama y ejecuta de manera invisible de la aplicación cliente por lo que no es fácil depurar errores
pueden llegar a sobrecargar la BD

Una tabla puede tener seis disparadores: BEFORE INSERT, AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE y AFETER DELETE. Los disparadores no afectan a ordenes que no son INSERT, UPDATE o DELETE; como por ejemplo, TRUNCATE; pero sí afectan a otras ordenes que las usan internamente, como por ejemplo REPLACE o SOURCE.

Como hemos visto con el ejemplo anterior, un disparador se ejecuta para cada registro que se añade, actualiza o borra en la tabla. Si una orden, por ejemplo, borra varios registros, su disparador se ejecuta varias veces.

Los nombres de los disparadores suelen seguir la siguiente convención: 
(BEFORE | AFTER)_NombreTabla_(INSERT| UPDATE | DELETE) o sus variantes
(BEFORE | AFTER)NombreTabla(INSERT| UPDATE | DELETE)
(Antes | Despues)_(Insertar | Actualizar | Borrar)_NombreTabla
(Antes | Despues)(Insertar | Actualizar | Borrar)NombreTabla

Un disparador puede tener una única orden, por ejemplo, un SET o podría tener una llamada a un procedimiento que nos permitiría aprovechar el mismo código para varios disparadores. Si ponemos más de una orden en un disparador, usaremos un bloque BEGIN, END.

Las palabras clave OLD y NEW son muy útiles y se refieren al registro que se va insertar, borrar o actualizar antes o depués de la acción. En un disparador INSERT sólo podemos usar NEW.Campo. En un disparador DELETE sólo podemos usar OLD.Campo. En un disparador UPDATE podemos usar tanto OLD.Campo como NEW.Campo para referirnos al valor de un campo del registro antes de actualizarlo o después. Todos los campos OLD son de sólo lectura, pero los campos NEW en un disparador BEFORE UPDATE o BEFORE INSERT son de lectura y escritura, lo que nos permite modificar el valor que se va a añadir o actualizar en la BD. */

DROP TABLE IF EXISTS EquiposB;
CREATE TABLE EquiposB AS SELECT * FROM Equipos;

ALTER TABLE EquiposB ADD COLUMN AnyFundacion INT;
SELECT * FROM EquiposB;

UPDATE EquiposB SET AnyFundacion = IdEquipo + 1900;
UPDATE EquiposB SET AnyFundacion = 1899 WHERE NombreEquipo = "Barcelona";
UPDATE EquiposB SET AnyFundacion = 1900 WHERE NombreEquipo LIKE "%Madrid%";


DROP TRIGGER IF EXISTS BeforeEquiposBInsert;
DELIMITER //

//
CREATE TRIGGER BeforeEquiposBInsert
BEFORE INSERT ON EquiposB
FOR EACH ROW
BEGIN
	IF NEW.AnyFundacion < 100 THEN SET NEW.AnyFundacion = NEW.AnyFundacion + 2000;  END IF;
END 
//

DELIMITER ;

INSERT INTO EquiposB VALUES (130, "Prueba1", 2015);
INSERT INTO EquiposB VALUES (130, "Prueba2", 10);
SELECT * FROM EquiposB WHERE NombreEquipo LIKE "Prueba%";

-- 34. Modificar el disparador anterior para que si introducimos años como por ejemplo 98, nos cree el año 1998
DROP TRIGGER IF EXISTS BeforeEquiposBInsert;
DELIMITER //

CREATE TRIGGER BeforeEquiposBInsert
BEFORE INSERT ON EquiposB
FOR EACH ROW
BEGIN
	IF NEW.AnyFundacion <= YEAR(CURDATE()) - 2000
		THEN SET NEW.AnyFundacion = NEW.AnyFundacion + 2000;
	ELSEIF NEW.AnyFundacion < 100
		THEN SET NEW.AnyFundacion = NEW.AnyFundacion + 1900;
    END IF;
END //

DELIMITER ;

DELETE FROM EquiposB WHERE NombreEquipo LIKE 'Prueba%';
INSERT INTO EquiposB VALUES (140,'Prueba1',0);
INSERT INTO EquiposB VALUES (141,'Prueba2',18);
INSERT INTO EquiposB VALUES (142,'Prueba3',19);
INSERT INTO EquiposB VALUES (142,'Prueba3',20);
INSERT INTO EquiposB VALUES (143,'Prueba4',30);
INSERT INTO EquiposB VALUES (144,'Prueba5',99);
INSERT INTO EquiposB VALUES (145,'Prueba6',100);
SELECT * FROM EquiposB WHERE NombreEquipo LIKE 'Prueba%';


-- 35. Modificar el disparador anterior para afecte a las actualizaciones
DROP TRIGGER IF EXISTS BeforeEquiposBUpdate;
DELIMITER //

CREATE TRIGGER BeforeEquiposBUpdate
BEFORE UPDATE ON EquiposB
FOR EACH ROW
BEGIN
	IF NEW.AnyFundacion <= YEAR(CURDATE()) - 2000
		THEN SET NEW.AnyFundacion = NEW.AnyFundacion + 2000;
	ELSEIF NEW.AnyFundacion < 100
		THEN SET NEW.AnyFundacion = NEW.AnyFundacion + 1900;
    END IF;
END //

DELIMITER ;

UPDATE EquiposB SET AnyFundacion = IdEquipo;
SELECT * FROM EquiposB ORDER BY 3;

-- 36. Añadir dos campos a la tabla EquiposB: GolesLocal y GolesVisitante que indiquen los goles marcados por el equipo como local y como visitante. Bloquea la tabla para cualquier operación de escritura, actualiza los dos nuevos campos con sus valores correctos, crea los disparadores que mantendrán esos dos valores actualizados ante cualquier modificación de la tabla partidos y desbloquea la tabla.
ALTER TABLE EquiposB ADD COLUMN GolesLocal INT DEFAULT 0;
ALTER TABLE EquiposB ADD COLUMN GolesVisitante INT DEFAULT 0;

 UPDATE EquiposB SET GolesLocal = (
	SELECT SUM(GolesLocal) 
    FROM Partidos 
    WHERE Partidos.EquipoLocal = EquiposB.IdEquipo
);

 UPDATE EquiposB SET GolesVisitante = (
	SELECT SUM(GolesVisitante) 
    FROM Partidos 
    WHERE Partidos.EquipoVisitante = EquiposB.IdEquipo
);

UPDATE EquiposB SET GolesLocal = 0 WHERE GolesLocal IS NULL;
UPDATE EquiposB SET GolesVisitante = 0 WHERE GolesLocal IS NULL;



DROP TRIGGER IF EXISTS AfterPartidosInsert;
DELIMITER //

CREATE TRIGGER AfterPartidosInsert
AFTER INSERT ON Partidos
FOR EACH ROW
BEGIN
	 UPDATE EquiposB SET GolesLocal = GolesLocal + NEW.GolesLocal WHERE EquiposB.IdEquipo = New.EquipoLocal;
     UPDATE EquiposB SET GolesVisitante = GolesVisitante + NEW.GolesVisitante WHERE EquiposB.IdEquipo = New.EquipoVisitante;
END //

DELIMITER ;

SELECT * FROM EquiposB;

-- Pruebas de AfterPartidosInsert: 
SELECT * FROM EquiposB WHERE IdEquipo IN (17, 18);
-- Partido Barcelona-Betis
INSERT INTO Partidos VALUES (40001,'2015-2016',2015,99,0,3,6,'',17,18); 
SELECT * FROM EquiposB WHERE IdEquipo IN (17, 18);
-- Partido Betis-Barcelona 
INSERT INTO Partidos VALUES (40002,'2015-2016',2015,99,0,2,2,'',18,17);
SELECT * FROM EquiposB WHERE IdEquipo IN (17, 18); 

/*
'17', 'Barcelona', '3899', '2253'
'18', 'Betis',     '1412',  '912'
*/


DROP TRIGGER IF EXISTS AfterPartidosDelete;
DELIMITER //

CREATE TRIGGER AfterPartidosDelete
AFTER DELETE ON Partidos
FOR EACH ROW
BEGIN
	 UPDATE EquiposB SET GolesLocal = GolesLocal - OLD.GolesLocal WHERE EquiposB.IdEquipo = OLD.EquipoLocal;
     UPDATE EquiposB SET GolesVisitante = GolesVisitante - OLD.GolesVisitante WHERE EquiposB.IdEquipo = OLD.EquipoVisitante;
END //

DELIMITER ;


-- Pruebas de AfterPartidosDelete:
DELETE FROM Partidos WHERE Id = 40002;
DELETE FROM Partidos WHERE Id = 40001;


DROP TRIGGER IF EXISTS AfterPartidosUpdate;
DELIMITER //

CREATE TRIGGER AfterPartidosUpdate
AFTER UPDATE ON Partidos
FOR EACH ROW
BEGIN
	IF OLD.GolesLocal != NEW.GolesLocal 
		OR OLD.GolesVisitante != NEW.GolesVisitante 
        OR OLD.EquipoLocal != NEW.EquipoLocal 
        OR OLD.EquipoVisitante != NEW.EquipoVisitante
        THEN
			 UPDATE EquiposB SET GolesLocal = GolesLocal - OLD.GolesLocal WHERE EquiposB.IdEquipo = OLD.EquipoLocal;
			 UPDATE EquiposB SET GolesVisitante = GolesVisitante - OLD.GolesVisitante WHERE EquiposB.IdEquipo = OLD.EquipoVisitante;
			 UPDATE EquiposB SET GolesLocal = GolesLocal + NEW.GolesLocal WHERE EquiposB.IdEquipo = New.EquipoLocal;
			UPDATE EquiposB SET GolesVisitante = GolesVisitante + NEW.GolesVisitante WHERE EquiposB.IdEquipo = New.EquipoVisitante;
     END IF;
END //

DELIMITER ;


-- Pruebas de AfterPartidosUpdate:
SELECT * FROM EquiposB WHERE IdEquipo IN (17, 67, 81); -- Barcelona, Real Madrid y Xerez
SELECT * FROM Partidos WHERE EquipoLocal=17 AND EquipoVisitante=67 LIMIT 1; 
SELECT * FROM Partidos WHERE Id = 7;
UPDATE Partidos SET GolesLocal=3, GolesVisitante=5 WHERE Id=7; 
UPDATE Partidos SET GolesLocal=1, GolesVisitante=2 WHERE Id=7;
UPDATE Partidos SET EquipoLocal=81 WHERE Id=7;
UPDATE Partidos SET EquipoLocal=17 WHERE Id=7;
UPDATE Partidos SET EquipoVisitante=81 WHERE Id=7;
UPDATE Partidos SET EquipoVisitante=67 WHERE Id=7;

/*
'7', '1929', '1929', '2', '0', '1', '2', '17', '67'
'17', 'Barcelona',   '3901', '2253'
'67', 'Real_Madrid', '3631', '2222'
'81', 'Xerez_2',       '20',   '18'

*/

-- -----------------------------------------------------------------
-- Ejercicio completo
-- -----------------------------------------------------------------
DROP TABLE IF EXISTS EquiposB;
CREATE TABLE EquiposB AS SELECT * FROM Equipos;
ALTER TABLE EquiposB ADD COLUMN GolesLocal INT DEFAULT 0;
ALTER TABLE EquiposB ADD COLUMN GolesVisitante INT DEFAULT 0;

LOCK TABLES Partidos Write, EquiposB Write; 

UPDATE EquiposB SET GolesLocal = (
    SELECT SUM(GolesLocal) FROM Partidos
    WHERE Partidos.EquipoLocal = EquiposB.IdEquipo);
UPDATE EquiposB SET GolesVisitante = (
    SELECT SUM(GolesVisitante) FROM Partidos
    WHERE Partidos.EquipoVisitante = EquiposB.IdEquipo);
UPDATE EquiposB SET GolesLocal = 0 WHERE GolesLocal IS NULL;
UPDATE EquiposB SET GolesVisitante = 0 WHERE GolesVisitante IS NULL;

DROP TRIGGER IF EXISTS AfterPartidosInsert; 
DELIMITER // 
CREATE TRIGGER AfterPartidosInsert
AFTER INSERT ON Partidos
FOR EACH ROW
BEGIN
    UPDATE EquiposB SET GolesLocal = GolesLocal + NEW.GolesLocal
    WHERE  EquiposB.IdEquipo = NEW.EquipoLocal;
    UPDATE EquiposB SET GolesVisitante = GolesVisitante + NEW.GolesVisitante
    WHERE  EquiposB.IdEquipo = NEW.EquipoVisitante;    
END// 
DELIMITER ;

DROP TRIGGER IF EXISTS AfterPartidosDelete; 
DELIMITER // 
CREATE TRIGGER AfterPartidosDelete
AFTER DELETE ON Partidos
FOR EACH ROW
BEGIN
    UPDATE EquiposB SET GolesLocal = GolesLocal - OLD.GolesLocal
    WHERE  EquiposB.IdEquipo = OLD.EquipoLocal;
    UPDATE EquiposB SET GolesVisitante = GolesVisitante - OLD.GolesVisitante
    WHERE  EquiposB.IdEquipo = OLD.EquipoVisitante;    
END// 
DELIMITER ; 

DROP TRIGGER IF EXISTS AfterPartidosUpdate; 
DELIMITER // 
CREATE TRIGGER AfterPartidosUpdate
AFTER UPDATE ON Partidos
FOR EACH ROW
BEGIN
    IF OLD.GolesLocal <> NEW.GolesLocal OR
       OLD.GolesVisitante <> NEW.GolesVisitante OR
       OLD.EquipoLocal <> NEW.EquipoLocal OR
       OLD.EquipoVisitante <> NEW.EquipoVisitante THEN
            UPDATE EquiposB SET GolesLocal = GolesLocal - OLD.GolesLocal
            WHERE  EquiposB.IdEquipo = OLD.EquipoLocal;
            UPDATE EquiposB SET GolesVisitante = GolesVisitante - OLD.GolesVisitante
            WHERE  EquiposB.IdEquipo = OLD.EquipoVisitante; 
            UPDATE EquiposB SET GolesLocal = GolesLocal + NEW.GolesLocal
            WHERE  EquiposB.IdEquipo = NEW.EquipoLocal;
            UPDATE EquiposB SET GolesVisitante = GolesVisitante + NEW.GolesVisitante
            WHERE  EquiposB.IdEquipo = NEW.EquipoVisitante;    
    END IF;
END// 
DELIMITER ; 

UNLOCK TABLES;
-- -----------------------------------------------------------------
-- Fin ejercicio completo
-- -----------------------------------------------------------------


-- -----------------------------------------------------------------
-- Auditoría de Bases de Datos
-- -----------------------------------------------------------------
-- 37. Queremos llevar una auditoría de los cambios realizados en los nombres de equipo de la tabla EquiposB. Para cada cambio, guardaremos el momento en que se realizó el cambio, el usuario que lo hace, qué operación se hizo ('Insertar', 'Actualizar' o 'Borrar'), el identificador del equipo modificado, el nombre del equipo antiguo y el nombre del equipo nuevo.
-- Funciones que vamos a usar: SELECT NOW(), USER();
-- Tipos devueltos por las funciones: CHAR(20) y VARCHAR(255)

DROP TABLE IF EXISTS EquiposB; 
CREATE TABLE EquiposB AS SELECT * FROM Equipos; 

DROP TABLE IF EXISTS AuditEquiposB; 
CREATE TABLE AuditEquiposB ( 
  IdAuditEquiposB INT(11) NOT NULL AUTO_INCREMENT, 
  FechaHora       CHAR(20) NOT NULL, 
  Usuario         VARCHAR(255), 
  Operacion       ENUM('Insertar','Actualizar','Borrar') NOT NULL, 
  IdEquipo        INT(11) NOT NULL, 
  EquipoAntiguo   VARCHAR(255) DEFAULT NULL, 
  EquipoNuevo     VARCHAR(255) DEFAULT NULL, 
  PRIMARY KEY (IdAuditEquiposB) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TRIGGER IF EXISTS AfterEquipoBInsert; 
DELIMITER // 
CREATE TRIGGER AfterEquipoBInsert
AFTER INSERT ON EquiposB
FOR EACH ROW
BEGIN
	 INSERT INTO AuditEquiposB VALUES(NULL, Now(), USER(), "Insertar",  NEW.IdEquipo, NULL, NEW.NombreEquipo);
END// 
DELIMITER ;


SELECT * FROM AuditEquiposB;
SELECT * FROM EquiposB;
SELECT Now(), USER();

-- Pruebas:
TRUNCATE TABLE AuditEquiposB; 
DELETE FROM EquiposB WHERE IdEquipo BETWEEN 200 AND 205;
INSERT INTO EquiposB VALUES (200, 'CF Venta de Baños');
INSERT INTO EquiposB VALUES (201, 'Club Natación Alicante'); 
INSERT INTO EquiposB VALUES (202, 'Sociedad Deportiva Cultural Michelín'); 
INSERT INTO EquiposB VALUES (203, 'Mecánico Futbol Club'); 
SELECT * FROM AuditEquiposB;
