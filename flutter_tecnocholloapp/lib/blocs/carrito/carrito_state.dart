import 'package:equatable/equatable.dart';
import '../../models/carrito.dart';

enum CarritoStatus { initial, success, failure, deleted, failDeleted, sold }

class CarritoState extends Equatable {
  const CarritoState({this.status = CarritoStatus.initial, this.carrito});

  final CarritoStatus status;
  final Carrito? carrito;

  CarritoState copyWith({
    CarritoStatus? status,
    Carrito? carrito,
  }) {
    return CarritoState(
        status: status ?? this.status, carrito: carrito ?? this.carrito);
  }

  @override
  String toString() {
    return '''CarritoState { status: $status }''';
  }

  @override
  List<Object> get props => [status];
}
