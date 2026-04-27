import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/di/auth_di.dart';
import '../base/base_feature_di.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  _registerInfrastructure();
  _registerFeatures();
}

void _registerInfrastructure() {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}

/// Thêm feature mới: chỉ cần thêm vào list này.
void _registerFeatures() {
  final features = <BaseFeatureDI>[
    AuthDI(),
    // HomeDI(),
    // ProfileDI(),
  ];
  for (final feature in features) {
    feature.register(sl);
  }
}
