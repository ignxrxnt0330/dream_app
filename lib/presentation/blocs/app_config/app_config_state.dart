part of 'app_config_bloc.dart';

class AppConfigState extends Equatable {
  final bool darkMode;
  final String defaultTitle;
  final Color appColor;
  const AppConfigState(this.darkMode, this.defaultTitle, this.appColor);

  AppConfigState copyWith({bool? darkMode, String? defaultTitle, Color? appColor}) {
    return AppConfigState(
      darkMode ?? this.darkMode,
      defaultTitle ?? this.defaultTitle,
      appColor ?? this.appColor,
    );
  }

  @override
  List<Object> get props => [darkMode, defaultTitle, appColor];
}
