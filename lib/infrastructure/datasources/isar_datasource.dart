import 'package:dream_app/domain/datasource/local_storage_datasource.dart';
import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:isar/isar.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

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
