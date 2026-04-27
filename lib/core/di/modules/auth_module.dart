import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../../features/auth/domain/usecases/login_usecase.dart';
import '../../../features/auth/domain/usecases/logout_usecase.dart';
import '../../../features/auth/domain/usecases/register_usecase.dart';
import '../../../features/auth/presentation/login/bloc/login_bloc.dart';
import '../../../features/auth/presentation/register/bloc/register_bloc.dart';
import '../../../features/auth/presentation/shared/auth_bloc.dart';

class AuthModule {
  static void register(GetIt sl) {
    _datasources(sl);
    _repositories(sl);
    _usecases(sl);
    _blocs(sl);
  }

  static void _datasources(GetIt sl) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        auth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
      ),
    );
  }

  static void _repositories(GetIt sl) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl()),
    );
  }

  static void _usecases(GetIt sl) {
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => LogoutUseCase(sl()));
    sl.registerLazySingleton(() => RegisterUseCase(sl()));
    sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  }

  static void _blocs(GetIt sl) {
    // Singleton — sống suốt vòng đời app, cung cấp qua BlocProvider ở root
    sl.registerLazySingleton(
      () => AuthBloc(
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ),
    );

    // Factory — tạo mới mỗi lần vào màn hình
    sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
    sl.registerFactory(() => RegisterBloc(registerUseCase: sl()));
  }

  // ViewModels được tạo trực tiếp trong router (không qua sl)
  // để đảm bảo ViewModel và BlocProvider dùng cùng BLoC instance.
}
