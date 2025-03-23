import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:dream_app/infrastructure/datasources/wm_tasks.dart';
import 'package:flutter/material.dart';

import 'package:dream_app/config/router/app_router.dart';
import 'package:dream_app/config/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl_standalone.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    try {
      final wmTasks = WmTasks();
      wmTasks.getTaskCallback(task);
    } catch (e) {
      print("Exception $e");
    }
    return Future.value(true);
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  // }

  final wmTasks = WmTasks();
  wmTasks.registerTasks();

  await wmTasks.getTaskCallback("back-up-task")();

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
