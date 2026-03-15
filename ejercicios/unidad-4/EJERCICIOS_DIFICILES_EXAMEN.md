# Ejercicios para Repasar - Examen Tema 4

## 🔴 Más Difíciles (requieren lógica avanzada)

| Ejercicio | Dificultad | Por qué |
|-----------|------------|---------|
| **14** | Difícil | Cursor con lógica de posiciones (1, 10, 20, 30...) |
| **15** | Difícil | Cursor comparando valor actual con anterior |
| **17** | Difícil | Auditoría completa (INSERT + UPDATE + DELETE) |

## 🟠 Complejos (muchos conceptos juntos)

| Ejercicio | Complejidad | Por qué |
|-----------|-------------|---------|
| **9** | Medio-Alto | Función con bucle + REGEXP para contar palabras |
| **12** | Alto | Palíndromo limpiando puntuación (múltiples pasos) |
| **16** | Alto | 3 disparadores (AFTER INSERT/DELETE/UPDATE) sincronizados |
| **23** | Alto | Doble bucle anidado + procesamiento de strings |

---

## 🎯 Para el examen, practicá especialmente:

### 1. Cursores (Ejercicios 14, 15)

Son los más complicados porque combinás:
- FETCH
- CONTINUE HANDLER
- LOOP/WHILE
- Variables que mantienen estado

### 2. Disparadores (Ejercicios 16, 17)

Conceptos clave:
- **OLD vs NEW** - OLD = valor antes, NEW = valor después
- **BEFORE vs AFTER** - BEFORE permite modificar antes de guardar
- **INSERT vs UPDATE vs DELETE** - Cada evento tiene sus variables

### 3. Funciones con bucles (Ejercicios 9, 12, 22)

Manipulás caracteres uno por uno, muy común en exámenes.

---

## 📝 Ejercicio 14 - Explicación

```sql
-- Pedido: ciudades en posiciones 1, 10, 20, 30... 1000
-- Ordenadas por población ASC

Bucle: LOOP
    FETCH curCiudades INTO vNombre, vPoblacion;
    IF finCur THEN LEAVE Bucle; END IF;
    
    -- Solo guardamos cuando llegamos a la posición deseada
    IF contador = vPosicion THEN
        INSERT INTO PosicionesCiudades VALUES(vPosicion, vNombre, vPoblacion);
        SET vPosicion = vPosicion + 10;  -- Próxima posición: 10, 20, 30...
    END IF;
    
    SET contador = contador + 1;
    
    IF vPosicion > 1000 THEN
        LEAVE Bucle;
    END IF;
END LOOP Bucle;
```

**Clave:** Usás dos contadores:
- `contador`: avanza en cada row del cursor
- `vPosición`: avanza de 10 en 10 (1, 10, 20...)

---

## 📝 Ejercicio 15 - Explicación

```sql
-- Pedido: para cada país, mostrar diferencia de PNB con el anterior

FETCH curPaises INTO vNombre, vAnyIndep, vPNB;

IF vPNBAnterior IS NULL OR vPNB IS NULL THEN
    -- Primer registro o hay NULL
    INSERT INTO PaisesPNB VALUES(vNombre, vAnyIndep, vPNB, 'n/a');
ELSE
    -- Diferencia con el anterior
    INSERT INTO PaisesPNB VALUES(vNombre, vAnyIndep, vPNB, CONCAT(vPNB - vPNBAnterior));
END IF;

-- Guardamos el PNB actual para la próxima iteración
SET vPNBAnterior = vPNB;
```

**Clave:** Variable que guarda el valor anterior (`vPNBAnterior`)

---

## 📝 Ejercicio 16 - Explicación (Disparadores)

