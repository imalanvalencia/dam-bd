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
