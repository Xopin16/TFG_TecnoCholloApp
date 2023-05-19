import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/carrito/carrito_bloc.dart';
import '../../blocs/carrito/carrito_state.dart';
import '../pages/no_products_page.dart';
import 'carrito_list_item.dart';

class CarritoList extends StatefulWidget {
  const CarritoList({super.key});

  @override
  State<CarritoList> createState() => CarritoListState();
}

class CarritoListState extends State<CarritoList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarritoBloc, CarritoState>(
      builder: (context, state) {
        switch (state.status) {
          case CarritoStatus.failure:
            return NoProducts();
          // return const Center(child: Text('NO HAY PRODUCTOS.'));
          case CarritoStatus.success:
            if (state.carrito.toString().isEmpty) {
              return NoProducts();
            }
            // return DetailsListItem(details: state.carrito!);
            return CarritoListItem(
              carrito: state.carrito!,
            );
          case CarritoStatus.initial:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
