import '../../../../../core/base/base_cubit.dart';
import '../../../../../core/base/base_state.dart';
import '../../../data/datasources/exercises_remote_datasource.dart';
import 'template_gallery_state.dart';

class TemplateGalleryCubit extends LoadCubit<TemplateGalleryState> {
  final ExercisesRemoteDataSource _datasource;

  TemplateGalleryCubit({required ExercisesRemoteDataSource datasource})
      : _datasource = datasource,
        super(const TemplateGalleryState());

  @override
  Future<void> fetchData() => load();

  Future<void> load() => guard(() async {
        final templates = await _datasource.getTemplates();
        return state.copyWith(
          status: ViewStatus.success,
          templates: templates,
        );
      });

  void selectCategory(String? category) {
    if (category == state.selectedCategory) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(selectedCategory: category));
    }
  }
}
