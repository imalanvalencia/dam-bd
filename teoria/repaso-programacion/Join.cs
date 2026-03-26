using System.Collections.Generic;

// ¡IMPORTANTE!
// Para que el código funcione, MiniNeptuno.cs debe estar en la carpeta de tu proyecto

/* Tablas y campos:
categorias    (int IdCategoria, string NombreCategoria);
proveedores   (int IdProveedor, string NombreProveedor, string? Contacto, string? Telefono, string? Direccion);
productos     (int IdProducto,  string NombreProducto, int IdCategoria, int IdProveedor, decimal Precio, int Stock);
detallePedido (int IdDetallePedido, int IdPedido, int IdProducto, int Cantidad, decimal PrecioUnitario);
pedidos       (int IdPedido, int IdCliente, int IdEmpleado, DateTime FechaPedido);
clientes      (int IdCliente,   string NombreCliente, string? Contacto, string? Telefono, string? Direccion);
empleados     (int IdEmpleado,  string NombreEmpleado, string Cargo, string? Telefono, string? Direccion);
*/

public class Join
{
  public static void ImprimeElementos<T>(string titulo, IEnumerable<T> elementos)
  {
    Console.WriteLine(titulo);
    foreach (var elemento in elementos)
      Console.WriteLine(elemento);
    Console.WriteLine();
  }

  public static void ImprimeElementos(string titulo, object valor)
  {
    Console.WriteLine($"{titulo}: {valor}");
  }

  public static void JoinMain()
  {
    // CONSULTA 1 -------------------------------------------------------------------
    // Listado de productos y su categoría
    // Salida:
    /*  { Producto = Coca Cola 1L, Categoria = Bebidas }
        { Producto = Pepsi 1L, Categoria = Bebidas }
        { Producto = Agua Mineral 1.5L, Categoria = Bebidas }
        ...
        { Producto = Monitor Full HD, Categoria = Electrónica } */

    var consulta1 = MiniNeptuno.productos
        .Join(
                MiniNeptuno.categorias,
                p => p.IdCategoria,
                c => c.IdCategoria,
                (p, c) => new { Producto = p, Categoria = c }
            );

    ImprimeElementos("Consulta 1: Listado de productos y su categoría", consulta1);

    // CONSULTA 2 -------------------------------------------------------------------
    // IdCategoria y número de productos de esa categoría
    // Salida:
    /*  { IdCategoria = 1, NumeroProductos = 3 }
        { IdCategoria = 2, NumeroProductos = 3 }
        { IdCategoria = 3, NumeroProductos = 4 } */

    var consulta2 = MiniNeptuno.productos
      .GroupBy(
          p => p.IdCategoria, 
          (g, p) => new { IdCategoria = g, NumeroProductos = p.Count()
        });

    ImprimeElementos("Consulta 2: IdCategoria y número de productos de esa categoría", consulta2);

    // CONSULTA 3 -------------------------------------------------------------------
    // Nombre de la categoría y número de productos de esa categoría
    // Salida:
    /*  { Categoria = Bebidas, NumeroProductos = 3 }
        { Categoria = Alimentos, NumeroProductos = 3 }
        { Categoria = Electrónica, NumeroProductos = 4 } */

    var consulta3 = 3;

    ImprimeElementos("Consulta 3: Nombre de la categoria y número de productos de esa categoría", consulta3);

    // CONSULTA 4 -------------------------------------------------------------------
    // Id del pedido y nombre del cliente
    // Salida:
    /*  { IdPedido = 1, Cliente = Supermercados La Plaza }
        { IdPedido = 2, Cliente = Supermercados La Plaza }
        { IdPedido = 3, Cliente = Tiendas El Sol }
        { IdPedido = 4, Cliente = Almacenes del Sur }
        ...
        { IdPedido = 19, Cliente = Comercial Herrera } */

    var consulta4 = 4;

    ImprimeElementos("Consulta 4: IdCategoria y número de productos de esa categoría", consulta4);

    // CONSULTA 5 -------------------------------------------------------------------
    // Id del pedido, nombre del cliente y nombre del empleado que gestiona el pedido
    // Salida:
    /*  { IdPedido = 1, Cliente = Supermercados La Plaza, Empleado = Ana López (Gerente) }
        { IdPedido = 2, Cliente = Supermercados La Plaza, Empleado = Laura Sánchez (Vendedor) }
        { IdPedido = 3, Cliente = Tiendas El Sol, Empleado = Carlos Martínez (Vendedor) }
        ...
        { IdPedido = 19, Cliente = Comercial Herrera, Empleado = María Fernández (Administrador) } */

    var consulta5 = 5;

    ImprimeElementos("Consulta 5: Id del pedido, nombre del cliente y nombre del empleado que gestiona el pedido", consulta5);
  }
}