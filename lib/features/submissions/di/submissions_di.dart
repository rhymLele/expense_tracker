import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/submissions_remote_datasource.dart';
import '../data/repositories/submissions_repository_impl.dart';
import '../domain/repositories/submissions_repository.dart';
import '../domain/usecases/get_enrollment_submissions_usecase.dart';
import '../domain/usecases/submit_answer_usecase.dart';

class SubmissionsDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<SubmissionsRemoteDataSource>(
      () => SubmissionsRemoteDataSourceImpl(),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<SubmissionsRepository>(
      () => SubmissionsRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => SubmitAnswerUseCase(sl()));
    sl.registerLazySingleton(() => GetEnrollmentSubmissionsUseCase(sl()));
  }
}
