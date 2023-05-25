import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/carrito/carrito_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/carrito/carrito_event.dart';

import '../../models/carrito.dart';

class CarritoListItem extends StatelessWidget {
  const CarritoListItem({Key? key, required this.carrito}) : super(key: key);

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
        child: SingleChildScrollView(
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
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: carrito.productos!.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final producto = carrito.productos![index];
                  return ListTile(
                    title: Text(producto.nombre),
                    subtitle: Text('${producto.precio}€'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        BlocProvider.of<CarritoBloc>(context)
                          ..add(RemoveCarrito(producto.id));
                      },
                    ),
                  );
                },
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
                    '${carrito.total}€',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // final _ventaService = getIt<VentaService>();
                  // _ventaService.checkout();
                  BlocProvider.of<CarritoBloc>(context)..add(CarritoSold());
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.0),
                  ),
                  backgroundColor: Colors.lightGreen,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: Center(
                    child: Text(
                      'FINALIZAR COMPRA',
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
