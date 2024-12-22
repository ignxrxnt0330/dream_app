part of 'dream_stats_bloc.dart';

abstract class DreamStatsEvent extends Equatable {
  const DreamStatsEvent();

  @override
  List<Object> get props => [];
}

class FetchStats extends DreamStatsEvent {
  const FetchStats();
}
