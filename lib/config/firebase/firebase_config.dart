import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Reads Firebase configuration injected via --dart-define-from-file.
///
/// Each tenant has its own Firebase project. The config values are stored
/// in Firestore and passed as environment variables during CI builds.
/// For local development, values come from .env/{tenant}.env files.
///
/// API_KEY and APP_ID are platform-specific (Android and iOS each get
/// their own app in the Firebase project). The remaining values are
/// shared across both platforms (project-level).
class FirebaseConfig {
  static final FirebaseConfig _instance = FirebaseConfig._internal();
  factory FirebaseConfig() => _instance;
  FirebaseConfig._internal();

  // Platform-specific values
  static const String _androidApiKey =
      String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
  static const String _androidAppId =
      String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
  static const String _iosApiKey =
      String.fromEnvironment('FIREBASE_IOS_API_KEY');
  static const String _iosAppId =
      String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const String _iosBundleId =
      String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');

  // Shared values (project-level)
  static const String _messagingSenderId =
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const String _projectId =
      String.fromEnvironment('FIREBASE_TENANT_PROJECT_ID');
  static const String _storageBucket =
      String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

  bool get isConfigured =>
      _androidApiKey.isNotEmpty || _iosApiKey.isNotEmpty;

  FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: _androidApiKey,
          appId: _androidAppId,
          messagingSenderId: _messagingSenderId,
          projectId: _projectId,
          storageBucket: _storageBucket,
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: _iosApiKey,
          appId: _iosAppId,
          messagingSenderId: _messagingSenderId,
          projectId: _projectId,
          storageBucket: _storageBucket,
          iosBundleId: _iosBundleId,
        );
      default:
        throw UnsupportedError(
          'FirebaseConfig is not supported for this platform.',
        );
    }
  }
}
