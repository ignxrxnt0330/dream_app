import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  const CustomBottomNavigation({super.key, required this.selectedIndex});

  void onItemTapped(BuildContext context, int index) {
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
            label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            label: "Calendar"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            label: "Search"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_graph,
              color: Colors.white,
            ),
            label: "Stats"),
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
