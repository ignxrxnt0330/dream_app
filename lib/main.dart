import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:flutter/material.dart';

import 'package:dream_app/config/router/app_router.dart';
import 'package:dream_app/config/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl_standalone.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
    case "export_dreams":
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_task', '$task ran at ${DateTime.now()}');
      await IsarDatasource().exportDreams(dialog: false);
        break;
      default:
        break;
    }
    
    return Future.value(true);
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
      "export-task",
      "export_dreams",
      frequency: Duration(hours: 24),
      );

  //FIXME:
  await findSystemLocale();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
          BlocProvider<DreamSearchBloc>(
            create: (context) => DreamSearchBloc(),
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
              debugShowCheckedModeBanner: false,
              theme: AppTheme().getTheme(context),
            );
          },
        ));
  }
}
