part of 'dream_stats_bloc.dart';

class DreamStatsState extends Equatable {
  final int bracket;
  final int dreamCount;
  final int wordCount;
  final int charCount;
  final Streak currentStreak;
  final Streak longestStreak;
  final int mostActiveDotW;
  final Map<String,int> names;

  const DreamStatsState({this.bracket = 7, this.dreamCount = 0, this.wordCount = 0, this.charCount = 0, required this.currentStreak, required this.longestStreak, required this.mostActiveDotW, required this.names});

  DreamStatsState copyWith({
    int? bracket,
    int? dreamCount,
    int? wordCount,
    int? charCount,
    Streak? currentStreak,
    Streak? longestStreak,
    int? mostActiveDotW,
    Map<String,int>? names,
  }) =>
      DreamStatsState(
        bracket: bracket ?? this.bracket,
        dreamCount: dreamCount ?? this.dreamCount,
        wordCount: wordCount ?? this.wordCount,
        charCount: charCount ?? this.charCount,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        mostActiveDotW: mostActiveDotW ?? this.mostActiveDotW,
        names: names ?? this.names,
      );

  @override
    List<Object> get props => [bracket,dreamCount,wordCount,charCount];
}
