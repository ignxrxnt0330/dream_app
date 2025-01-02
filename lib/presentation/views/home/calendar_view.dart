import 'package:dream_app/config/theme/app_theme.dart';
import 'package:dream_app/presentation/blocs/dream_calendar/dream_calendar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_calendar/streak_calendar.dart';

class CalendarView extends StatefulWidget {
  static const name = 'calendar_view';
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<DateTime> selectedDates = [];

  @override
  void initState() {
    super.initState();
    context.read<DreamCalendarBloc>().add(const FetchDates());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DreamCalendarBloc>();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          bloc.add(const FetchDates());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: CleanCalendar(
            startWeekday: WeekDay.monday,
            datesForStreaks: bloc.state.dates,
            datesForSkips: const [],

            // date props
            generalDatesProperties: DatesProperties(datesDecoration: DatesDecoration(datesTextColor: Colors.white, datesBorderColor: Colors.black)),
            leadingTrailingDatesProperties: DatesProperties(hide: true),
            streakDatesProperties: DatesProperties(datesDecoration: DatesDecoration(datesTextColor: Colors.white, datesBackgroundColor: Colors.black)),
            selectedDatesProperties: DatesProperties(datesDecoration: DatesDecoration(datesTextColor: Colors.black, datesBackgroundColor: Colors.white)),

            dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
            onSelectedDates: (List<DateTime> value) {
              if (selectedDates.isEmpty || selectedDates.first != value.first) {
                selectedDates = value;
              } else {
                selectedDates = [];
              }
              setState(() {});
            },
            selectedDates: selectedDates,
          ),
        ),
      ),
    );
  }
}
