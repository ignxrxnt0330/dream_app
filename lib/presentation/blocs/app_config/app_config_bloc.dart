import 'package:dream_app/infrastructure/sp_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  SpConfig config = SpConfig();

  AppConfigBloc() : super(const AppConfigState(true, null)) {
    _initConfig();
    on<SetDarkMode>(_setDarkMode);
    on<ToggleDarkMode>(_toggleDarkMode);
    on<SetDefaultTitle>(_setDefaultTitle);
  }

  void _initConfig() async {
    add(SetDarkMode(await config.getDarkMode()));
    String? defTitle = await config.getDefaultTitle();
    if (defTitle != null && defTitle.isNotEmpty) {
      add(SetDefaultTitle(defTitle));
    }
  }

  void _setDarkMode(SetDarkMode event, Emitter<AppConfigState> emit) async {
    await config.setDarkMode(event.darkMode);
    emit(state.copyWith(darkMode: event.darkMode));
  }

  void _toggleDarkMode(ToggleDarkMode event, Emitter<AppConfigState> emit) async {
    await config.toggleDarkMode();
    emit(state.copyWith(darkMode: !state.darkMode));
  }

  void _setDefaultTitle(SetDefaultTitle event, Emitter<AppConfigState> emit) async {
    await config.setDefaultTitle(event.title);
    emit(state.copyWith(defaultTitle: event.title));
  }
}
