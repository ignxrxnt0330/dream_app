import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  static const name = 'home_view';
  const HomeView({super.key});
  //TODO: listView : controller => ScrollController

@override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home View'),
    );
  }
}