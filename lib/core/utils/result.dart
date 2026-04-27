import '../errors/failure.dart';

class Result<T> {
  final T? data;
  final Failure? failure;

  const Result.success(this.data) : failure = null;
  const Result.failure(this.failure) : data = null;

  bool get isSuccess => failure == null;

  R fold<R>(R Function(Failure) onFailure, R Function(T) onSuccess) {
    if (isSuccess) return onSuccess(data as T);
    return onFailure(failure!);
  }
}
