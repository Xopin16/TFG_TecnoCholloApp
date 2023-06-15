import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductFetched extends ProductEvent {}

class ProductFiltered extends ProductEvent {
  final String nombre;

  ProductFiltered(this.nombre);
}
