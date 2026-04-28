package com.example.sam.biometric

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyPermanentlyInvalidatedException
import android.security.keystore.KeyProperties
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricManager.Authenticators.BIOMETRIC_STRONG
import androidx.biometric.BiometricManager.Authenticators.BIOMETRIC_WEAK
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey

/**
 * Native plugin xử lý enrollment detection qua Android KeyStore
 * và hiển thị BiometricPrompt cho xác thực sinh trắc học.
 */
class BiometricPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var appContext: Context
    private var activity: FragmentActivity? = null

    private val KEY_ALIAS = "sam_biometric_enrollment_key"
    private val KEYSTORE  = "AndroidKeyStore"

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.example.sam/biometric")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ─── ActivityAware ────────────────────────────────────────────────────────

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as? FragmentActivity
    }

    override fun onDetachedFromActivityForConfigChanges() { activity = null }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity as? FragmentActivity
    }

    override fun onDetachedFromActivity() { activity = null }

    // ─── Dispatch ─────────────────────────────────────────────────────────────

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkEnrollmentStatus"  -> checkEnrollmentStatus(result)
            "setupBiometricKey"      -> setupBiometricKey(result)
            "resetBiometricKey"      -> resetBiometricKey(result)
            "checkSupportBiometric"  -> checkSupportBiometric(result)
            "getEnrolledBiometrics"  -> getEnrolledBiometrics(result)
            "authenticate"           -> {
                val reason = call.argument<String>("reason") ?: "Xác thực để tiếp tục"
                authenticate(reason, result)
            }
            else -> result.notImplemented()
        }
    }

    // ─── Enrollment detection ─────────────────────────────────────────────────

    /**
     * Thử dùng key đã tạo.
     * KeyPermanentlyInvalidatedException → vân tay mới được thêm → "changed"
     */
    private fun checkEnrollmentStatus(result: MethodChannel.Result) {
        try {
            val keyStore = KeyStore.getInstance(KEYSTORE).apply { load(null) }
            if (!keyStore.containsAlias(KEY_ALIAS)) {
                result.success("notSetup")
                return
            }
            val key    = keyStore.getKey(KEY_ALIAS, null) as SecretKey
            val cipher = Cipher.getInstance(
                "${KeyProperties.KEY_ALGORITHM_AES}/${KeyProperties.BLOCK_MODE_CBC}/${KeyProperties.ENCRYPTION_PADDING_PKCS7}"
            )
            cipher.init(Cipher.ENCRYPT_MODE, key)
            result.success("ok")
        } catch (e: KeyPermanentlyInvalidatedException) {
            result.success("changed")
        } catch (e: Exception) {
            result.error("BIOMETRIC_ERROR", e.message, null)
        }
    }

    private fun setupBiometricKey(result: MethodChannel.Result) {
        try {
            val keyStore = KeyStore.getInstance(KEYSTORE).apply { load(null) }
            if (keyStore.containsAlias(KEY_ALIAS)) keyStore.deleteEntry(KEY_ALIAS)

            val kg = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, KEYSTORE)
            kg.init(
                KeyGenParameterSpec.Builder(
                    KEY_ALIAS,
                    KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
                )
                    .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
                    .setUserAuthenticationRequired(true)
                    .setInvalidatedByBiometricEnrollment(true)
                    .build()
            )
            kg.generateKey()
            result.success(null)
        } catch (e: Exception) {
            result.error("BIOMETRIC_ERROR", e.message, null)
        }
    }

    private fun resetBiometricKey(result: MethodChannel.Result) {
        try {
            val keyStore = KeyStore.getInstance(KEYSTORE).apply { load(null) }
            if (keyStore.containsAlias(KEY_ALIAS)) keyStore.deleteEntry(KEY_ALIAS)
            result.success(null)
        } catch (e: Exception) {
            result.error("BIOMETRIC_ERROR", e.message, null)
        }
    }

    // ─── Device capability ────────────────────────────────────────────────────

    private fun checkSupportBiometric(result: MethodChannel.Result) {
        val bm     = BiometricManager.from(appContext)
        val status = bm.canAuthenticate(BIOMETRIC_STRONG or BIOMETRIC_WEAK)
        result.success(
            status != BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE &&
            status != BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE
        )
    }

    /**
     * Android không phân biệt chi tiết loại biometric qua BiometricManager.
     * Trả về ["fingerprint"] nếu có bất kỳ biometric nào được đăng ký.
     */
    private fun getEnrolledBiometrics(result: MethodChannel.Result) {
        val bm    = BiometricManager.from(appContext)
        val types = mutableListOf<String>()
        val enrolled = bm.canAuthenticate(BIOMETRIC_STRONG or BIOMETRIC_WEAK)
        if (enrolled == BiometricManager.BIOMETRIC_SUCCESS) {
            types.add("fingerprint")
        }
        result.success(types)
    }

    // ─── Authentication ───────────────────────────────────────────────────────

    private fun authenticate(reason: String, result: MethodChannel.Result) {
        val fragmentActivity = activity ?: run {
            result.error("NO_ACTIVITY", "No activity available for BiometricPrompt", null)
            return
        }

        val executor = ContextCompat.getMainExecutor(appContext)

        val callback = object : BiometricPrompt.AuthenticationCallback() {
            override fun onAuthenticationSucceeded(r: BiometricPrompt.AuthenticationResult) {
                result.success("success")
            }

            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                when (errorCode) {
                    BiometricPrompt.ERROR_LOCKOUT           -> result.success("lockedOut")
                    BiometricPrompt.ERROR_LOCKOUT_PERMANENT -> result.success("permanentlyLockedOut")
                    else                                    -> result.success("failed")
                }
            }

            // Biometric không khớp nhưng user có thể thử lại — không resolve ở đây
            override fun onAuthenticationFailed() {}
        }

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Xác thực sinh trắc học")
            .setSubtitle(reason)
            .setNegativeButtonText("Hủy")
            .setAllowedAuthenticators(BIOMETRIC_STRONG or BIOMETRIC_WEAK)
            .build()

        fragmentActivity.runOnUiThread {
            BiometricPrompt(fragmentActivity, executor, callback).authenticate(promptInfo)
        }
    }
}