```sql
-- AFTER INSERT: Sumar la nueva población
UPDATE Pais SET PoblacionTotal = PoblacionTotal + NEW.Poblacion
WHERE Codigo = NEW.CodigoPais;

-- AFTER DELETE: Restar la población borrada
UPDATE Pais SET PoblacionTotal = PoblacionTotal - OLD.Poblacion
WHERE Codigo = OLD.CodigoPais;

-- AFTER UPDATE: Si cambió país o población
-- 1. Restar el valor OLD
UPDATE Pais SET PoblacionTotal = PoblacionTotal - OLD.Poblacion
WHERE Codigo = OLD.CodigoPais;
-- 2. Sumar el valor NEW
UPDATE Pais SET PoblacionTotal = PoblacionTotal + NEW.Poblacion
WHERE Codigo = NEW.CodigoPais;
```

**Clave:** 
- `NEW.` = valor que se inserta/actualiza
- `OLD.` = valor antes de borrar/actualizar

---

## 📝 Ejercicio 17 - Explicación (Auditoría)

```sql
-- Tabla de auditoría
CREATE TABLE AuditPais (
    IdAudit INT AUTO_INCREMENT PRIMARY KEY,
    FechaHora CHAR(20),
    Usuario VARCHAR(255),
    Operacion ENUM('Insertar', 'Actualizar', 'Borrar'),
    CodigoAntiguo CHAR(3),
    CodigoNuevo CHAR(3),
    NombreAntiguo VARCHAR(255),
    NombreNuevo VARCHAR(255)
);

-- AFTER INSERT
INSERT INTO AuditPais VALUES (NULL, NOW(), USER(), 'Insertar', NULL, NEW.Codigo, NULL, NEW.Nombre);

-- AFTER UPDATE
INSERT INTO AuditPais VALUES (NULL, NOW(), USER(), 'Actualizar', OLD.Codigo, NEW.Codigo, OLD.Nombre, NEW.Nombre);

-- AFTER DELETE
INSERT INTO AuditPais VALUES (NULL, NOW(), USER(), 'Borrar', OLD.Codigo, NULL, OLD.Nombre, NULL);
```

---

## 📝 Ejercicio 9 - Contar Palabras

```sql
CREATE FUNCTION NumeroPalabras(cadena VARCHAR(1000)) RETURNS INT
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE esPalabra BOOL DEFAULT FALSE;
    DECLARE caracter CHAR(1);
    DECLARE contador INT DEFAULT 0;
    
    WHILE i <= CHAR_LENGTH(cadena) DO
        caracter = SUBSTRING(cadena, i, 1);
        
        -- Si es letra o número, es parte de una palabra
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
END
```

---

## 📝 Ejercicio 12 - Palíndromo sin puntuación

```sql
CREATE FUNCTION EsPalindromo3(cadena VARCHAR(1000)) RETURNS BOOL
BEGIN
    DECLARE cadenaLimpia VARCHAR(1000) DEFAULT '';
    DECLARE i INT DEFAULT 1;
    DECLARE j INT;
    DECLARE caracter CHAR(1);
    
    -- Paso 1: Limpiar la cadena (solo letras y números en minúsculas)
    WHILE i <= CHAR_LENGTH(cadena) DO
        caracter = LOWER(SUBSTRING(cadena, i, 1));
        IF caracter REGEXP '[a-záéíóúñ0-9]' THEN
            SET cadenaLimpia = CONCAT(cadenaLimpia, caracter);
        END IF;
        SET i = i + 1;
    END WHILE;
    
    -- Paso 2: Verificar palíndromo
    SET j = CHAR_LENGTH(cadenaLimpia);
    SET i = 1;
    
    WHILE i <= j DO
        IF SUBSTRING(cadenaLimpia, i, 1) != SUBSTRING(cadenaLimpia, j, 1) THEN
            RETURN FALSE;
        END IF;
        SET i = i + 1;
        SET j = j - 1;
    END WHILE;
    
    RETURN TRUE;
END
```

---

## ✅ Repaso Rápido de Conceptos

### Procedimientos vs Funciones

