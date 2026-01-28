# TABLA DE REPASO SQL - EXAMEN DAM-B
## Tema 1-3: SQL Básico → Avanzado II

| Concepto | ¿Qué es? | ¿Cómo funciona? | ¿Cuándo usarlo? | Ejemplo clave |
|-----------|----------|------------------|-----------------|---------------|
| **SELECT básico** | Consulta simple de datos | `SELECT columnas FROM tabla [WHERE condición]` | Para listar datos básicos | `SELECT Nombre, Poblacion FROM Pais WHERE Continente = 'Europe'` |
| **DISTINCT** | Elimina duplicados | `SELECT DISTINCT columna FROM tabla` | Para valores únicos | `SELECT DISTINCT Continente FROM Pais` |
| **LIKE vs REGEXP** | Búsqueda de patrones | `LIKE` con `_` y `%`<br>`REGEXP` con expresiones regulares | `LIKE`: patrones simples<br>`REGEXP`: patrones complejos | `LIKE 'A%'` (empieza con A)<br>`REGEXP '[aeiou]$'` (termina en vocal) |
| **Funciones de cadena** | Manipulación de texto | `CHAR_LENGTH()`, `UPPER()`, `LEFT()`, `SUBSTRING()` | Transformación y análisis de texto | `CHAR_LENGTH(Nombre)`<br>`UPPER(NombreLocal)` |
| **Funciones numéricas** | Cálculos matemáticos | `ROUND()`, `TRUNCATE()`, `FLOOR()`, `CEILING()` | Redondeo y cálculos precisos | `ROUND(Poblacion/1000000, 1)`<br>`FLOOR(EsperanzaVida)` |
| **Funciones de fecha** | Manipulación temporal | `DATE_FORMAT()`, `YEAR()`, `MONTH()`, `DATE_ADD()` | Formato y extracción de fechas | `DATE_FORMAT(FechaPedido, '%d-%m-%Y')`<br>`YEAR(FechaPedido)` |
| **Funciones de control** | Condicionales SQL | `IF(condicion, valor_si, valor_no)`<br>`CASE WHEN...THEN...END` | Lógica condicional en SELECT | `IF(EsOficial='T', 'Oficial', 'No oficial')` |
| **INNER JOIN** | Intersección de tablas | `FROM tabla1 JOIN tabla2 ON campo1=campo2` | Solo registros coincidentes | `Pais JOIN Ciudad ON Pais.Codigo = Ciudad.CodigoPais` |
| **LEFT JOIN** | Todos de la izquierda | `FROM izq LEFT JOIN der ON condicion` | Todos de tabla izquierda + coincidencias | `Pais LEFT JOIN Ciudad` (países sin ciudades) |
| **RIGHT JOIN** | Todos de la derecha | `FROM izq RIGHT JOIN der ON condicion` | Todos de tabla derecha + coincidencias | Simular con LEFT JOIN invertido |
| **FULL JOIN** | Unión completa | `LEFT JOIN UNION RIGHT JOIN` | Todos los registros de ambas tablas | `(A LEFT JOIN B) UNION (B LEFT JOIN A)` |
| **Subconsultas NO correlacionadas** | Subconsulta independiente | Se ejecuta una sola vez, independiente de la consulta principal | Cuando la subconsulta puede ejecutarse sola | `WHERE Poblacion > (SELECT AVG(Poblacion) FROM Pais)` |
| **Subconsultas CORRELACIONADAS** | Subconsulta dependiente | Se ejecuta por cada fila de la consulta principal | Cuando necesita valores de la consulta principal | `WHERE EXISTS (SELECT * FROM LenguaPais WHERE CodigoPais = Pais.Codigo)` |
| **EXISTS vs COUNT(*)** | Verificación de existencia | `EXISTS`: eficiente, booleano<br>`COUNT(*)`: ineficiente, numérico | **SIEMPRE EXISTS/NOT EXISTS** para verificar existencia | `EXISTS (subconsulta)`<br>NO: `(SELECT COUNT(*) FROM...) > 0` |
| **GROUP BY** | Agrupación de resultados | `GROUP BY columna1, columna2...` | Para agregaciones por grupos | `GROUP BY Continente, Region` |
| **HAVING** | Filtro de grupos | `HAVING condición_agregada` | Para filtrar DESPUÉS de agrupar | `HAVING COUNT(*) > 10` |
| **WITH ROLLUP** | Totales en agrupaciones | `GROUP BY columna1, columna2 WITH ROLLUP` | Para incluir totales y subtotales | `GROUP BY Continente, Region WITH ROLLUP` |
| **Clasificación por tramos** | Categorización de datos | `CASE WHEN valor BETWEEN min AND max THEN 'tramo' END` | Para分组连续数值 ranges | `CASE WHEN PNB <= 1000 THEN 'Muy Pobre' WHEN PNB <= 5000 THEN 'Pobre' END` |
| **RAND() + LIMIT** | Selección aleatoria | `ORDER BY RAND() LIMIT n` | Para obtener registros aleatorios | `ORDER BY RAND() LIMIT 5` |
| **Agregaciones anidadas** | Múltiples niveles | `AVG(SUM(...))` o subconsultas | Para estadísticas complejas | `SELECT AVG(num_productos) FROM (SELECT COUNT(*) AS num_productos FROM Productos GROUP BY IdProveedor)` |

