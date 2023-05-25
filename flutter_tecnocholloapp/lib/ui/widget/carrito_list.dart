import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tecnocholloapp/blocs/carrito/carrito_bloc.dart';
import 'package:flutter_tecnocholloapp/models/models.dart';
import 'package:flutter_tecnocholloapp/ui/pages/carrito_sold_page.dart';
import 'package:flutter_tecnocholloapp/ui/pages/delete_carrito_page.dart';
import 'package:flutter_tecnocholloapp/ui/pages/no_cart_page.dart';
import '../../blocs/carrito/carrito_state.dart';
import 'carrito_list_item.dart';

class CarritoList extends StatefulWidget {
  final User user;
  const CarritoList({super.key, required this.user});

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
            return Text("failed to fetch carrito");
          // return const Center(child: Text('NO HAY PRODUCTOS.'));
          case CarritoStatus.success:
            if (state.carrito!.productos!.isEmpty) {
              return NoCart();
            }
            // return DetailsListItem(details: state.carrito!);
            return CarritoListItem(
              carrito: state.carrito!,
            );
          case CarritoStatus.initial:
            return const CircularProgressIndicator();
          case CarritoStatus.deleted:
            return DeletedCarritoPage(
              user: widget.user,
            );
          case CarritoStatus.failDeleted:
            return Text("Fallo al borrar");
          case CarritoStatus.sold:
            return SoldCarritoPage(user: widget.user);
        }
      },
    );
  }
}
