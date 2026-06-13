import 'package:get_it/get_it.dart';
import '../../../core/base/base_feature_di.dart';
import '../data/datasources/chat_remote_datasource.dart';

class ChatDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(),
    );
  }
}