---

## **REGLAS DE ORO DEL EXAMEN**

### **1. Tratamiento de NULOS**
```sql
-- Nulos afectan negativamente → SIEMPRE verificar
WHERE campo IS NOT NULL  -- Para evitar nulos en cálculos
IF(campo IS NULL, 0, campo)  -- Para convertir nulos
```

### **2. Subconsultas Correlacionadas OBLIGATORIAS**
```sql
-- CORRECTO (eficiente):
WHERE EXISTS (SELECT * FROM LenguaPais WHERE CodigoPais = Pais.Codigo)

-- INCORRECTO (ineficiente):
WHERE (SELECT COUNT(*) FROM LenguaPais WHERE CodigoPais = Pais.Codigo) > 0
```

### **3. BETWEEN vs Comparaciones explícitas**
```sql
-- Si hay solapamiento, NO usar BETWEEN
-- CORRECTO:
WHEN valor >= 100 AND valor < 200 THEN 'Tramo1'

-- INCORRECTO (solapado):
WHEN valor BETWEEN 100 AND 200 THEN 'Tramo1'
```

### **4. Diferencias clave COUNT(*) vs SUM()**
```sql
COUNT(*)           -- Número de filas/registros
COUNT(DISTINCT campo)  -- Valores únicos
SUM(campo)         -- Suma total de valores
AVG(campo)         -- Promedio
```

### **5. Patrones de clasificación por tramos**
```sql
-- Patrón estándar para tramos:
CASE 
    WHEN valor >= 0 AND valor <= 1000 THEN 'Muy Bajo'
    WHEN valor >= 1001 AND valor <= 5000 THEN 'Bajo' 
    -- ... más tramos
END
```

---

## **ERRORES COMUNES A EVITAR**

| Error | Por qué ocurre | Solución |
|-------|----------------|----------|
| **Usar COUNT(*) > 0 en vez de EXISTS** | Ineficiente, recorre todos los registros | `EXISTS (SELECT * FROM ...)` |
| **Olvidar IS NOT NULL en cálculos** | Los nulos anulan operaciones aritméticas | `WHERE campo IS NOT NULL` |
| **BETWEEN con límites solapados** | Ambigüedad en valores límite | Usar comparaciones explícitas `>= AND <=` |
| **Subconsultas correlacionadas mal referenciadas** | Error "Unknown column" | Verificar que los campos referenciados existen en la consulta principal |
| **GROUP BY incorrecto** | Columnas en SELECT sin estar en GROUP BY | Todas las columnas no agregadas deben estar en GROUP BY |
| **Confundir COUNT(*) con SUM()** | Contar filas vs sumar valores | `COUNT(*)` para filas, `SUM()` para sumar valores |

---

## **ESQUEMAS DE REFERENCIA**

### **Base de datos MUNDO**
```sql
Pais: Codigo, Nombre, Continente, Region, Superficie, AnyIndep?, Poblacion, EsperanzaVida?, PNB?, PNBAnt?, NombreLocal, FormaGobierno, CabezaEstado?, Capital?, Codigo2
LenguaPais: CodigoPais, Lengua, EsOficial, Porcentaje  
Ciudad: Id, Nombre, CodigoPais, Zona, Poblacion
```

### **Base de datos NEPTUNO**
```sql
Proveedores: IdProveedor, NombreEmpresa, NombreContacto, Direccion, ...
Categorias: IdCategoria, NombreCategoria, ...
Productos: IdProducto, NombreProducto, IdProveedor, IdCategoria, CantidadPorUnidad, PrecioUnitario, ...
DetallesPedido: IdPedido, IdProducto, PrecioUnitario, Cantidad, descuento
Pedidos: IdPedido, IdCliente, IdEmpleado, FechaPedido, ...
Clientes: IdCliente, NombreEmpresa, NombreContacto, ...
Empleados: IdEmpleado, Apellido, Nombre, Superior, ...
```

---

## **FÓRMULAS IMPORTANTES**

```sql
-- Densidad de población
Densidad = Poblacion / Superficie

-- Renta per cápita  
RentaPerCapita = PNB * 1000000 / Poblacion

-- Incremento PNB
Incremento = (PNB - PNBAnt) / PNBAnt * 100

-- Precio con descuento
PrecioFinal = PrecioUnitario * Cantidad * (1 - Descuento)

-- PNB per cápita de ciudad
PNBPercapitaCiudad = (PNB / NumCiudades) / PoblacionCiudad
```

---

## **ORDEN DE EJECUCIÓN DE UNA CONSULTA**

1. **FROM / JOIN** - Unión de tablas
2. **WHERE** - Filtrado de filas (individual)
3. **GROUP BY** - Agrupación 
4. **HAVING** - Filtrado de grupos
5. **SELECT** - Selección de columnas (incluye funciones y CASE)
6. **ORDER BY** - Ordenación
7. **LIMIT** - Limitación de resultados

---

**¡ESTA ES TU GUÍA DEFINITIVA! Repásala bien y estarás perfecto para el examen.** 🚀