import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/follows_remote_datasource.dart';
import '../data/repositories/follows_repository_impl.dart';
import '../domain/repositories/follows_repository.dart';
import '../domain/usecases/follow_teacher_usecase.dart';
import '../domain/usecases/get_followers_usecase.dart';
import '../domain/usecases/get_following_usecase.dart';
import '../domain/usecases/unfollow_teacher_usecase.dart';

class FollowsDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<FollowsRemoteDataSource>(
      () => FollowsRemoteDataSourceImpl(),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<FollowsRepository>(
      () => FollowsRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => FollowTeacherUseCase(sl()));
    sl.registerLazySingleton(() => UnfollowTeacherUseCase(sl()));
    sl.registerLazySingleton(() => GetFollowingUseCase(sl()));
    sl.registerLazySingleton(() => GetFollowersUseCase(sl()));
  }
}
