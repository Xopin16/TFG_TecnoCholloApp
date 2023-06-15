import 'package:equatable/equatable.dart';

import '../../models/product.dart';

enum VentaStatus { initial, success, failure }

class VentaState extends Equatable {
  const VentaState({
    this.status = VentaStatus.initial,
    this.ventas = const <dynamic>[],
  });

  final VentaStatus status;
  final List<dynamic> ventas;

  VentaState copyWith({
    VentaStatus? status,
    List<Product>? products,
    required List ventas,
  }) {
    return VentaState(
      status: status ?? this.status,
      ventas: ventas,
    );
  }

  @override
  String toString() {
    return '''VentaState { status: $status, products: ${ventas.length} }''';
  }

  @override
  List<Object> get props => [status, ventas];
}
