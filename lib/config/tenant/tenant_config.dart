import 'package:flutter/material.dart';

/// Reads tenant branding values injected via --dart-define-from-file.
///
/// Usage:
///   flutter run --dart-define-from-file=.env/whitebank.env
///   flutter run --dart-define-from-file=.env/blubank.env
class TenantConfig {
  static final TenantConfig _instance = TenantConfig._internal();
  factory TenantConfig() => _instance;
  TenantConfig._internal();

  // Identity
  final String tenantId =
      const String.fromEnvironment('TENANT_ID', defaultValue: 'whitebank');
  final String appName =
      const String.fromEnvironment('APP_NAME', defaultValue: 'WhiteBank');
  final String packageName = const String.fromEnvironment('PACKAGE_NAME',
      defaultValue: 'com.bokidev.whitebank');

  // Colors (ARGB hex from .env)
  static const String _primaryColorHex =
      String.fromEnvironment('PRIMARY_COLOR', defaultValue: 'FF1B5E20');
  static const String _accentColorHex =
      String.fromEnvironment('ACCENT_COLOR', defaultValue: 'FFFFD600');
  static const String _errorColorHex =
      String.fromEnvironment('ERROR_COLOR', defaultValue: 'FFEB2E25');

  final Color primaryColor = Color(int.parse(_primaryColorHex, radix: 16));
  final Color accentColor = Color(int.parse(_accentColorHex, radix: 16));
  final Color errorColor = Color(int.parse(_errorColorHex, radix: 16));

  // Asset paths
  String get logoPath => 'assets/tenants/$tenantId/logo.svg';
}
