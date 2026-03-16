-- --------------------------------------------------------------------------------------
-- Nombre: Alan Smith Valencia Izquierdo
-- 1DAM-B.  Bases de datos
-- Examen del Tema4. Programando con SQL
-- 16-mar-2026
-- --------------------------------------------------------------------------------------

/*
Puntuación de las consultas: Cada ejercicio vale cinco puntos.
Duración del examen: 60 minutos
Se valorará además de que las solución de los ejercicios sea correcta, la correcta indentación, los comentarios en el código, nombres de columna correctos y la claridad y simplicidad del código en general. 
No entregues dos soluciones a la misma consulta. Cada consulta debe tener una única solución, aunque puedes añadir todos los comentarios que creas conveniente.
No es obligatorio realizar análisis de nulos en las consultas, aunque se puede hacer si se cree conveniente.
Se debe realizar el mismo análisis de subconsultas realizado en clase.
*/

-- -----------------------------------------------------------------------------
-- EJERCICIO 1. (5 puntos)
-- -----------------------------------------------------------------------------
-- Código Proporcionado:
DROP DATABASE IF EXISTS Palabras;
CREATE DATABASE IF NOT EXISTS Palabras;
USE Palabras;

CREATE TEMPORARY TABLE IF NOT EXISTS Palabras (
  IdPalabra INT NOT NULL,
  Palabra VARCHAR(255)
) ENGINE = MEMORY;

TRUNCATE TABLE Palabras;
INSERT INTO Palabras VALUES (1,'hola'), (2,'mundo'), (3,'casa'), (4,'perro'), (5,'gato'), (6,'árbol'), (7,'mar'), (8,'sol'), (9,'luna'), (10,'acción'), (11,'libro'), (12,'mesa'),(13,'silla'),(14,'ventana'),(15,'puerta'),(16,'ciudad'),(17,'campo'),(18,'río'),(19,'montaña'),(20,'carro'),(21,'coche'),(22,'tren'),(23,'barco'),(24,'avión'),(25,'agua'),(26,'fuego'),(27,'tierra'),(28,'viento'),(29,'nube'),(30,'perro'),(31,'rojo'),(32,'azul'),(33,'negro'),(34,'blanco'),(35,'uno'),(36,'dos'),(37,'tres'),(38,'cuatro'),(39,'cinco'),(40,'arroz'),(41,'comida'),(42,'pan'),(43,'queso'),(44,'leche'),(45,'fruta'),(46,'arte'),(47,'cine'),(48,'teatro'),(49,'baile'),(50,'leer'),(51,'escritor'),(52,'poeta'),(53,'lector'),(54,'escuela'),(55,'maestro'),(56,'alumno'),(57,'clase'),(58,'tarea'),(59,'examen'),(60,'creer'),(61,'trabajo'),(62,'oficina'),(63,'empresa'),(64,'jefe'),(65,'equipo'),(66,'amigo'),(67,'familia'),(68,'hermano'),(69,'madre'),(70,'acceso'),(71,'padre'),(72,'hijo'),(73,'niño'),(74,'niña'),(75,'juego'),(76,'pelota'),(77,'parque'),(78,'flor'),(79,'jardín'),(80,'corrección'),(81,'bosque'),(82,'playa'),(83,'isla'),(84,'desierto'),(85,'camino'),(86,'sendero'),(87,'puente'),(88,'torre'),(89,'castillo'),(90,'innato'),(91,'muralla'),(92,'historia'),(93,'leyenda'),(94,'cultura'),(95,'idioma'),(96,'palabra'),(97,'frase'),(98,'texto'),(99,'cuento'),(100,'cooperar');
SELECT * FROM Palabras;

-- SOLUCIÓN:
DROP PROCEDURE IF EXISTS Ejercicio1;
DELIMITER //
CREATE PROCEDURE Ejercicio1()
BEGIN 
	DECLARE vPalabraCursor VARCHAR(255);
   DECLARE vPalabra VARCHAR(255);
   DECLARE vIdPalabra VARCHAR(255);
   DECLARE vCaracter VARCHAR(255);
   DECLARE vCaracterAnterior VARCHAR(255);
   
   DECLARE Contador INT DEFAULT 0;
   
   DECLARE FinCursor BOOLEAN DEFAULT FALSE;

   DECLARE CursorPalabra CURSOR FOR
		SELECT * FROM Palabras;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET FinCursor = TRUE;
   
   CREATE TEMPORARY TABLE IF NOT EXISTS CaracterDoblesSeguidos(
			IdPalabra INT NOT NULL,
            Palabra2 VARCHAR(255)
		) ENGINE = MEMORY;
   
   OPEN CursorPalabra;
   Bucle: LOOP   
		FETCH CursorPalabra INTO vIdPalabra, vPalabraCursor;
		IF FinCursor THEN LEAVE Bucle; END IF;
       
       SET vPalabra= vPalabraCursor;
       SET Contador = 0;
       
       

       WHILE CHAR_LENGTH(vPalabra) > 0  AND Contador = 0 DO
				SET  vCaracter = LOWER(LEFT(vPalabra, 1));
                 SET vPalabra = SUBSTRING(vPalabra, 2);
                
                 IF  vCaracter = vCaracterAnterior THEN SET Contador = Contador + 1; END IF;
                 
                 IF Contador = 1 THEN INSERT INTO CaracterDoblesSeguidos VALUES(vIdPalabra, vPalabraCursor); END IF;
                 
                SET vCaracterAnterior = vCaracter;
        END WHILE;
   END LOOP Bucle;
   CLOSE CursorPalabra; 
   
   SELECT SUM(IdPalabra) FROM CaracterDoblesSeguidos;
   SELECT * FROM CaracterDoblesSeguidos;
   DROP TABLE IF EXISTS CaracterDoblesSeguidos;
END// 
DELIMITER ;
CALL Ejercicio1();




-- -----------------------------------------------------------------------------
-- EJERCICIO 2. (5 puntos)
-- -----------------------------------------------------------------------------
-- Código proporcionado: está en el ejercicio anterior

-- SOLUCIÓN:
DROP PROCEDURE IF EXISTS Ejercicio2;
DELIMITER //
CREATE PROCEDURE Ejercicio2()
BEGIN 
   DECLARE vPalabra VARCHAR(255);
   DECLARE vPalabraAnterior VARCHAR(255);
   DECLARE FinCursor BOOLEAN DEFAULT FALSE;

   DECLARE CursorPalabra CURSOR FOR
		SELECT Palabra FROM Palabras;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET FinCursor = TRUE;
   
   CREATE TEMPORARY TABLE IF NOT EXISTS PalabrasHermanas (
			Palabra1 VARCHAR(255),
            Palabra2 VARCHAR(255)
		) ENGINE = MEMORY;
   
   OPEN CursorPalabra;
   Bucle: LOOP   
       FETCH CursorPalabra INTO vPalabra;
       IF FinCursor THEN LEAVE Bucle; END IF;

       IF LOWER(RIGHT(vPalabraAnterior, 1)) = LOWER(LEFT(vPalabra, 1)) THEN	
				INSERT INTO PalabrasHermanas VALUES (vPalabraAnterior, vPalabra);
		END IF;
        SET vPalabraAnterior = vPalabra;
   END LOOP Bucle;
   CLOSE CursorPalabra; 
   
   SELECT * FROM PalabrasHermanas;
   DROP TABLE IF EXISTS PalabrasHermanas;
END// 
DELIMITER ;
CALL Ejercicio2();
