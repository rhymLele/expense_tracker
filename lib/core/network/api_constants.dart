class ApiConstants {
  // iOS Simulator  → localhost:3000
  // Android Emulator → 10.0.2.2:3000
  // Physical device → http://<your-machine-IP>:3000
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
  static const String updateOnboarding = '/users/me/onboarding';
  static String userProfile(String id) => '/users/$id';

  // Templates
  static const String exerciseTemplates = '/exercises/templates';
  static const String topicTemplates = '/topics/templates';

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

  // Enrollments (new schema)
  static const String myEnrollments = '/enrollments/me';
  static const String enrollmentEnroll = '/enrollments';
  static const String enrollmentsActive = '/enrollments/me/active';
  static String enrollmentCancel(String id) => '/enrollments/$id';
  static String enrollmentCompleteDay(String id) => '/enrollments/$id/complete-day';
  static const String enrollmentQueueReorder = '/enrollments/queue/reorder';
  // Legacy endpoints (kept for backward compat)
  static String todayTasks(String id) => '/enrollments/$id/today';
  static String useFreeze(String id) => '/enrollments/$id/freeze';

  // Posts (new social layer)
  static const String posts = '/posts';
  static String postById(String id) => '/posts/$id';
  static String postsByUser(String uid) => '/posts/by-user/$uid';

  // Roadmaps (new learning layer)
  static const String roadmaps = '/roadmaps';
  static String roadmapById(String id) => '/roadmaps/$id';
  static String roadmapsByCreator(String uid) => '/roadmaps/by-creator/$uid';

  // Votes
  static String voteRoadmap(String id) => '/votes/roadmaps/$id';
  static String myVote(String id) => '/votes/roadmaps/$id/my';

  // Messages
  static const String conversations = '/conversations';
  static String conversationMessages(String id) => '/conversations/$id/messages';

  // Submissions
  static const String submissions = '/submissions';
  static String submissionById(String id) => '/submissions/$id';
  static String gradeSubmission(String id) => '/submissions/$id/grade';
  static String submissionsByEnrollment(String id) => '/submissions/enrollment/$id';
}
