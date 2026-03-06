/// Per-tenant feature flags injected at compile time via --dart-define-from-file.
///
/// Configure per tenant in Firestore under:
///   tenants/{tenantId}.features (map) {
///     THEME_CHANGE: true/false
///     LANGUAGE: true/false
///     ACCOUNT_BALANCE: true/false
///     PAYMENTS: true/false
///     CARDS: true/false
///     ANALYTICS: true/false
///   }
///
/// All flags default to true (show everything) if not explicitly set.
class FeatureFlags {
  static final FeatureFlags _instance = FeatureFlags._internal();
  factory FeatureFlags() => _instance;
  FeatureFlags._internal();

  final bool themeChange =
      const bool.fromEnvironment('FEATURE_THEME_CHANGE', defaultValue: true);

  final bool language =
      const bool.fromEnvironment('FEATURE_LANGUAGE', defaultValue: true);

  final bool accountBalance =
      const bool.fromEnvironment('FEATURE_ACCOUNT_BALANCE', defaultValue: true);

  final bool payments =
      const bool.fromEnvironment('FEATURE_PAYMENTS', defaultValue: true);

  final bool cards =
      const bool.fromEnvironment('FEATURE_CARDS', defaultValue: true);

  final bool analytics =
      const bool.fromEnvironment('FEATURE_ANALYTICS', defaultValue: true);
}