| Procedimiento | Función |
|---------------|---------|
| `CALL nombre()` | `SELECT nombre()` |
| Puede tener OUT | RETURNS tipo |
| No retorna valor | Retorna valor |

### Parámetros

```sql
-- IN: solo entrada (por defecto)
-- OUT: solo salida
-- INOUT: entrada y salida
CREATE PROCEDURE ejemplo(IN a INT, OUT b INT, INOUT c INT)
```

### Cursores

```sql
DECLARE cur CURSOR FOR SELECT ...;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

OPEN cur;
LOOP
    FETCH cur INTO variable;
    IF fin THEN LEAVE; END IF;
    -- proceso
END LOOP;
CLOSE cur;
```

### Disparadores

```sql
CREATE TRIGGER nombre
[BEFORE|AFTER] [INSERT|UPDATE|DELETE] ON tabla
FOR EACH ROW
BEGIN
    -- OLD solo en UPDATE/DELETE
    -- NEW solo en INSERT/UPDATE
END
```

---

# 📚 Ejercicios 24-35: Matemática Recreativa

Todos estos ejercicios siguen un patrón similar. Acá te explico cada uno:

---

## 📝 Ejercicio 24 - Número Perfecto

**Definición:** Número natural igual a la suma de sus divisores propios.
- Ejemplos: 6 (1+2+3), 28, 496, 8128

### Función auxiliar (se usa en varios ejercicios)

```sql
CREATE FUNCTION SumaDivisores(numero INT) RETURNS INT
BEGIN
    DECLARE suma INT DEFAULT 0;
    DECLARE i INT DEFAULT 1;
    
    WHILE i < numero DO
        IF numero % i = 0 THEN
            SET suma = suma + i;
        END IF;
        SET i = i + 1;
    END WHILE;
    
    RETURN suma;
END
```

### Función: ¿Es perfecto?

```sql
CREATE FUNCTION EsPerfecto(numero INT) RETURNS BOOL
BEGIN
    RETURN SumaDivisores(numero) = numero;
END
```

**Lógica:** `SumaDivisores(n) = n` → es perfecto

---

## 📝 Ejercicio 25 - Mostrar perfectos en rango

```sql
CREATE PROCEDURE MostrarPerfectos(inicio INT, fin INT)
BEGIN
    DECLARE i INT DEFAULT inicio;
    
    WHILE i <= fin DO
        IF EsPerfecto(i) THEN
            SELECT i AS 'Número Perfecto';
        END IF;
        SET i = i + 1;
    END WHILE;
END
```

---

## 📝 Ejercicio 26 - Guardar perfectos en tabla

Igual que el 25 pero con `INSERT INTO tabla VALUES (i)` en vez de SELECT.

---

## 📝 Ejercicio 27 - Número Abundante

**Definición:** Suma de divisores propios > número
- Ejemplo: 12 → 1+2+3+4+6 = 16 > 12 ✓

```sql
CREATE FUNCTION EsAbundante(numero INT) RETURNS BOOL
BEGIN
    RETURN SumaDivisores(numero) > numero;
END
```

**Lógica:** `SumaDivisores(n) > n` → es abundante

---

## 📝 Ejercicio 28 - Mostrar abundantes en rango

Igual que ejercicio 25 pero usando `EsAbundante()`.

---

## 📝 Ejercicio 29 - Guardar abundantes en tabla

Igual que ejercicio 26 pero usando `EsAbundante()`.

---

## 📝 Ejercicio 30 - Número Deficiente

**Definición:** Suma de divisores propios < número
- Ejemplo: 16 → 1+2+4+8 = 15 < 16 ✓

```sql
CREATE FUNCTION EsDeficiente(numero INT) RETURNS BOOL
BEGIN
    RETURN SumaDivisores(numero) < numero;
END
```

**Lógica:** `SumaDivisores(n) < n` → es deficiente

---

## 📝 Ejercicio 31 - Número Apocalíptico

**Definición:** 2^n contiene la secuencia "666"
- Ejemplos: 157, 192

