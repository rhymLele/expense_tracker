import '../../../../core/base/base_cubit.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/usecases/get_today_tasks_usecase.dart';
import 'today_tasks_state.dart';

class TodayTasksCubit extends LoadCubit<TodayTasksState> {
  final GetTodayTasksUseCase _getTodayTasks;

  TodayTasksCubit({required GetTodayTasksUseCase getTodayTasks})
      : _getTodayTasks = getTodayTasks,
        super(const TodayTasksState());

  /// Load theo [enrollmentId] từ UI, nên [init] không tự nạp.
  @override
  Future<void> fetchData() async {}

  Future<void> load(String enrollmentId) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getTodayTasks(enrollmentId);
    result.fold(
      (f) => emit(state.copyWith(status: ViewStatus.failure, error: f.message)),
      (tasks) => emit(state.copyWith(
        status: ViewStatus.success,
        todayTasks: tasks,
      )),
    );
  }
}
