import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/topic_comment_entity.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/topics_repository.dart';
import '../datasources/topics_remote_datasource.dart';

class TopicsRepositoryImpl implements TopicsRepository {
  final TopicsRemoteDataSource _dataSource;

  const TopicsRepositoryImpl(this._dataSource);

  @override
  Future<Result<TopicEntity>> getTopic(String id) async {
    try {
      return Result.success(await _dataSource.getTopic(id));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaginatedResult<TopicEntity>>> getTopicsByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return Result.success(await _dataSource.getTopicsByTeacher(teacherId, page: page, limit: limit));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TopicEntity>> createTopic({
    required String type,
    required String title,
    String? description,
    String? visibility,
  }) async {
    try {
      return Result.success(await _dataSource.createTopic(
        type: type,
        title: title,
        description: description,
        visibility: visibility,
      ));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> toggleLike(String topicId) async {
    try {
      await _dataSource.toggleLike(topicId);
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TopicCommentEntity>>> getComments(String topicId) async {
    try {
      return Result.success(await _dataSource.getComments(topicId));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TopicCommentEntity>> addComment({
    required String topicId,
    required String content,
    String? parentId,
  }) async {
    try {
      return Result.success(
        await _dataSource.addComment(topicId: topicId, content: content, parentId: parentId),
      );
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
