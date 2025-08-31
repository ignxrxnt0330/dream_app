import 'dart:math' as math;

import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:dream_app/presentation/blocs/dream_stats/dream_stats_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsView extends StatefulWidget {
  static const name = 'stats_view';
  const StatsView({super.key});


  @override
    State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> with TickerProviderStateMixin{
  late TabController tabBarController;


  @override
    void initState() {
      super.initState();

      context.read<DreamStatsBloc>().add(const FetchStats());
    }

  void onChangeIndex (int index) {
    late int bracket;
    switch (index) {
      case 0: bracket = 7;
      case 1: bracket = 30;
      case 2: bracket = 365;
      case 3: bracket = 99999;
    }
    context.read<DreamStatsBloc>().add( BracketChanged(bracket: bracket));
  }

  @override
    Widget build(BuildContext context) {
      tabBarController = TabController(vsync: this, length: 4);
      tabBarController.addListener(() {
          onChangeIndex(tabBarController.index);
          });

      final List<Tab> tabs = <Tab>[
        Tab(text: 'Weekly'),
        Tab(text: 'Monthly'), 
        Tab(text: 'Yearly'), 
        Tab(text: 'All time')];

      return BlocBuilder<DreamStatsBloc, DreamStatsState>(
          builder:(context,state){
          return DefaultTabController(
              length: tabs.length,
              child: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: tabs,
                    onTap: onChangeIndex,
                    ),
                  ),
                body: 
                Column(
                  children: [
                  Card(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      children: [
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                        StatCard(number: state.dreamCount ,text:"dreams"),
                        StatCard(number: state.wordCount ,text:"words"),
                        StatCard(number: state.charCount ,text:"characters"),
                        ],),
                      //Text("madotw ${DateUtils_.DateUtils().getDayName(state.mostActiveDotW)}"),
                      ],
                      ),
                    ),
                  Expanded(
                    child: TabBarView(
                      children: tabs.map((Tab tab) { 
                        return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                CustomPieChart(data:state.types),
                                CustomPieChart(data:state.lucidness),
                                CustomBarChart(data:state.names),
                                ]
                                )
                              )
                            );
                        }).toList(),
                      ),
                    ),
                  ]
                    ),
                  ),
                  );  

          }
      );
    }
}

class StatCard extends StatelessWidget {
  final int number;
  final String text;
  const StatCard({super.key,required this.number,required this.text});

  @override
    Widget build(BuildContext context) {
      return Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Text(number.toString()),
              Text(text),
            ],),
            ),
          );
    }
}


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

class CustomPieChart extends StatelessWidget {
  final Map<String, int> data;
  const CustomPieChart({super.key,required this.data});

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
                    Color color = Color.lerp(Theme.of(context).colorScheme.primary, modColor, mod) ?? primary;
                    return PieChartSectionData(
                        value: entry.value.toDouble(),
                        title: entry.key,
                        color:color,
                        );
                    }),
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
