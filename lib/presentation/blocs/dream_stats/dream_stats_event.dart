part of 'dream_stats_bloc.dart';

abstract class DreamStatsEvent extends Equatable {
  const DreamStatsEvent();

  @override
  List<Object> get props => [];
}

class FetchStats extends DreamStatsEvent {
  final int bracket;
  const FetchStats({required this.bracket});
}

class BracketChanged extends DreamStatsEvent {
  final int bracket;
  const BracketChanged({required this.bracket});
}

class StatsScrollChange extends DreamStatsEvent {
  final double scroll;
  const StatsScrollChange({
    required this.scroll,
  });
}

class FetchStatsDreams extends DreamStatsEvent {
  const FetchStatsDreams();
}
