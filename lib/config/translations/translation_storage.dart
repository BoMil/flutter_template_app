import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef LanguageChangeCallback = void Function();

/// This is a singleton class that holds the AppLocalizations object and current language.
///
/// It give us possibility to acccess translations without using a build context,
///
/// like in validator classes and services, and to change the language of the app.
class TranslationStorage {
  static final TranslationStorage _singleton = TranslationStorage._internal();

  factory TranslationStorage() {
    return _singleton;
  }

  TranslationStorage._internal();

  late AppLocalizations _translation;

  /// Current language of the app
  Locale selectedLanguage = const Locale('en');

  /// Translation getter that can be accessed from anywhere in the app
  static AppLocalizations get translation => _singleton._translation;

  LanguageChangeCallback? onLanguageChanged;

  /// Initialize translations
  void initTranslation() async {
    _translation = await AppLocalizations.delegate.load(selectedLanguage);
  }

  /// Change language of the app if it is supported
  void changeLanguage(Locale locale) async {
    if (!_checkIfLanguageIsSupported(locale)) {
      return;
    }
    selectedLanguage = locale;
    _translation = await AppLocalizations.delegate.load(selectedLanguage);
    _singleton.onLanguageChanged?.call();
  }

  bool _checkIfLanguageIsSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale);
  }
}
