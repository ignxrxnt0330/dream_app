import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/domain/entities/stats/streak.dart';

abstract class LocalStorageDatasource {
  Future<int> saveDream(Dream dream);
  Future<void> deleteDream(int id);
  Future<void> deleteAllDreams();
  Future<List<Dream?>> loadDreams(
      {int limit = 10,
      int offset = 0,
      String order = "date",
      String query = "",
      bool asc = false,
      bool fav = false,
      bool hidden = false,
      int type = 3});
  Future<int> homeDreamCount(
      {bool fav = false, bool hidden = false, int type = 3, String query});
  Future<Dream?> getDream(int id);
  Future<void> toggleFavDream(int id);
  Future<List<Dream?>> loadFavoriteDreams({int limit = 10, int offset = 0});
  Future<List<Dream>> getAllDreams({DateTime? start, DateTime? end});
  Future<bool> exportDreams(String encryptKey);
  Future<bool?> importDreams({String path, String encryptKey});
  Future<String?> requestFile();
  Future<List<Dream>>? searchDreams(String query,
      {int limit = 10, int offset = 0, names = const [], bool newToOld = true});
  Future<int> searchDreamsResultCount(String query, {names = const []});
  Future<List<DateTime>> allDates({DateTime? start, DateTime? end});
  Future<DateTime> firstDate();
  Future<DateTime> lastDate();
  Future<List<Dream>> dreamsOnDate(DateTime date);

  // stats
  Future<int> dreamCount(int bracket);
  Future<int> wordCount(int bracket);
  Future<int> charCount(int bracket);
  Future<int?> mostActiveDotW(
      int bracket); // most active day of the week => day of the week with the most dreams
  Future<List<DateTime>?> mostActiveTime(
      int bracket); // two hour interval with the most dreams
  Future<Map<String, int>?> mostUsedNames(int bracket);
  Future<Map<String, int>?> dreamLucidness(int bracket);
  Future<Map<String, int>?> dreamTypes(int bracket);
  Future<Map<String, int>?> dreamMood(int bracket);

  Future<Streak> currentStreak();
  Future<Streak> longestStreak();
}
