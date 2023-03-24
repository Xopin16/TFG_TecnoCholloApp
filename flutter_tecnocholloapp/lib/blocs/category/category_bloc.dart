import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:flutter_tecnocholloapp/blocs/category/category.dart';
import 'package:flutter_tecnocholloapp/services/services.dart';

import '../../services/category_service.dart';

var counter = 0;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService _categoryService;
  CategoryBloc(CategoryService categoryService)
      : assert(categoryService != null),
        _categoryService = categoryService,
        super(const CategoryState()) {
    on<CategoryFetched>(
      _onCategoryFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RemoveCategory>(
      _onRemoveCategory,
    );
    // on<EditCategory>(
    //   _onEditCategory,
    // );
  }

  Future<void> _onCategoryFetched(
    CategoryFetched event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == CategoryStatus.initial) {
        counter = 0;
        final categories = await _categoryService.getAllCategories(counter);
        return emit(
          state.copyWith(
            status: CategoryStatus.success,
            categories: categories.category,
            hasReachedMax: categories.totalPages - 1 <= counter,
          ),
        );
      }
      counter++;
      final categories = await _categoryService.getAllCategories(counter);
      emit(
        state.copyWith(
          status: CategoryStatus.success,
          categories: List.of(state.categories)..addAll(categories.category),
          hasReachedMax: categories.totalPages - 1 <= counter,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CategoryStatus.failure));
    }
  }

  void _onRemoveCategory(
    RemoveCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await _categoryService.deleteCategory(event.id);
      emit(state.copyWith(status: CategoryStatus.deleted));
    } catch (_) {
      emit(state.copyWith(status: CategoryStatus.failDeleted));
    }
  }

  // Future<void> _onEditCategory(
  //   EditCategory event,
  //   Emitter<CategoryState> emit,
  // ) async {
  //   try {
  //     await _categoryService.editCategory(event.id, event.nombre);
  //     emit(state.copyWith(status: CategoryStatus.edited));
  //   } catch (_) {
  //     emit(state.copyWith(status: CategoryStatus.failEdited));
  //   }
  // }
}
