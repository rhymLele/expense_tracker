enum BiometricType {
  fingerprint,
  face,
  iris,
  unknown;

  static BiometricType fromString(String value) => switch (value) {
        'fingerprint' => BiometricType.fingerprint,
        'face'        => BiometricType.face,
        'iris'        => BiometricType.iris,
        _             => BiometricType.unknown,
      };
}
