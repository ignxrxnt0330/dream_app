import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/widgets/shared/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:dream_app/presentation/views/views.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'HomeScreen';
  final int index;

  const HomeScreen({super.key, required this.index});

  final routes = const <Widget>[
    HomeView(),
    CalendarView(),
    SearchView(),
    StatsView(),
    ConfigView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dream_app'),
        actions: [
          //TODO:
          IconButton(
            icon: const Icon(Icons.question_mark_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        // keeps state
        index: index,
        children: routes,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<DreamFormBloc>().add(const FormInit());
          context.push("/dream/0");
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: index,
      ),
    );
  }
}
