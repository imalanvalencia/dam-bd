-- Base de datos para pruebas
-- MiniMundo
-- Adaptado de las base de datos "world database"
-- obtenida de: https://dev.mysql.com/doc/index-other.html
-- ------------------------------------------------------

DROP SCHEMA IF EXISTS minimundo;
CREATE SCHEMA minimundo;
USE minimundo;

CREATE TABLE `Ciudad` (
  `ID`         int(11)  NOT NULL,
  `Nombre`     char(35) NOT NULL DEFAULT '',
  `CodigoPais` char(3)  NOT NULL DEFAULT '',
  `Poblacion`  int(11)  NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB;

INSERT INTO `Ciudad` VALUES (1,'Alicante','ESP', 300000);
INSERT INTO `Ciudad` VALUES (2,'Elche'   ,'ESP', 200000);
INSERT INTO `Ciudad` VALUES (3,'Madrid'  ,'ESP',3000000);
INSERT INTO `Ciudad` VALUES (4,'Lyon'    ,'FRA', 500000);
INSERT INTO `Ciudad` VALUES (5,'Paris'   ,'FRA',5000000);

CREATE TABLE `Pais` (
  `Codigo`    char(3)     NOT NULL DEFAULT '',
  `Nombre`    char(52)    NOT NULL DEFAULT '',
  `AnyIndep`  smallint(6) DEFAULT NULL,
  `Poblacion` int(11)     NOT NULL DEFAULT '0',
  `Capital`   int(11)     DEFAULT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB;

INSERT INTO `Pais` VALUES ('ESP','Spain',     1492,45000000,3);
INSERT INTO `Pais` VALUES ('FRA','France',    843 ,50000000,5);
INSERT INTO `Pais` VALUES ('ATA','Antarctica',NULL,0       ,NULL);

CREATE TABLE `LenguaPais` (
  `CodigoPais` char(3)       NOT NULL DEFAULT '',
  `Lengua`     char(30)      NOT NULL DEFAULT '',
  `EsOficial`  enum('T','F') NOT NULL DEFAULT 'F',
  `Porcentaje` float(4,1)    NOT NULL DEFAULT '0.0',
  PRIMARY KEY (`CodigoPais`,`Lengua`)
) ENGINE=InnoDB;

INSERT INTO `LenguaPais` VALUES ('ESP','Basque',  'F',1.6);
INSERT INTO `LenguaPais` VALUES ('ESP','Catalan', 'F',16.9);
INSERT INTO `LenguaPais` VALUES ('ESP','Galecian','F',6.4);
INSERT INTO `LenguaPais` VALUES ('ESP','Spanish', 'T',74.4);
INSERT INTO `LenguaPais` VALUES ('FRA','French',  'T',93.6);
INSERT INTO `LenguaPais` VALUES ('FRA','Spanish', 'F',0.4);