```sql
CREATE FUNCTION EsApocaliptico(n INT) RETURNS BOOL
BEGIN
    DECLARE potencia VARCHAR(1000);
    
    SET potencia = CAST(POW(2, n) AS CHAR);
    
    RETURN INSTR(potencia, '666') > 0;
END
```

**Clave:** `POW(2,n)` → `CAST(... AS CHAR)` → `INSTR(..., '666')`

---

## 📝 Ejercicio 32 - Mostrar apocalípticos en rango

Igual que ejercicio 25 pero usando `EsApocaliptico()`.

---

## 📝 Ejercicio 33 - Guardar apocalípticos en tabla

Igual que ejercicio 26 pero usando `EsApocaliptico()`.

---

## 📝 Ejercicio 34 - Números Felices/Infelices

**Número feliz:** Sumar cuadrados de dígitos hasta llegar a 1
- 203 → 2²+0²+3² = 13 → 1²+3² = 10 → 1²+0² = 1 ✓ FELIZ

**Número infeliz:** No llega a 1 (entra en ciclo)
- 16 → 37 → 58 → 89 → 145 → 42 → 20 → 4 → 16... (ciclo) ✗ INFELIZ

### Función: Suma de cuadrados de dígitos

```sql
CREATE FUNCTION SumaCuadradosDigitos(numero INT) RETURNS INT
BEGIN
    DECLARE suma INT DEFAULT 0;
    DECLARE digito INT;
    
    WHILE numero > 0 DO
        SET digito = numero % 10;
        SET suma = suma + (digito * digito);
        SET numero = numero DIV 10;
    END WHILE;
    
    RETURN suma;
END
```

### Función: ¿Es feliz?

```sql
CREATE FUNCTION EsFeliz(n INT) RETURNS BOOL
BEGIN
    DECLARE actual INT;
    DECLARE visited VARCHAR(1000);
    
    SET actual = n;
    SET visited = '';
    
    WHILE actual != 1 AND INSTR(visited, CONCAT(actual, ',')) = 0 DO
        SET visited = CONCAT(visited, actual, ',');
        SET actual = SumaCuadradosDigitos(actual);
    END WHILE;
    
    RETURN actual = 1;
END
```

**Clave:** Se usa un string `visited` para detectar ciclos.

---

## 📝 Ejercicio 35 - Números Afortunados

**Algoritmo (Criba modificada):**
```
1. Lista: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15...
2. Tachar posiciones PARES: 1, 3, 5, 7, 9, 11, 13, 15...
3. El 2do número que quedó es 3 → tachar múltiplos de 3
4. El siguiente es 7 → tachar múltiplos de 7
5. Y así sucesivamente
```

Los que sobreviven = números afortunados.

```sql
CREATE PROCEDURE Ejercicio35(maximo INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE contador INT DEFAULT 1;
    DECLARE posicionActual INT;
    
    -- Tabla temporal para la criba
    CREATE TABLE CribaTemporal (
        numero INT PRIMARY KEY,
        eliminado BOOL DEFAULT FALSE
    );
    
    -- Llenar con números 1 a maximo
    WHILE i <= maximo DO
        INSERT INTO CribaTemporal VALUES (i, FALSE);
        SET i = i + 1;
    END WHILE;
    
    -- Tachar pares (posiciones 2, 4, 6...)
    UPDATE CribaTemporal SET eliminado = TRUE 
    WHERE numero % 2 = 0;
    
    -- Para cada número no eliminado, tachar sus múltiplos
    SET contador = 3;  -- Empezamos desde 3
    WHILE contador <= maximo DO
        -- Verificar si contador no está eliminado
        IF (SELECT COUNT(*) FROM CribaTemporal 
            WHERE numero = contador AND NOT eliminado) > 0 THEN
            -- Tachar múltiplos de contador
            SET i = contador * 2;
            WHILE i <= maximo DO
                UPDATE CribaTemporal SET eliminado = TRUE 
                WHERE numero = i;
                SET i = i + contador;
            END WHILE;
        END IF;
        SET contador = contador + 1;
    END WHILE;
    
    -- Los no eliminados son afortunados
    SELECT * FROM CribaTemporal WHERE NOT eliminado;
    
    DROP TABLE CribaTemporal;
END
```

