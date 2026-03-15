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
DROP PROCEDURE IF EXISTS Ejercicio1;
DELIMITER //

CREATE PROCEDURE Ejercicio1()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS Informacion(
        Nombre VARCHAR(255),
        Tipo VARCHAR(25)
    ) ENGINE = MEMORY;
    
    INSERT INTO Informacion 
    SELECT Nombre, 'País' FROM Pais ORDER BY Poblacion DESC LIMIT 1;
    
    INSERT INTO Informacion 
    SELECT Nombre, 'Ciudad' FROM Ciudad ORDER BY Poblacion DESC LIMIT 1;
    
    INSERT INTO Informacion 
    SELECT Lengua, 'Lengua' FROM LenguaPais GROUP BY Lengua ORDER BY COUNT(*) DESC LIMIT 1;
    
    SELECT * FROM Informacion;
    
    DROP TABLE IF EXISTS Informacion;
END //

DELIMITER ;

CALL Ejercicio1();
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
DROP PROCEDURE IF EXISTS Ejercicio2;
DELIMITER //

CREATE PROCEDURE Ejercicio2(IN pContinente VARCHAR(255))
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS Informacion(
        Nombre VARCHAR(255),
        Tipo VARCHAR(25)
    ) ENGINE = MEMORY;
    
    INSERT INTO Informacion 
    SELECT Nombre, 'País' FROM Pais WHERE Continente = pContinente ORDER BY Poblacion DESC LIMIT 1;
    
    INSERT INTO Informacion 
    SELECT Ciudad.Nombre, 'Ciudad' 
    FROM Ciudad JOIN Pais 
    ON Ciudad.CodigoPais = Pais.Codigo 
    WHERE Pais.Continente = pContinente 
    ORDER BY Ciudad.Poblacion DESC 
    LIMIT 1;
    
    INSERT INTO Informacion 
    SELECT LenguaPais.Lengua, 'Lengua' 
    FROM LenguaPais JOIN Pais 
    ON LenguaPais.CodigoPais = Pais.Codigo
    WHERE Pais.Continente = pContinente
    GROUP BY LenguaPais.Lengua 
    ORDER BY COUNT(*) DESC 
    LIMIT 1;
    
    SELECT * FROM Informacion;
    
    DROP TABLE IF EXISTS Informacion;
END //

DELIMITER ;

CALL Ejercicio2('South America');

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

DROP PROCEDURE IF EXISTS Ejercicio3;
DELIMITER //

CREATE PROCEDURE Ejercicio3(IN n INT)
BEGIN
	DECLARE i INT DEFAULT n;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS CadenaTabla (
        Cadena VARCHAR(255)
    ) ENGINE = MEMORY;
    
    IF n >= 2 AND n <= 9 AND n IS NOT NULL THEN
		
        WHILE i > 0 DO
            INSERT INTO CadenaTabla VALUES(REPEAT("*", n));
            SET i = i - 1;
        END WHILE;
    END IF;
    
    SELECT * FROM CadenaTabla;
    DROP TABLE IF EXISTS CadenaTabla;
END //

DELIMITER ;

CALL Ejercicio3(5);

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
DROP PROCEDURE IF EXISTS Ejercicio4;
DELIMITER //

CREATE PROCEDURE Ejercicio4(IN n INT)
BEGIN
	DECLARE  i INT;
    DECLARE  j INT;
    DECLARE aInsertar VARCHAR(255);
    
	
    CREATE TEMPORARY TABLE IF NOT EXISTS CadenaTabla (
        Cadena VARCHAR(255)
    ) ENGINE = MEMORY;
    
    IF n >= 2 AND n <= 9 AND n IS NOT NULL THEN
        SET i = 1;
        
        WHILE i <= n DO
			SET aInsertar = "";
			SET j =i;
            
			WHILE j <= n DO
                SET aInsertar = CONCAT(aInsertar, j);
                SET j = j + 1;
            END WHILE;
            
            INSERT INTO CadenaTabla VALUES(aInsertar);
            
            SET i = i + 1;
        END WHILE;
    END IF;
	SELECT * FROM     CadenaTabla;
    DROP TABLE IF EXISTS CadenaTabla;
END //

DELIMITER ;

CALL Ejercicio4(5);

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

DROP PROCEDURE IF EXISTS Ejercicio5;
DELIMITER //

CREATE PROCEDURE Ejercicio5(IN n INT)
BEGIN
 DECLARE i INT DEFAULT 1;
 DECLARE j INT DEFAULT 1;
 DECLARE aInsertar VARCHAR(255) DEFAULT "*";
 
 
    CREATE TEMPORARY TABLE IF NOT EXISTS CadenaTabla (
        Cadena VARCHAR(255)
    ) ENGINE = MEMORY;
    
    IF n >= 2 AND n <= 9 AND n IS NOT NULL THEN
    
		INSERT INTO CadenaTabla VALUES(REPEAT("*", n));
             
        WHILE i <= n DO
			WHILE j  <= i DO 
				SET aInsertar = CONCAT(aInsertar, j);
                SET j = j + 1;
            END WHILE;
			INSERT INTO CadenaTabla VALUES(aInsertar);
            SET i = i + 1;
        END WHILE;
        
        
         INSERT INTO CadenaTabla VALUES(REPEAT("*", n));
    END IF;
    
    SELECT * FROM CadenaTabla;
    DROP TABLE IF EXISTS CadenaTabla;
END //

DELIMITER ;

CALL Ejercicio5(5);

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
DROP PROCEDURE IF EXISTS Ejercicio6;
DELIMITER //

CREATE PROCEDURE Ejercicio6(IN minimo INT, IN maximo INT)
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS ASCII_Tabla (
        ValorASCII INT,
        Caracter CHAR(1)
    ) ENGINE = MEMORY;
    
    IF minimo IS NOT NULL AND maximo IS NOT NULL AND minimo <= maximo THEN
        WHILE minimo <= maximo DO
            INSERT INTO ASCII_Tabla VALUES(minimo, CHAR(minimo));
            SET minimo = minimo + 1;
        END WHILE;
    END IF;
    
    SELECT * FROM ASCII_Tabla;
    DROP TABLE IF EXISTS ASCII_Tabla;
END //

DELIMITER ;

CALL Ejercicio6(32, 126);

-- --------------------------------------------------------------------------------------
-- Ejercicio 7. En el Tema 3 realizamos la siguiente consulta: 2. Nombre de los países que tienen dos o más ciudades con dos millones de habitantes como mínimo. Parametriza la consulta para que podamos cambiar tanto el número de ciudades como el número de habitantes. Chequea errores en los parámetros y muestra mensajes descritivos. 
DROP PROCEDURE IF EXISTS Ejercicio7;
DELIMITER //

