import 'package:equatable/equatable.dart';

abstract class ProductUserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductUserFetched extends ProductUserEvent {}

class RemoveProduct extends ProductUserEvent {
  RemoveProduct(this.id);
  final int id;
}

// class EditProduct extends ProductUserEvent {
//   EditProduct(this.id, this.nombre, this.precio, this.descripcion);
//   final int id;
//   final String nombre;
//   final double precio;
//   final String descripcion;
// }
