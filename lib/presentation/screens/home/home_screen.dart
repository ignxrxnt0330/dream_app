import 'package:dream_app/presentation/widets/shared/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:dream_app/presentation/views/views.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'HomeScreen';
  final int index;

  const HomeScreen({super.key, required this.index});

  final routes = const <Widget>[
    HomeView(),
    CalendarView(),
    StatsView(),
    SearchView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dream_app'),
      ),
      body: IndexedStack(
        // keeps state
        index: index,
        children: routes,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: index,
      ),
    );
  }
}
