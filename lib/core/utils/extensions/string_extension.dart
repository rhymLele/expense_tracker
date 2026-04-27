extension StringExtension on String {
  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);

  bool get isValidPhone => RegExp(r'^(0|\+84)[0-9]{9}$').hasMatch(this);

  bool get isValidPassword => length >= 8;

  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ').map((w) => w.capitalize).join(' ');

  String? get nullIfEmpty => isEmpty ? null : this;

  bool get isNullOrEmpty => isEmpty;
}

extension StringNullableExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  String get orEmpty => this ?? '';
}
