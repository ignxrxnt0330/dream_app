import 'package:dream_app/config/router/app_router.dart';
import 'package:dream_app/config/theme/app_theme.dart';
import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localization.dart';

final GlobalKey<_MainAppState> mainAppKey = GlobalKey<_MainAppState>();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterLocalization.instance.ensureInitialized();

  runApp(Portal(child: MainApp(key: mainAppKey)));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale _locale = Locale('en');
  void setAppLanguage(String langCode) {
    setState(() {
      _locale = Locale(langCode.split('').take(2).join(''));
    });
  }

  @override
  Widget build(BuildContext context) {
    // no need to add home: because go_router knows the initial location

    return MultiBlocProvider(
        providers: [
          BlocProvider<DreamFormBloc>(
            create: (context) => DreamFormBloc(),
          ),
          BlocProvider<DreamHomeBloc>(
            create: (context) => DreamHomeBloc(),
          ),
         BlocProvider<DreamStatsBloc>(
            create: (context) => DreamStatsBloc(),
          ),
          BlocProvider<DreamCalendarBloc>(
            create: (context) => DreamCalendarBloc(),
          ),
          BlocProvider<AppConfigBloc>(
            create: (context) => AppConfigBloc(),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              routerConfig: appRouter,
              locale: _locale,
              supportedLocales: AppLocalization.supportedLocales,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              theme: AppTheme().getTheme(context),
            );
          },
        ));
  }
}