CREATE PROCEDURE Ejercicio7(IN numCiudades INT, IN numHabitantes INT)
BEGIN
    IF numCiudades IS NULL OR numCiudades < 2 THEN
        SELECT 'El número de ciudades debe ser mayor o igual a 2' AS 'ERROR';
    ELSEIF numHabitantes IS NULL OR numHabitantes < 0 THEN
        SELECT 'El número de habitantes debe ser mayor o igual a 0' AS 'ERROR';
    ELSE
        SELECT 	Pais.Nombre
        FROM 		Pais JOIN Ciudad 
        ON 			Pais.Codigo = Ciudad.CodigoPais
        WHERE 	Ciudad.Poblacion >= numHabitantes
        GROUP BY Pais.Codigo
        HAVING COUNT(*) >= numCiudades;
    END IF;
END //

DELIMITER ;

CALL Ejercicio7(2, 2000000);

-- --------------------------------------------------------------------------------------
-- Ejercicio 8. En el Tema 3 realizamos la siguiente consulta: Listado de los países y el número de ciudades de ese país para los países que tienen más ciudades que España. Parametriza la consulta para que podamos cambiar el país. Chequea errores en el parámetro y muestra mensajes descritivos. 
DROP PROCEDURE IF EXISTS Ejercicio8;
DELIMITER //

CREATE PROCEDURE Ejercicio8(IN paisParam VARCHAR(255))
BEGIN
    DECLARE numCiudadesPais INT;
    
    IF paisParam IS NULL OR paisParam = '' THEN
        SELECT 'El nombre del país no puede ser nulo o vacío' AS 'ERROR';
    ELSEIF NOT EXISTS (SELECT 1 FROM Pais WHERE Nombre = paisParam) THEN
        SELECT CONCAT('El país ', paisParam, ' no existe') AS 'ERROR';
    ELSE
        SET numCiudadesPais = (SELECT COUNT(*) FROM Ciudad JOIN Pais ON Ciudad.CodigoPais = Pais.Codigo WHERE Pais.Nombre = paisParam);
        
        SELECT Pais.Nombre AS 'País', COUNT(Ciudad.Nombre) AS 'Número de ciudades'
        FROM 	Pais LEFT JOIN Ciudad 
        ON 		Pais.Codigo = Ciudad.CodigoPais
        GROUP BY Pais.Codigo
        HAVING COUNT(Ciudad.Nombre) > numCiudadesPais;
    END IF;
END //

DELIMITER ;

CALL Ejercicio8('Spain');

-- --------------------------------------------------------------------------------------
-- Ejercicio 9. Crea una función que nos indique el número de palabras de una cadena. Para ello recorreremos la cadena de entrada. Entendemos como palabra cualquier secuencia segida de letras, letras acentuadas y dígitos; cualquier otra secuencia de uno o más carácteres es un separador: espacio, coma, punto, etc.
DROP FUNCTION IF EXISTS NumeroPalabras;
DELIMITER //

CREATE FUNCTION NumeroPalabras(cadena VARCHAR(255)) RETURNS INT
BEGIN
    DECLARE contador INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE esPalabra BOOL DEFAULT FALSE;
    DECLARE caracter CHAR(1);
    DECLARE longitud INT;
    
    IF cadena IS NULL OR cadena = '' THEN
        RETURN 0;
    END IF;
    
    SET longitud = CHAR_LENGTH(cadena);
    
    WHILE i < longitud DO
        SET caracter = SUBSTRING(cadena, i, 1);
        
        IF caracter REGEXP '[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9]' THEN
            IF NOT esPalabra THEN
                SET contador = contador + 1;
                SET esPalabra = TRUE;
            END IF;
        ELSE
            SET esPalabra = FALSE;
        END IF;
        
        SET i = i + 1;
    END WHILE;
    
    RETURN contador;
END //

DELIMITER ;

SELECT NumeroPalabras('Hola mundo, esto es una prueba');

-- --------------------------------------------------------------------------------------
-- Ejercicio 10. Crea una función que nos indique si la cadena introducida es palíndromo. Entendemos como palíndromos:  radar, recognizing, rotor, salas, seres, etc.
DROP FUNCTION IF EXISTS EsPalindromo;
DELIMITER //

CREATE FUNCTION EsPalindromo(cadena VARCHAR(255)) RETURNS BOOL
BEGIN
    IF cadena IS NULL OR cadena = "" THEN
        RETURN FALSE;
    END IF;
    
    RETURN cadena = REVERSE(cadena);
END //

DELIMITER ;

SELECT EsPalindromo('radar'), EsPalindromo("recognizing"), EsPalindromo("rotor"), EsPalindromo('hola');

-- --------------------------------------------------------------------------------------
-- Ejercicio 11. Crea una función que nos indique si la cadena introducida es palíndromo. Entendemos como palíndromos:  radar, recognizing, rotor, salas, seres, etc. USA un bucle y la funión SUBSTR() para comprobar el carácter de una posición concreta en la cadena.
DROP FUNCTION IF EXISTS EsPalindromo2;
DELIMITER //

CREATE FUNCTION EsPalindromo2(cadena VARCHAR(255)) RETURNS BOOL
BEGIN
    DECLARE j INT;
    DECLARE cadenaAlReves VARCHAR(255) DEFAULT "";
    

    
    IF cadena IS NULL OR cadena = "" THEN
        RETURN FALSE;
    END IF;
    
    SET j = CHAR_LENGTH(cadena);
    
    WHILE j >= 1 DO
		SET cadenaAlReves = CONCAT(cadenaAlReves, SUBSTRING(cadena, j, 1));
        
        SET j = j - 1;
    END WHILE;
    
    RETURN cadena = cadenaAlReves;
END //

DELIMITER ;

SELECT EsPalindromo2('radar'), EsPalindromo2('hola');

-- --------------------------------------------------------------------------------------
-- Ejercicio 12. Crea una función que nos indique si la cadena introducida es palíndromo sin tener en cuenta los espacios en blanco y signos de puntuación. En este caso serían palíndromos: "Añora la Roña", "La ruta, natural", etc.
DROP FUNCTION IF EXISTS EsPalindromo3;
DELIMITER //

