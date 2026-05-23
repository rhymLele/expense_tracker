// Wrapper matching the pizza BE response format:
// { message: { code, message }, reason, status, data, count }
class ApiResponse<T> {
  final bool status;
  final String reason;
  final T? data;
  final int count;

  const ApiResponse({
    required this.status,
    required this.reason,
    this.data,
    required this.count,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromData,
  ) {
    return ApiResponse(
      status: json['status'] as bool,
      reason: json['reason'] as String? ?? '',
      data: json['data'] != null && fromData != null ? fromData(json['data']) : null,
      count: json['count'] as int? ?? 0,
    );
  }
}
