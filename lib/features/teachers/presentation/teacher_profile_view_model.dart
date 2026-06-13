import '../../../core/base/base_view_model.dart';
import '../domain/usecases/get_teacher_profile_usecase.dart';
import '../../follows/domain/usecases/follow_teacher_usecase.dart';
import '../../follows/domain/usecases/unfollow_teacher_usecase.dart';
import '../../topics/domain/usecases/get_topics_by_teacher_usecase.dart';
import 'bloc/teacher_profile_cubit.dart';

class TeacherProfileViewModel extends BaseViewModel<TeacherProfileCubit> {
  TeacherProfileViewModel({
    required GetTeacherProfileUseCase getTeacherProfile,
    required GetTopicsByTeacherUseCase getTopicsByTeacher,
    required FollowTeacherUseCase follow,
    required UnfollowTeacherUseCase unfollow,
  }) : super(TeacherProfileCubit(
          getTeacherProfile: getTeacherProfile,
          getTopicsByTeacher: getTopicsByTeacher,
          follow: follow,
          unfollow: unfollow,
        ));

  void load(String userId) => bloc.load(userId);

  void toggleFollow() => bloc.toggleFollow();
}