CREATE FUNCTION EsPalindromo3(cadena VARCHAR(255)) RETURNS BOOL
BEGIN
    DECLARE cadenaLimpia VARCHAR(255);
    DECLARE caracter CHAR(1);
    DECLARE i INT;
    
    IF cadena IS NULL OR cadena = '' THEN
        RETURN FALSE;
    END IF;
    
    
   SET cadenaLimpia = "";
   SET i =1;
	WHILE i <= CHAR_LENGTH(cadena) DO
		SET caracter = LOWER(SUBSTRING(cadena, i, 1));
		IF caracter REGEXP '[a-záéíóúñ0-9]' THEN
			SET cadenaLimpia = CONCAT(cadenaLimpia, caracter);
		END IF;
		SET i = i + 1;
	END WHILE;

    SET i = 1;
    WHILE i <= CHAR_LENGTH(cadenaLimpia) / 2 DO
		IF SUBSTRING(cadenaLimpia, i, 1) != SUBSTRING(cadenaLimpia, CHAR_LENGTH(cadenaLimpia) + 1 - i, 1) 
			THEN RETURN FALSE;
        END IF;
        
        SET i = i + 1;
    END WHILE;
    
    RETURN TRUE;
END //

DELIMITER ;

SELECT EsPalindromo3('Añora la Roña'), EsPalindromo3('La ruta natural'), EsPalindromo3("hola");

-- --------------------------------------------------------------------------------------
-- Ejercicio 13. Crea una fución que nos indique si el número que le pasamos como parámetro es primo. un número primo es un número natural mayor que 1 que tiene únicamente dos divisores distintos: él mismo y el 1. 
DROP FUNCTION IF EXISTS EsPrimo;
DELIMITER //

CREATE FUNCTION EsPrimo(numero INT) RETURNS BOOL
BEGIN
    DECLARE i INT DEFAULT 2;
    
    IF numero IS NULL OR numero <= 1 THEN
        RETURN FALSE;
    END IF;
    
    WHILE i <= SQRT(numero) DO
        IF numero % i = 0 THEN
            RETURN FALSE;
        END IF;
        SET i = i + 1;
    END WHILE;
    
    RETURN TRUE;
END //

DELIMITER ;

SELECT EsPrimo(7), EsPrimo(4), EsPrimo(1);

-- --------------------------------------------------------------------------------------
-- Ejercicio 14. Crea un procedimiento que de un listado de ciudades ordenado por poblacion ascendente, nos de la ciudades que ocupan las posiciones 1, 10, 20, 30 ,..., 980, 990, 1000 (acabará aquí). Usa un cursor.
DROP PROCEDURE IF EXISTS Ejercicio14;
DELIMITER //

CREATE PROCEDURE Ejercicio14()
BEGIN
    DECLARE vNombre VARCHAR(255);
    DECLARE vPoblacion INT;
    DECLARE vPosicion INT DEFAULT 1;
    DECLARE contador INT DEFAULT 1;
    DECLARE finCur BOOL DEFAULT FALSE;
    
    DECLARE curCiudades CURSOR FOR
        SELECT Nombre, Poblacion FROM Ciudad ORDER BY Poblacion ASC;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCur = TRUE;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS PosicionesCiudades (
        Posicion INT,
        Nombre VARCHAR(255),
        Poblacion INT
    ) ENGINE = MEMORY;
    
    OPEN curCiudades;
    
    Bucle: LOOP
        FETCH curCiudades INTO vNombre, vPoblacion;
        IF finCur THEN LEAVE Bucle; END IF;
        
        IF contador = vPosicion THEN
            INSERT INTO PosicionesCiudades VALUES(vPosicion, vNombre, vPoblacion);
            
            IF vPosicion = 1 
				THEN SET vPosicion = 10; 
				ELSE SET vPosicion = vPosicion + 10; 
            END IF;
        END IF;
        
        SET contador = contador + 1;
        
        IF vPosicion > 1000 THEN LEAVE Bucle; END IF;
    END LOOP Bucle;
    
    CLOSE curCiudades;
    
    SELECT * FROM PosicionesCiudades;
    DROP TABLE IF EXISTS PosicionesCiudades;
END //

DELIMITER ;

CALL Ejercicio14();

-- --------------------------------------------------------------------------------------
-- Ejercicio 15. Crea un procedimiento que de un listado de países ordenado por fecha de independencia de manera que para cada país muestre el incremento o decremento del PNB entre ese país y el país anterior de la lista. Para el primer país y cuando uno de los PNB sea nulo, mostrará n/a.
DROP PROCEDURE IF EXISTS Ejercicio15;
DELIMITER //

CREATE PROCEDURE Ejercicio15()
BEGIN
    DECLARE vNombre VARCHAR(255);
    DECLARE vAnyIndep INT;
    DECLARE vPNB DECIMAL(10,2);
    DECLARE vPNBAnterior DECIMAL(10,2) DEFAULT NULL;
    DECLARE finCur BOOL DEFAULT FALSE;
    
	DECLARE curPaises CURSOR FOR
		SELECT Nombre, AnyIndep, PNB FROM Pais WHERE AnyIndep IS NOT NULL ORDER BY AnyIndep ASC;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCur = TRUE;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS PaisesPNB (
        Nombre VARCHAR(255),
        AnyoIndependencia INT,
        PNB DECIMAL(10,2),
        VariacionPNB VARCHAR(255)
    ) ENGINE = MEMORY;
    
    OPEN curPaises;
    
    Bucle: LOOP
        FETCH curPaises INTO vNombre, vAnyIndep, vPNB;
        IF finCur THEN LEAVE Bucle; END IF;
        
        IF vPNBAnterior IS NULL OR vPNB IS NULL THEN
            INSERT INTO PaisesPNB VALUES(vNombre, vAnyIndep, vPNB, 'n/a');
        ELSE
            INSERT INTO PaisesPNB VALUES(vNombre, vAnyIndep, vPNB, CONCAT(ROUND(vPNB - vPNBAnterior, 2)));
        END IF;
        
        SET vPNBAnterior = vPNB;
    END LOOP Bucle;
    
    CLOSE curPaises;
    
    SELECT * FROM PaisesPNB;
    DROP TABLE IF EXISTS PaisesPNB;
END //

DELIMITER ;

CALL Ejercicio15();

-- --------------------------------------------------------------------------------------
-- Ejercicio 16. Vamos a añadir un campo a la tabla país que indique la suma de la población de sus ciudades, actualizaremos este campo con los valores reales, añadiremos también los diparadores necesarios para mantener este nuevo campo actualizado antes modificaciones de la tabla de ciudades e incluiremos el código necesario para probarlo todo.
ALTER TABLE Pais ADD COLUMN PoblacionTotal INT DEFAULT 0;

UPDATE Pais SET PoblacionTotal = (
    SELECT COALESCE(SUM(Poblacion), 0) FROM Ciudad WHERE Ciudad.CodigoPais = Pais.Codigo
);

DROP TRIGGER IF EXISTS AfterCiudadInsert;
DELIMITER //

