import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/notifications_remote_datasource.dart';
import '../presentation/bloc/notifications_cubit.dart';

class NotificationsDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(),
    );
  }

  @override
  void blocs(GetIt sl) {
    sl.registerFactory(
      () => NotificationsCubit(datasource: sl()),
    );
  }
}
