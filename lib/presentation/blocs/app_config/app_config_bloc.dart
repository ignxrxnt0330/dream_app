import 'package:dream_app/infrastructure/sp_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  SpConfig config = SpConfig();

  AppConfigBloc() : super(const AppConfigState(true)) {
    _initConfig();
    on<SetDarkMode>(_setDarkMode);
    on<ToggleDarkMode>(_toggleDarkMode);
  }

  void _setDarkMode(SetDarkMode event, Emitter<AppConfigState> emit) {
    config.setDarkMode(event.darkMode);
    emit(AppConfigState(event.darkMode));
  }

  void _toggleDarkMode(ToggleDarkMode event, Emitter<AppConfigState> emit) {
    config.toggleDarkMode();
    emit(AppConfigState(!state.darkMode));
  }

  void _initConfig() async {
    add(SetDarkMode(darkMode: await config.getDarkMode()));
    print("dark mode: ${state.darkMode}");
  }
}
