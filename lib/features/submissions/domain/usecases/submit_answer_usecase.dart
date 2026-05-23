import '../../../../core/utils/result.dart';
import '../entities/submission_entity.dart';
import '../repositories/submissions_repository.dart';

class SubmitAnswerUseCase {
  final SubmissionsRepository _repository;
  const SubmitAnswerUseCase(this._repository);

  Future<Result<SubmissionEntity>> call({
    required String enrollmentId,
    required String dayTaskId,
    required Map<String, dynamic> answer,
  }) {
    return _repository.submitAnswer(
      enrollmentId: enrollmentId,
      dayTaskId: dayTaskId,
      answer: answer,
    );
  }
}
