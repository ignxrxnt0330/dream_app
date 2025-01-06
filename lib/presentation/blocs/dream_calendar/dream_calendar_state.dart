part of 'dream_calendar_bloc.dart';

class DreamCalendarState extends Equatable {
  final List<DateTime> dates;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<Dream> dreams;

  const DreamCalendarState(this.dates, this.dreams, this.firstDate, this.lastDate);

  DreamCalendarState copyWith({List<DateTime>? dates, List<Dream>? dreams, DateTime? firstDate, DateTime? lastDate}) => DreamCalendarState(
        dates ?? this.dates,
        dreams ?? this.dreams,
        firstDate ?? this.firstDate,
        lastDate ?? this.lastDate,
      );

  @override
  List<Object> get props => [dates, dreams];
}
