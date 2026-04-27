import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  // Localization
  AppLocalizations get l10n => AppLocalizations.of(this);
  String tr(String key) => AppLocalizations.of(this).translate(key);

  // Screen size
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Navigation
  NavigatorState get navigator => Navigator.of(this);
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
        MaterialPageRoute(builder: (_) => page),
      );
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushReplacementNamed<T, void>(routeName, arguments: arguments);
  void pushNamedAndRemoveUntil(String routeName) => Navigator.of(this)
      .pushNamedAndRemoveUntil(routeName, (route) => false);

  // SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
  }) =>
      showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => ctx.pop(false), child: Text(cancelText)),
            TextButton(onPressed: () => ctx.pop(true), child: Text(confirmText)),
          ],
        ),
      );

  // Keyboard
  void hideKeyboard() => FocusScope.of(this).unfocus();
}
