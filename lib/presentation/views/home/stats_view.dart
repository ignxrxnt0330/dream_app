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
    final bloc = context.read<DreamStatsBloc>();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                StatCard(title: "total dreams", text: bloc.state.dreamCount.toString()),
                StatCard(title: "total words", text: bloc.state.wordCount.toString()),
                StatCard(title: "total characters", text: bloc.state.charCount.toString()), //TODO: human readable
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                StatCard(title: "current streak", text: bloc.state.currentStreak.streak.toString()),
                StatCard(title: "start", text: bloc.state.currentStreak.streakStart.toString()),
                StatCard(title: "end", text: bloc.state.currentStreak.streakEnd.toString()),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                StatCard(title: "longest streak", text: bloc.state.longestStreak.streak.toString()),
                StatCard(title: "start", text: bloc.state.longestStreak.streakStart.toString()),
                StatCard(title: "end", text: bloc.state.longestStreak.streakEnd.toString()),
              ],
            ),
          ],
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
