import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_calendar/dream_calendar_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_dream_list_tile.dart';
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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<DreamCalendarBloc>().add(const FetchDates());
    context.read<DreamCalendarBloc>().add(const FetchBracket());
    context.read<DreamCalendarBloc>().add(FetchDreamsOnDate(DateTime.now()));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DreamCalendarBloc>();
    final configState = context.watch<AppConfigBloc>().state;
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: CleanCalendar(
              currentDateOfCalendar: bloc.state.selectedDate,
              startWeekday: WeekDay.monday,
              startDateOfCalendar: bloc.state.firstDate,
              endDateOfCalendar: bloc.state.lastDate,
              datesForStreaks: bloc.state.dates,
              datesForSkips: const [], //TODO:

              // date props
              generalDatesProperties: DatesProperties(datesDecoration: DatesDecoration(datesTextColor: configState.darkMode ? Colors.white : Colors.black, datesBorderColor: configState.darkMode ? Colors.black : Colors.white)),
              leadingTrailingDatesProperties: DatesProperties(hide: true),
              streakDatesProperties: DatesProperties(datesDecoration: DatesDecoration(datesTextColor: configState.darkMode ? Colors.white : Colors.black, datesBackgroundColor: configState.darkMode ? Colors.black : Colors.white)),
              selectedDatesProperties: DatesProperties(datesDecoration: DatesDecoration(datesTextColor: configState.darkMode ? Colors.black : Colors.white, datesBackgroundColor: configState.darkMode ? Colors.white : Colors.black)),

              dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
              onSelectedDates: (List<DateTime> value) {
                bool noDreams = bloc.state.dates.where((el) => el.day == value.first.day && el.month == value.first.month && el.year == value.first.year).isEmpty;
                if (noDreams) {
                  return;
                }
                if (bloc.state.selectedDate == value.first) {
                  return;
                }
                bloc.add(FetchDreamsOnDate(value.first));
              },
              selectedDates: [bloc.state.selectedDate],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
              child: bloc.state.dreams.isNotEmpty ? Center(child: Text("${bloc.state.dreams.length} dreams")) : null,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final dream = bloc.state.dreams[index];
                return CustomDreamListTile(dream: dream);
              },
              childCount: bloc.state.dreams.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
