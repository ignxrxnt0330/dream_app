// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:dream_app/domain/consts.dart';
import 'package:dream_app/domain/datasource/local_storage_datasource.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/domain/entities/stats/streak.dart';
import 'package:encrypter/encrypter/aes.dart';
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
  Future<void> deleteAllDreams() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.dreams.where().deleteAll();
    });
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
  Future<List<Dream>> loadDreams(
      {int limit = 10,
      int offset = 0,
      String order = "date",
      bool asc = false,
      bool fav = false,
      bool hidden = false,
      int type = 3}) async {
    final isar = await db;
    final dreams = await isar.dreams
        .buildQuery(
          filter: FilterGroup.and([
            if (fav) FilterCondition.equalTo(property: 'isFav', value: true),
            if (hidden)
              FilterCondition.equalTo(property: 'hidden', value: true),
            if (type != 3)
              FilterCondition.equalTo(property: 'type', value: type),
          ]),
          sortBy: [
            SortProperty(property: order, sort: asc ? Sort.asc : Sort.desc)
          ],
          offset: offset,
          limit: limit,
        )
        .findAll();
    return dreams.cast<Dream>();
  }

  @override
  Future<int> homeDreamCount(
      {bool fav = false, bool hidden = false, int type = 3}) async {
    final isar = await db;
    final count = await isar.dreams
        .buildQuery(
          filter: FilterGroup.and([
            if (fav) FilterCondition.equalTo(property: 'isFav', value: true),
            if (hidden)
              FilterCondition.equalTo(property: 'hidden', value: true),
            if (type != 3)
              FilterCondition.equalTo(property: 'type', value: type),
          ]),
        )
        .count();
    return count;
  }

  @override
  Future<List<Dream?>> loadFavoriteDreams(
      {int limit = 10, int offset = 0}) async {
    final isar = await db;
    final List<Dream> dreams = await isar.dreams
        .where()
        .filter()
        .isFavEqualTo(true)
        .sortByDateDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
    return dreams;
  }

  @override
  Future<List<Dream>> getAllDreams({DateTime? start, DateTime? end}) async {
    final isar = await db;
    final dreams = await isar.dreams
        .buildQuery(
          filter: FilterGroup.and([
            if (start != null && end != null)
              FilterCondition.between(
                  property: 'date',
                  lower: start,
                  upper: end.add(Duration(days: 1)),
                  includeLower: false),
          ]),
        )
        .findAll();
    return dreams.cast<Dream>();
  }

  @override
  Future<bool> exportDreams(String encryptKey) async {
    try {
      final List<Dream> dreams = await getAllDreams();
      String data = "[${dreams.map((dream) => dream.toJson()).join(",\n")}]";
      bool saved = false;

      final dir = await getTemporaryDirectory();
      if (dir != null) {
        final int timeStamp = DateTime.now().millisecondsSinceEpoch;
        String filePath = "${dir.path}/dreams_$timeStamp.json";

        if (encryptKey != "") {
          String? encryptedData = await Encrypter.encryptAES256CBC(data, key: encryptKey.padRight(32));
          if (encryptedData == null) return false;
          data = encryptedData;
          filePath = "${dir.path}/dreams_$timeStamp.enc";
        }

        final file = await File(filePath).create();
        await file.writeAsString(data);
        if (Platform.isAndroid) {
          final params = SaveFileDialogParams(sourceFilePath: filePath);
          await FlutterFileDialog.saveFile(params: params)
              .then((res) => saved = true);
        }
      } else {
        return saved;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> importDreams({String path = '', String encryptKey = ''}) async {
    try {
      List<Dream> dreams = [];
      if (path != null) {
        final File file = File(path);
        String data = await file.readAsString();

        if (encryptKey != "") {
          String? decryptedData = await Encrypter.decryptAES256CBC(data, key: encryptKey.padRight(32));
          if (decryptedData == null) return false;
          data = decryptedData;
        }

        final List<dynamic> jsonDreams = jsonDecode(data);
        for (Map<String, dynamic> jsonDream in jsonDreams) {
          dreams.add(Dream.fromJson(jsonDream));
        }
        final isar = await db;
        isar.writeTxnSync(() => isar.dreams.putAllSync(dreams));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Dream>>? searchDreams(String query,
      {int limit = 10,
      int offset = 0,
      names = const <String>[],
      newToOld = true}) async {
    final isar = await db;
    final dreams = await isar.dreams
        .where()
        .filter()
        .descriptionContains(query, caseSensitive: false)
        .or()
        .titleContains(query, caseSensitive: false)
        .sortByDateDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
    return dreams;
  }

  @override
  Future<int> searchDreamsResultCount(String query,
      {names = const <String>[]}) async {
    final isar = await db;
    final int dreamCount = await isar.dreams
        .where()
        .filter()
        .descriptionContains(query, caseSensitive: false)
        .or()
        .titleContains(query, caseSensitive: false)
        .count();
    return dreamCount;
  }

  @override
  Future<int> dreamCount(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    final isar = await db;
    final int dreamCount =
        await isar.dreams.where().filter().dateGreaterThan(date).count();
    return dreamCount;
  }

  @override
  Future<Streak> currentStreak() async {
    int streak = 0;

    final isar = await db;
    List<DateTime?> dates = await isar.dreams
        .where(distinct: true)
        .sortByDateDesc()
        .dateProperty()
        .findAll();
    if (dates.isEmpty) {
      return Streak(
          streak: streak,
          streakStart: DateTime.now(),
          streakEnd: DateTime.now());
    }

    dates = dates
        .where((date) => date != null)
        .map((date) => DateTime(date!.year, date.month, date.day))
        .toSet()
        .toList();

    DateTime streakEnd = dates.last ?? DateTime.now();
    DateTime streakStart = dates.last ?? DateTime.now();

    for (int i = dates.length - 1; i >= 0; i--) {
      final currentDate = dates[i];
      final previousDate = dates[i - 1 != -1 ? i - 1 : i];
      if (currentDate == null || previousDate == null) continue;
      if (currentDate.day == previousDate.day &&
          currentDate.month == previousDate.month &&
          currentDate.year == previousDate.year) {
        continue;
      }

      final isNextDay = currentDate.difference(previousDate).inDays.abs() <= 1;
      if (isNextDay) {
        streak++;
        streakEnd = previousDate;
      } else {
        streak = 1;
        streakStart = previousDate;
        streakEnd = previousDate;
      }
    }
    return Streak(
        streak: streak, streakStart: streakStart, streakEnd: streakEnd);
  }

  @override
  Future<Streak> longestStreak() async {
    int streak = 0;
    final isar = await db;
    List<DateTime?> dates = await isar.dreams
        .where(distinct: true)
        .sortByDateDesc()
        .dateProperty()
        .findAll();
    if (dates.isEmpty) {
      return Streak(
          streak: streak,
          streakStart: DateTime.now(),
          streakEnd: DateTime.now());
    }

    dates = dates
        .where((date) => date != null)
        .map((date) => DateTime(date!.year, date.month, date.day))
        .toSet()
        .toList();

    DateTime streakEnd = dates.last ?? DateTime.now();
    DateTime streakStart = dates.last ?? DateTime.now();
    late DateTime currStreakEnd = DateTime.now();
    late DateTime currStreakStart = DateTime.now();

    int longestStreak = 0;

    for (int i = dates.length - 1; i >= 0; i--) {
      final currentDate = dates[i];
      final previousDate = dates[(i - 1 != -1) ? i - 1 : i];

      if (currentDate == null || previousDate == null) continue;

      final isNextDay = currentDate.difference(previousDate).inDays.abs() <= 1;

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

    return Streak(
        streak: longestStreak, streakStart: streakStart, streakEnd: streakEnd);
  }

  @override
  Future<int> charCount(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    final isar = await db;
    final descriptions = await isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .descriptionProperty()
        .findAll();
    final descCount = descriptions.isEmpty
        ? 0
        : descriptions
            .map((e) => e != "" ? e.length : 0)
            .reduce((value, element) => value + element);
    final titles = await isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .titleProperty()
        .findAll();
    final titleCount = titles.isEmpty
        ? 0
        : titles
            .map((e) => e != "" && e != null ? e.length : 0)
            .reduce((value, element) => value + element);
    return descCount + titleCount;
  }

  @override
  Future<int> wordCount(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    final isar = await db;
    final descriptions = await isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .descriptionProperty()
        .findAll();
    if (descriptions.isEmpty) return 0;
    final descCount = descriptions
        .map((e) => e.split(" ").where((e) => e != "").toList().length)
        .reduce((value, element) => value + element);
    final titles = await isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .titleProperty()
        .findAll();
    final titleCount = titles
        .map((e) =>
            e != null ? e.split(" ").where((e) => e != "").toList().length : 0)
        .reduce((value, element) => value + element);
    return descCount + titleCount;
  }

  @override
  Future<List<DateTime>> allDates({DateTime? start, DateTime? end}) async {
    final isar = await db;
    //TODO: next month
    final dates = await isar.dreams.buildQuery(
      property: "date",
      filter: FilterGroup.and([
        if (start != null && end != null)
          FilterCondition.greaterThan(property: 'date', value: start),
        if (start != null && end != null)
          FilterCondition.lessThan(property: 'date', value: end),
      ]),
      sortBy: [SortProperty(property: 'date', sort: Sort.asc)],
    ).findAll();

    return dates.cast<DateTime>();
  }

  @override
  Future<DateTime> firstDate() async {
    final isar = await db;
    final date =
        await isar.dreams.where().sortByDate().dateProperty().findFirst();
    return date ?? DateTime.now();
  }

  @override
  Future<DateTime> lastDate() async {
    final isar = await db;
    final date =
        await isar.dreams.where().sortByDateDesc().dateProperty().findFirst();
    return date ?? DateTime.now();
  }

  @override
  Future<List<Dream>> dreamsOnDate(DateTime date) async {
    final DateTime dayStart = DateTime(date.year, date.month, date.day);
    final DateTime dayEnd =
        DateTime(date.year, date.month, date.day, 23, 59, 59);

    final isar = await db;
    final dreams = await isar.dreams
        .where()
        .filter()
        .dateBetween(dayStart, dayEnd)
        .sortByDate()
        .findAll();
    return dreams;
  }

  @override
  Future<int?> mostActiveDotW(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    final isar = await db;
    final Map<int, int> daysOfTheWeek = {};

    await isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .dateProperty()
        .findAll()
        .then((dates) {
      // ignore: avoid_function_literals_in_foreach_calls
      dates.forEach(
          (e) => daysOfTheWeek[e!.weekday] = daysOfTheWeek[e.weekday] ?? 0 + 1);
    });

    final daysOfTheWeekList = daysOfTheWeek.entries.toList();
    if (daysOfTheWeekList.isEmpty) return null;
    daysOfTheWeekList.sort((a, b) => b.value.compareTo(a.value));

    return daysOfTheWeekList.first.key;
  }

  @override
  Future<List<DateTime>?> mostActiveTime(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    // TODO: implement mostActiveTime
    //TODO: 2h intervals ¿?
    throw UnimplementedError();
  }

  @override
  Future<Map<String, int>?> mostUsedNames(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    final isar = await db;
    final Map<String, int> allNames = {};

    await isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .namesProperty()
        .findAll()
        .then((dream) {
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

    return Map.fromEntries(namesList);
  }

  @override
  Future<Map<String, int>?> dreamLucidness(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    final Map<int, String> lucidnessMap = Consts().lucidness;
    final Map<String, int> map = {};

    final isar = await db;
    final List<int> lucidnesses = isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .lucidnessProperty()
        .findAllSync();

    for (var lucidness in lucidnesses) {
      final name = lucidnessMap[lucidness];
      if (name == null) {
        continue;
      }
      map[name] = (map[name] ?? 0) + 1;
    }
    return map;
  }

  @override
  Future<Map<String, int>?> dreamTypes(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    final Map<int, String> typesMap = Consts().types;
    final Map<String, int> map = {};

    final isar = await db;
    final List<int> types = isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .typeProperty()
        .findAllSync();

    for (var type in types) {
      final name = typesMap[type];
      if (name == null) {
        continue;
      }
      map[name] = (map[name] ?? 0) + 1;
    }
    return map;
  }

  @override
  Future<Map<String, int>?> dreamMood(int bracket) async {
    DateTime date = DateTime.now().subtract(Duration(days: bracket));
    final Map<int, String> moodsMap = Consts().mood;
    final Map<String, int> map = {};

    final isar = await db;
    final List<int> moods = isar.dreams
        .where()
        .filter()
        .dateGreaterThan(date)
        .moodProperty()
        .findAllSync();

    for (var mood in moods) {
      final name = moodsMap[mood];
      if (name == null) {
        continue;
      }
      map[name] = (map[name] ?? 0) + 1;
    }
    return map;
  }

  @override
  Future<String?> requestFile() async {
      final params = OpenFileDialogParams(
        dialogType: OpenFileDialogType.document,
        fileExtensionsFilter: ["json", "enc"],
        localOnly: true,
      );
    final filePath = await FlutterFileDialog.pickFile(params: params);
		return filePath;
  }
}