CREATE TRIGGER AfterCiudadInsert
AFTER INSERT ON Ciudad
FOR EACH ROW
BEGIN
    UPDATE Pais SET PoblacionTotal = PoblacionTotal + NEW.Poblacion
    WHERE Codigo = NEW.CodigoPais;
END //

DELIMITER ;

DROP TRIGGER IF EXISTS AfterCiudadDelete;
DELIMITER //

CREATE TRIGGER AfterCiudadDelete
AFTER DELETE ON Ciudad
FOR EACH ROW
BEGIN
    UPDATE Pais SET PoblacionTotal = PoblacionTotal - OLD.Poblacion
    WHERE Codigo = OLD.CodigoPais;
END //

DELIMITER ;

DROP TRIGGER IF EXISTS AfterCiudadUpdate;
DELIMITER //

CREATE TRIGGER AfterCiudadUpdate
AFTER UPDATE ON Ciudad
FOR EACH ROW
BEGIN
    IF OLD.CodigoPais != NEW.CodigoPais OR OLD.Poblacion != NEW.Poblacion THEN
        UPDATE Pais SET PoblacionTotal = PoblacionTotal - OLD.Poblacion
        WHERE Codigo = OLD.CodigoPais;
        UPDATE Pais SET PoblacionTotal = PoblacionTotal + NEW.Poblacion
        WHERE Codigo = NEW.CodigoPais;
    END IF;
END //

DELIMITER ;

-- Prueba
SELECT Nombre, PoblacionTotal FROM Pais WHERE Codigo = 'ESP';
INSERT INTO Ciudad VALUES (NULL, 'PruebaCiudad', 'ESP', 100000);
SELECT Nombre, PoblacionTotal FROM Pais WHERE Codigo = 'ESP';
DELETE FROM Ciudad WHERE Nombre = 'PruebaCiudad' AND CodigoPais = 'ESP';

-- --------------------------------------------------------------------------------------
-- Ejercicio 17. Queremos realizar una auditoría sobre los cambios realizados en el código y el nombre de los países. Incluye el código que crea la tabla, los disparadores y las pruebas realizadas para ver que todo va bien.
DROP TABLE IF EXISTS AuditPais;
CREATE TABLE AuditPais (
    IdAudit INT NOT NULL AUTO_INCREMENT,
    FechaHora CHAR(20),
    Usuario VARCHAR(255),
    Operacion ENUM('Insertar', 'Actualizar', 'Borrar'),
    CodigoAntiguo CHAR(3),
    CodigoNuevo CHAR(3),
    NombreAntiguo VARCHAR(255),
    NombreNuevo VARCHAR(255),
    PRIMARY KEY (IdAudit)
) ENGINE = InnoDB;

DROP TRIGGER IF EXISTS AfterPaisInsert;
DELIMITER //

CREATE TRIGGER AfterPaisInsert
AFTER INSERT ON Pais
FOR EACH ROW
BEGIN
    INSERT INTO AuditPais VALUES (NULL, NOW(), USER(), 'Insertar', NULL, NEW.Codigo, NULL, NEW.Nombre);
END //

DELIMITER ;

DROP TRIGGER IF EXISTS AfterPaisUpdate;
DELIMITER //

CREATE TRIGGER AfterPaisUpdate
AFTER UPDATE ON Pais
FOR EACH ROW
BEGIN
    INSERT INTO AuditPais VALUES (NULL, NOW(), USER(), 'Actualizar', OLD.Codigo, NEW.Codigo, OLD.Nombre, NEW.Nombre);
END //

DELIMITER ;

DROP TRIGGER IF EXISTS AfterPaisDelete;
DELIMITER //

CREATE TRIGGER AfterPaisDelete
AFTER DELETE ON Pais
FOR EACH ROW
BEGIN
    INSERT INTO AuditPais VALUES (NULL, NOW(), USER(), 'Borrar', OLD.Codigo, NULL, OLD.Nombre, NULL);
END //

DELIMITER ;

-- Pruebas
INSERT INTO Pais VALUES ('ZZZ', 'País de Prueba', 'Europe', 1000000, 1000, 80, '2024-01-01', 'Test', 1000);
UPDATE Pais SET Nombre = 'País de Prueba Modificado' WHERE Codigo = 'ZZZ';
DELETE FROM Pais WHERE Codigo = 'ZZZ';
SELECT * FROM AuditPais;

-- --------------------------------------------------------------------------------------
-- Ejercicio 18. De un listado de ciudades ordenado alfabéticamente y, si dos ciudades tienen el mismo nombre, ordenado por población; necesitamos saber cuántos grupos hay en los que cuatro o más ciudades pertenecen al mismo país.
DROP PROCEDURE IF EXISTS Ejercicio18;
DELIMITER //

CREATE PROCEDURE Ejercicio18()
BEGIN
    SELECT CodigoPais AS 'Código de País', COUNT(*) AS 'Cantidad de Ciudades'
    FROM Ciudad
    GROUP BY CodigoPais
    HAVING COUNT(*) >= 4 
    ORDER BY COUNT(*) DESC;
END //

DELIMITER ;

CALL Ejercicio18();

-- --------------------------------------------------------------------------------------
-- Ejercicio 19. Parametrizar el procedimiento anterior para que le podamos indicar el número máximo de repeticiones
DROP PROCEDURE IF EXISTS Ejercicio19;
DELIMITER //

CREATE PROCEDURE Ejercicio19(IN minimo INT)
BEGIN
    IF minimo IS NULL OR minimo < 2 THEN
        SELECT 'El número mínimo debe ser mayor o igual a 2' AS 'ERROR';
    ELSE
        SELECT CodigoPais AS 'Código de País', COUNT(*) AS 'Cantidad de Ciudades'
        FROM Ciudad
        GROUP BY CodigoPais
        HAVING COUNT(*) >= minimo
        ORDER BY COUNT(*) DESC;
    END IF;
END //

DELIMITER ;

CALL Ejercicio19(4);

-- --------------------------------------------------------------------------------------
-- Ejercicio 20. Crea una tabla temporal donde se guardarán los datos de las repeticiones. Esta tabla será el resultado que devolverá el procedimiento
DROP PROCEDURE IF EXISTS Ejercicio20;
DELIMITER //

