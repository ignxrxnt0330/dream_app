import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_calendar/dream_calendar_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_dream_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class CalendarView extends StatefulWidget {
  static const name = 'calendar_view';
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  ScrollController scrollController = ScrollController();
  final EventList<Event> _markedDateMap = EventList<Event>(events: {});

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
            child: CalendarCarousel<Event>(
              onDayPressed: (DateTime date, List<Event> events) {
                bool noDreams = bloc.state.dates
                    .where((el) =>
                        el.day == date.day &&
                        el.month == date.month &&
                        el.year == date.year)
                    .isEmpty;
                if (noDreams) {
                  return;
                }
                bool selected = bloc.state.selectedDate == date;
                if (selected) {
                  return;
                }
                bloc.add(FetchDreamsOnDate(date));
              },

              daysHaveCircularBorder: true,
              customGridViewPhysics: const NeverScrollableScrollPhysics(),

// header
              showHeader: true,
              headerTextStyle: TextStyle(
                color: configState.darkMode ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              headerMargin: const EdgeInsets.symmetric(vertical: 10),

              rightButtonIcon: Icon(Icons.chevron_right,
                  color: configState.darkMode ? Colors.white : Colors.black),
              leftButtonIcon: Icon(Icons.chevron_left,
                  color: configState.darkMode ? Colors.white : Colors.black),

              headerTitleTouchable: true,
              onHeaderTitlePressed: () => context
                  .read<DreamCalendarBloc>()
                  .add(FetchDreamsOnDate(DateTime.now())),

// selected
              selectedDayButtonColor:
                  configState.darkMode ? Colors.white : Colors.black,
              selectedDayBorderColor:
                  configState.darkMode ? Colors.black : Colors.white,
              selectedDayTextStyle: TextStyle(
                  color: configState.darkMode ? Colors.black : Colors.white),

// today
              todayButtonColor:
                  configState.darkMode ? Colors.white : Colors.black,
              todayBorderColor:
                  configState.darkMode ? Colors.black : Colors.white,
              todayTextStyle: TextStyle(
                  color: configState.darkMode ? Colors.black : Colors.white),

              targetDateTime: bloc.state.targetDate,
              firstDayOfWeek: 1, // monday
              pageSnapping: true,
              weekdayTextStyle: TextStyle(
                color: configState.darkMode ? Colors.white : Colors.black,
              ),
              weekendTextStyle: TextStyle(
                color: Colors.black,
              ),
              markedDatesMap: _markedDateMap,
              height: 450.0,
              selectedDateTime: bloc.state.selectedDate,
              pageScrollPhysics: const PageScrollPhysics(),
              customDayBuilder: (
                /// you can provide your own build function to make custom day containers
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
              ) {
                bool noDreams = bloc.state.dates
                    .where((el) =>
                        el.day == day.day &&
                        el.month == day.month &&
                        el.year == day.year)
                    .isEmpty;
                if (isPrevMonthDay || isNextMonthDay) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.transparent)),
                  );
                }
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isSelectedDay
                          ? (configState.darkMode ? Colors.white : Colors.black)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (isSelectedDay || isToday)
                            ? (configState.darkMode
                                ? Colors.white
                                : Colors.black)
                            : (noDreams ? Colors.transparent : Colors.grey),
                      )),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: (isToday || isSelectedDay)
                          ? (configState.darkMode ? Colors.black : Colors.white)
                          : (noDreams
                              ? Colors.grey
                              : (configState.darkMode
                                  ? Colors.white
                                  : Colors.black)),
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
              child: bloc.state.dreams.isNotEmpty
                  ? Center(
                      child: Text(
                          "${bloc.state.dreams.length} ${bloc.state.dreams.length == 1 ? "dream" : "dreams"}"))
                  : null,
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
