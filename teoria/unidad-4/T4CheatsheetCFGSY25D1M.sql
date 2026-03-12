-- ----------------------------------------------------------------------------
-- CÓDIGO: CFGSY25D1M
-- Pequeña referencia sobre progamación con MySQL
-- ----------------------------------------------------------------------------

-- Cheatsheet CFGSY25D1M
-- ----------------------------------------------------------------------------
-- TIPOS DE DATOS:
-- Tipos de datos
INT, VARCHAR(255), BOOLEAN, CHAR, FLOAT, DOUBLE, DATE, DATETIME, TIME, YEAR, TEXT, ENUM('T','F')

-- Constantes
TRUE, FALSE;

-- Cheatsheet CFGSY25D1M
-- ----------------------------------------------------------------------------
-- ESTRUCTURAS DE CONTROL:
-- IF
IF     Numero > 8 THEN Ordenes;
ELSEIF Numero < 8 THEN Ordenes;
ELSEIF Numero = 8 THEN Ordenes;
ELSE   Ordenes;
END IF;

-- CASE
CASE IntA
    WHEN 1 THEN Ordenes;
    WHEN 2 THEN Ordenes;
    ELSE Ordenes;
END CASE;

CASE
    WHEN IntA = 1 THEN Ordenes;
    WHEN IntA = 2 THEN Ordenes;
    ELSE Ordenes;
END CASE;

-- Cheatsheet CFGSY25D1M
-- ----------------------------------------------------------------------------
-- BUCLES:
-- Bucle LOOP
SET Contador = 0;
Bucle: LOOP
    IF Contador >= Numero THEN LEAVE Bucle; END IF;
    SELECT CONCAT(Contador, ': Hola mudo') AS 'Resultado';
    SET Contador = Contador + 1;
END LOOP Bucle;

-- Bucle REPEAT-UNTIL
SET Contador = 0;
REPEAT
    SELECT CONCAT(Contador, ': Hola mudo') AS 'Resultado';
    SET Contador = Contador + 1;
UNTIL Contador >= Numero END REPEAT;

-- Bucle WHILE
SET Contador = 0;
WHILE Contador < Numero DO
    SELECT CONCAT(Contador, ': Hola mudo') AS 'Resultado';
    SET Contador = Contador + 1;
END WHILE;

-- Cheatsheet CFGSY25D1M
-- ----------------------------------------------------------------------------
-- FUNCIONES Y PROCEDIMIENTOS:
-- Definición de un procedimiento
DROP PROCEDURE IF EXISTS P1;
DELIMITER //
CREATE PROCEDURE P1(IN Cadena1 VARCHAR(50))
BEGIN
    DECLARE Cadena2  VARCHAR(50) DEFAULT 'Hola';

    SET Cadena2 = 'Hola';
    SELECT CONCAT(Cadena2, ' ', Cadena1);
END//
DELIMITER ;
CALL P1('mundo');

-- Definición de una función
DROP FUNCTION IF EXISTS UnoDeDos;
DELIMITER //
CREATE FUNCTION UnoDeDos(IntA INT, IntB INT)
   RETURNS INT
BEGIN
   IF RAND() > 0.6
       THEN RETURN IntA;
       ELSE RETURN IntB;
   END IF;
END//
DELIMITER ;

-- Cheatsheet CFGSY25D1M
-- Procedimiento con etiqueta
CREATE PROCEDURE P1()
Procedimiento: BEGIN
    LOOP
        IF RAND() > 0.9 THEN LEAVE Procedimiento; END IF;
        SELECT 'Hola mundo' AS 'Resultado';
    END LOOP;
END Procedimiento//

-- Cheatsheet CFGSY25D1M
-- Llamadas a procedimientos
DROP PROCEDURE IF EXISTS PruebaProc;
DELIMITER //
CREATE PROCEDURE PruebaProc (OUT X INT)
BEGIN
   SET X= ROUND(RAND() * 9 + 1);
END// 
DELIMITER ;

CALL PruebaProc(@A);
SELECT @A * 2 AS 'Resultado';

-- Cheatsheet CFGSY25D1M
-- Llamadas a funciones
DROP FUNCTION IF EXISTS PruebaFunc;
DELIMITER //
CREATE FUNCTION PruebaFunc ()
   RETURNS INT
BEGIN
   RETURN ROUND(RAND() * 9 + 1);
END// 
DELIMITER ;
SELECT PruebaFunc() * 2 AS Resultado;

