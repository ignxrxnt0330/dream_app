import 'package:dream_app/domain/entities/stats/streak.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_stats_event.dart';
part 'dream_stats_state.dart';

class DreamStatsBloc extends Bloc<DreamStatsEvent, DreamStatsState> {
  DreamStatsBloc()
      : super(DreamStatsState(
            currentStreak: Streak(streak: 0, streakStart: DateTime.now(), streakEnd: DateTime.now()), longestStreak: Streak(streak: 0, streakStart: DateTime.now(), streakEnd: DateTime.now()), mostActiveDotW: 0, mostUsedName: "")) {
    on<FetchStats>((_fetchStats));
  }

  Future<void> _fetchStats(FetchStats event, Emitter<DreamStatsState> emit) async {
    final dreamCount = await IsarDatasource().dreamCount();
    final wordCount = await IsarDatasource().wordCount();
    final charCount = await IsarDatasource().charCount();
    final longestStreak = await IsarDatasource().longestStreak();
    final currentStreak = await IsarDatasource().currentStreak();
    final mostActiveDotW = await IsarDatasource().mostActiveDotW();
    final mostUsedName = await IsarDatasource().mostUsedName();
    print("mostActiveDotW: $mostActiveDotW");
    print("mostUsedName: $mostUsedName");

    emit(state.copyWith(
      dreamCount: dreamCount,
      wordCount: wordCount,
      charCount: charCount,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      mostActiveDotW: mostActiveDotW,
      mostUsedName: mostUsedName,
    ));
  }
}
