import 'package:equatable/equatable.dart';
import '../../models/product.dart';

enum DetailStatus { initial, success, failure }

class DetailState extends Equatable {
  const DetailState({this.status = DetailStatus.initial, this.details});

  final DetailStatus status;
  final Product? details;

  DetailState copyWith({
    DetailStatus? status,
    Product? details,
  }) {
    return DetailState(
        status: status ?? this.status, details: details ?? this.details);
  }

  @override
  String toString() {
    return '''DetailState { status: $status }''';
  }

  @override
  List<Object> get props => [status];
}