CREATE PROCEDURE Ejercicio20(IN minimo INT)
BEGIN
    IF minimo IS NULL OR minimo < 2 THEN
        SELECT 'El número mínimo debe ser mayor o igual a 2' AS 'ERROR';
    ELSE
        CREATE TEMPORARY TABLE IF NOT EXISTS CiudadPais(
            Codigo CHAR(3),
            Nombre CHAR(52)
        ) ENGINE = MEMORY;
        
        INSERT INTO CiudadPais
        SELECT Pais.Codigo, Pais.Nombre
        FROM Pais
        JOIN (
            SELECT CodigoPais, COUNT(*) AS num
            FROM Ciudad
            GROUP BY CodigoPais
            HAVING num >= minimo
        ) sub ON Pais.Codigo = sub.CodigoPais;
        
        SELECT * FROM CiudadPais;
        DROP TABLE IF EXISTS CiudadPais;
    END IF;
END //

DELIMITER ;

CALL Ejercicio20(4);

-- --------------------------------------------------------------------------------------
-- Ejercicio 21. Modificar el procedimiento anterior para comprobar que el número de repeticiones sea mayor o igual que dos. Si no lo es se mostrará un error descriptivo.
DROP PROCEDURE IF EXISTS Ejercicio21;
DELIMITER //

CREATE PROCEDURE Ejercicio21(IN minimo INT)
BEGIN
    IF minimo IS NULL OR minimo < 2 THEN
        SELECT 'El número de repeticiones debe ser mayor o igual a 2' AS 'ERROR';
    ELSE
        CREATE TEMPORARY TABLE IF NOT EXISTS CiudadPais(
            Codigo CHAR(3),
            Nombre CHAR(52)
        ) ENGINE = MEMORY;
        
        INSERT INTO CiudadPais
        SELECT Pais.Codigo, Pais.Nombre
        FROM Pais
        JOIN (
            SELECT CodigoPais, COUNT(*) AS num
            FROM Ciudad
            GROUP BY CodigoPais
            HAVING num >= minimo
        ) sub ON Pais.Codigo = sub.CodigoPais;
        
        SELECT * FROM CiudadPais;
        DROP TABLE IF EXISTS CiudadPais;
    END IF;
END //

DELIMITER ;

CALL Ejercicio21(2);

-- --------------------------------------------------------------------------------------
-- Ejercicio 22. Calcula la suma de todos los dígitos de todos los número presentes en una base de datos de números enteros positivos. Para probar el algoritmo llenaremos la BD con números enteros aleatorios positivos. Por ejemplo, si la base de datos contiene los número 12, 33 y 67 el resultado será 1+2 + 3+3 + 6+7= 22.

-- Tabla de prueba
DROP TABLE IF EXISTS Numeros;
CREATE TABLE Numeros (
    numero INT PRIMARY KEY
);

INSERT INTO Numeros VALUES (12), (33), (67);

-- Función auxiliar: suma los dígitos de un número
DROP FUNCTION IF EXISTS SumaDigitosNumero;
DELIMITER //

CREATE FUNCTION SumaDigitosNumero(numero INT) RETURNS INT
BEGIN
    DECLARE suma INT DEFAULT 0;
    DECLARE digito INT;
    
    IF numero IS NULL OR numero < 0 THEN
        RETURN 0;
    END IF;
    
    WHILE numero > 0 DO
        SET digito = numero % 10;
        SET suma = suma + digito;
        SET numero = numero DIV 10;
    END WHILE;
    
    RETURN suma;
END //

DELIMITER ;

-- Procedimiento con cursor
DROP PROCEDURE IF EXISTS Ejercicio22;
DELIMITER //

CREATE PROCEDURE Ejercicio22()
BEGIN
    DECLARE vNumero INT;
    DECLARE sumaTotal INT DEFAULT 0;
    DECLARE finCur BOOL DEFAULT FALSE;
    
    DECLARE curNumeros CURSOR FOR SELECT numero FROM Numeros;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCur = TRUE;
    
    OPEN curNumeros;
    
    Bucle: LOOP
        FETCH curNumeros INTO vNumero;
        IF finCur THEN LEAVE Bucle; END IF;
        
        SET sumaTotal = sumaTotal + SumaDigitosNumero(vNumero);
    END LOOP Bucle;
    
    CLOSE curNumeros;
    
    SELECT sumaTotal AS 'Suma total de digitos';
END //

DELIMITER ;

CALL Ejercicio22();

-- --------------------------------------------------------------------------------------
-- Ejercicio 23. Dada una BD de palabras, realiza un procedimiento que guarde en otra tabla con las letras del abecedario el número de apariciones de cada letra. Todas las letras se pasarán a minúsculas. No se tendrán en cuenta los caracteres que aparezcan en las palabras pero que no estén en la tabla Letras.

DROP TABLE IF EXISTS Palabras;
CREATE TABLE Palabras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    palabra VARCHAR(255)
);

INSERT INTO Palabras (palabra) VALUES ('Hola'), ('Mundo'), ('Programacion'), ('Base de Datos');

DROP TABLE IF EXISTS Letras;
CREATE TABLE Letras (
    letra CHAR(1) PRIMARY KEY
);

INSERT INTO Letras (letra) VALUES 
    ('a'), ('b'), ('c'), ('d'), ('e'), ('f'), ('g'), ('h'), ('i'), ('j'), 
    ('k'), ('l'), ('m'), ('n'), ('o'), ('p'), ('q'), ('r'), ('s'), ('t'), 
    ('u'), ('v'), ('w'), ('x'), ('y'), ('z');

DROP PROCEDURE IF EXISTS Ejercicio23;
DELIMITER //

CREATE PROCEDURE Ejercicio23()
BEGIN
    DECLARE vPalabra VARCHAR(255);
    DECLARE vCaracter CHAR(1);
    DECLARE finCurPalabras BOOL DEFAULT FALSE;
    DECLARE finCurLetras BOOL DEFAULT FALSE;
    
    -- Cursor para recorrer las palabras
    DECLARE curPalabras CURSOR FOR SELECT palabra FROM Palabras;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCurPalabras = TRUE;
    
    -- Tabla de resultado
    DROP TABLE IF EXISTS ConteoLetras;
    CREATE TABLE ConteoLetras (
        letra CHAR(1),
        cantidad INT DEFAULT 0,
        PRIMARY KEY (letra)
    );
    
    -- Inicializar tabla con todas las letras
    INSERT INTO ConteoLetras (letra, cantidad)
    SELECT letra, 0 FROM Letras;
    
    OPEN curPalabras;
    
    BuclePalabras: LOOP
        FETCH curPalabras INTO vPalabra;
        IF finCurPalabras THEN LEAVE BuclePalabras; END IF;
        
        -- Procesar cada carácter de la palabra
        WHILE CHAR_LENGTH(vPalabra) > 0 DO
            SET vCaracter = LOWER(LEFT(vPalabra, 1));
            
            IF vCaracter REGEXP '[a-z]' THEN
                UPDATE ConteoLetras SET cantidad = cantidad + 1 WHERE letra = vCaracter;
            END IF;
            
            SET vPalabra = SUBSTRING(vPalabra, 2);
        END WHILE;
    END LOOP BuclePalabras;
    
    CLOSE curPalabras;
    
    SELECT * FROM ConteoLetras ORDER BY cantidad DESC;
