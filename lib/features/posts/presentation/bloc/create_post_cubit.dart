import '../../../../core/base/base_cubit.dart';
import '../../../../core/base/base_state.dart';
import '../../../topics/domain/usecases/create_topic_usecase.dart';
import 'create_post_state.dart';

class CreatePostCubit extends LoadCubit<CreatePostState> {
  final CreateTopicUseCase _createTopicUseCase;

  CreatePostCubit({required CreateTopicUseCase createTopicUseCase})
      : _createTopicUseCase = createTopicUseCase,
        super(const CreatePostState());

  /// Không có load ban đầu — bài viết được submit từ UI.
  @override
  Future<void> fetchData() async {}

  Future<void> submit(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    emit(const CreatePostState(status: ViewStatus.loading));
    // title max 200 chars; put full text in description so feed shows content
    final title =
        trimmed.length > 100 ? '${trimmed.substring(0, 100)}…' : trimmed;
    final result = await _createTopicUseCase(
      type: 'lesson',
      title: title,
      description: trimmed,
      visibility: 'public',
    );
    result.fold(
      (f) => emit(CreatePostState(status: ViewStatus.failure, error: f.message)),
      (_) => emit(const CreatePostState(status: ViewStatus.success)),
    );
  }

  void reset() => emit(const CreatePostState());
}
