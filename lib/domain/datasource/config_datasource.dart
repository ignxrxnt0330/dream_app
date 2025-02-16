abstract class ConfigDatasource {
  Future<bool> setDarkMode(bool darkMode);
  Future<bool> getDarkMode();
  Future<bool> toggleDarkMode();
}
