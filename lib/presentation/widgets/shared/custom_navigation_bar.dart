import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final List<CustomNavigationBarAction> actions;
  const CustomBottomNavigation(
      {super.key, required this.selectedIndex, required this.actions});

  void onItemTapped(BuildContext context, int index) {
    final action = actions[index];

    if (selectedIndex != index && !action.ignoreRoute) {
      context.go("/home/$index");
    }

    if (selectedIndex == index || action.always) {
      action.action(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      enableFeedback: false,
      selectedLabelStyle: const TextStyle(fontFamily: "Consolas"),
      currentIndex: selectedIndex,
      onTap: (index) => onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: "home"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
            ),
            label: "calendar"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: "stats"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_graph,
            ),
            label: "stats"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "config"),
      ],
    );
  }
}

class CustomNavigationBarAction {
  final Function action;
  final bool always;
  final bool ignoreRoute;

  CustomNavigationBarAction({
    required this.action,
    this.always = true,
    this.ignoreRoute = false,
  }); // executes every time, or only when its already focused
}