END //

DELIMITER ;



CALL Ejercicio23();

-- Código que se da a los alumnos
-- Enlaces a las fuentes utilizadas para los ejercicios numéricos:
-- Matemática recreativa: https://es.wikipedia.org/wiki/Categor%C3%ADa:Matem%C3%A1tica_recreativa
-- Tipos de números: https://www.gaussianos.com/tipos-de-numeros/
-- The On-Line Encyclopedia of Integer Sequences. Lucky numbers
-- http://oeis.org/A000959
-- Proyecto Euler. Muy interesante para problemas matemáticos: https://projecteuler.net/about cuenta creada con leonomis
-- --------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------
-- Ejercicio 24. Crea subprograma (procedimiento o función alamacenados) que nos indique si un número es perfecto:
/*
Número perfecto: todo número natural que es igual a la suma de sus divisores propios (es decir, todos sus divisores excepto el propio número). Por ejemplo, 6 es un número perfecto ya que sus divisores propios son 1, 2, y 3 y se cumple que 1+2+3=6. Los números 28, 496 y 8128 también son perfectos.
*/

-- Función auxiliar para sumar divisores propios
DROP FUNCTION IF EXISTS SumaDivisores;
DELIMITER //

CREATE FUNCTION SumaDivisores(numero INT) RETURNS INT
BEGIN
    DECLARE suma INT DEFAULT 0;
    DECLARE i INT DEFAULT 1;
    
    IF numero IS NULL OR numero <= 0 THEN
        RETURN 0;
    END IF;
    
    WHILE i < numero DO
        IF numero % i = 0 THEN
            SET suma = suma + i;
        END IF;
        SET i = i + 1;
    END WHILE;
    
    RETURN suma;
END //

DELIMITER ;

-- Función: ¿Es número perfecto?
DROP FUNCTION IF EXISTS EsPerfecto;
DELIMITER //

CREATE FUNCTION EsPerfecto(numero INT) RETURNS BOOL
BEGIN
    IF numero IS NULL OR numero <= 0 THEN
        RETURN FALSE;
    END IF;
    
    RETURN SumaDivisores(numero) = numero;
END //

DELIMITER ;

SELECT EsPerfecto(6), EsPerfecto(28), EsPerfecto(12);

-- --------------------------------------------------------------------------------------
-- Ejercicio 25. Crea un subprograma que nos saque por pantalla los números perfectos comprendidos entre un rango de números que le pasaremos como parámetro
DROP PROCEDURE IF EXISTS Ejercicio25;
DELIMITER //

CREATE PROCEDURE Ejercicio25(IN inicio INT, IN fin INT)
BEGIN
    DECLARE i INT;
    
CREATE TEMPORARY TABLE IF NOT EXISTS NumerosPerfectos (
            numero INT PRIMARY KEY
        ) ENGINE = MEMORY;

    IF inicio IS NULL OR fin IS NULL OR inicio > fin THEN
        SELECT 'Los parámetros no son válidos' AS 'ERROR';
    ELSE
      
  
        SET i = inicio;
        WHILE i <= fin DO
            IF EsPerfecto(i) THEN
                INSERT INTO NumerosPerfectos VALUES (i);
            END IF;
            SET i = i + 1;
        END WHILE;
    END IF;

    SELECT numero AS "Numeros Perfectos" FROM NumerosPerfectos;
    DROP TABLE IF EXISTS NumerosPerfectos;
END //

DELIMITER ;

CALL Ejercicio25(1, 500);

-- --------------------------------------------------------------------------------------
-- Ejercicio 26. Crea un subprograma que alamacene en una tabla los números perfectos comprendidos entre un rango de números que le pasaremos como parámetro
DROP TABLE IF EXISTS NumerosPerfectos;
CREATE TABLE NumerosPerfectos (
    numero INT PRIMARY KEY
);

DROP PROCEDURE IF EXISTS Ejercicio26;
DELIMITER //

CREATE PROCEDURE Ejercicio26(IN inicio INT, IN fin INT)
BEGIN
    DECLARE i INT;
    
    IF inicio IS NULL OR fin IS NULL OR inicio > fin THEN
        SELECT 'Los parámetros no son válidos' AS 'ERROR';
    ELSE
        TRUNCATE TABLE NumerosPerfectos;
        SET i = inicio;
        WHILE i <= fin DO
            IF EsPerfecto(i) THEN
                INSERT INTO NumerosPerfectos VALUES (i);
            END IF;
            SET i = i + 1;
        END WHILE;
        
        SELECT * FROM NumerosPerfectos;
    END IF;
END //

DELIMITER ;

CALL Ejercicio26(1, 100);

-- --------------------------------------------------------------------------------------
-- Ejercicio 27.  Crea subprograma que nos indique si un número es abundante:
/*
Número abundante: todo número natural que cumple que la suma de sus divisores propios es mayor que el propio número. Por ejemplo, 12 es abundante ya que sus divisores son 1, 2, 3, 4 y 6 y se cumple que 1+2+3+4+6=16, que es mayor que el propio 12.
*/
DROP FUNCTION IF EXISTS EsAbundante;
DELIMITER //

CREATE FUNCTION EsAbundante(numero INT) RETURNS BOOL
BEGIN
    IF numero IS NULL OR numero <= 0 THEN
        RETURN FALSE;
    END IF;
    
    RETURN SumaDivisores(numero) > numero;
END //

DELIMITER ;

SELECT EsAbundante(12), EsAbundante(6), EsAbundante(18);

-- --------------------------------------------------------------------------------------
-- Ejercicio 28. Crea un subprograma que nos saque por pantalla los números abundantes comprendidos entre un rango de números que le pasaremos como parámetro
DROP PROCEDURE IF EXISTS Ejercicio28;
DELIMITER //

CREATE PROCEDURE Ejercicio28(IN inicio INT, IN fin INT)
BEGIN
    DECLARE i INT;
    
    IF inicio IS NULL OR fin IS NULL OR inicio > fin THEN
        SELECT 'Los parámetros no son válidos' AS 'ERROR';
    ELSE
        SET i = inicio;
        WHILE i <= fin DO
            IF EsAbundante(i) THEN
                SELECT i AS 'Número Abundante', SumaDivisores(i) AS 'Suma de divisores';
            END IF;
            SET i = i + 1;
        END WHILE;
    END IF;
