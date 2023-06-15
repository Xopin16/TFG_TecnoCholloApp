import 'package:bloc/bloc.dart';
import '../../services/product_service.dart';
import 'details.dart';

class DetailsBloc extends Bloc<DetailEvent, DetailState> {
  late ProductService _productService;
  DetailsBloc(ProductService productService)
      : assert(productService != null),
        _productService = productService,
        super(const DetailState()) {
    on<DetailFetched>(
      _onDetailFetched,
    );
  }

  Future<void> _onDetailFetched(
    DetailFetched event,
    Emitter<DetailState> emit,
  ) async {
    if (state.props.isEmpty) return;
    try {
      if (state.status == DetailStatus.initial) {
        final details = await _productService.getDetail(event.id);
        return emit(
            state.copyWith(details: details, status: DetailStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: DetailStatus.failure));
    }
  }
}
