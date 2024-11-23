import 'package:flutter/material.dart';

class StatsView extends StatelessWidget {
  static const name = 'stats_view';
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Stats View'),
      ),
    );
  }
}
