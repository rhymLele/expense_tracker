class ApiConstants {
  // Change to your server IP when testing on a real device.
  static const String baseUrl = 'http://localhost:3000';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String authMe = '/auth/me';
  static const String refresh = '/auth/refresh';

  // Users
  static const String usersMe = '/users/me';
  static const String becomeTeacher = '/users/me/become-teacher';
  static String userProfile(String id) => '/users/$id';

  // Teachers
  static const String teachers = '/teachers';
  static String teacherProfile(String userId) => '/teachers/$userId';
  static const String myTeacherProfile = '/teachers/me';

  // Follows
  static const String following = '/follows/following';
  static String followTeacher(String teacherId) => '/follows/$teacherId';
  static String teacherFollowers(String teacherId) => '/follows/$teacherId/followers';

  // Topics
  static const String topics = '/topics';
  static String topicById(String id) => '/topics/$id';
  static String topicsByTeacher(String teacherId) => '/topics/teacher/$teacherId';
  static String topicLike(String id) => '/topics/$id/like';
  static String topicComments(String id) => '/topics/$id/comments';

  // Feed
  static const String feed = '/feed';

  // Exercises
  static const String exercises = '/exercises';
  static String exerciseById(String id) => '/exercises/$id';
  static String exercisesByTeacher(String tid) => '/exercises/teacher/$tid';

  // Journeys
  static const String journeys = '/journeys';
  static String journeyById(String id) => '/journeys/$id';
  static String journeyDays(String id) => '/journeys/$id/days';
  static String enrollJourney(String id) => '/journeys/$id/enroll';

  // Enrollments
  static const String myEnrollments = '/enrollments/me';
  static String todayTasks(String id) => '/enrollments/$id/today';
  static String useFreeze(String id) => '/enrollments/$id/freeze';

  // Submissions
  static const String submissions = '/submissions';
  static String submissionById(String id) => '/submissions/$id';
  static String gradeSubmission(String id) => '/submissions/$id/grade';
  static String submissionsByEnrollment(String id) => '/submissions/enrollment/$id';
}
