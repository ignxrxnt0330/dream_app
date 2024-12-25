import 'package:dream_app/presentation/blocs/dream_stats/dream_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsView extends StatefulWidget {
  static const name = 'stats_view';
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  @override
  void initState() {
    super.initState();

    context.read<DreamStatsBloc>().add(const FetchStats());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DreamStatsBloc>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          bloc.add(const FetchStats());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: BlocBuilder<DreamStatsBloc, DreamStatsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        StatCard(title: "total dreams", text: state.dreamCount.toString()),
                        StatCard(title: "total words", text: state.wordCount.toString()),
                        StatCard(title: "total characters", text: state.charCount.toString()), //TODO: human readable
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        StatCard(title: "current streak", text: state.currentStreak.streak.toString()),
                        StatCard(title: "end", text: "${state.currentStreak.streakStart.day}/${state.currentStreak.streakStart.month}/${state.currentStreak.streakStart.year % 100}"),
                        StatCard(title: "end", text: "${state.currentStreak.streakEnd.day}/${state.currentStreak.streakEnd.month}/${state.currentStreak.streakEnd.year % 100}"),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        StatCard(title: "longest streak", text: state.longestStreak.streak.toString()),
                        StatCard(title: "end", text: "${state.longestStreak.streakStart.day}/${state.longestStreak.streakStart.month}/${state.longestStreak.streakStart.year % 100}"),
                        StatCard(title: "end", text: "${state.longestStreak.streakEnd.day}/${state.longestStreak.streakEnd.month}/${state.longestStreak.streakEnd.year % 100}"),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String text;
  const StatCard({super.key, required this.text, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: MediaQuery.of(context).size.width / 3.5,
        width: MediaQuery.of(context).size.width / 3.5,
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(text),
          ],
        ),
      ),
    );
  }
}