-- Cheatsheet CFGSY25D1M
-- ----------------------------------------------------------------------------
-- CURSORES:
DROP PROCEDURE IF EXISTS PruebaCursor;
DELIMITER //
CREATE PROCEDURE PruebaCursor()
BEGIN 
   DECLARE Cadena CHAR(20);
   DECLARE Numero INT;
   DECLARE FinCursor BOOLEAN DEFAULT FALSE;

   DECLARE CursorCadena CURSOR FOR
       SELECT 1, 'Hola'
	   UNION ALL
	   SELECT 2, 'Mundo';
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET FinCursor = TRUE;
   
   OPEN CursorCadena;
   Bucle: LOOP   
       FETCH CursorCadena INTO Numero, Cadena;
       IF FinCursor THEN LEAVE Bucle; END IF;
       SELECT CONCAT ('Número: ', Numero, '. Cadena: ', Cadena) AS 'Resultado'; 
   END LOOP Bucle;
   CLOSE CursorCadena; 
END// 
DELIMITER ;
CALL PruebaCursor();

-- Cheatsheet CFGSY25D1M
-- ----------------------------------------------------------------------------
-- CREACIÓN Y MANIPULACIÓN DE BASES DE DATOS
DROP DATABASE IF EXISTS Prueba;
CREATE DATABASE IF NOT EXISTS Prueba;
USE Prueba;

DROP TABLE IF EXISTS Tabla1;
CREATE TEMPORARY TABLE Tabla1 (
    Numero INT DEFAULT NULL,
    Cadena VARCHAR(255) DEFAULT '',
    PRIMARY KEY (Numero)
) ENGINE = MEMORY;

TRUNCATE TABLE Tabla1;
INSERT INTO Tabla1 VALUES(1, 'Hola');
INSERT INTO Tabla1 VALUES(2, 'Mundo');
UPDATE Tabla1 SET Cadena = 'Hello' WHERE Numero = 1;
DELETE FROM Tabla1 WHERE Numero = 1;
SELECT * FROM Tabla1;

ALTER TABLE Tabla1 ADD COLUMN Numero2 INT NOT NULL DEFAULT 0;
ALTER TABLE Tabla1 CHANGE COLUMN Numero2 NumeroDos INT NOT NULL DEFAULT 0;
ALTER TABLE Tabla1 DROP COLUMN NumeroDos;
ALTER TABLE Tabla1 DROP PRIMARY KEY;
ALTER TABLE Tabla1 ADD COLUMN IdRegistro INT NOT NULL PRIMARY KEY AUTO_INCREMENT FIRST;
ALTER TABLE Tabla1 DROP COLUMN IdRegistro;
CREATE TABLE Tabla2 AS (SELECT * FROM Tabla1);
DROP TABLE IF EXISTS Tabla2;

-- Cheatsheet CFGSY25D1M
-- ----------------------------------------------------------------------------
-- DISPARADORES:
-- Nota: no se pueden poner disparadores a una tabla temporal. Quitamos el "TEMPORARY"
DROP TABLE IF EXISTS Tabla1;
CREATE TABLE Tabla1 (
    Numero INT DEFAULT NULL,
    Cadena VARCHAR(255) DEFAULT ''
) ENGINE = MEMORY;

-- BEFORE, AFTER
-- INSERT, UPDATE, DELETE
DROP TRIGGER IF EXISTS AfterTabla1Insert; 
DELIMITER // 
CREATE TRIGGER AfterTabla1Insert
AFTER INSERT ON Tabla1
FOR EACH ROW
BEGIN
   SET @Operaciones = @Operaciones + 1;
END// 
DELIMITER ; 
SET @Operaciones = 0;
INSERT INTO Tabla1 VALUES(1, 'Hola');
SELECT @Operaciones;

-- Cheatsheet CFGSY25D1M
-- ----------------------------------------------------------------------------
-- AUDITORÍAS:
DROP TABLE IF EXISTS Auditoria; 
CREATE TABLE Auditoria ( 
  IdAuditEquiposB INT NOT NULL AUTO_INCREMENT, 
  FechaHora       CHAR(20) NOT NULL, 
  Usuario         VARCHAR(255), 
  Operacion       ENUM('Insertar', 'Actualizar', 'Borrar') NOT NULL, 
-- Otros campos
  PRIMARY KEY (IdAuditEquiposB) 
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

INSERT INTO Auditoria VALUES (NULL, NOW(), USER(), OtrosDatos, ...);

