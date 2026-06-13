import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/exercises_remote_datasource.dart';
import 'template_gallery_state.dart';

class TemplateGalleryCubit extends Cubit<TemplateGalleryState> {
  final ExercisesRemoteDataSource _datasource;

  TemplateGalleryCubit({required ExercisesRemoteDataSource datasource})
      : _datasource = datasource,
        super(const TemplateGalleryState());

  Future<void> load() async {
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

  void selectCategory(String? category) {
    if (category == state.selectedCategory) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: category));
    }
  }
}
