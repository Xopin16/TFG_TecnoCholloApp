import 'package:flutter/material.dart';
import 'package:flutter_tecnocholloapp/config/locator.dart';
import 'package:flutter_tecnocholloapp/services/venta_service.dart';
import 'package:flutter_tecnocholloapp/ui/pages/home_page.dart';

import '../../models/carrito.dart';

class CarritoListItem extends StatelessWidget {
  const CarritoListItem({super.key, required this.carrito});
  final Carrito carrito;

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
            Center(
              child: Text(
                'CESTA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Producto',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 40.0, bottom: 16.0),
                        child: Text(
                          'Precio',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                ...carrito.productos!.map((producto) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Text(producto.nombre),
                      ),
                      TableCell(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Text('${producto.precio}€'))),
                    ],
                  );
                }),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '1000€',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // final _ventaService = getIt<VentaService>();
                      // _ventaService.checkout();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => VentasScreen(),
                      //   ),
                      // );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.lightGreen,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: Text(
                        'FINALIZAR COMPRA',
                        style: TextStyle(fontSize: 12.0, color: Colors.black),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: Text("${carrito.id}"),
  //   );
  // }

