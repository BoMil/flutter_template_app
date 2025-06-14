import 'package:flutter/material.dart';
import 'package:flutter_template_app/core/shared/widgets/screens/header_bar.dart';
import 'package:flutter_template_app/theme/get_theme_color.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getSelectedThemeColors(context).primaryBackground,
      appBar: const HeaderBar(),
      body: const Center(
        child: Text('Welcome to Landing page'),
      ),
    );
  }
}