END //

DELIMITER ;

CALL Ejercicio28(1, 30);

-- --------------------------------------------------------------------------------------
-- Ejercicio 29. Crea un subprograma que alamacene en una tabla los números abundantes comprendidos entre un rango de números que le pasaremos como parámetro
DROP TABLE IF EXISTS NumerosAbundantes;
CREATE TABLE NumerosAbundantes (
    numero INT PRIMARY KEY,
    sumaDivisores INT
);

DROP PROCEDURE IF EXISTS Ejercicio29;
DELIMITER //

CREATE PROCEDURE Ejercicio29(IN inicio INT, IN fin INT)
BEGIN
    DECLARE i INT;
    
    IF inicio IS NULL OR fin IS NULL OR inicio > fin THEN
        SELECT 'Los parámetros no son válidos' AS 'ERROR';
    ELSE
        TRUNCATE TABLE NumerosAbundantes;
        SET i = inicio;
        WHILE i <= fin DO
            IF EsAbundante(i) THEN
                INSERT INTO NumerosAbundantes VALUES (i, SumaDivisores(i));
            END IF;
            SET i = i + 1;
        END WHILE;
        
        SELECT * FROM NumerosAbundantes;
    END IF;
END //

DELIMITER ;

CALL Ejercicio29(1, 100);

-- --------------------------------------------------------------------------------------
-- Ejercicio 30. Crea un subprograma que alamacene en una tabla los números deficientes comprendidos entre un rango de números que le pasaremos como parámetro
/*
Número deficiente: todo número natural que cumple que la suma de sus divisores propios es menor que el propio número. Por ejemplo, 16 es un número deficiente ya que sus divisores propios son 1, 2, 4 y 8 y se cumple que 1+2+4+8=15, que es menor que 16.
*/
DROP FUNCTION IF EXISTS EsDeficiente;
DELIMITER //

CREATE FUNCTION EsDeficiente(numero INT) RETURNS BOOL
BEGIN
    IF numero IS NULL OR numero <= 0 THEN
        RETURN FALSE;
    END IF;
    
    RETURN SumaDivisores(numero) < numero;
END //

DELIMITER ;

DROP TABLE IF EXISTS NumerosDeficientes;
CREATE TABLE NumerosDeficientes (
    numero INT PRIMARY KEY,
    sumaDivisores INT
);

DROP PROCEDURE IF EXISTS Ejercicio30;
DELIMITER //

CREATE PROCEDURE Ejercicio30(IN inicio INT, IN fin INT)
BEGIN
    DECLARE i INT;
    
    IF inicio IS NULL OR fin IS NULL OR inicio > fin THEN
        SELECT 'Los parámetros no son válidos' AS 'ERROR';
    ELSE
        TRUNCATE TABLE NumerosDeficientes;
        SET i = inicio;
        WHILE i <= fin DO
            IF EsDeficiente(i) THEN
                INSERT INTO NumerosDeficientes VALUES (i, SumaDivisores(i));
            END IF;
            SET i = i + 1;
        END WHILE;
        
        SELECT * FROM NumerosDeficientes;
    END IF;
END //

DELIMITER ;

CALL Ejercicio30(1, 30);

-- --------------------------------------------------------------------------------------
-- Ejercicio 31. Crea subprograma que nos indique si un número es apocalíptico:
/*
Número apocalíptico: todo número natural n que cumple que 2^n contiene la secuencia 666. Por ejemplo, los números 157 y 192 son números apocalípticos.  Nota: el número 2^192 es tan grande que aunque es apocalíptico, MySQL dice que no lo es, incluso aunque se declaren las variables como FLOAT(65)
*/-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS EsApocaliptico;
DELIMITER //

CREATE FUNCTION EsApocaliptico(n INT) RETURNS BOOL
BEGIN
    DECLARE potencia VARCHAR(1000);
    
    IF n IS NULL OR n < 0 THEN
        RETURN FALSE;
    END IF;
    
    SET potencia = CAST(POW(2, n) AS CHAR);
    
    RETURN INSTR(potencia, '666') > 0;
END //

DELIMITER ;

SELECT EsApocaliptico(157), EsApocaliptico(192), EsApocaliptico(100);

-- --------------------------------------------------------------------------------------
-- Ejercicio 32. Crea un subprograma que nos saque por pantalla los números apocalípticos comprendidos entre un rango de números que le pasaremos como parámetro
DROP PROCEDURE IF EXISTS Ejercicio32;
DELIMITER //

CREATE PROCEDURE Ejercicio32(IN inicio INT, IN fin INT)
BEGIN
    DECLARE i INT;
    
    IF inicio IS NULL OR fin IS NULL OR inicio > fin THEN
        SELECT 'Los parámetros no son válidos' AS 'ERROR';
    ELSE
        SET i = inicio;
        WHILE i <= fin DO
            IF EsApocaliptico(i) THEN
                SELECT i AS 'Número Apocalíptico';
            END IF;
            SET i = i + 1;
        END WHILE;
    END IF;
END //

DELIMITER ;

CALL Ejercicio32(1, 200);

-- --------------------------------------------------------------------------------------
-- Ejercicio 33. Crea un subprograma que alamacene en una tabla los números apocalípticos comprendidos entre un rango de números que le pasaremos como parámetro
DROP TABLE IF EXISTS NumerosApocalipticos;
CREATE TABLE NumerosApocalipticos (
    numero INT PRIMARY KEY
);

DROP PROCEDURE IF EXISTS Ejercicio33;
DELIMITER //

CREATE PROCEDURE Ejercicio33(IN inicio INT, IN fin INT)
BEGIN
    DECLARE i INT;
    
    IF inicio IS NULL OR fin IS NULL OR inicio > fin THEN
        SELECT 'Los parámetros no son válidos' AS 'ERROR';
    ELSE
        TRUNCATE TABLE NumerosApocalipticos;
        SET i = inicio;
        WHILE i <= fin DO
            IF EsApocaliptico(i) THEN
                INSERT INTO NumerosApocalipticos VALUES (i);
            END IF;
            SET i = i + 1;
        END WHILE;
        
        SELECT * FROM NumerosApocalipticos;
    END IF;
END //

DELIMITER ;

CALL Ejercicio33(1, 500);

-- --------------------------------------------------------------------------------------
-- Ejercicio 34. Crea un subprograma que alamacene en una tabla todos los números entre un rango de números que le pasaremos como parámetro y que indicará en la misma tabla si cada número es feliz o infeliz:
/*
Número feliz: todo número natural que cumple que si sumamos los cuadrados de sus dígitos y seguimos el proceso con los resultados obtenidos el resultado es 1. Por ejemplo, el número 203 es un número feliz ya que 2^2+0^2+3^2=13; 1^2+3^2=10; 1^2+0^2=1.
Número infeliz: todo número natural que no es un número feliz. Por ejemplo, el número 16 es un número infeliz.
*/

