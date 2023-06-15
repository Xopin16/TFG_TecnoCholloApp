import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class DetailFetched extends DetailEvent {
  const DetailFetched(this.id);
  final int id;
}
