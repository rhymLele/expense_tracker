enum BiometricStatus {
  /// Sẵn sàng dùng
  available,

  /// Thiết bị không có phần cứng biometric
  notAvailable,

  /// Có phần cứng nhưng chưa đăng ký vân tay/face
  notEnrolled,

  /// Người dùng vừa thêm vân tay mới → phải reset để đảm bảo bảo mật
  enrollmentChanged,

  /// Chưa setup biometric login (lần đầu dùng app)
  notSetup,
}
