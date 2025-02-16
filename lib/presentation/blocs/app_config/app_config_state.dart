part of 'app_config_bloc.dart';

class AppConfigState extends Equatable {
  final bool darkMode;
  const AppConfigState(this.darkMode);

  @override
  List<Object> get props => [darkMode];
}
