// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:dream_app/domain/datasource/local_storage_datasource.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/domain/entities/stats/streak.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
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
  Future<List<Dream>> loadDreams({int limit = 10, int offset = 0, String order = "date", bool asc = false, bool fav = false, bool hidden = false}) async {
    final isar = await db;
    final dreams = await isar.dreams
        .buildQuery(
          filter: FilterGroup.and([
            if (fav) FilterCondition.equalTo(property: 'isFav', value: true),
            if (hidden) FilterCondition.equalTo(property: 'hidden', value: true),
          ]),
          sortBy: [SortProperty(property: order, sort: asc ? Sort.asc : Sort.desc)],
          offset: offset,
          limit: limit,
        )
        .findAll();
    return dreams.cast<Dream>();
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
      final List<Dream> dreams = await getAllDreams();
      String data = "[${dreams.map((dream) => dream.toJson()).join(",\n")}]";

      final dir = await getTemporaryDirectory();
      if (dir != null) {
        final timeStamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = "${dir.path}/dreams_$timeStamp.json";
        final file = await File(filePath).create();
        await file.writeAsString(data);
        if (Platform.isAndroid) {
          final params = SaveFileDialogParams(sourceFilePath: filePath);
          final finalPath = await FlutterFileDialog.saveFile(params: params);

          print('Download path: $finalPath');
        }
      } else {
        print("Downloads directory not available");
      }
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  @override
  Future<void> importDreams() async {
    try {
      final params = OpenFileDialogParams(
        dialogType: OpenFileDialogType.document,
        fileExtensionsFilter: ["json"],
        localOnly: true,
      );
      final filePath = await FlutterFileDialog.pickFile(params: params);
      List<Dream> dreams = [];
      if (filePath != null) {
        final file = File(filePath);
        final data = await file.readAsString();
        final List<dynamic> jsonDreams = jsonDecode(data);
        for (Map<String, dynamic> jsonDream in jsonDreams) {
          dreams.add(Dream.fromJson(jsonDream));
        }
        final isar = await db;
        isar.writeTxnSync(() => isar.dreams.putAllSync(dreams));
      }
    } catch (e) {
      print("Error importing file: $e");
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
    final dreams = await isar.dreams.where().filter().descriptionContains(query, caseSensitive: false).or().titleContains(query, caseSensitive: false).sortByDateDesc().offset(offset).limit(limit).findAll();
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

    for (int i = dates.length - 1; i >= 0; i--) {
      final currentDate = dates[i];
      final previousDate = dates[i - 1 != -1 ? i - 1 : i];
      if (currentDate == null || previousDate == null) continue;
      if (currentDate.day == previousDate.day && currentDate.month == previousDate.month && currentDate.year == previousDate.year) continue;

      final isNextDay = previousDate.day == currentDate.add(const Duration(days: 1)).day;

      if (isNextDay) {
        streak++;
        streakEnd = previousDate;
      } else {
        streak = 1;
        streakStart = previousDate;
        streakEnd = previousDate;
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
    late DateTime currStreakEnd = DateTime.now();
    late DateTime currStreakStart = DateTime.now();

    int longestStreak = 0;

    for (int i = dates.length - 1; i >= 0; i--) {
      final currentDate = dates[i];
      final previousDate = dates[i - 1 != -1 ? i - 1 : i];

      if (currentDate == null || previousDate == null) continue;
      if (currentDate.day == previousDate.day && currentDate.month == previousDate.month && currentDate.year == previousDate.year) continue;

      final isNextDay = previousDate.day == currentDate.add(const Duration(days: 1)).day;

      if (isNextDay) {
        streak++;
        currStreakEnd = previousDate;
      } else if (!isNextDay || i == dates.length - 1) {
        if (streak > longestStreak) {
          streakStart = currStreakStart;
          streakEnd = currStreakEnd;
          longestStreak = streak;
        }
        streak = 1;
        currStreakStart = previousDate;
      }
    }

    return Streak(streak: longestStreak, streakStart: streakStart, streakEnd: streakEnd);
  }

  @override
  Future<int> charCount() async {
    final isar = await db;
    final descriptions = await isar.dreams.where().descriptionProperty().findAll();
    final descCount = descriptions.isEmpty ? 0 : descriptions.map((e) => e != "" ? e.length : 0).reduce((value, element) => value + element);
    final titles = await isar.dreams.where().titleProperty().findAll();
    final titleCount = titles.isEmpty ? 0 : titles.map((e) => e != "" && e != null ? e.length : 0).reduce((value, element) => value + element);
    return descCount + titleCount;
  }

  @override
  Future<int> wordCount() async {
    final isar = await db;
    final descriptions = await isar.dreams.where().descriptionProperty().findAll();
    if (descriptions.isEmpty) return 0;
    final descCount = descriptions.map((e) => e.split(" ").where((e) => e != "").toList().length).reduce((value, element) => value + element);
    final titles = await isar.dreams.where().titleProperty().findAll();
    final titleCount = titles.map((e) => e != null ? e.split(" ").where((e) => e != "").toList().length : 0).reduce((value, element) => value + element);
    return descCount + titleCount;
  }

  @override
  Future<List<DateTime>> allDates() async {
    final isar = await db;
    //TODO: next month
    final dates = await isar.dreams.where(distinct: true).sortByDateDesc().dateProperty().findAll();
    return dates.cast<DateTime>();
  }

  @override
  Future<DateTime> firstDate() async {
    final isar = await db;
    final date = await isar.dreams.where().sortByDate().dateProperty().findFirst();
    return date ?? DateTime.now();
  }

  @override
  Future<DateTime> lastDate() async {
    final isar = await db;
    final date = await isar.dreams.where().sortByDateDesc().dateProperty().findFirst();
    return date ?? DateTime.now();
  }

  @override
  Future<List<Dream>> dreamsOnDate(DateTime date) async {
    final DateTime dayStart = DateTime(date.year, date.month, date.day);
    final DateTime dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final isar = await db;
    final dreams = await isar.dreams.where().filter().dateBetween(dayStart, dayEnd).sortByDate().findAll();
    return dreams;
  }

  @override
  Future<int?> mostActiveDotW() async {
    final isar = await db;
    final Map<int, int> daysOfTheWeek = {};

    await isar.dreams.where().dateProperty().findAll().then((dates) {
      // ignore: avoid_function_literals_in_foreach_calls
      dates.forEach((e) => daysOfTheWeek[e!.weekday] = daysOfTheWeek[e.weekday] ?? 0 + 1);
    });

    final daysOfTheWeekList = daysOfTheWeek.entries.toList();
    if (daysOfTheWeekList.isEmpty) return null;
    daysOfTheWeekList.sort((a, b) => b.value.compareTo(a.value));

    return daysOfTheWeekList.first.key;
  }

  @override
  Future<List<DateTime>?> mostActiveTime() async {
    // TODO: implement mostActiveTime
    throw UnimplementedError();
  }

  @override
  Future<String?> mostUsedName() async {
    final isar = await db;
    final Map<String, int> allNames = {};

    await isar.dreams.where().namesProperty().findAll().then((dream) {
      for (List<String>? names in dream) {
        if (names != null) {
          for (String name in names) {
            allNames[name] = (allNames[name] ?? 0) + 1;
          }
        }
      }
    });

    final namesList = allNames.entries.toList();
    if (namesList.isEmpty) return null;
    namesList.sort((a, b) => b.value.compareTo(a.value));

    return namesList.first.key;
  }
}
