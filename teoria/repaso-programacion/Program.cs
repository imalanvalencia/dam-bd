

public class Program
{
    public static void MapeaElementos()
    {
        double[] reales = [1.3, 3.4, 4.5, 5.6, 8.7];

        /* 
        map --> Select
        */

        int[] num = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 25, 12, 15, 16, 10];


        string IntToSrt(int num) => num switch
        {
            0 => "cero",
            1 => "uno",
            2 => "dos",
            3 => "tres",
            4 => "cuatro",
            5 => "cinco",
            6 => "seis",
            7 => "siete",
            8 => "ocho",
            9 => "nueve",
            _ => "otro",
        };

        Func<int, string> IntToSrtDel = IntToSrt;


        IEnumerable<int> Generador()
        {
            Random semilla = new();

            for (int i = 0; i < 20; i++)
            {
                /* 
                    Hace que se procese los numero sin tener que esperarlos
                    y no se crea un array nunca para guardar los datos
                    la idea es procesarlos conforme lleguen, asi optimizas la memoria sin saturarla
                    Generacion Perezosa
                */
                yield return semilla.Next(21);
            }
        }

        var numString = num.Select(IntToSrtDel);
        //  El yield pasa automaticamente el select se crea ese numero y se pasa al select, luego crea otro numero y lo pasa al select, ... 
        var numerosAleatorioString = Generador().Select(IntToSrtDel);


        IEnumerable<double> enteros = reales.Select(n => n * 2);

        Console.WriteLine("Numero reales: " + string.Join(", ", enteros));
        Console.WriteLine("Numero Cadena: " + string.Join(", ", numString));
        Console.WriteLine("Numero aleatorios: " + string.Join(", ", numerosAleatorioString));
    }

    public static void Main()
    {
        Console.WriteLine("\n======================================  Consola ======================================\n");

        // MapeaElementos();
        GroupBy.GroupByMain();

        Console.WriteLine("\n======================================  Consola ======================================\n");

    }
}
