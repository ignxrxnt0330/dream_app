import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:dream_app/presentation/delegates/dream_search_delegate.dart';
import 'package:dream_app/presentation/widgets/shared/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:dream_app/presentation/views/views.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';
  final int index;

  const HomeScreen({super.key, required this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FloatingActionButton? getFab(int index, BuildContext context) {
    switch (index) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            context.read<DreamFormBloc>().add(const FormInit());
            context.push("/dream/0");
          },
          child: const Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () {
            var bloc = context.read<DreamCalendarBloc>();
            // showDatePicker(context: context, firstDate: bloc.state.firstDate ?? DateTime.now(), lastDate: bloc.state.lastDate ?? DateTime.now()).then(
            showDatePicker(context: context, firstDate: DateTime(2020, 1, 1), lastDate: DateTime(2069, 4, 20)).then(
              (value) {
                if (value == null) {
                  return;
                }
                bloc.add(FetchDreamsOnDate(value));
              },
              onError: (err) {
                debugPrint(err);
              },
            );
          },
          child: const Icon(Icons.date_range),
        );

      case 3:
        return FloatingActionButton(
          onPressed: () {
            Phoenix.rebirth(context);
          },
          child: const Icon(Icons.refresh),
        );
      default:
        return null;
    }
  }

  final routes = const <Widget>[
    HomeView(),
    CalendarView(),
    StatsView(),
    ConfigView(),
  ];

  final actions = [
    () => print("home"),
    () => print("calendar"),
    () => print("stats"),
    () => print("config"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dream_app'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DreamSearchDelegate(context),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        // keeps state
        index: widget.index,
        children: routes,
      ),
      floatingActionButton: getFab(widget.index, context),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: widget.index,
        actions: actions,
      ),
    );
  }
}
