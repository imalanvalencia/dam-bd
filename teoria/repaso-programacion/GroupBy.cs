using System.Collections.Generic; // No es obligatorio
using System.Linq; // No es obligatorio

public record EntradasC(string Nombre, int Cantidad);

public class GroupBy
{
    public static void ImprimeElementos<T>(string titulo, IEnumerable<T> elementos)
    {
        Console.WriteLine(titulo);
        foreach (var elemento in elementos)
            Console.WriteLine(elemento);
        Console.WriteLine();
    }

    public static void GroupByMain()
    {
        // Crear y poblar la lista de personas
        List<EntradasC> fondoComun = new List<EntradasC>
        {
            new EntradasC("Juan", 10),
            new EntradasC("Ana", 15),
            new EntradasC("Raquel", 35),
            new EntradasC("Raquel", -15),
            new EntradasC("Ana", -10),
            new EntradasC("Raquel", -12),
            new EntradasC("Juan", -17),
            new EntradasC("Ana", 16),
            new EntradasC("Juan", -5),
            new EntradasC("Raquel", 20)
        };

        // Consultas sobre la lista de personas
        var saldoTotal = fondoComun.Sum((r) => r.Cantidad);
        Console.WriteLine($"Saldo Total: {saldoTotal}");

        var numeroDeOperaciones = fondoComun.Count();
        Console.WriteLine($"Numero de operaciones: {numeroDeOperaciones}");

        var operacionConMayorCantidad = fondoComun.Max(r => r.Cantidad);
        Console.WriteLine($"Operacion con mayor cantidad: {operacionConMayorCantidad}");
        var operacionConMenorCantidad = fondoComun.Min(r => r.Cantidad);
        Console.WriteLine($"Operacion con menor cantidad: {operacionConMenorCantidad}");

        var cantidadPromedio = fondoComun.Average(r => r.Cantidad);
        Console.WriteLine($"Cantidad promedio: {cantidadPromedio}");

        var algunaCantidadNegativa = fondoComun.Exists(r => r.Cantidad < 0);
        Console.WriteLine($"¿Existe algun registro con cantidad negativa? : {(algunaCantidadNegativa ? "Si" : "No")}");

        var todosSonPositivos = fondoComun.All(r => r.Cantidad > 0);
        Console.WriteLine($"¿Todas las cantidades son positivas? : {(todosSonPositivos ? "Si" : "No")}");


        // var saldoPorPersona = fondoComun.GroupBy(r => r.Nombre, (g, rg) => new { Nombre = g, Saldo = rg.Sum(rgr => rgr.Cantidad) }).OrderBy(ns => ns.Nombre);
        var saldoPorPersona = fondoComun.GroupBy(r => r.Nombre, (g, rg) => new { Nombre = g, Saldo = rg.Sum(rgr => rgr.Cantidad) }).OrderBy(ns => ns.Nombre);
        // ImprimeElementos("Saldo por persona: ", saldoPorPersona);
    }
}