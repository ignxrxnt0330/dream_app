part of 'dream_calendar_bloc.dart';

class DreamCalendarState extends Equatable {
  final List<DateTime> dates;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime selectedDate;
  final DateTime targetDate;
  final List<Dream> dreams;

  const DreamCalendarState(this.dates, this.dreams, this.firstDate, this.lastDate, this.targetDate, this.selectedDate);

  DreamCalendarState copyWith({List<DateTime>? dates, List<Dream>? dreams, DateTime? firstDate, DateTime? lastDate, DateTime? targetDate, DateTime? selectedDate}) => DreamCalendarState(
        dates ?? this.dates,
        dreams ?? this.dreams,
        firstDate ?? this.firstDate,
        lastDate ?? this.lastDate,
        targetDate ?? this.targetDate,
        selectedDate ?? this.selectedDate,
      );

  @override
  List<Object> get props => [dates, dreams, selectedDate, targetDate];
}
