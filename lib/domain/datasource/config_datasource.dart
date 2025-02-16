abstract class ConfigDatasource {
  Future<bool> setDarkMode(bool darkMode);
  Future<bool> getDarkMode();
  Future<bool> toggleDarkMode();
  Future<String?> getDefaultTitle();
  Future<void> setDefaultTitle(String title);
}
