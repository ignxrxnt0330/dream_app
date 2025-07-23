import 'package:dream_app/presentation/blocs/app_config/app_config_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_calendar/dream_calendar_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_dream_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;

class CalendarView extends StatefulWidget {
    static const name = 'calendar_view';
    const CalendarView({super.key});

    @override
        State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
    ScrollController scrollController = ScrollController();
final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2019, 2, 10): [
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 1',
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: Colors.red,
            height: 5,
            width: 5,
          ),
        ),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 2',
        ),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 3',
        ),
      ],
    },
  );

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
                                bloc.add(FetchDreamsOnDate(date));
                                },
//weekendTextStyle: const TextStyle(
//                      color: Colors.red,
//                      ),
thisMonthDayBorderColor: Colors.grey,
targetDateTime:bloc.state.targetDate,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
customDayBuilder: (   /// you can provide your own build function to make custom day containers
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
    /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
    /// This way you can build custom containers for specific days only, leaving rest as default.

    // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
    //    if (day.day == 15) {
    //        return const Center(
    //                child: Icon(Icons.local_airport),
    //                );
    //    } else {
    //        return null;
    //    }
    return null;
},
weekFormat: false,
    markedDatesMap: _markedDateMap,
    height: 420.0,
    selectedDateTime: bloc.state.selectedDate,
    daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
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
