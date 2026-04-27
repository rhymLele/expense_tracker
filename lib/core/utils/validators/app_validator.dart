class AppValidator {
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email không được để trống';
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) return 'Email không hợp lệ';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Mật khẩu không được để trống';
    if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Vui lòng xác nhận mật khẩu';
    if (value != password) return 'Mật khẩu không khớp';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Số điện thoại không được để trống';
    final regex = RegExp(r'^(0|\+84)[0-9]{9}$');
    if (!regex.hasMatch(value)) return 'Số điện thoại không hợp lệ';
    return null;
  }

  static String? minLength(String? value, int min, [String? fieldName]) {
    if (value == null || value.length < min) {
      return '${fieldName ?? 'Trường này'} phải có ít nhất $min ký tự';
    }
    return null;
  }

  static String? maxLength(String? value, int max, [String? fieldName]) {
    if (value != null && value.length > max) {
      return '${fieldName ?? 'Trường này'} không được vượt quá $max ký tự';
    }
    return null;
  }

  static FormFieldValidator<String> compose(List<FormFieldValidator<String>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}

// ignore: non_constant_identifier_names
typedef FormFieldValidator<T> = String? Function(T? value);
