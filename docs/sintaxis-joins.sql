-- Sintáxis de los JOIN

-- Estilo de los JOIN
SELECT Ciudad.Nombre, LenguaPais.Lengua
FROM   Ciudad JOIN Pais JOIN LenguaPais
ON     Ciudad.Id = Pais.Capital AND Pais.Codigo = LenguaPais.CodigoPais
LIMIT 10;

SELECT Ciudad.Nombre, LenguaPais.Lengua
FROM   Ciudad JOIN Pais JOIN LenguaPais
ON     Ciudad.Id   = Pais.Capital AND
       Pais.Codigo = LenguaPais.CodigoPais
LIMIT 10;

-- SI usamos paréntesis:
FROM A JOIN B JOIN C ON A.Col1=B.Id AND B.Col2=C.Id;
FROM (A JOIN B ON A.Id=B.Id) JOIN C ON B.Id=C.Id;
FROM A JOIN (B JOIN C ON B.Id=C.Id) ON A.Id=B.Id ;

-- Estilo de LEFT JOIN (dependiendo de la posición del LEFT JOIN algunas consultas dan error)
-- OK
-- ver: https://www.itprotoday.com/sql-server/take-control-joins
SELECT Ciudad.Nombre, LenguaPais.Lengua
FROM   Ciudad JOIN Pais JOIN LenguaPais
ON     Ciudad.Id = Pais.Capital AND
       Pais.Codigo = LenguaPais.CodigoPais
LIMIT 10;

-- ERROR
SELECT Ciudad.Nombre, LenguaPais.Lengua
FROM   Ciudad LEFT JOIN Pais JOIN LenguaPais
ON     Ciudad.Id = Pais.Capital AND
       Pais.Codigo = LenguaPais.CodigoPais
LIMIT 10;

-- OK
SELECT Ciudad.Nombre, LenguaPais.Lengua
FROM   Ciudad JOIN Pais LEFT JOIN LenguaPais
ON     Ciudad.Id = Pais.Capital AND
       Pais.Codigo = LenguaPais.CodigoPais
LIMIT 10;

-- ERROR
SELECT Ciudad.Nombre, LenguaPais.Lengua
FROM   Ciudad LEFT JOIN Pais LEFT JOIN LenguaPais
ON     Ciudad.Id = Pais.Capital AND
       Pais.Codigo = LenguaPais.CodigoPais
LIMIT 10;

-- Si nos da error, tenemos que suar los paréntesis
SELECT Ciudad.Nombre, LenguaPais.Lengua
FROM   (Ciudad LEFT JOIN Pais ON Ciudad.Id = Pais.Capital)
       JOIN LenguaPais ON Pais.Codigo = LenguaPais.CodigoPais
LIMIT 10;
