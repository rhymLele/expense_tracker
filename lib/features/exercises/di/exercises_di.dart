import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/exercises_remote_datasource.dart';
import '../data/repositories/exercises_repository_impl.dart';
import '../domain/repositories/exercises_repository.dart';
import '../domain/usecases/get_exercise_usecase.dart';
import '../domain/usecases/get_exercises_by_teacher_usecase.dart';
import '../presentation/bloc/exercise_session_bloc.dart';
import '../presentation/create_exercise/bloc/create_exercise_bloc.dart';
import '../presentation/template_gallery/bloc/template_gallery_bloc.dart';

class ExercisesDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<ExercisesRemoteDataSource>(
      () => ExercisesRemoteDataSourceImpl(),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<ExercisesRepository>(
      () => ExercisesRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => GetExerciseUseCase(sl()));
    sl.registerLazySingleton(() => GetExercisesByTeacherUseCase(sl()));
  }

  @override
  void blocs(GetIt sl) {
    sl.registerFactory(
      () => ExerciseSessionBloc(
        getTodayTasks: sl(),
        submitAnswer: sl(),
      ),
    );
    sl.registerFactory(() => TemplateGalleryBloc(datasource: sl()));
    sl.registerFactory(() => CreateExerciseBloc(datasource: sl()));
  }
}
