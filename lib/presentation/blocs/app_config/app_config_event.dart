part of 'app_config_bloc.dart';

abstract class AppConfigEvent {
  const AppConfigEvent();
}

class SetDarkMode extends AppConfigEvent {
  final bool darkMode;
  const SetDarkMode(this.darkMode);
}

class ToggleDarkMode extends AppConfigEvent {
  const ToggleDarkMode();
}

class SetDefaultTitle extends AppConfigEvent {
  final String title;
  const SetDefaultTitle(this.title);
}

class ChangeAppColor extends AppConfigEvent {
  final Color appColor;
  const ChangeAppColor(this.appColor);
}
