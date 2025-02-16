part of 'app_config_bloc.dart';

abstract class AppConfigEvent {
  const AppConfigEvent();
}

class SetDarkMode extends AppConfigEvent {
  final bool darkMode;
  const SetDarkMode({required this.darkMode});
}

class ToggleDarkMode extends AppConfigEvent {
  const ToggleDarkMode();
}
