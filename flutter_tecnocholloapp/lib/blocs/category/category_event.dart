import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryFetched extends CategoryEvent {}

class RemoveCategory extends CategoryEvent {
  RemoveCategory(this.id);
  final int id;
}

// class EditCategory extends CategoryEvent {
//   EditCategory(this.id, this.nombre);
//   final int id;
//   final String nombre;
// }
