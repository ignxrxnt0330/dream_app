import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsViewNew extends StatelessWidget {
  const StatsViewNew({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> dummyData1 = List.generate(8, (index) {
      return FlSpot(index.toDouble(), index * Random().nextDouble());
    });
    final List<FlSpot> dummyData2 = List.generate(8, (index) {
      return FlSpot(index.toDouble(), index * Random().nextDouble());
    });
    final List<FlSpot> dummyData3 = List.generate(8, (index) {
      return FlSpot(index.toDouble(), index * Random().nextDouble());
    });

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: DropdownButton<String>(
                      value: "a",
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      onChanged: (String? value) {},
                      style: const TextStyle(color: Colors.white),
                      items: ["a", "b"].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Row(children: [
              LineChart(
                LineChartData(lineBarsData: [
                  LineChartBarData(
                    spots: dummyData1,
                    isCurved: true,
                    barWidth: 3,
                  ),
                  LineChartBarData(
                    spots: dummyData2,
                    isCurved: true,
                    barWidth: 3,
                  ),
                  LineChartBarData(
                    spots: dummyData3,
                    isCurved: false,
                    barWidth: 3,
                  )
                ]),
                // swapAnimationDuration: const Duration(milliseconds: 150),
                // swapAnimationCurve: Curves.linear,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              )
            ])
          ],
        ),
      ),
    );
  }
}
