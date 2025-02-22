import 'dart:ui';

import 'package:dream_app/domain/datasource/config_datasource.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  @override
  Future<String?> getDefaultTitle() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('defaultTitle');
  }

  @override
  Future<void> setDefaultTitle(String title) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('defaultTitle', title);
  }

  @override
  Future<Color> getAppColor() async {
    prefs = await SharedPreferences.getInstance();
    String appColor = prefs.getString('appColor') ?? "9C27B0";
    return colorFromHex(appColor) ?? const Color(0xFF9C27B0);
  }

  @override
  Future<void> changeAppColor(Color appColor) async {
    prefs = await SharedPreferences.getInstance();
    String color = colorToHex(appColor);
    prefs.setString('appColor', color);
  }
}
