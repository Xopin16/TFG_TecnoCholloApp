import 'package:equatable/equatable.dart';

abstract class CategoryProductEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CategoryProductFetched extends CategoryProductEvent {}
  // CategoryProductFetched(this.id);
  // final int id;
