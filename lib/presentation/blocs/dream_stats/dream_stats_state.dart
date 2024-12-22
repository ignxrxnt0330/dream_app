part of 'dream_stats_bloc.dart';

class DreamStatsState extends Equatable {
  final int dreamCount;
  final int wordCount;
  final int charCount;
  final Streak currentStreak;
  final Streak longestStreak;

  const DreamStatsState({this.dreamCount = 0, this.wordCount = 0, this.charCount = 0, required this.currentStreak, required this.longestStreak});

  DreamStatsState copyWith({
    int? dreamCount,
    int? wordCount,
    int? charCount,
    Streak? currentStreak,
    Streak? longestStreak,
  }) =>
      DreamStatsState(
        dreamCount: dreamCount ?? this.dreamCount,
        wordCount: wordCount ?? this.wordCount,
        charCount: charCount ?? this.charCount,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
      );

  @override
  List<Object> get props => [dreamCount, wordCount, charCount, currentStreak, longestStreak];
}
