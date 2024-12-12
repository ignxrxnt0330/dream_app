import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_search/dream_search_bloc.dart';
import 'package:flutter/material.dart';

import 'package:dream_app/config/router/app_router.dart';
import 'package:dream_app/config/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        ],
        child: MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          theme: AppTheme().getTheme(),
        ));
  }
}
