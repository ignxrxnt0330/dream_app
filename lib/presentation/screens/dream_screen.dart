import 'package:flutter/material.dart';

import '../views/views.dart';

class DreamScreen extends StatelessWidget {
  static const name = 'DreamScreen';
  final int? dreamId;
  const DreamScreen({super.key, this.dreamId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('new dream'),
        ),
        body: Expanded(
          child: ListView(
            children: const [
              DreamFormView(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
