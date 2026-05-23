import 'package:get_it/get_it.dart';

import '../../features/auth/di/auth_di.dart';
import '../../features/enrollments/di/enrollments_di.dart';
import '../../features/exercises/di/exercises_di.dart';
import '../../features/feed/di/feed_di.dart';
import '../../features/follows/di/follows_di.dart';
import '../../features/journeys/di/journeys_di.dart';
import '../../features/submissions/di/submissions_di.dart';
import '../../features/teachers/di/teachers_di.dart';
import '../../features/topics/di/topics_di.dart';
import '../base/base_feature_di.dart';
import '../network/network_client.dart';
import '../storage/token_storage.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  _registerInfrastructure();
  _registerFeatures();
}

void _registerInfrastructure() {
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  NetworkClient.init(sl<TokenStorage>());
}

void _registerFeatures() {
  final features = <BaseFeatureDI>[
    AuthDI(),
    TeachersDI(),
    FollowsDI(),
    TopicsDI(),
    FeedDI(),
    ExercisesDI(),
    JourneysDI(),
    EnrollmentsDI(),
    SubmissionsDI(),
  ];
  for (final feature in features) {
    feature.register(sl);
  }
}
