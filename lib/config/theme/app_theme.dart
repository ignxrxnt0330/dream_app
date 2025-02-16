import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppTheme {
  ThemeData getTheme(BuildContext context) {
    var bloc = context.watch<AppConfigBloc>();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: bloc.state.darkMode ? Brightness.dark : Brightness.light,
        surface: bloc.state.darkMode ? Colors.black : Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bloc.state.darkMode ? Colors.black : Colors.white,
        foregroundColor: bloc.state.darkMode ? Colors.white : Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bloc.state.darkMode ? Colors.black : Colors.white,
        selectedItemColor: bloc.state.darkMode ? Colors.white : Colors.black,
        unselectedItemColor: bloc.state.darkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
