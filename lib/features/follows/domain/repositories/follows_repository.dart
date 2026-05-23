import '../../../../core/utils/result.dart';
import '../../../teachers/domain/entities/teacher_profile_entity.dart';

abstract class FollowsRepository {
  Future<Result<void>> follow(String teacherId);
  Future<Result<void>> unfollow(String teacherId);
  Future<Result<List<TeacherProfileEntity>>> getFollowing();
  Future<Result<List<TeacherProfileEntity>>> getFollowers(String teacherId);
}
