import 'package:flutter/material.dart';
import 'package:flutter_template_app/config/translations/enums/language.dart';
import 'package:flutter_template_app/config/translations/translation_storage.dart';
import 'package:flutter_template_app/core/shared/widgets/cards/selectable_item.dart';
import 'package:flutter_template_app/core/shared/widgets/screens/header_bar.dart';
import 'package:flutter_template_app/theme/get_theme_color.dart';
import 'package:flutter_template_app/theme/theme_config.dart';
import 'package:flutter_template_app/theme/theme_constants.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isDark = false;

  @override
  void initState() {
    isDark = themeConfig.currentTheme == ThemeMode.dark;
    super.initState();
  }

  switchTheme() {
    isDark = !isDark;
    ThemeMode themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    themeConfig.changeTheme(themeMode);
  }

  changeLanguageToEnglish() {
    TranslationStorage().changeLanguage(Language.english.value);
  }

  changeLanguageToSpanish() {
    TranslationStorage().changeLanguage(Language.spanisn.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getSelectedThemeColors(context).primaryBackground,
      appBar: const HeaderBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.pagePadding),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                TranslationStorage.translation.helloWorld,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                TranslationStorage.translation.welcomeToLandingPage,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Center(
              child: Text(
                TranslationStorage.translation.yourCurrentThemeIs(themeConfig.currentTheme.name.toUpperCase()),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            SelectableItem(
              fontSize: 14,
              title: TranslationStorage.translation.switchTheme,
              rightContent: Icon(
                Icons.arrow_forward_ios,
                color: context.colors.primaryBackground,
                size: 15,
              ),
              leftIcon: const Row(
                children: [
                  Icon(Icons.mode_night_outlined),
                  SizedBox(width: 10),
                ],
              ),
              textColor: context.colors.primaryText,
              itemPressed: () {
                switchTheme();
              },
            ),
            const SizedBox(height: 20),
            SelectableItem(
              fontSize: 14,
              title: TranslationStorage.translation.changeLanguageToEnglish,
              rightContent: Icon(
                Icons.arrow_forward_ios,
                color: context.colors.primaryBackground,
                size: 15,
              ),
              leftIcon: const Row(
                children: [
                  Icon(Icons.language_sharp),
                  SizedBox(width: 10),
                ],
              ),
              textColor: context.colors.primaryText,
              itemPressed: () {
                changeLanguageToEnglish();
              },
            ),
            const SizedBox(height: 20),
            SelectableItem(
              fontSize: 14,
              title: TranslationStorage.translation.changeLanguageToSpanish,
              rightContent: Icon(
                Icons.arrow_forward_ios,
                color: context.colors.primaryBackground,
                size: 15,
              ),
              leftIcon: const Row(
                children: [
                  Icon(Icons.language_sharp),
                  SizedBox(width: 10),
                ],
              ),
              textColor: context.colors.primaryText,
              itemPressed: () {
                changeLanguageToSpanish();
              },
            ),
          ],
        ),
      ),
    );
  }
}
