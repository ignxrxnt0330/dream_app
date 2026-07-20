part of 'app_config_bloc.dart';

class AppConfigState extends Equatable {
  final bool darkMode;
  final String defaultTitle;
  final String defaultEncryptionKey;
  final Color appColor;
  final int lastExported;
  final String language;
  final String importDreamsPath;
  final bool unsavedChanges;
  const AppConfigState(
      this.darkMode,
      this.defaultTitle,
      this.defaultEncryptionKey,
      this.appColor,
      this.lastExported,
      this.language,
      this.importDreamsPath,
      this.unsavedChanges);

  AppConfigState copyWith(
      {bool? darkMode,
      String? defaultTitle,
      String? defaultEncryptionKey,
      Color? appColor,
      int? lastExported,
      String? language,
      String? importDreamsPath,
      bool? unsavedChanges}) {
    return AppConfigState(
        darkMode ?? this.darkMode,
        defaultTitle ?? this.defaultTitle,
        defaultEncryptionKey ?? this.defaultEncryptionKey,
        appColor ?? this.appColor,
        lastExported ?? this.lastExported,
        language ?? this.language,
        importDreamsPath ?? this.importDreamsPath,
        unsavedChanges ?? this.unsavedChanges);
  }

  @override
  List<Object> get props => [
        darkMode,
        defaultTitle,
        defaultEncryptionKey,
        appColor,
        lastExported,
        language,
        importDreamsPath,
        unsavedChanges
      ];
}
