part of 'app_config_bloc.dart';

class AppConfigState extends Equatable {
  final bool darkMode;
  final String defaultTitle;
  final Color appColor;
  final int lastExported;
  final String language;
  final String importDreamsPath;
  const AppConfigState(this.darkMode, this.defaultTitle, this.appColor,
      this.lastExported, this.language, this.importDreamsPath);

  AppConfigState copyWith({
    bool? darkMode,
    String? defaultTitle,
    Color? appColor,
    int? lastExported,
    String? language,
    String? importDreamsPath,
  }) {
    return AppConfigState(
      darkMode ?? this.darkMode,
      defaultTitle ?? this.defaultTitle,
      appColor ?? this.appColor,
      lastExported ?? this.lastExported,
      language ?? this.language,
      importDreamsPath ?? this.importDreamsPath,
    );
  }

  @override
  List<Object> get props =>
      [darkMode, defaultTitle, appColor, lastExported, language, importDreamsPath];
}
