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
  final Map<String,int> lucidness;
  final Map<String,int> types;
  final Map<String,int> mood;
  final double scroll;

  const DreamStatsState({this.bracket = 7, this.dreamCount = 0, this.wordCount = 0, this.charCount = 0, required this.currentStreak, required this.longestStreak, required this.mostActiveDotW, required this.names,required this.lucidness, required this.types, this.scroll = 0, required this.mood});

  DreamStatsState copyWith({
    int? bracket,
    int? dreamCount,
    int? wordCount,
    int? charCount,
    Streak? currentStreak,
    Streak? longestStreak,
    int? mostActiveDotW,
    Map<String,int>? names,
    Map<String,int>? lucidness,
    Map<String,int>? types,
    double? scroll,
    Map<String,int>? mood,
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
        lucidness: lucidness ?? this.lucidness,
        types: types ?? this.types,
        scroll: scroll ?? this.scroll,
        mood: mood ?? this.mood,
      );

  @override
    List<Object> get props => [
    bracket,
    dreamCount,
    wordCount,
    charCount,
    currentStreak,
    longestStreak,
    mostActiveDotW,
    names,
    lucidness,
    types,
    mood];
}