---

## 📋 Resumen - Ejercicios 24-35

| # | Tipo | Concepto clave |
|---|------|----------------|
| 24 | Función | `SumaDivisores(n) = n` |
| 25 | Procedimiento | WHILE + función 24 |
| 26 | Procedimiento | WHILE + INSERT |
| 27 | Función | `SumaDivisores(n) > n` |
| 28 | Procedimiento | WHILE + función 27 |
| 29 | Procedimiento | WHILE + INSERT |
| 30 | Función | `SumaDivisores(n) < n` |
| 31 | Función | `POW(2,n)` + `INSTR(...)` |
| 32 | Procedimiento | WHILE + función 31 |
| 33 | Procedimiento | WHILE + INSERT |
| 34 | Función | WHILE hasta llegar a 1 |
| 35 | Procedimiento | Criba modificada |

---

## 📝 Ejercicio 22 - Suma de dígitos con cursor

**Enunciado:** Calcula la suma de todos los dígitos de todos los números presentes en una tabla.

### Solución con cursor

```sql
-- Tabla de prueba
CREATE TABLE Numeros (numero INT);
INSERT INTO Numeros VALUES (12), (33), (67);  -- Resultado: 22

-- Función auxiliar: suma los dígitos de un número
CREATE FUNCTION SumaDigitosNumero(numero INT) RETURNS INT
BEGIN
    DECLARE suma INT DEFAULT 0;
    DECLARE digito INT;
    
    WHILE numero > 0 DO
        SET digito = numero % 10;
        SET suma = suma + digito;
        SET numero = numero DIV 10;  -- IMPORTANTE: usar DIV, no /
    END WHILE;
    
    RETURN suma;
END

-- Procedimiento con cursor
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
END
```

**Clave:** El cursor itera sobre los números, y para cada uno llama a la función `SumaDigitosNumero`.

---

## 📝 Ejercicio 23 - Conteo de letras con cursor

**Enunciado:** Dada una tabla de palabras, contar cuántas veces aparece cada letra del abecedario.

### Solución con cursor

```sql
-- Tablas de prueba
CREATE TABLE Palabras (id INT PRIMARY KEY, palabra VARCHAR(255));
INSERT INTO Palabras VALUES (1,'Hola'), (2,'Mundo');

CREATE TABLE Letras (letra CHAR(1) PRIMARY KEY);
INSERT INTO Letras VALUES ('a'),('b'),('c'),...;

CREATE PROCEDURE Ejercicio23()
BEGIN
    DECLARE vPalabra VARCHAR(255);
    DECLARE vCaracter CHAR(1);
    DECLARE finCurPalabras BOOL DEFAULT FALSE;
    
    -- Cursor para las palabras
    DECLARE curPalabras CURSOR FOR SELECT palabra FROM Palabras;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCurPalabras = TRUE;
    
    -- Tabla resultado
    CREATE TABLE ConteoLetras (
        letra CHAR(1),
        cantidad INT DEFAULT 0,
        PRIMARY KEY (letra)
    );
    
    -- Inicializar con todas las letras
    INSERT INTO ConteoLetras SELECT letra, 0 FROM Letras;
    
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
END
```

**Clave:** Cursor para las palabras + WHILE anidado para procesar cada carácter.

---

## ⚠️ Errores comunes a evitar

1. **División entera:** Usar `numero / 10` en vez de `numero DIV 10`
2. **Orden DECLARE:** Variables → Cursors → Handlers → Código
3. **FETCH sin verificar fin:** Siempre verificar `IF finCur THEN LEAVE` después del FETCH
