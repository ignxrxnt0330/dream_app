part of 'app_config_bloc.dart';

class AppConfigState extends Equatable {
  final bool darkMode;
  final String defaultTitle;
  final Color appColor;
  final int lastExported;
  const AppConfigState(
      this.darkMode, this.defaultTitle, this.appColor, this.lastExported);

  AppConfigState copyWith(
      {bool? darkMode,
      String? defaultTitle,
      Color? appColor,
      int? lastExported}) {
    return AppConfigState(
      darkMode ?? this.darkMode,
      defaultTitle ?? this.defaultTitle,
      appColor ?? this.appColor,
      lastExported ?? this.lastExported,
    );
  }

  @override
  List<Object> get props => [darkMode, defaultTitle, appColor, lastExported];
}
