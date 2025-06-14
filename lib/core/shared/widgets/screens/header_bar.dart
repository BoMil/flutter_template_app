import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/get_theme_color.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final Function()? backButtonPressed;
  final List<Widget>? actions; // Opcionalne akcije

  const HeaderBar({
    super.key,
    this.icon = Icons.arrow_back_ios_new,
    this.backButtonPressed,
    this.actions, // Dodali smo parametar za opcionalne akcije
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // toolbarHeight: 180,
      backgroundColor: getSelectedThemeColors(context).secondaryBackground,
      foregroundColor: AppColors.primaryBackground,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => backButtonPressed?.call(),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 18.0, bottom: 8),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryText,
              size: 18,
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
