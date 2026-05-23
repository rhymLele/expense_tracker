import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/journeys_remote_datasource.dart';
import '../data/repositories/journeys_repository_impl.dart';
import '../domain/repositories/journeys_repository.dart';
import '../domain/usecases/enroll_journey_usecase.dart';
import '../domain/usecases/get_journey_days_usecase.dart';
import '../domain/usecases/get_journey_usecase.dart';

class JourneysDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<JourneysRemoteDataSource>(
      () => JourneysRemoteDataSourceImpl(),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<JourneysRepository>(
      () => JourneysRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => GetJourneyUseCase(sl()));
    sl.registerLazySingleton(() => GetJourneyDaysUseCase(sl()));
    sl.registerLazySingleton(() => EnrollJourneyUseCase(sl()));
  }
}
