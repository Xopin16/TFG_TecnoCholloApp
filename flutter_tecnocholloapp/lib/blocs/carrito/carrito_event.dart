import 'package:equatable/equatable.dart';

abstract class CarritoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CarritoFetched extends CarritoEvent {}

class RemoveCarrito extends CarritoEvent {
  RemoveCarrito(this.id);
  final int id;
}

class CarritoSold extends CarritoEvent {}
