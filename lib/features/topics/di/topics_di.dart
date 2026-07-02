import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/topics_remote_datasource.dart';
import '../data/repositories/topics_repository_impl.dart';
import '../domain/repositories/topics_repository.dart';
import '../domain/usecases/add_topic_comment_usecase.dart';
import '../domain/usecases/apply_like_toggle_usecase.dart';
import '../domain/usecases/create_topic_usecase.dart';
import '../domain/usecases/get_topic_comments_usecase.dart';
import '../domain/usecases/get_topic_usecase.dart';
import '../domain/usecases/get_topics_by_teacher_usecase.dart';
import '../domain/usecases/toggle_like_usecase.dart';
import '../presentation/create_topic/create_topic_view_model.dart';
import '../presentation/topic_detail_view_model.dart';

class TopicsDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<TopicsRemoteDataSource>(
      () => TopicsRemoteDataSourceImpl(),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<TopicsRepository>(
      () => TopicsRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => GetTopicUseCase(sl()));
    sl.registerLazySingleton(() => GetTopicsByTeacherUseCase(sl()));
    sl.registerLazySingleton(() => CreateTopicUseCase(sl()));
    sl.registerLazySingleton(() => ToggleLikeUseCase(sl()));
    sl.registerLazySingleton(() => const ApplyLikeToggleUseCase());
    sl.registerLazySingleton(() => GetTopicCommentsUseCase(sl()));
    sl.registerLazySingleton(() => AddTopicCommentUseCase(sl()));
  }

  @override
  void viewModels(GetIt sl) {
    sl.registerFactory(
      () => TopicDetailViewModel(
        getTopic: sl(),
        getComments: sl(),
        toggleLike: sl(),
        addComment: sl(),
      ),
    );
    sl.registerFactory(() => CreateTopicViewModel(createTopic: sl()));
  }
}