-- Función: suma de cuadrados de dígitos
DROP FUNCTION IF EXISTS SumaCuadradosDigitos;
DELIMITER //

CREATE FUNCTION SumaCuadradosDigitos(numero INT) RETURNS INT
BEGIN
    DECLARE suma INT DEFAULT 0;
    DECLARE digito INT;
    
    IF numero IS NULL OR numero < 0 THEN
        RETURN 0;
    END IF;
    
    WHILE numero > 0 DO
        SET digito = numero % 10;
        SET suma = suma + (digito * digito);
        SET numero = numero / 10;
    END WHILE;
    
    RETURN suma;
END //

DELIMITER ;

-- Función: verificar si es feliz (llega a 1)
DROP FUNCTION IF EXISTS EsFeliz;
DELIMITER //

CREATE FUNCTION EsFeliz(n INT) RETURNS BOOL
BEGIN
    DECLARE actual INT;
    DECLARE visited VARCHAR(1000);
    
    IF n IS NULL OR n <= 0 THEN
        RETURN FALSE;
    END IF;
    
    SET actual = n;
    SET visited = '';
    
    WHILE actual != 1 AND INSTR(visited, CONCAT(actual, ',')) = 0 DO
        SET visited = CONCAT(visited, actual, ',');
        SET actual = SumaCuadradosDigitos(actual);
    END WHILE;
    
    RETURN actual = 1;
END //

DELIMITER ;

SELECT EsFeliz(203), EsFeliz(16), EsFeliz(7);

DROP TABLE IF EXISTS NumerosFelices;
CREATE TABLE NumerosFelices (
    numero INT PRIMARY KEY,
    esFeliz ENUM('Feliz', 'Infeliz')
);

DROP PROCEDURE IF EXISTS Ejercicio34;
DELIMITER //

CREATE PROCEDURE Ejercicio34(IN inicio INT, IN fin INT)
BEGIN
    DECLARE i INT;
    
    IF inicio IS NULL OR fin IS NULL OR inicio > fin THEN
        SELECT 'Los parámetros no son válidos' AS 'ERROR';
    ELSE
        TRUNCATE TABLE NumerosFelices;
        SET i = inicio;
        WHILE i <= fin DO
            IF EsFeliz(i) THEN
                INSERT INTO NumerosFelices VALUES (i, 'Feliz');
            ELSE
                INSERT INTO NumerosFelices VALUES (i, 'Infeliz');
            END IF;
            SET i = i + 1;
        END WHILE;
        
        SELECT * FROM NumerosFelices;
    END IF;
END //

DELIMITER ;

CALL Ejercicio34(1, 30);

-- --------------------------------------------------------------------------------------
-- Ejercicio 35. Crea un subprograma que alamacene en una tabla todos los números afortunados comprendidos entre uno y un números que le pasaremos como parámetro.
/*
Número afortunado: Tomemos la secuencia de todos los naturales a partir del 1: 1, 2, 3, 4, 5,… Tachemos los que aparecen en las posiciones pares. Queda: 1, 3, 5, 7, 9, 11, 13,… Como el segundo número que ha quedado es el 3 tachemos todos los que aparecen en las posiciones múltiplo de 3 empezando desde la posición 1. Queda: 1, 3, 7, 9, 13,… Como el siguiente número que quedó es el 7 tachamos ahora todos los que aparecen en las posiciones múltiplos de 7. Así sucesivamente. Los números que sobreviven se denominan números afortunados.
*/
DROP TABLE IF EXISTS NumerosAfortunados;
CREATE TABLE NumerosAfortunados (
    numero INT PRIMARY KEY
);

DROP PROCEDURE IF EXISTS Ejercicio35;
DELIMITER //

CREATE PROCEDURE Ejercicio35(IN maximo INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE contador INT DEFAULT 1;
    DECLARE posicionActual INT;
    DECLARE numActual INT;
    DECLARE existe INT DEFAULT 1;
    
    -- Tabla temporal para la criba
    DROP TABLE IF EXISTS CribaTemporal;
    CREATE TABLE CribaTemporal (
        numero INT PRIMARY KEY,
        eliminado BOOL DEFAULT FALSE
    ) ENGINE = MEMORY;
    
    IF maximo IS NULL OR maximo < 1 THEN
        SELECT 'El parámetro no es válido' AS 'ERROR';
    ELSE
        -- Llenar la tabla con números del 1 al máximo
        WHILE i <= maximo DO
            INSERT INTO CribaTemporal VALUES (i, FALSE);
            SET i = i + 1;
        END WHILE;
        
        -- Empezamos desde el segundo número (el 2, pero su posición es 1 en la lista original de impares)
        -- Primero tachamos los pares (posiciones 2, 4, 6...)
        SET posicionActual = 2;
        WHILE posicionActual <= maximo DO
            UPDATE CribaTemporal SET eliminado = TRUE 
            WHERE numero = posicionActual AND numero <= maximo;
            SET posicionActual = posicionActual + 2;
        END WHILE;
        
        -- Ahora procesamos los números que quedaron (la lista de impares)
        -- Empezamos desde el segundo número de la lista (el 3)
        SET contador = 2; -- Posición en la lista de no eliminados
        SET posicionActual = 3;
        
        WHILE posicionActual <= maximo DO
            -- Verificar si posicionActual está eliminado o no existe
            SET existe = (SELECT COUNT(*) FROM CribaTemporal 
                         WHERE numero = posicionActual AND NOT eliminado);
            
            IF existe > 0 THEN
                -- Es un número no eliminado, usamos contador como paso
                SET i = posicionActual * 2;
                WHILE i <= maximo DO
                    UPDATE CribaTemporal SET eliminado = TRUE 
                    WHERE numero = i;
                    SET i = i + posicionActual;
                END WHILE;
            END IF;
            
            SET posicionActual = posicionActual + 1;
        END WHILE;
        
        -- Insertar los números no eliminados (afortunados)
        INSERT INTO NumerosAfortunados
        SELECT numero FROM CribaTemporal WHERE NOT eliminado;
        
        SELECT * FROM NumerosAfortunados;
        
        DROP TABLE IF EXISTS CribaTemporal;
    END IF;
END //

DELIMITER ;

CALL Ejercicio35(100);

-- The On-Line Encyclopedia of Integer Sequences. Lucky numbers
-- http://oeis.org/A000959
