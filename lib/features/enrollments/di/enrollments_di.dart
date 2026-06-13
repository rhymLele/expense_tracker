import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/enrollments_remote_datasource.dart';
import '../data/repositories/enrollments_repository_impl.dart';
import '../domain/repositories/enrollments_repository.dart';
import '../domain/usecases/get_my_enrollments_usecase.dart';
import '../domain/usecases/get_today_tasks_usecase.dart';
import '../domain/usecases/use_freeze_usecase.dart';
import '../presentation/bloc/enrollments_cubit.dart';
import '../presentation/bloc/roadmap_home/roadmap_home_cubit.dart';
import '../presentation/bloc/today_tasks_cubit.dart';

class EnrollmentsDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<EnrollmentsRemoteDataSource>(
      () => EnrollmentsRemoteDataSourceImpl(),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<EnrollmentsRepository>(
      () => EnrollmentsRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => GetMyEnrollmentsUseCase(sl()));
    sl.registerLazySingleton(() => GetTodayTasksUseCase(sl()));
    sl.registerLazySingleton(() => UseFreezeUseCase(sl()));
  }

  @override
  void blocs(GetIt sl) {
    sl.registerFactory(
      () => EnrollmentsCubit(getMyEnrollmentsUseCase: sl()),
    );
    sl.registerFactory(
      () => TodayTasksCubit(getTodayTasks: sl()),
    );
    sl.registerFactory(
      () => RoadmapHomeCubit(datasource: sl()),
    );
  }
}
