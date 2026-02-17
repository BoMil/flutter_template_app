import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_template_app/config/environment/environment.dart';
import 'package:flutter_template_app/config/firebase/firebase_config.dart';
import 'package:flutter_template_app/config/routes/router_config.dart';
import 'package:flutter_template_app/config/routes/routes.dart';
import 'package:flutter_template_app/config/translations/translation_storage.dart';
import 'package:flutter_template_app/core/features/authentication/cubits/auth/auth_cubit.dart';
import 'package:flutter_template_app/core/utils/api/app_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template_app/theme/theme_config.dart';
import 'package:flutter_template_app/theme/themes.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  // Don't log the debug print messages in the production build
  if (kReleaseMode || Environment.environment != 'DEV') {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase if configured for this tenant
  if (FirebaseConfig().isConfigured) {
    await Firebase.initializeApp(
      options: FirebaseConfig().currentPlatform,
    );
  }

  AppInterceptor().initializeInterceptor();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthCubit authCubit = AuthCubit(
    secureStorage: const FlutterSecureStorage(),
  );

  @override
  void initState() {
    RouterState().authCubit = authCubit;
    TranslationStorage().initTranslation();
    TranslationStorage().onLanguageChanged = onLanguageChanged;
    ThemeConfig().onThemeChanged = onThemeChange;
    _initializeTheme();
    super.initState();
  }

  _initializeTheme() async {
    ThemeMode themeMode = await ThemeConfig().initThemeConfig();
    ThemeConfig().changeTheme(themeMode);
  }

  @override
  void dispose() {
    RouterState().authCubit.close();
    super.dispose();
  }

  onThemeChange(ThemeMode themeMode) {
    // print('MAIN onThemeChange $themeMode');
    setState(() {});
  }

  onLanguageChanged() {
    // print('MAIN onLanguageChanged $themeMode');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if (Environment.environment == 'STAGING') {
    // Upgrader.clearSavedSettings();
    // }

    RouterState().initializeRouteState();

    // This is the list of globaly accessible cubits/blocs
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RouterState().authCubit..initAuthState(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            // Add necessary logic here
          }

          if (state is Authenticated) {
            // Add necessary logic here
          }
        },
        child: ToastificationWrapper(
          child: MaterialApp.router(
            theme: Themes.light,
            darkTheme: Themes.dark,
            themeMode: ThemeConfig().currentTheme,
            locale: TranslationStorage().selectedLanguage,
            routerDelegate: Routes().goRouterInstance.routerDelegate,
            routeInformationProvider: Routes().goRouterInstance.routeInformationProvider,
            routeInformationParser: Routes().goRouterInstance.routeInformationParser,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
  }
}
