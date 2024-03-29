import 'package:equatable/equatable.dart';

abstract class FavouriteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FavouriteFetched extends FavouriteEvent {}

class RemoveFavorite extends FavouriteEvent {
  final int id;
  RemoveFavorite(this.id);
}
