using System.Collections.Generic;

public static class MiniNeptuno
{
  public record Categoria(int IdCategoria, string NombreCategoria);
  public record Proveedor(int IdProveedor, string NombreProveedor, string? Contacto, string? Telefono, string? Direccion);
  public record Producto(int IdProducto, string NombreProducto, int IdCategoria, int IdProveedor, decimal Precio, int Stock);
  public record Cliente(int IdCliente, string NombreCliente, string? Contacto, string? Telefono, string? Direccion);
  public record Empleado(int IdEmpleado, string NombreEmpleado, string Cargo, string? Telefono, string? Direccion);
  public record Pedido(int IdPedido, int IdCliente, int IdEmpleado, DateTime FechaPedido);
  public record DetallePedido(int IdDetallePedido, int IdPedido, int IdProducto, int Cantidad, decimal PrecioUnitario);

  // Poblar Categorias
  // public record Categoria(int IdCategoria, string NombreCategoria);
  public static List<Categoria> categorias = new List<Categoria>
    {
        new Categoria(1, "Bebidas"),
        new Categoria(2, "Alimentos"),
        new Categoria(3, "Electrónica")
    };

  // Poblar Proveedores
  // public record Proveedor(int IdProveedor, string NombreProveedor, string? Contacto, string? Telefono, string? Direccion);
  public static List<Proveedor> proveedores = new List<Proveedor>
    {
        new Proveedor(1, "Distribuidora Bebidas S.A.", "Juan Pérez", "912345678", "Av. Principal 123, Madrid"),
        new Proveedor(2, "Alimentos del Norte S.L.", "María López", "934567890", "Calle Mayor 45, Barcelona"),
        new Proveedor(3, "Productos Gourmet S.A.", "Carlos García", "956789012", "Plaza Central 10, Sevilla"),
        new Proveedor(4, "Electrodomésticos Global S.L.", "Ana Fernández", "987654321", "Calle Comercio 22, Valencia"),
        new Proveedor(5, "Tecnología Avanzada S.A.", "Luis Martínez", "910111213", "Av. Innovación 5, Bilbao")
    };

  // Poblar Productos
  // public record Producto(int IdProducto, string NombreProducto, int IdCategoria, int IdProveedor, decimal Precio, int Stock);
  public static List<Producto> productos = new List<Producto>
    {
        new Producto(1, "Coca Cola 1L", 1, 1, 1.50m, 100),
        new Producto(2, "Pepsi 1L", 1, 1, 1.40m, 120),
        new Producto(3, "Agua Mineral 1.5L", 1, 2, 0.80m, 200),
        new Producto(4, "Pan Integral 500g", 2, 2, 1.20m, 50),
        new Producto(5, "Galletas de Chocolate", 2, 3, 2.50m, 80),
        new Producto(6, "Leche Entera 1L", 2, 3, 1.00m, 150),
        new Producto(7, "Auriculares Bluetooth", 3, 4, 25.00m, 30),
        new Producto(8, "Teclado Mecánico", 3, 5, 15.00m, 20),
        new Producto(9, "Ratón Inalámbrico", 3, 5, 10.00m, 25),
        new Producto(10, "Monitor Full HD", 3, 5, 150.00m, 10)
    };

  // Poblar Clientes
  // public record Cliente(int IdCliente, string NombreCliente, string? Contacto, string? Telefono, string? Direccion);
  public static List<Cliente> clientes = new List<Cliente>
    {
      new Cliente(1, "Supermercados La Plaza", "Pedro Sánchez", "911223344", "Calle Gran Vía 12, Madrid"),
      new Cliente(2, "Tiendas El Sol", "Laura Gómez", "922334455", "Av. Mediterráneo 34, Valencia"),
      new Cliente(3, "Almacenes del Sur", "Javier Ruiz", "933445566", "Calle Andalucía 56, Sevilla"),
      new Cliente(4, "Comercial Norte", "Sofía Torres", "944556677", "Av. Cantábrico 78, Bilbao"),
      new Cliente(5, "Distribuciones Vega", "Miguel Ortega", "955667788", "Calle Sierra Nevada 90, Granada"),
      new Cliente(6, "Mercado Central", "Isabel Ramírez", "966778899", "Plaza Mayor 15, Barcelona"),
      new Cliente(7, "Hipermercados Global", "Andrés Castro", "977889900", "Calle Comercio 22, Zaragoza"),
      new Cliente(8, "Tiendas Familiares", "Patricia Vega", "988990011", "Av. Libertad 45, Alicante"),
      new Cliente(9, "Distribuidora León", "Fernando León", "999001122", "Calle León 67, León"),
      new Cliente(10, "Comercial Herrera", "Carmen Herrera", "910112233", "Calle Herrera 89, Valladolid")
    };

