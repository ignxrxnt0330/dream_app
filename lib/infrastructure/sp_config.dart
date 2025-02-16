import 'package:dream_app/domain/datasource/config_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpConfig extends ConfigDatasource {
  late SharedPreferences prefs;

  @override
  Future<bool> setDarkMode(bool darkMode) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setBool('darkMode', darkMode);
  }

  @override
  Future<bool> getDarkMode() async {
    prefs = await SharedPreferences.getInstance();
    bool? darkMode = prefs.getBool('darkMode');
    darkMode ??= await setDarkMode(false);
    return darkMode;
  }

  @override
  Future<bool> toggleDarkMode() async {
    return await setDarkMode(!await getDarkMode());
  }
}
