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
  final String snackbarMessage;
  const AppConfigState(
      this.darkMode,
      this.defaultTitle,
      this.defaultEncryptionKey,
      this.appColor,
      this.lastExported,
      this.language,
      this.importDreamsPath,
      this.unsavedChanges,
      this.snackbarMessage);

  AppConfigState copyWith(
      {bool? darkMode,
      String? defaultTitle,
      String? defaultEncryptionKey,
      Color? appColor,
      int? lastExported,
      String? language,
      String? importDreamsPath,
      bool? unsavedChanges,
      String? snackbarMessage}) {
    return AppConfigState(
        darkMode ?? this.darkMode,
        defaultTitle ?? this.defaultTitle,
        defaultEncryptionKey ?? this.defaultEncryptionKey,
        appColor ?? this.appColor,
        lastExported ?? this.lastExported,
        language ?? this.language,
        importDreamsPath ?? this.importDreamsPath,
        unsavedChanges ?? this.unsavedChanges,
        snackbarMessage ?? this.snackbarMessage);
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
        unsavedChanges,
        snackbarMessage
      ];
}
