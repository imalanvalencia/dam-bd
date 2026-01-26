-- ----------------------------------------------------------------------------
-- Tema 3. CheatSheet 
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Base de datos de mundo S03I01M38L1A9B 
-- ----------------------------------------------------------------------------
/*
Pais: Codigo, Nombre, Continente, Region, Superficie, AnyIndep?, Poblacion, EsperanzaVida?, PNB?, PNBAnt?, NombreLocal, FormaGobierno, CabezaEstado?, Capital?, Codigo2
LenguaPais: CodigoPais, Lengua, EsOficial, Porcentaje
Ciudad: Id, Nombre, CodigoPais, Zona, Poblacion
*/

-- ----------------------------------------------------------------------------
-- Base de datos de Neptuno DAM1ADAM1BDAW
-- ----------------------------------------------------------------------------
/*
Proveedores:   IdProveedor, NombreEmpresa, NombreContacto, Direccion, ...
Categorias:    IdCategoria, NombreCategoria, ...
Productos:     IdProducto,  NombreProducto, IdProveedor, IdCategoria, CantidadPorUnidad, PrecioUnitario, ...
DetallesPedido:IdPedido, IdProducto, PrecioUnitario, Cantidad, descuento
Pedidos:       IdPedido, IdCliente, IdEmpleado, FechaPedido, ...
Clientes:      IdCliente,   NombreEmpresa, NombreContacto, ...
Empleados:     IdEmpleado, Apellido, Nombre, Superior, ...
EmpresasEnvio: IdEmpresaEnvio, NombreEmpresa, ...
TerritoriosEmpleados: IdEmpleado, IdTerritorio
Territorios:   IdTerritorio, DescripcionTerritorio, IdRegion
Region:        IdRegion, DescripcionRegion
*/

-- ----------------------------------------------------------------------------
-- Funciones de cadenas de caracteres DAM1ADAM1BDAW
-- ----------------------------------------------------------------------------

ORD(cad): código de un carácter multibyte de la forma: 1er byte + 2º byte*256 + 3er byte*256² + …
CHAR(num,…): convierte los números en su carácter correspondiente
CHAR_LENGTH(cad): devuelve la longitud en caracteres de una cadena
CONCAT(cad1, cad2, …): concatena las cadenas
CONCAT_WS(separador, cad1, cad2, …): concatena con un separador
HEX(cad): devuelve la representación en hexadecimal de la cadena
UNHEX(cad): convierte una representación en hexadecimal en cadena
INSERT(cad, pos, long, subcad): inserta la cadena subcad en la cadena cad a partir de la posición pos eliminando long caracteres de la cadena cad
LEFT(cad, num): devuelve los num caracteres más a la izquierda de cad
RIGHT(cad, num): devuelve los num caracteres más a la derecha de cad
LOWER(cad): convierte todos los caracteres de cad a minúsculas
UPPER(cad): convierte todos los caracteres de cad a mayúsculas
LOCATE(subcad, cad): devuelve la posición de la primera ocurrencia de subcad en cad o 0 si la cadena no es encontrada
LOCATE(subcad, cad, num): devuelve la posición de la primera ocurrencia de subcad en cad a partir de la posición num o 0 si la cadena no es encontrada
REPLACE(cad, subcad1, subcad2): devuelve cad con todas las ocurrencias de subcad1 reemplazadas por subcad2
REVERSE(cad): devuelve cad invertida
SUBSTRING(cad, num): devuelve una subcadena de cad empezando en la posición num

-- ----------------------------------------------------------------------------
-- Funciones numéricas DAM1ADAM1BDAW
-- ----------------------------------------------------------------------------

ABS(num): devuelve el valor absoluto de num (lo pasa a positivo)
num1 DIV num2: devuelve la división entera. Es un operador, no una función
PI(): devuelve el número PI
SIN(num): seno de un ángulo num en radianes
COS(num): coseno de un ángulo num en radianes
DEGREES(num): convierte num de radianes a grados
RADIANS(num): convierte num de grados a radianes
MOD(num1, num2): devuelve el resto de dividir num1 entre num2
POW(num1, num2): devuelve el resultado de num1 elevado a num2
RAND(): devuelve un valor aleatorio mayor o igual que 0 y menor que 1
ROUND(num1, num2): redondea num1 a num2 decimales. Si num2 no existe redondea al entero más cercano.
SQRT(num): devuelve la raíz cuadrada de num
TRUNCATE(num1, num2): trunca num1 a num2 decimales.
FLOOR(num): trunca al entero menor que num
CEILING(num): trunca al entero mayor que num
IN Dentro de una tabla buscar varios campos

