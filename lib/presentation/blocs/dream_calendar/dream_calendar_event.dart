part of 'dream_calendar_bloc.dart';

abstract class DreamCalendarEvent {
  const DreamCalendarEvent();
}

class FetchDates extends DreamCalendarEvent {
  const FetchDates();
}

class FetchDreamsOnDate extends DreamCalendarEvent {
  final DateTime? date;
  const FetchDreamsOnDate({this.date});
}

class FetchBracket extends DreamCalendarEvent {
  // first and last date
  const FetchBracket();
}

class ToggleCalendarFav extends DreamCalendarEvent {
  final Id dreamId;

  const ToggleCalendarFav({required this.dreamId});
}
