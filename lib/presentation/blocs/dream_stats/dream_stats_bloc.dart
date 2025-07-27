import 'package:dream_app/domain/entities/stats/streak.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_stats_event.dart';
part 'dream_stats_state.dart';

class DreamStatsBloc extends Bloc<DreamStatsEvent, DreamStatsState> {
  DreamStatsBloc()
      : super(DreamStatsState(
            currentStreak: Streak(streak: 0, streakStart: DateTime.now(), streakEnd: DateTime.now()), longestStreak: Streak(streak: 0, streakStart: DateTime.now(), streakEnd: DateTime.now()), mostActiveDotW: 0, names: {})) {
    on<FetchStats>((_fetchStats));
    on<BracketChanged>((_bracketChanged));
  }

  Future<void> _fetchStats(FetchStats event, Emitter<DreamStatsState> emit) async {
    int bracket = state.bracket;
    final dreamCount = await IsarDatasource().dreamCount(bracket);
    final wordCount = await IsarDatasource().wordCount(bracket);
    final charCount = await IsarDatasource().charCount(bracket);
    final longestStreak = await IsarDatasource().longestStreak();
    final currentStreak = await IsarDatasource().currentStreak();
    final mostActiveDotW = await IsarDatasource().mostActiveDotW(bracket);
    final names = await IsarDatasource().mostUsedNames(bracket);

    emit(state.copyWith(
      dreamCount: dreamCount,
      wordCount: wordCount,
      charCount: charCount,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      mostActiveDotW: mostActiveDotW,
      names: names,
    ));
  }

  Future<void> _bracketChanged(BracketChanged event, Emitter<DreamStatsState> emit) async {
    emit(state.copyWith(bracket: event.bracket));
    await _fetchStats(FetchStats(), emit);

  }
}