-- ----------------------------------------------------------------------------
-- Funciones de fecha-hora DAM1ADAM1BDAW
-- ----------------------------------------------------------------------------
-- Tipos de datos:

DATE: de '1000-01-01' a '9999-12-31'
DATETIME: de '1000-01-01 00:00:00.000000' a '9999-12-31 23:59:59.999999'
TIME: de '-838:59:59.000000' a '838:59:59.000000'

DATE_ADD(fecha,INTERVAL expr unidad)Añade expr elementos de unidad a fecha
DATE_SUB(fecha,INTERVAL expr unidad): Igual que DATE_ADD pero sustrae
DATE_FORMAT(fecha,format): Formatea la fecha según la cadena de formato

-- ----------------------------------------------------------------------------
-- Funciones de control de flujo DAM1ADAM1BDAW
-- ----------------------------------------------------------------------------
CASE: Operador CASE
IF(): Función IF

CASE: elige de entre una serie de valores (sintáxis 1) o condiciones (sintáxis 2)
-- Sintáxis 1:
CASE value WHEN [compare_value] THEN result [WHEN [compare_value] THEN result ...] [ELSE result] END
-- Sintáxis 2:
CASE WHEN [condition] THEN result [WHEN [condition] THEN result ...] [ELSE result] END

IF():  retorna un valor numérico o cadena de caracteres, en función del contexto en que se usa
-- Sintáxis:
IF(condicion, valor_si_verdadero, valor_si_falso_o_nulo)  verdadero es > 0 y falso es = 0

----------------------------------------------------------------------------------------
-- FORMULAS DAM1ADAM1BDAW
----------------------------------------------------------------------------------------

-- BETWEEN V1 AND V2 equivale a >= V1 AND <=V2
-- Densidad de Poblacion: Poblacion / Superficie
-- Renta per capita: PNB / Poblacion
-- Incremento y decremento de PNB con respecto al PNB Anterior: PNB - PNBAnt / PNBAnt * 100

----------------------------------------------------------------------------------------
-- CARACTERES ESPECIALES PARA REGEXP Y LIKE DAM1ADAM1BDAW
----------------------------------------------------------------------------------------
/*
FUNCIONES DE COMPARACIÓN DE CADENAS
_=el guión bajo representa un carácter
%= cero o muchos carácteres donde lo pones
^ Busca las ciudades que empiezan por ede '^ede'
$ Busca las ciudades que terminan por ede 'ede$'
. Coíncide con cualquier carácter por cualquier sitio pero no empiezan por (tienen un carácter, y un ede)'.ede'
* Cero o muchas repeticiones del carácter anterior 'ede*'
+ uno o muchas repeticiones del carácter anterior 'al+i'
? cero o una repetición del carácter anterior 'al?i'
| o una o la otra '^al|^am' (o que empiecen por am o por al)
(abc)* cero o muchas veces de lo que hay en paréntesis
'al(am)+' tiene que tener alam pero am puede tener uno o muchos de lo que está en paréntesis

a{2,3} (minimo, máximo) marcas las repeticiones que quieres que salgan seguidas (quiero las ciudades que tengan entre 2 y 3 a seguida)
a{0,} cero o muchas a == a*
a{1,} ==a+
a{0, 1}==a?

[a-dX] uno de los caracteres que hay dentro 
- cualquier caracter de la a a la d 
[^ cualquie caracter que no sea ninguno de los que dice la condición de después ([^a-d] nunguno de entre la a y la d incluídas)

'[[:alnum:]]+' uno o más caracteres alfanuméricos
'[[:punct:]]' salen signos de puntuación
'\\[' buscar ciudades que tengan corchete abierto
// buscar caracteres que tienen un significado especial 
*/
