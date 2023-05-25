import 'package:flutter/material.dart';

import '../../models/venta.dart';

class VentaListItem extends StatelessWidget {
  final Venta venta;

  const VentaListItem({Key? key, required this.venta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FACTURA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text('ID de venta: ${venta.id}'),
            Text('Precio total: ${venta.precio}€'),
            Text('Fecha de venta: ${venta.fechaVenta.toString()}'),
            SizedBox(height: 16.0),
            Text(
              'Productos:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: venta.products!.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final producto = venta.products?[index];
                return ListTile(
                  title: Text(producto!.nombre),
                  subtitle: Text('Precio: ${producto.precio}€'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
