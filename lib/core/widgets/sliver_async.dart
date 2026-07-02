import 'package:flutter/material.dart';

/// Chọn sliver hiển thị theo trạng thái load — gom pattern
/// "loading toàn trang / lỗi + thử lại / nội dung" về một chỗ, dùng chung
/// cho mọi màn hình dạng `CustomScrollView`.
///
/// ```dart
/// slivers: [
///   mySliverAppBar,
///   ...sliverAsync(
///     loading: state.isInitialLoading,
///     error: state.isInitialError,
///     onRetry: () => cubit.load(),
///     data: () => [ ...các sliver nội dung... ],
///   ),
/// ]
/// ```
List<Widget> sliverAsync({
  required bool loading,
  required bool error,
  required List<Widget> Function() data,
  VoidCallback? onRetry,
  String errorText = 'Đã có lỗi xảy ra',
  String retryText = 'Thử lại',
  Color? color,
}) {
  if (loading) {
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator(color: color)),
      ),
    ];
  }
  if (error) {
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: _ErrorRetry(
          text: errorText,
          retryText: retryText,
          onRetry: onRetry,
          color: color,
        ),
      ),
    ];
  }
  return data();
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({
    required this.text,
    required this.retryText,
    required this.onRetry,
    this.color,
  });

  final String text;
  final String retryText;
  final VoidCallback? onRetry;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onRetry,
              child: Text(
                retryText,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: color ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
