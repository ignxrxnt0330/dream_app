part of 'dream_calendar_bloc.dart';

class DreamCalendarState extends Equatable {
  final List<DateTime> dates;

  const DreamCalendarState(this.dates);

  DreamCalendarState copyWith({List<DateTime>? dates}) => DreamCalendarState(dates ?? this.dates,);

  @override
  List<Object> get props => [dates];
}
