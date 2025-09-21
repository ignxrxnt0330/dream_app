import 'dart:ui';

abstract class ConfigDatasource {
  Future<bool> setDarkMode(bool darkMode);
  Future<bool> getDarkMode();
  Future<bool> toggleDarkMode();
  Future<String?> getDefaultTitle();
  Future<void> setDefaultTitle(String title);
  Future<Color> getAppColor();
  Future<void> changeAppColor(Color appColor);
  Future<int> getLastExported();
  Future<void> setLastExported(int lastExported);
}
