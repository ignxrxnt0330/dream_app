import 'package:flutter/material.dart';

import 'package:dream_app/config/router/app_router.dart';
import 'package:dream_app/config/theme/app_theme.dart';
import 'package:intl/intl_standalone.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FIXME:
  await findSystemLocale();

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // no need to add home: because go_router knows the initial location
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
