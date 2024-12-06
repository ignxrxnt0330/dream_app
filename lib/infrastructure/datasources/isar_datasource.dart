import 'dart:io';

import 'package:dream_app/domain/datasource/local_storage_datasource.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    try {
      await _requestPermissions();
      final dir = await getApplicationDocumentsDirectory();
      if (Isar.instanceNames.isEmpty) {
        return Isar.open([DreamSchema], inspector: true, directory: dir.path);
      }
      return Future.value(Isar.getInstance());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        var result = await Permission.storage.request();
        if (!result.isGranted) {
          // Show a dialog to the user explaining why the permission is needed
          // and direct them to the app settings to manually enable the permission.
          // await openAppSettings();
          throw Exception("Storage permission denied");
        }
      }
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
  Future<void> saveDream(Dream dream) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.dreams.putSync(dream));
  }

  @override
  Future<void> toggleFavDream(int id) async {
    final isar = await db;
    final dream = await isar.dreams.filter().idEqualTo(id).findFirst();
    if (dream == null) return;
    saveDream(dream.copyWith(isFav: !dream.isFav));
  }

  @override
  Future<List<Dream>> loadDreams({int limit = 10, int offset = 0}) async {
    print("asdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasd");
    final isar = await db;
    final List<Dream> dreams = await isar.dreams.where().offset(offset).limit(limit).findAll();
    return dreams;
  }

  @override
  Future<List<Dream?>> loadFavoriteDreams({int limit = 10, int offset = 0}) async {
    final isar = await db;
    final List<Dream> dreams = await isar.dreams.where().filter().isFavEqualTo(true).offset(offset).limit(limit).findAll();
    return dreams;
  }
}
