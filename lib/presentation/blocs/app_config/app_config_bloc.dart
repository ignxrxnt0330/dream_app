import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:dream_app/infrastructure/datasources/sp_config.dart';
import 'package:dream_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restart_app/restart_app.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  SpConfig config = SpConfig();
  final datasource = IsarDatasource();

  AppConfigBloc()
      : super(const AppConfigState(true, "", Color(0xFF9C27B0), 0, 'en-GB')) {
    _initConfig();
    on<SetDarkMode>(_setDarkMode);
    on<ToggleDarkMode>(_toggleDarkMode);
    on<SetDefaultTitle>(_setDefaultTitle);
    on<ChangeAppColor>(_changeAppColor);
    on<ImportDreams>(_importDreams);
    on<ExportDreams>(_exportDreams);
    on<DeleteAllDreams>(_deleteAllDreams);
    on<SetLastExported>(_setLastExported);
    on<SetLanguage>(_setLanguage);
  }

  void _initConfig() async {
    add(SetDarkMode(await config.getDarkMode()));
    String? defTitle = await config.getDefaultTitle();
    if (defTitle != null && defTitle.isNotEmpty) {
      add(SetDefaultTitle(defTitle));
    }
    add(ChangeAppColor(await config.getAppColor()));
    int? lastExported = await config.getLastExported();
    if (lastExported != 0) {
      add(SetLastExported(lastExported));
    }
    String lang = await config.getLanguage();
    mainAppKey.currentState?.setAppLanguage(lang);
    add(SetLanguage(lang));
  }

  void _setDarkMode(SetDarkMode event, Emitter<AppConfigState> emit) async {
    await config.setDarkMode(event.darkMode);
    emit(state.copyWith(darkMode: event.darkMode));
  }

  void _toggleDarkMode(
      ToggleDarkMode event, Emitter<AppConfigState> emit) async {
    await config.toggleDarkMode();
    emit(state.copyWith(darkMode: !state.darkMode));
  }

  void _setDefaultTitle(
      SetDefaultTitle event, Emitter<AppConfigState> emit) async {
    await config.setDefaultTitle(event.title);
    emit(state.copyWith(defaultTitle: event.title));
  }

  void _setLastExported(
      SetLastExported event, Emitter<AppConfigState> emit) async {
    await config.setLastExported(event.lastExported);
    emit(state.copyWith(lastExported: event.lastExported));
  }

  void _changeAppColor(
      ChangeAppColor event, Emitter<AppConfigState> emit) async {
    await config.changeAppColor(event.appColor);
    emit(state.copyWith(appColor: event.appColor));
  }

  void _exportDreams(ExportDreams event, Emitter<AppConfigState> emit) async {
    await datasource.exportDreams();
    int lastExported = DateTime.now().millisecondsSinceEpoch;
    SpConfig().setLastExported(lastExported);
    emit(state.copyWith(lastExported: lastExported));
  }

  void _importDreams(ImportDreams event, Emitter<AppConfigState> emit) async {
    bool res = await datasource.importDreams();
    if (res) Restart.restartApp();
  }

  void _deleteAllDreams(
      DeleteAllDreams event, Emitter<AppConfigState> emit) async {
    await datasource.deleteAllDreams();
    Restart.restartApp();
  }

  void _setLanguage(SetLanguage event, Emitter<AppConfigState> emit) async {
    await config.setLanguage(event.lang);
    mainAppKey.currentState?.setAppLanguage(event.lang);
    SpConfig().setLanguage(event.lang);
    emit(state.copyWith(language: event.lang));
  }
}
