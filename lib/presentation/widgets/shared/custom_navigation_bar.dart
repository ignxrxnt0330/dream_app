import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final List<Function> actions;
  const CustomBottomNavigation({super.key, required this.selectedIndex, required this.actions});

  void onItemTapped(BuildContext context, int index) {
    actions[index]();
    context.go("/home/$index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.white, //FIXME: ¿?
      elevation: 0,
      currentIndex: selectedIndex,
      onTap: (index) => onItemTapped(context, index),
      //! min 2 items with label
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            label: "home"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            label: "calendar"),
        // BottomNavigationBarItem(
        //     icon: Icon(
        //       Icons.search,
        //       color: Colors.white,
        //     ),
        //     label: "search"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_graph,
              color: Colors.white,
            ),
            label: "stats"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            label: "config"),
      ],
    );
  }
}
