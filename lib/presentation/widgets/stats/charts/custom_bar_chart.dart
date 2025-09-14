
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatelessWidget {
  final Map<String, int> data;
  const CustomBarChart({super.key,required this.data});

  @override
    Widget build(BuildContext context) {
      if (data.isEmpty) {
        return const Text("No data available.");
      }

      final entries = data.entries.toList().take(7).toList();

      return Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: GestureDetector(
            child:SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(
                    border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                      ),
                    ),
                  groupsSpace: 10,
                  barGroups: List.generate(entries.length, (i) {
                    final entry = entries[i];
                    return BarChartGroupData(
                        x: i,
                        barRods: [
                        BarChartRodData(
                          fromY: 0,
                          toY: entry.value.toDouble(),
                          width: 15,
                          color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                        );
                    }),
titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                  ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= entries.length) {
                    return const SizedBox.shrink();
                    }
                    return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          entries[index].key,
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                          ),
                        );
                    },
                    ),
                  ),
                ),
                ),
                )

                  ),
                onDoubleTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text("All data"),
                          content: SingleChildScrollView(
                            child: Column(
                              children:data.entries.map((name) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Text(name.key),
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

