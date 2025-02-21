import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/domain/entities/stats/streak.dart';

abstract class LocalStorageDatasource {
  Future<int> saveDream(Dream dream);
  Future<void> deleteDream(int id);
  Future<List<Dream?>> loadDreams({int limit = 10, int offset = 0, String order = "date", bool asc = false});
  Future<Dream?> getDream(int id);
  Future<void> toggleFavDream(int id);
  Future<List<Dream?>> loadFavoriteDreams({int limit = 10, int offset = 0});
  Future<List<Dream>> getAllDreams();
  Future<void> exportDreams();
  Future<void> importDreams();
  Future<List<String>>? getAllNames();
  Future<List<Dream>>? searchDreams(String query, {int limit = 10, int offset = 0, names = const [], bool newToOld = true});
  Future<int> searchDreamsResultCount(String query, {names = const []});
  Future<int> dreamCount();
  Future<int> wordCount();
  Future<int> charCount();
  Future<Streak> currentStreak();
  Future<Streak> longestStreak();
  Future<List<DateTime>> allDates();
  Future<DateTime> firstDate();
  Future<DateTime> lastDate();
  Future<List<Dream>> dreamsOnDate(DateTime date);
  Future<int?> mostActiveDotW(); // most active day of the week => day of the week with the most dreams
  Future<List<DateTime>?> mostActiveTime(); // two hour interval with the most dreams
  Future<String?> mostUsedName();
}
