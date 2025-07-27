import 'package:dream_app/config/theme/app_theme.dart';
import 'package:dream_app/presentation/blocs/dream_stats/dream_stats_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_app/util/date_utils.dart' as DateUtils_;

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

  @override
    Widget build(BuildContext context) {
      final bloc = context.watch<DreamStatsBloc>();
      tabBarController = TabController(vsync: this, length: 4);

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
                    onTap: (index) {
                    late int bracket;
                    switch (index) {
                    case 0: bracket = 7;
                    case 1: bracket = 30;
                    case 2: bracket = 365;
                    case 3: bracket = 99999;
                    }
                    bloc.add( BracketChanged(bracket: bracket));
                    },
                    ),
                  ),
                body: TabBarView(
                  children: tabs.map((Tab tab) { return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                          Card(
                            color: Theme.of(context).cardColor,
                            child: Column(
                              children: [ Text("${state.dreamCount} dreams"),
                              Text("${state.wordCount} words"),
                              Text("${state.charCount} characters"),
                              Text(
                                state.names.isNotEmpty
                                ? "most named person ${state.names.keys.first} (${state.names.values.first})"
                                : "No names found"
                                ),
                              Text("madotw ${DateUtils_.DateUtils().getDayName(state.mostActiveDotW)}"),
                              GestureDetector(
                                child:SizedBox(
                                  height: 200,
                                  child: NamesChart(names:state.names)

                                  ),
                                onDoubleTap: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text("All names"),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children:state.names.entries.map((name) {
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

                                },
),
                              ],
                              ),
                              ),
                              ]
                                )
                                )
                                );
                  }).toList(),
              ),
              ),
              );  

          }
      );
    }
}


class NamesChart extends StatelessWidget {
  final Map<String, int> names;

  const NamesChart({super.key, required this.names});

  @override
    Widget build(BuildContext context) {
      if (names.isEmpty) {
        return const Text("No name data available.");
      }

      final entries = names.entries.toList().take(7).toList();

      return BarChart(
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
            );
    }
}
