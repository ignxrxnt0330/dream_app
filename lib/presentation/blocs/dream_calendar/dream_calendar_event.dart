part of 'dream_calendar_bloc.dart';

abstract class DreamCalendarEvent {
  const DreamCalendarEvent();
}

class FetchDates extends DreamCalendarEvent {
  const FetchDates();
}

class FetchDreams extends DreamCalendarEvent {
  final DateTime date;
  const FetchDreams(this.date);
}
