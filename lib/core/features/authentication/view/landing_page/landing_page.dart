import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template_app/config/tenant/tenant_config.dart';
import 'package:flutter_template_app/config/translations/enums/language.dart';
import 'package:flutter_template_app/config/translations/translation_storage.dart';
import 'package:flutter_template_app/core/shared/widgets/screens/header_bar.dart';
import 'package:flutter_template_app/theme/get_theme_color.dart';
import 'package:flutter_template_app/theme/theme_color.dart';
import 'package:flutter_template_app/theme/theme_config.dart';
import 'package:flutter_template_app/theme/theme_constants.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isDark = false;
  String currentLang = 'en';

  @override
  void initState() {
    isDark = themeConfig.currentTheme == ThemeMode.dark;
    super.initState();
  }

  void _switchTheme(bool dark) {
    setState(() => isDark = dark);
    ThemeMode themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    themeConfig.changeTheme(themeMode);
  }

  void _changeLanguage(String lang) {
    setState(() => currentLang = lang);
    if (lang == 'en') {
      TranslationStorage().changeLanguage(Language.english.value);
    } else {
      TranslationStorage().changeLanguage(Language.spanisn.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = TranslationStorage.translation;
    final tenant = TenantConfig();

    return Scaffold(
      backgroundColor: context.colors.primaryBackground,
      appBar: const HeaderBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.pagePadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildHeroSection(t, tenant),
            const SizedBox(height: 32),
            _buildSettingsSection(t),
            const SizedBox(height: 32),
            _buildFeaturesSection(t),
            const SizedBox(height: 32),
            _buildColorPaletteSection(t),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(dynamic translation, TenantConfig tenant) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            tenant.logoPath,
            height: 64,
          ),
          const SizedBox(height: 12),
          Text(
            tenant.appName,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: tenant.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            translation.appTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: context.colors.primaryText.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 20),
          // CustomOutlinedButton(
          //   title: translation.signIn,
          //   width: 200,
          //   height: 46,
          //   radius: 24,
          //   color: AppColors.baseWhite,
          //   backgroundColor: tenant.primaryColor,
          //   borderColor: tenant.primaryColor,
          //   onClick: () {},
          // ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(dynamic t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(t.settings, Icons.settings_outlined),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.brightness_6_outlined,
                    size: 20,
                    color: context.colors.primaryText,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.appearance,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.colors.primaryText,
                      ),
                    ),
                  ),
                  _buildToggleChips(
                    options: [
                      (t.lightMode, !isDark),
                      (t.darkMode, isDark),
                    ],
                    onTap: (index) => _switchTheme(index == 1),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                height: 1,
                color: context.colors.primaryText.withOpacity(0.1),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 20,
                    color: context.colors.primaryText,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.language,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.colors.primaryText,
                      ),
                    ),
                  ),
                  _buildToggleChips(
                    options: [
                      ('EN', currentLang == 'en'),
                      ('ES', currentLang == 'es'),
                    ],
                    onTap: (index) => _changeLanguage(index == 0 ? 'en' : 'es'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleChips({
    required List<(String, bool)> options,
    required void Function(int) onTap,
  }) {
    final tenant = TenantConfig();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(options.length, (index) {
        final (label, isActive) = options[index];
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? tenant.primaryColor : context.colors.primaryText.withOpacity(0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(index == 0 ? 8 : 0),
                bottomLeft: Radius.circular(index == 0 ? 8 : 0),
                topRight: Radius.circular(index == options.length - 1 ? 8 : 0),
                bottomRight: Radius.circular(index == options.length - 1 ? 8 : 0),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : context.colors.primaryText.withOpacity(0.6),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFeaturesSection(dynamic t) {
    final features = [
      (Icons.account_balance_wallet_outlined, t.accountBalance, t.accountBalanceDesc),
      (Icons.swap_horiz, t.payments, t.paymentsDesc),
      (Icons.credit_card_outlined, t.cards, t.cardsDesc),
      (Icons.bar_chart_outlined, t.analytics, t.analyticsDesc),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(t.features, Icons.grid_view_outlined),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final (icon, title, desc) = features[index];
            return _buildFeatureCard(icon, title, desc);
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String desc) {
    final tenant = TenantConfig();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tenant.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 22, color: tenant.primaryColor),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.colors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              desc,
              style: TextStyle(
                fontSize: 11,
                color: context.colors.primaryText.withOpacity(0.5),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPaletteSection(dynamic t) {
    final tenant = TenantConfig();
    final colors = [
      (t.primary, tenant.primaryColor),
      (t.accent, tenant.accentColor),
      (t.error, tenant.errorColor),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(t.colorPalette, Icons.palette_outlined),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: colors.map((entry) {
              final (label, color) = entry;
              return Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.primaryText.withOpacity(0.1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.colors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    colorToHex(color),
                    style: TextStyle(
                      fontSize: 10,
                      color: context.colors.primaryText.withOpacity(0.5),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.colors.primaryText.withOpacity(0.5)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.colors.primaryText,
          ),
        ),
      ],
    );
  }
}
