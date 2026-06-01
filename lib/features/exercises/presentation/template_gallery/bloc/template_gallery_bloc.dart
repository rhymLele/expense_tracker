import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/exercises_remote_datasource.dart';
import 'template_gallery_event.dart';
import 'template_gallery_state.dart';

class TemplateGalleryBloc
    extends Bloc<TemplateGalleryEvent, TemplateGalleryState> {
  final ExercisesRemoteDataSource _datasource;

  TemplateGalleryBloc({required ExercisesRemoteDataSource datasource})
      : _datasource = datasource,
        super(const TemplateGalleryState()) {
    on<TemplateGalleryLoadRequested>(_onLoad);
    on<TemplateGalleryCategorySelected>(_onCategorySelected);
  }

  Future<void> _onLoad(
    TemplateGalleryLoadRequested event,
    Emitter<TemplateGalleryState> emit,
  ) async {
    emit(state.copyWith(status: TemplateGalleryStatus.loading));
    try {
      final templates = await _datasource.getTemplates();
      emit(state.copyWith(
        status: TemplateGalleryStatus.success,
        templates: templates,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TemplateGalleryStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onCategorySelected(
    TemplateGalleryCategorySelected event,
    Emitter<TemplateGalleryState> emit,
  ) {
    if (event.category == state.selectedCategory) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: event.category));
    }
  }
}