  // Poblar Empleados
  // public record Empleado(int IdEmpleado, string NombreEmpleado, string Cargo, string? Telefono, string? Direccion);
  public static List<Empleado> empleados = new List<Empleado>
    {
        new Empleado(1, "Ana López", "Gerente", "600123456", "Calle Alcalá 45, Madrid"),
        new Empleado(2, "Carlos Martínez", "Vendedor", "601234567", "Calle Balmes 23, Barcelona"),
        new Empleado(3, "Laura Sánchez", "Vendedor", "602345678", "Av. Blasco Ibáñez 12, Valencia"),
        new Empleado(4, "Javier Gómez", "Vendedor", "603456789", "Calle Feria 56, Sevilla"),
        new Empleado(5, "María Fernández", "Administrador", "604567890", "Av. Gran Vía 78, Bilbao")
    };

  // Poblar Pedidos
  // public record Pedido(int IdPedido, int IdCliente, int IdEmpleado, DateTime FechaPedido);
  public static List<Pedido> pedidos = new List<Pedido>
    {
        new Pedido(1, 1, 1, new DateTime(2023, 9, 15)),
        new Pedido(2, 1, 3, new DateTime(2023, 9, 20)),
        new Pedido(3, 2, 2, new DateTime(2023, 9, 18)),
        new Pedido(4, 3, 4, new DateTime(2023, 9, 25)),
        new Pedido(5, 3, 5, new DateTime(2023, 10, 1)),
        new Pedido(6, 3, 1, new DateTime(2023, 10, 5)),
        new Pedido(7, 4, 2, new DateTime(2023, 9, 10)),
        new Pedido(8, 4, 3, new DateTime(2023, 9, 22)),
        new Pedido(9, 4, 4, new DateTime(2023, 9, 30)),
        new Pedido(10, 5, 5, new DateTime(2023, 9, 5)),
        new Pedido(11, 6, 1, new DateTime(2023, 9, 28)),
        new Pedido(12, 6, 3, new DateTime(2023, 9, 14)),
        new Pedido(13, 7, 4, new DateTime(2023, 9, 21)),
        new Pedido(14, 8, 2, new DateTime(2023, 9, 8)),
        new Pedido(15, 8, 5, new DateTime(2023, 9, 19)),
        new Pedido(16, 9, 1, new DateTime(2023, 9, 16)),
        new Pedido(17, 9, 3, new DateTime(2023, 9, 29)),
        new Pedido(18, 9, 4, new DateTime(2023, 9, 11)),
        new Pedido(19, 10, 5, new DateTime(2023, 9, 26))
    };

  // Poblar DetallesPedido
  // public record DetallePedido(int IdDetallePedido, int IdPedido, int IdProducto, int Cantidad, decimal PrecioUnitario);
  public static List<DetallePedido> detallesPedido = new List<DetallePedido>
    {
        new DetallePedido(1, 1, 1, 10, 1.50m),
        new DetallePedido(2, 1, 3, 5, 0.80m),
        new DetallePedido(3, 2, 2, 8, 1.40m),
        new DetallePedido(4, 3, 4, 6, 1.20m),
        new DetallePedido(5, 3, 5, 4, 2.50m),
        new DetallePedido(6, 3, 6, 10, 1.00m),
        new DetallePedido(7, 4, 7, 2, 25.00m),
        new DetallePedido(8, 5, 8, 1, 15.00m),
        new DetallePedido(9, 5, 9, 3, 10.00m),
        new DetallePedido(10, 6, 10, 1, 150.00m),
        new DetallePedido(11, 7, 1, 12, 1.50m),
        new DetallePedido(12, 7, 2, 6, 1.40m),
        new DetallePedido(13, 8, 3, 15, 0.80m),
        new DetallePedido(14, 8, 4, 5, 1.20m),
        new DetallePedido(15, 9, 5, 7, 2.50m),
        new DetallePedido(16, 9, 6, 20, 1.00m),
        new DetallePedido(17, 10, 7, 3, 25.00m),
        new DetallePedido(18, 10, 8, 2, 15.00m),
        new DetallePedido(19, 11, 9, 4, 10.00m),
        new DetallePedido(20, 11, 10, 1, 150.00m),
        new DetallePedido(21, 12, 1, 8, 1.50m),
        new DetallePedido(22, 12, 3, 10, 0.80m),
        new DetallePedido(23, 13, 4, 5, 1.20m),
        new DetallePedido(24, 13, 5, 6, 2.50m),
        new DetallePedido(25, 14, 6, 12, 1.00m),
        new DetallePedido(26, 14, 7, 1, 25.00m),
        new DetallePedido(27, 15, 8, 2, 15.00m),
        new DetallePedido(28, 15, 9, 3, 10.00m),
        new DetallePedido(29, 16, 10, 1, 150.00m),
        new DetallePedido(30, 17, 1, 5, 1.50m),
        new DetallePedido(31, 17, 2, 3, 1.40m),
        new DetallePedido(32, 18, 3, 7, 0.80m),
        new DetallePedido(33, 18, 4, 4, 1.20m),
        new DetallePedido(34, 19, 5, 9, 2.50m),
        new DetallePedido(35, 19, 6, 15, 1.00m),
        new DetallePedido(36, 19, 7, 2, 25.00m),
        new DetallePedido(37, 19, 8, 1, 15.00m)
    };
}