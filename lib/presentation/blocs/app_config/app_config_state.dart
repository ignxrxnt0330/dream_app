part of 'app_config_bloc.dart';

class AppConfigState extends Equatable {
  final bool darkMode;
  final String? defaultTitle;
  const AppConfigState(this.darkMode, this.defaultTitle);

  AppConfigState copyWith({bool? darkMode, String? defaultTitle}) {
    return AppConfigState(
      darkMode ?? this.darkMode,
      defaultTitle ?? this.defaultTitle,
    );
  }

  @override
  List<Object> get props => [darkMode];
}
