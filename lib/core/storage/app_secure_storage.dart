import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Singleton dùng chung toàn app.
/// Bất kỳ feature nào cần secure storage đều lấy [instance] thay vì tự tạo.
class AppSecureStorage {
  AppSecureStorage._();

  static const FlutterSecureStorage instance = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}
