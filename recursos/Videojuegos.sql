-- Videojuegos
-- Base de datos creada para hacer prácticas de JOINs en clase
-- Curso:  2011-12
-- Módulo: Bases de datos
-- Grupo:  1º DAM
--
-- Tenemos dos tablas: Videojuegos y Géneros
-- Tenemos un videojuego sin género asignado
-- y dos géneros de los que no tenemos ningún videojuego.


/*Eliminamos la base de datos entera, por si existiera previamente*/
DROP DATABASE IF EXISTS Videojuegos;

/*Creamos la base de datos vacía*/
CREATE DATABASE  Videojuegos;

/*Activamos la base de datos*/
USE Videojuegos;

/*Creamos la tabla géneros*/
CREATE TABLE Generos
(
IdGenero int NOT NULL,
Nombre varchar(255) NOT NULL,
PRIMARY KEY (IdGenero)
);

/*Y la tabla Videojuegos*/
CREATE TABLE Videojuegos
(
Id int NOT NULL,
Titulo varchar(255) NOT NULL,
Pegi varchar(10),
IdGenero int,
PRIMARY KEY (Id),
FOREIGN KEY (IdGenero) REFERENCES Generos(IdGenero)
);

/* Insertamos los datos en la tabla Generos */
INSERT INTO Generos (IdGenero, Nombre) VALUES (1,'FPS');
INSERT INTO Generos (IdGenero, Nombre) VALUES (2,'ROL');
INSERT INTO Generos (IdGenero, Nombre) VALUES (3,'RPG');

/* Insertamos los datos en la tabla Videojuegos */
INSERT INTO Videojuegos (Id,Titulo,Pegi,IdGenero) VALUES (1,'Gears of War','18+',1);
INSERT INTO Videojuegos (Id,Titulo,Pegi,IdGenero) VALUES (2,'Battlefield III','18+',1);
INSERT INTO Videojuegos (Id,Titulo,Pegi,IdGenero) VALUES (3,'Pokèmon','6+',NULL);

