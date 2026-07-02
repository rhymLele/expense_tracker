import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../../../features/topics/domain/usecases/create_topic_usecase.dart';
import '../data/datasources/posts_remote_datasource.dart';
import '../presentation/bloc/create_post_cubit.dart';

class PostsDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<PostsRemoteDataSource>(
      () => PostsRemoteDataSourceImpl(),
    );
  }

  @override
  void blocs(GetIt sl) {
    sl.registerFactory(
      () => CreatePostCubit(createTopicUseCase: sl<CreateTopicUseCase>()),
    );
  }
}
