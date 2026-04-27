import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../../core/base/base_feature_di.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../presentation/login/login_view_model.dart';
import '../presentation/register/register_view_model.dart';
import '../presentation/shared/auth_bloc.dart';

class AuthDI extends BaseFeatureDI {
  @override
  void datasources(GetIt sl) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        auth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
      ),
    );
  }

  @override
  void repositories(GetIt sl) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl()),
    );
  }

  @override
  void usecases(GetIt sl) {
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => LogoutUseCase(sl()));
    sl.registerLazySingleton(() => RegisterUseCase(sl()));
    sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  }

  @override
  void blocs(GetIt sl) {
    sl.registerLazySingleton(
      () => AuthBloc(
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ),
    );
  }

  @override
  void viewModels(GetIt sl) {
    sl.registerFactory(() => LoginViewModel(loginUseCase: sl()));
    sl.registerFactory(() => RegisterViewModel(registerUseCase: sl()));
  }
}
