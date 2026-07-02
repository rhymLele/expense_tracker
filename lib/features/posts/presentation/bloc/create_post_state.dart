import '../../../../core/base/base_state.dart';

class CreatePostState extends BaseState<CreatePostState> {
  const CreatePostState({super.status, super.error});

  bool get isLoading => status.isLoading;
  bool get isSuccess => status.isSuccess;
  bool get isFailure => status.isFailure;

  CreatePostState copyWith({ViewStatus? status, String? error}) =>
      CreatePostState(status: status ?? this.status, error: error);

  @override
  CreatePostState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props => [status, error];
}
