DROP DATABASE IF EXISTS FactorialesDB;
CREATE DATABASE IF NOT EXISTS FactorialesDB;
USE FactorialesDB;


CREATE TABLE `Factoriales` (
    `Numero`    INTEGER NOT NULL,
    `Factorial` DECIMAL(65),
    PRIMARY KEY (`Numero`)
);


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



