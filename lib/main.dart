import 'package:flutter_template_app/config/environment/environment.dart';
import 'package:flutter_template_app/config/routes/router_config.dart';
import 'package:flutter_template_app/config/routes/routes.dart';
import 'package:flutter_template_app/core/features/authentication/cubits/auth/auth_cubit.dart';
import 'package:flutter_template_app/core/utils/api/app_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template_app/theme/themes.dart';
import 'package:toastification/toastification.dart';

void main() async {
  // Don't log the debug print messages in the production build
  if (kReleaseMode || Environment.environment != 'DEV') {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();

  // Build production APK: fvm flutter build apk --dart-define-from-file=.env/production.env
  // Build staging APK: fvm flutter build apk --dart-define-from-file=.env/staging.env

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
    // TranslationStorage().initTranslation();
    // ThemeConfig().onThemeChanged = onThemeChange;
    // _initializeTheme();
    super.initState();
  }

  // _initializeTheme() async {
  //   ThemeMode themeMode = await ThemeConfig().initThemeConfig();
  //   ThemeConfig().changeTheme(themeMode);
  // }

  @override
  void dispose() {
    RouterState().authCubit.close();
    super.dispose();
  }

  onThemeChange(ThemeMode themeMode) {
    // print('MAIN onThemeChange $themeMode');
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
            // themeMode: ThemeConfig().currentTheme,
            // locale: TranslationStorage().selectedLanguage,
            routerDelegate: Routes().goRouterInstance.routerDelegate,
            routeInformationProvider: Routes().goRouterInstance.routeInformationProvider,
            routeInformationParser: Routes().goRouterInstance.routeInformationParser,
            // localizationsDelegates: AppLocalizations.localizationsDelegates,
            // supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
  }
}
