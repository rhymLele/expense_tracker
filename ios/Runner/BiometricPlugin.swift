import Flutter
import LocalAuthentication

/**
 * iOS Biometric Plugin.
 * Enrollment detection: LAContext.evaluatedPolicyDomainState thay đổi khi user thêm/xóa Face ID/Touch ID.
 * Authentication: LAContext.evaluatePolicy để hiển thị native biometric prompt.
 */
class BiometricPlugin: NSObject, FlutterPlugin {

    private let DOMAIN_STATE_KEY = "sam_biometric_domain_state"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.example.sam/biometric",
            binaryMessenger: registrar.messenger()
        )
        registrar.addMethodCallDelegate(BiometricPlugin(), channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method {
        case "checkEnrollmentStatus":  checkEnrollmentStatus(result: result)
        case "setupBiometricKey":      setupBiometricKey(result: result)
        case "resetBiometricKey":      resetBiometricKey(result: result)
        case "checkSupportBiometric":  checkSupportBiometric(result: result)
        case "getEnrolledBiometrics":  getEnrolledBiometrics(result: result)
        case "authenticate":
            let reason = args?["reason"] as? String ?? "Xác thực để tiếp tục"
            authenticate(reason: reason, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // ─── Enrollment detection ─────────────────────────────────────────────────

    private func checkEnrollmentStatus(result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            result("notAvailable")
            return
        }
        guard let currentState = context.evaluatedPolicyDomainState else {
            result("notAvailable")
            return
        }
        guard let storedState = UserDefaults.standard.data(forKey: DOMAIN_STATE_KEY) else {
            result("notSetup")
            return
        }
        result(currentState == storedState ? "ok" : "changed")
    }

    private func setupBiometricKey(result: @escaping FlutterResult) {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        guard let domainState = context.evaluatedPolicyDomainState else {
            result(FlutterError(code: "BIOMETRIC_ERROR", message: "Cannot read biometric domain state", details: nil))
            return
        }
        UserDefaults.standard.set(domainState, forKey: DOMAIN_STATE_KEY)
        result(nil)
    }

    private func resetBiometricKey(result: @escaping FlutterResult) {
        UserDefaults.standard.removeObject(forKey: DOMAIN_STATE_KEY)
        result(nil)
    }

    // ─── Device capability ────────────────────────────────────────────────────

    private func checkSupportBiometric(result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?
        result(context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error))
    }

    private func getEnrolledBiometrics(result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            result([])
            return
        }
        switch context.biometryType {
        case .faceID:   result(["face"])
        case .touchID:  result(["fingerprint"])
        case .opticID:  result(["iris"])
        default:        result([])
        }
    }

    // ─── Authentication ───────────────────────────────────────────────────────

    private func authenticate(reason: String, result: @escaping FlutterResult) {
        let context = LAContext()
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        ) { success, error in
            DispatchQueue.main.async {
                if success {
                    result("success")
                    return
                }
                guard let laError = error as? LAError else {
                    result("failed")
                    return
                }
                switch laError.code {
                case .biometryLockout:
                    result("lockedOut")
                default:
                    // userCancel, userFallback, systemCancel, authFailed, etc.
                    result("failed")
                }
            }
        }
    }
}
