import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatelessWidget {
  final Map<String, int> data;
  const CustomPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text("No data available.");
    }

    final entries = data.entries.toList().take(7).toList();

    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: GestureDetector(
          child: SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                    ),
                  ),
                  sections: List.generate(entries.length, (i) {
                    final entry = entries[i];
                    Color primary = Theme.of(context).colorScheme.primary;
                    double mod = 0.05 + math.Random().nextDouble() * 0.35;
                    Color modColor = mod % 2 == 0 ? Colors.white : Colors.black;
                    Color color = Color.lerp(
                            Theme.of(context).colorScheme.primary,
                            modColor,
                            mod) ??
                        primary;
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: entry.key,
                      color: color,
                    );
                  }),
                ),
              )),
          onDoubleTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("All data"),
                  content: SingleChildScrollView(
                    child: Column(
                      children: data.entries.map((name) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name.key,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(name.value.toString())
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        return;
                      },
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
