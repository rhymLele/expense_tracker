import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/teachers_remote_datasource.dart';
import '../data/repositories/teachers_repository_impl.dart';
import '../domain/repositories/teachers_repository.dart';
import '../domain/usecases/get_teacher_profile_usecase.dart';
import '../domain/usecases/get_teachers_usecase.dart';
import '../domain/usecases/update_teacher_profile_usecase.dart';
import '../presentation/bloc/teachers_list_bloc.dart';
import '../presentation/bloc/teacher_profile_bloc.dart';
import '../presentation/teacher_profile_view_model.dart';

class TeachersDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<TeachersRemoteDataSource>(
      () => TeachersRemoteDataSourceImpl(),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<TeachersRepository>(
      () => TeachersRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => GetTeachersUseCase(sl()));
    sl.registerLazySingleton(() => GetTeacherProfileUseCase(sl()));
    sl.registerLazySingleton(() => UpdateTeacherProfileUseCase(sl()));
  }

  @override
  void blocs(GetIt sl) {
    sl.registerFactory(
      () => TeachersListBloc(getTeachersUseCase: sl()),
    );
    sl.registerFactory(
      () => TeacherProfileBloc(
        getTeacherProfile: sl(),
        getTopicsByTeacher: sl(),
        follow: sl(),
        unfollow: sl(),
      ),
    );
  }

  @override
  void viewModels(GetIt sl) {
    sl.registerFactory(
      () => TeacherProfileViewModel(
        getTeacherProfile: sl(),
        getTopicsByTeacher: sl(),
        follow: sl(),
        unfollow: sl(),
      ),
    );
  }
}
