import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/colors/app_colors.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'services/task_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await EasyLocalization.ensureInitialized();


  final prefs = await SharedPreferences.getInstance();

  final bool isLoggedIn =
      prefs.getBool('is_logged_in') ?? false;


  await TaskStorage.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

      path: 'assets/translations',

      fallbackLocale:
      const Locale('en'),

      startLocale:
      const Locale('en'),

      child: MyApp(
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),


        ChangeNotifierProvider(
          create: (_) => ThemeProvider()
            ..loadTheme(),
        ),
      ],

      child: Consumer<ThemeProvider>(
        builder: (
            context,
            themeProvider,
            child,
            ) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            title: 'Todo App',


            localizationsDelegates:
            context.localizationDelegates,

            supportedLocales:
            context.supportedLocales,

            locale: context.locale,


            theme: ThemeData(
              useMaterial3: true,

              colorScheme:
              ColorScheme.fromSeed(
                seedColor:
                AppColors.primary,
              ),

              scaffoldBackgroundColor:
              AppColors.lightBackground,

              appBarTheme:
              const AppBarTheme(
                centerTitle: false,

                elevation: 0,

                backgroundColor:
                Colors.transparent,
              ),
            ),


            darkTheme: ThemeData(
              useMaterial3: true,

              brightness:
              Brightness.dark,

              colorScheme:
              ColorScheme.fromSeed(
                seedColor:
                AppColors.primary,

                brightness:
                Brightness.dark,
              ),

              appBarTheme:
              const AppBarTheme(
                centerTitle: false,

                elevation: 0,

                backgroundColor:
                Colors.transparent,
              ),
            ),



            themeMode:
            themeProvider.themeMode,



            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}