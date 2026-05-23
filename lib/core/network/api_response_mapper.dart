import '../models/paginated_result.dart';

/// Centralized parser for the pizza backend's standard response envelope:
/// { status, reason, data, count }
///
/// Use [single] for endpoints that return one object in `data`.
/// Use [list] for endpoints that return a plain array in `data`.
/// Use [paginated] for endpoints that return { items, total, ... } in `data`.
class ApiResponseMapper {
  const ApiResponseMapper._();

  /// `res['data']` is a Map → parse with [fromJson].
  static T single<T>(
    dynamic res,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      fromJson(res['data'] as Map<String, dynamic>);

  /// `res['data']` is a List → parse each element with [fromJson].
  static List<T> list<T>(
    dynamic res,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = res['data'] as List;
    return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  /// `res['data']` is `{ items: List, total: int, ... }` → parse as paginated.
  static PaginatedResult<T> paginated<T>(
    dynamic res,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final pageData = res['data'] as Map<String, dynamic>;
    final data = pageData['items'] as List;
    return PaginatedResult(
      items: data.map((e) => fromJson(e as Map<String, dynamic>)).toList(),
      count: pageData['total'] as int? ?? data.length,
    );
  }
}
