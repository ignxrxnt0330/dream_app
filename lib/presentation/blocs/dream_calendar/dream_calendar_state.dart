part of 'dream_calendar_bloc.dart';

class DreamCalendarState extends Equatable {
  final List<DateTime> dates;
  final List<Dream> dreams;

  const DreamCalendarState(this.dates, this.dreams);

  DreamCalendarState copyWith({List<DateTime>? dates, List<Dream>? dreams}) => DreamCalendarState(
        dates ?? this.dates,
        dreams ?? this.dreams,
      );

  @override
  List<Object> get props => [dates, dreams];
}
