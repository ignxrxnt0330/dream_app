class Streak {
  final int streak;
  final DateTime streakStart;
  final DateTime streakEnd;
  const Streak(
      {required this.streak,
      required this.streakStart,
      required this.streakEnd});

  @override
  toString() {
    return "Streak(streak: $streak, streakStart: $streakStart, streakEnd: $streakEnd)";
  }
}
