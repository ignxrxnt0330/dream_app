// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:dream_app/domain/datasource/local_storage_datasource.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/domain/entities/stats/streak.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      if (Isar.instanceNames.isEmpty) {
        return Isar.open([DreamSchema], inspector: true, directory: dir.path);
      }
      return Future.value(Isar.getInstance());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDream(int id) async {
    final isar = await db;
    final exists = await isar.dreams.filter().idEqualTo(id).findFirst();
    if (exists == null) return;
    isar.writeTxnSync(() => isar.dreams.deleteSync(id));
  }

  @override
  Future<Dream?> getDream(int id) async {
    final isar = await db;
    final dream = await isar.dreams.filter().idEqualTo(id).findFirst();
    return dream;
  }

  @override
  Future<int> saveDream(Dream dream) async {
    final isar = await db;
    dream.initNames();
    final int id = isar.writeTxnSync(() => isar.dreams.putSync(dream));
    return id;
  }

  @override
  Future<bool> toggleFavDream(int id) async {
    final isar = await db;
    final dream = await isar.dreams.filter().idEqualTo(id).findFirst();
    if (dream == null) return false;
    saveDream(dream.copyWith(isFav: !dream.isFav));
    return !dream.isFav;
  }

  @override
  Future<List<Dream>> loadDreams({int limit = 10, int offset = 0}) async {
    final isar = await db;
    final List<Dream> dreams = await isar.dreams.where().sortByDateDesc().offset(offset).limit(limit).findAll();
    return dreams;
  }

  @override
  Future<List<Dream?>> loadFavoriteDreams({int limit = 10, int offset = 0}) async {
    final isar = await db;
    final List<Dream> dreams = await isar.dreams.where().filter().isFavEqualTo(true).sortByDateDesc().offset(offset).limit(limit).findAll();
    return dreams;
  }

  @override
  Future<List<Dream>> getAllDreams() async {
    final isar = await db;
    final List<Dream> dreams = await isar.dreams.where().findAll();
    return dreams;
  }

  @override
  Future<void> exportDreams() async {
    try {
      DateTime now = DateTime.now();
      String data = "";
      final List<Dream> dreams = await getAllDreams();
      data = dreams.map((dream) => dream.toJson()).join("\n");

      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        final filePath = "${downloadsDir.path}/dreams_${now.toIso8601String()}.json";
        final file = await File(filePath).create();
        await file.writeAsString(data);
        print("File saved at: $filePath");
      } else {
        print("Downloads directory not available");
      }
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  @override
  Future<List<String>>? getAllNames() async {
    final isar = await db;
    final List<String> allNames = await isar.dreams.filter().namesIsNotNull().namesIsNotEmpty().findAll().then((dreams) {
      return dreams.map((dream) => dream.names!).expand((element) => element).toSet().toList();
    });
    return allNames;
  }

  @override
  Future<List<Dream>>? searchDreams(String query, {int limit = 10, int offset = 0, names = const <String>[], newToOld = true}) async {
    final isar = await db;
    final List<Dream> dreams = await isar.dreams.where().filter().descriptionContains(query, caseSensitive: false).or().titleContains(query, caseSensitive: false).offset(offset).limit(limit).findAll();
    return dreams;
  }

  @override
  Future<int> searchDreamsResultCount(String query, {names = const <String>[]}) async {
    final isar = await db;
    final int dreamCount = await isar.dreams.where().filter().descriptionContains(query, caseSensitive: false).or().titleContains(query, caseSensitive: false).count();
    return dreamCount;
  }

  @override
  Future<int> dreamCount() async {
    final isar = await db;
    final int dreamCount = await isar.dreams.where().count();
    return dreamCount;
  }

  @override
  Future<Streak> currentStreak() async {
    int streak = 0;

    final isar = await db;
    final dates = await isar.dreams.where(distinct: true).sortByDateDesc().dateProperty().findAll();
    if (dates.isEmpty) return Streak(streak: streak, streakStart: DateTime.now(), streakEnd: DateTime.now());

    DateTime streakEnd = dates.last ?? DateTime.now();
    DateTime streakStart = dates.last ?? DateTime.now();

    for (int i = dates.length - 1; i > 0; i--) {
      final currentDate = dates[i];
      final previousDate = dates[i - 1];
      if (currentDate == null || previousDate == null) continue;

      if (currentDate != null && previousDate != null && currentDate.difference(previousDate).inDays == 1) {
        streak++;
      } else {
        streakStart = previousDate;
        break;
      }
    }
    return Streak(streak: streak, streakStart: streakStart, streakEnd: streakEnd);
  }

  @override
  Future<Streak> longestStreak() async {
    int streak = 0;
    final isar = await db;
    final dates = await isar.dreams.where(distinct: true).sortByDateDesc().dateProperty().findAll();
    if (dates.isEmpty) return Streak(streak: streak, streakStart: DateTime.now(), streakEnd: DateTime.now());

    DateTime streakEnd = dates.last ?? DateTime.now();
    DateTime streakStart = dates.last ?? DateTime.now();

    int longestStreak = 0;

    for (int i = dates.length - 1; i > 0; i--) {
      final currentDate = dates[i];
      final previousDate = dates[i - 1];
      if (currentDate == null || previousDate == null) continue;

      if (currentDate.difference(previousDate).inDays == 1) {
        streak++;
      } else if (currentDate != null && previousDate != null && currentDate.difference(previousDate).inDays > 1) {
        if (streak > longestStreak) {
          longestStreak = streak;
          streak = 1;
        }
      }
    }

    return Streak(streak: streak, streakStart: streakStart, streakEnd: streakEnd);
  }

  @override
  Future<int> charCount() async {
    final isar = await db;
    final descriptions = await isar.dreams.where().descriptionProperty().findAll();
    final descCount = descriptions.map((e) => e != "" ? e.length : 0).reduce((value, element) => value + element);
    final titles = await isar.dreams.where().titleProperty().findAll();
    final titleCount = titles.map((e) => e != "" && e != null ? e.length : 0).reduce((value, element) => value + element);
    return descCount + titleCount;
  }

  @override
  Future<int> wordCount() async {
    final isar = await db;
    final descriptions = await isar.dreams.where().descriptionProperty().findAll();
    final descCount = descriptions.map((e) => e.split(" ").where((e) => e != "").toList().length).reduce((value, element) => value + element);
    final titles = await isar.dreams.where().titleProperty().findAll();
    final titleCount = titles.map((e) => e != null ? e.split(" ").where((e) => e != "").toList().length : 0).reduce((value, element) => value + element);
    return descCount + titleCount;
  }
}
