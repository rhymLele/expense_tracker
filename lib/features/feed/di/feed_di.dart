import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/feed_remote_datasource.dart';
import '../data/repositories/feed_repository_impl.dart';
import '../domain/repositories/feed_repository.dart';
import '../domain/usecases/get_feed_usecase.dart';
import '../presentation/bloc/feed_cubit.dart';

class FeedDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<FeedRemoteDataSource>(
      () => FeedRemoteDataSourceImpl(),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<FeedRepository>(
      () => FeedRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => GetFeedUseCase(sl()));
  }

  @override
  void blocs(GetIt sl) {
    sl.registerFactory(() => FeedCubit(getFeedUseCase: sl()));
  }
}
