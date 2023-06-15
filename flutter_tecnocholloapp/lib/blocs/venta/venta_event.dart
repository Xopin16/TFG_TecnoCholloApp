import 'package:equatable/equatable.dart';

abstract class VentaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VentaFetched extends VentaEvent {}
