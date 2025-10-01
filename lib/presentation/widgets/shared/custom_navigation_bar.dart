import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final List<Function> actions;
  const CustomBottomNavigation(
      {super.key, required this.selectedIndex, required this.actions});

  void onItemTapped(BuildContext context, int index) {
    if (selectedIndex == index) {
      actions[index](context);
      return;
    }
    context.go("/home/$index");
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
