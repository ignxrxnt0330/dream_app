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

class SetDefaultEncryptionKey extends AppConfigEvent {
  final String encryptionKey;
  const SetDefaultEncryptionKey(this.encryptionKey);
}

class ChangeAppColor extends AppConfigEvent {
  final Color appColor;
  const ChangeAppColor(this.appColor);
}

class ExportDreams extends AppConfigEvent {
  final String encryptKey;
  const ExportDreams(this.encryptKey);
}

class ImportDreams extends AppConfigEvent {
  final String path;
  final String encryptKey;
  const ImportDreams(this.path, this.encryptKey);
}

class DeleteAllDreams extends AppConfigEvent {
  const DeleteAllDreams();
}

class SetLastExported extends AppConfigEvent {
  final int lastExported;
  const SetLastExported(this.lastExported);
}

class SetLanguage extends AppConfigEvent {
  final String lang;
  const SetLanguage(this.lang);
}

class RequestFile extends AppConfigEvent {
  const RequestFile();
}
