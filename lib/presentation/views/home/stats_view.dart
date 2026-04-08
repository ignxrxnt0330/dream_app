import 'dart:developer';

import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/dream_stats/dream_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_app/presentation/widgets/stats/charts/charts.dart';
import 'package:intl/intl.dart';

class StatsView extends StatefulWidget {
  static const name = 'stats_view';
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> with TickerProviderStateMixin {
  late TabController tabBarController;
  late List<ScrollController> scrollControllers;
  late int bracket;

  @override
  void initState() {
    super.initState();
    bracket = 7;

    tabBarController = TabController(length: 4, vsync: this);

    tabBarController.addListener(() {
      onChangeIndex(tabBarController.index);
      setSwipeListener();
    });
    setSwipeListener();

    context
        .read<DreamStatsBloc>()
        .add(FetchStats(bracket: context.read<DreamStatsBloc>().state.bracket));

    scrollControllers = List.generate(4, (_) {
      final controller = ScrollController();
      controller.addListener(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!controller.position.isScrollingNotifier.value) {
            context.read<DreamStatsBloc>().add(
                  StatsScrollChange(scroll: controller.position.pixels),
                );
          }
        });
      });
      return controller;
    });
  }

  void onStartSwipe() {
    final animationValue = tabBarController.animation!.value;
    int currentIndex = tabBarController.index;
    if ((currentIndex - animationValue).abs() < 0.3) {
      return;
    }
    final List<int> tabs = <int>[7, 30, 365, 99999];

    if (animationValue > currentIndex) {
      bracket = tabs[currentIndex + 1];
    } else if (animationValue < currentIndex) {
      bracket = tabs[currentIndex - 1];
    }
    context.read<DreamStatsBloc>().add(BracketChanged(bracket: bracket));
    tabBarController.animation?.removeListener(onStartSwipe);
  }

  void setSwipeListener() {
    tabBarController.animation?.addListener(onStartSwipe);
  }

  void onChangeIndex(int index) {
    switch (index) {
      case 0:
        bracket = 7;
      case 1:
        bracket = 30;
      case 2:
        bracket = 365;
      case 3:
        bracket = 99999;
    }
    context.read<DreamStatsBloc>().add(BracketChanged(bracket: bracket));
    final double savedScroll = context.read<DreamStatsBloc>().state.scroll;
    restoreScroll(savedScroll, scrollControllers[index]);
  }

  void restoreScroll(double savedScroll, scrollController) {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final offset = savedScroll.clamp(0.0, maxScroll);

    scrollController.jumpTo(offset);
  }

  void trackScroll(DreamStatsState state, scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.position.isScrollingNotifier.addListener(() {
        if (!scrollController.position.isScrollingNotifier.value) {
          // scroll stopped
          context
              .read<DreamStatsBloc>()
              .add(StatsScrollChange(scroll: scrollController.position.pixels));
        }
      });
    });
  }

  @override
  void dispose() {
    for (final controller in scrollControllers) {
      controller.dispose();
    }
    tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<Tab> tabs = <Tab>[
      Tab(text: localizations.weekly),
      Tab(text: localizations.monthly),
      Tab(text: localizations.yearly),
      Tab(text: localizations.allTime)
    ];

    return BlocBuilder<DreamStatsBloc, DreamStatsState>(
        builder: (context, state) {
      return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                controller: tabBarController,
                tabs: tabs,
              ),
            ),
            body: Column(children: [
              Card(
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatCard(
                            number: state.dreamCount,
                            text: localizations.dreams),
                        StatCard(
                            number: state.wordCount, text: localizations.words),
                        StatCard(
                            number: state.charCount,
                            text: localizations.characters),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatCard(
                          number: state.currentStreak.streak,
                          text: localizations.currentStreak,
                          tooltipText:
                              "${DateFormat(localizations.dateFormat).format(state.currentStreak.streakStart)} - ${DateFormat(localizations.dmY).format(state.currentStreak.streakEnd)}",
                        ),
                        StatCard(
                          number: state.longestStreak.streak,
                          text: localizations.longestStreak,
                          tooltipText:
                              "${DateFormat(localizations.dmY).format(state.longestStreak.streakStart)} - ${DateFormat(localizations.dmY).format(state.longestStreak.streakEnd)}",
                        ),
                        StatCard(
                            number: (state.dreamCount / state.bracket * 100)
                                    .round() /
                                100,
                            text: localizations.dreamsPerDay,
                            onTap: () {
                              context
                                  .read<DreamStatsBloc>()
                                  .add(FetchStatsDreams());

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BlocBuilder<DreamStatsBloc,
                                      DreamStatsState>(
                                    builder: (context, state) {
                                      if (state.dreams.entries.isEmpty) {
                                        return const Dialog(
                                          child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                        );
                                      }

                                      return Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: RotatedBox(
                                              quarterTurns: 1,
                                              child: Column(
                                                children: [
                                                  Text(localizations
                                                      .dreamsPerDay),
                                                  Expanded(child: BlocBuilder<
                                                          DreamStatsBloc,
                                                          DreamStatsState>(
                                                      builder:
                                                          (context, state) {
                                                    return CustomLineChart(
                                                        data: state.dreams);
                                                  })),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            })
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabBarController,
                  children: List.generate(tabs.length, (index) {
                    final scrollController = scrollControllers[index];
                    return Center(
                        child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(children: [
                              StatsSection(children: [
                                Center(child: Text(localizations.names)),
                                CustomBarChart(data: state.names),
                              ]),
                              StatsSection(children: [
                                StatsHeader(text: localizations.lucidness),
                                CustomPieChart(data: state.lucidness),
                              ]),
                              StatsSection(children: [
                                StatsHeader(text: localizations.types),
                                CustomPieChart(data: state.types)
                              ]),
                              StatsSection(children: [
                                Center(child: Text(localizations.mood)),
                                CustomPieChart(data: state.mood),
                              ]),
                            ])));
                  }).toList(),
                ),
              ),
            ])),
      );
    });
  }
}

class StatsSection extends StatelessWidget {
  final List<Widget> children;
  const StatsSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: children,
      ),
    );
  }
}

class StatsHeader extends StatelessWidget {
  final String text;
  const StatsHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      text,
      style: TextStyle(fontSize: 16),
    ));
  }
}

class StatCard extends StatelessWidget {
  final num number;
  final String text;
  final String? tooltipText;
  final GestureTapCallback? onTap;
  const StatCard(
      {super.key,
      required this.number,
      required this.text,
      this.tooltipText,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(13),
            child: Tooltip(
              showDuration: Duration(seconds: 3),
              message: tooltipText ?? '',
              child: Column(
                children: [
                  Text(number.toString()),
                  Text(text),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatBigText extends StatelessWidget {
  final String text;
  const StatBigText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
