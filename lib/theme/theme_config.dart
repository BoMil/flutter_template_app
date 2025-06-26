import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template_app/config/constants/secure_storage_keys.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

typedef ThemeChangeCallback = void Function(ThemeMode themeMode);

class ThemeConfig {
  ThemeChangeCallback? onThemeChanged;

  ThemeMode currentTheme = ThemeMode.light;

  static final ThemeConfig _themeConfig = ThemeConfig._internal();

  factory ThemeConfig() {
    return _themeConfig;
  }

  ThemeConfig._internal();

  void changeTheme(ThemeMode themeMode) {
    // print(' changeTheme themeMode $themeMode');

    currentTheme = themeMode;
    saveTheme(currentTheme);

    _themeConfig.onThemeChanged?.call(themeMode);
  }

  Future<ThemeMode> initThemeConfig() async {
    currentTheme = await loadTheme();

    return currentTheme;
  }

  Future<void> saveTheme(ThemeMode mode) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: SecureStorageKeys.themeMode, value: mode.name);
    } catch (e) {
      debugPrint('Error in saveTheme: $e');
    }
  }

  Future<ThemeMode> loadTheme() async {
    try {
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: SecureStorageKeys.themeMode);
      if (value == ThemeMode.dark.name) {
        return ThemeMode.dark;
      }
    } catch (e) {
      debugPrint('error in loadTheme: $e');
      return ThemeMode.light;
    }

    return ThemeMode.light;
  }

  ThemeColor get themeColor => currentTheme == ThemeMode.dark ? darkThemeColors : lightThemeColors;
}

ThemeConfig themeConfig = ThemeConfig();
