import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/login/src.dart';
import '../../features/auth/presentation/register/src.dart';
import '../../features/auth/presentation/splash/src.dart';
import '../../features/follows/presentation/cubit/follow_cubit.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/teachers/presentation/teacher_profile_page.dart';
import '../../features/teachers/presentation/teacher_profile_view_model.dart';
import '../../features/exercises/presentation/exercise_page.dart';
import '../../features/topics/presentation/create_topic/create_topic_page.dart';
import '../../features/topics/presentation/create_topic/create_topic_view_model.dart';
import '../../features/topics/presentation/topic_detail_page.dart';
import '../../features/topics/presentation/topic_detail_view_model.dart';
import '../base/base_view_model.dart';
import '../di/service_locator.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String forgotPassword = '/forgot-password';
  static const String teacherProfile = '/teacher-profile';
  static const String topicDetail = '/topic-detail';
  static const String createTopic = '/create-topic';
  static const String exerciseSession = '/exercise-session';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _route((_) => const SplashPage(), settings);

      case AppRoutes.login:
        return _vmRoute(settings, sl<LoginViewModel>(), const LoginPage());

      case AppRoutes.register:
        return _vmRoute(settings, sl<RegisterViewModel>(), const RegisterPage());

      case AppRoutes.home:
        return _route(
          (_) => BlocProvider(
            create: (_) => sl<FollowCubit>()..load(),
            child: const HomePage(),
          ),
          settings,
        );

      case AppRoutes.teacherProfile:
        return _vmRoute(
          settings,
          sl<TeacherProfileViewModel>(),
          const TeacherProfilePage(),
        );

      case AppRoutes.topicDetail:
        return _vmRoute(
          settings,
          sl<TopicDetailViewModel>(),
          const TopicDetailPage(),
        );

      case AppRoutes.createTopic:
        return _vmRoute(
          settings,
          sl<CreateTopicViewModel>(),
          const CreateTopicPage(),
        );

      case AppRoutes.exerciseSession:
        return _route((_) => const ExercisePage(), settings);

      default:
        return _route((_) => const _NotFoundPage(), settings);
    }
  }

  /// Route chuẩn cho màn hình có ViewModel.
  /// Tự động inject [vm.blocProvider] + ViewModel vào context.
  static Route<dynamic> _vmRoute<VM extends BaseViewModel<dynamic>>(
    RouteSettings settings,
    VM vm,
    Widget page,
  ) =>
      _route(
        (_) => MultiBlocProvider(
          providers: [
            vm.blocProvider,
            BlocProvider<VM>.value(value: vm),
          ],
          child: page,
        ),
        settings,
      );

  static MaterialPageRoute<dynamic> _route(
    WidgetBuilder builder,
    RouteSettings settings,
  ) =>
      MaterialPageRoute(builder: builder, settings: settings);
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Trang không tồn tại')));
}
