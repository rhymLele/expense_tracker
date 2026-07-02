class ApiConstants {
  // iOS Simulator  → localhost:3000
  // Android Emulator → 10.0.2.2:3000
  // Physical device → http://<your-machine-IP>:3000
  static const String baseUrl = 'http://localhost:3000';

  static const String _v = '/v1';

  // Auth
  static const String login = '$_v/auth/login';
  static const String register = '$_v/auth/register';
  static const String logout = '$_v/auth/logout';
  static const String authMe = '$_v/auth/me';
  static const String refresh = '$_v/auth/refresh';

  // Users
  static const String usersMe = '$_v/users/me';
  static const String becomeTeacher = '$_v/users/me/become-teacher';
  static const String updateOnboarding = '$_v/users/me/onboarding';
  static String userProfile(String id) => '$_v/users/$id';

  // Templates
  static const String exerciseTemplates = '$_v/exercises/templates';
  static const String topicTemplates = '$_v/topics/templates';

  // Teachers
  static const String teachers = '$_v/teachers';
  static String teacherProfile(String userId) => '$_v/teachers/$userId';
  static const String myTeacherProfile = '$_v/teachers/me';

  // Follows
  static const String following = '$_v/follows/following';
  static String followTeacher(String teacherId) => '$_v/follows/$teacherId';
  static String teacherFollowers(String teacherId) => '$_v/follows/$teacherId/followers';

  // Topics
  static const String topics = '$_v/topics';
  static String topicById(String id) => '$_v/topics/$id';
  static String topicsByTeacher(String teacherId) => '$_v/topics/teacher/$teacherId';
  static String topicLike(String id) => '$_v/topics/$id/like';
  static String topicComments(String id) => '$_v/topics/$id/comments';

  // Feed
  static const String feed = '$_v/feed';

  // Exercises
  static const String exercises = '$_v/exercises';
  static String exerciseById(String id) => '$_v/exercises/$id';
  static String exercisesByTeacher(String tid) => '$_v/exercises/teacher/$tid';

  // Journeys
  static const String journeys = '$_v/journeys';
  static String journeyById(String id) => '$_v/journeys/$id';
  static String journeyDays(String id) => '$_v/journeys/$id/days';
  static String enrollJourney(String id) => '$_v/journeys/$id/enroll';

  // Enrollments
  static const String myEnrollments = '$_v/enrollments/me';
  static const String enrollmentEnroll = '$_v/enrollments';
  static const String enrollmentsActive = '$_v/enrollments/me/active';
  static String enrollmentCancel(String id) => '$_v/enrollments/$id';
  static String enrollmentCompleteDay(String id) => '$_v/enrollments/$id/complete-day';
  static const String enrollmentQueueReorder = '$_v/enrollments/queue/reorder';
  static String todayTasks(String id) => '$_v/enrollments/$id/today';
  static String useFreeze(String id) => '$_v/enrollments/$id/freeze';

  // Posts
  static const String posts = '$_v/posts';
  static String postById(String id) => '$_v/posts/$id';
  static String postsByUser(String uid) => '$_v/posts/by-user/$uid';
  static String postLike(String id) => '$_v/posts/$id/like';

  // Roadmaps
  static const String roadmaps = '$_v/roadmaps';
  static String roadmapById(String id) => '$_v/roadmaps/$id';
  static String roadmapsByCreator(String uid) => '$_v/roadmaps/by-creator/$uid';

  // Votes
  static String voteRoadmap(String id) => '$_v/votes/roadmaps/$id';
  static String myVote(String id) => '$_v/votes/roadmaps/$id/my';

  // Messages / Chat
  static const String myConversations = '$_v/messages/conversations';
  static const String startDirectConversation = '$_v/messages/conversations/direct';
  static String conversationMessages(String id) => '$_v/messages/conversations/$id/messages';

  // Notifications
  static const String notifications = '$_v/notifications';
  static const String notificationsUnreadCount = '$_v/notifications/unread-count';
  static const String notificationsReadAll = '$_v/notifications/read-all';
  static String notificationRead(String id) => '$_v/notifications/$id/read';

  // Submissions
  static const String submissions = '$_v/submissions';
  static String submissionById(String id) => '$_v/submissions/$id';
  static String gradeSubmission(String id) => '$_v/submissions/$id/grade';
  static String submissionsByEnrollment(String id) => '$_v/submissions/enrollment/$id';

  // Health (VERSION_NEUTRAL — không có prefix /v1)
  static const String health = '/health';
}
