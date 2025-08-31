import 'package:dream_app/domain/entities/stats/streak.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dream_stats_event.dart';
part 'dream_stats_state.dart';

class DreamStatsBloc extends Bloc<DreamStatsEvent, DreamStatsState> {
  DreamStatsBloc()
      : super(DreamStatsState(
            currentStreak: Streak(streak: 0, streakStart: DateTime.now(), streakEnd: DateTime.now()), longestStreak: Streak(streak: 0, streakStart: DateTime.now(), streakEnd: DateTime.now()), mostActiveDotW: 0, names: {}, types: {},lucidness: {})) {
    on<FetchStats>((_fetchStats));
    on<BracketChanged>((_bracketChanged));
    on<StatsScrollChange>((_scrollChanged));
  }

  Future<void> _fetchStats(FetchStats event, Emitter<DreamStatsState> emit) async {
    print("fetch");
    int bracket = state.bracket;
    final dreamCount = await IsarDatasource().dreamCount(bracket);
    final wordCount = await IsarDatasource().wordCount(bracket);
    final charCount = await IsarDatasource().charCount(bracket);
    final longestStreak = await IsarDatasource().longestStreak();
    final currentStreak = await IsarDatasource().currentStreak();
    final mostActiveDotW = await IsarDatasource().mostActiveDotW(bracket);
    final names = await IsarDatasource().mostUsedNames(bracket);
    final types = await IsarDatasource().dreamTypes(bracket);
    final lucidness = await IsarDatasource().dreamLucidness(bracket);

    emit(state.copyWith(
      dreamCount: dreamCount,
      wordCount: wordCount,
      charCount: charCount,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      mostActiveDotW: mostActiveDotW,
      names: names,
      types: types,
      lucidness: lucidness,
      bracket: event.bracket,
    ));
  }

  Future<void> _bracketChanged(BracketChanged event, Emitter<DreamStatsState> emit) async {
    if(event.bracket != 99999){
      await _fetchStats(FetchStats(bracket: event.bracket),emit);
    } else{
      DateTime date = await IsarDatasource().firstDate();
      final int bracket = DateTime.now().difference(date).inDays;
      await _fetchStats(FetchStats(bracket:bracket), emit);

    }
  }

  Future<void> _scrollChanged(StatsScrollChange event, Emitter<DreamStatsState> emit) async {
    emit(state.copyWith(
          scroll: event.scroll,
          ));
  }
}
