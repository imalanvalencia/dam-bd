// Introducción a SelecMany

public class SelectMany
{
    public static void SelectManyMain()
    {
        // Se puede usar para aplanar tablas
        int[][] tablaDentada =
        {
            new[] { 1, 2, 3 },
            new[] { 10, 20, 30, 40 },
            new[] { 5, 6, 7, 8, 9 },
            new[] { 100, 200, 300 },
            new[] { 11, 22, 33, 44, 55 }
        };

        var tablaAplanada = tablaDentada.SelectMany(t => t);
        Console.WriteLine("Numeros: " + string.Join(" ", tablaAplanada));

        var numerosPares = tablaDentada.SelectMany(t => t.Where(n => n % 2 == 0));
        var numerosPares2 = tablaDentada.SelectMany(t => t).Where(n => n % 2 == 0); // --> menos eficiente
        var noSeLoQueES = tablaDentada.SelectMany(t => t).Where(n => n % 2 == 0).OrderBy(n => n).Skip(1).Take(3); // --> menos eficiente
        Console.WriteLine("Numeros pares: " + string.Join(" ", numerosPares));
        Console.WriteLine("Numeros pares V2: " + string.Join(" ", numerosPares2));
        Console.WriteLine("No se lo que es: " + string.Join(" ", noSeLoQueES));


        // Es útil en tablas que contienen colecciones, como por ejemplo personas con sus mascotas
        var personasYMascotas = new[]
        {
            new { Nombre = "Ana",     Mascotas = new[] { "Luna", "Sol" } },
            new { Nombre = "Luis",    Mascotas = new[] { "Rex" } },
            new { Nombre = "Marta",   Mascotas = new[] { "Toby", "Nube", "Kiwi" } },
            new { Nombre = "Carlos",  Mascotas = new[] { "Max" } },
            new { Nombre = "Julia",   Mascotas = new[] { "Bimba", "Coco" } },
            new { Nombre = "Pablo",   Mascotas = new[] { "Nina" } },
            new { Nombre = "Laura",   Mascotas = new[] { "Pecas", "Rocky" } },
            new { Nombre = "Diego",   Mascotas = new[] { "Thor" } },
            new { Nombre = "Sara",    Mascotas = new[] { "Lola", "Molly", "Chispa" } },
            new { Nombre = "Elena",   Mascotas = new[] { "Kira" } }
        };

        var todasMascotas = personasYMascotas.SelectMany(pym => pym.Mascotas);
        System.Console.WriteLine("Mascotas: " + string.Join(" ", todasMascotas));

        // Se puede usar para aplanar frases en palabras, o palabras en caracteres
        // String.Split Method returns a string array that contains the substrings in this instance that are delimited by elements of a specified string
        var quijote = new List<string>
        {
            "En un lugar de La Mancha, de cuyo nombre no quiero acordarme,",
            "no ha mucho tiempo que vivía un hidalgo de los de lanza en astillero,",
            "adarga antigua, rocín flaco y galgo corredor."
        };

        var quijoteEnPalabras = quijote.SelectMany(f => f.Split(" ,.".ToCharArray(), StringSplitOptions.RemoveEmptyEntries));

        Console.WriteLine("Quijote en palabras: " + string.Join(" ", quijoteEnPalabras));

        var saludo = new List<string>
        {
            "Hola",
            "mundo",
            "cruel"
        };

    }
}