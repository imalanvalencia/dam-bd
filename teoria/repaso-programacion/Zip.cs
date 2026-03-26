// Ejemplo de uso de Zip para detectar cambios de estado en una secuencia de eventos de ratón

// Partimos de una lista con los eventos del ratón:
// estadosDelRaton = { false, true, true, false, true, false }

// Queremos detectar los cambios de estado, es decir, los momentos en los que se presiona, se mantiene o se suelta el botón del ratón.
// Para ello, vamos a comparar cada elemento de la lista con el siguiente, y vamos a generar un evento en función de si el ratón se ha presionado, mantenido o soltado.

// Vamos a plicar Zip a la lista de estados del ratón con ella misma con un elemento menos (Skip(1))
// estadosDelRaton =         {  false,         true,         true,          false,         true,        false  }  <- estado del ratón en un momento dado
// estadosDelRaton.Skip(1) = {  true,          true,         false,         true,          false               }  <- estado del ratón en el momento siguiente
// resultado de Zip =        { (false, true), (true, true), (true, false), (false, true), (true, false)        }
// resultado =               {  Presionado,    Mantenido,    Soltado,       Presionado,    Soltado             }

enum eventoRaton { NoPresionado, Presionado, Mantenido, Soltado };

public class Zip
{
    public static void ZipMain()
    {
        var estadosDelRaton = new List<bool> { false, true, true, false, true, false, false, true, true, true, false, false, false, false, true, true, true, true, false, false, false, false, true, true, false };

        var resultado = estadosDelRaton
        .Zip(estadosDelRaton.Skip(1), 
                (estadoAnterior, estadoActual) => (estadoAnterior, estadoActual) switch
                {
                    (false, false) => eventoRaton.NoPresionado,
                    (false, true) => eventoRaton.Presionado,
                    (true, true) => eventoRaton.Mantenido,
                    (true, false) => eventoRaton.Soltado,
                }
            );

        Console.WriteLine("Resultado:\n" + string.Join("\n", resultado));
    }

}

/* Salida:
Presionado
Mantenido
Soltado
Presionado
Soltado
NoPresionado
Presionado
Mantenido
Mantenido
Soltado
NoPresionado
NoPresionado
NoPresionado
Presionado
Mantenido
Mantenido
Mantenido
Soltado
NoPresionado
NoPresionado
NoPresionado
Presionado
Mantenido
Soltado
Presionado
Mantenido
Soltado
Presionado
Soltado
NoPresionado
Presionado
Mantenido
Mantenido
Soltado
NoPresionado
NoPresionado
NoPresionado
Presionado
Mantenido
Mantenido
Mantenido
Soltado
NoPresionado
NoPresionado
NoPresionado
Presionado
Mantenido
Soltado */