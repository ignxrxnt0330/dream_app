import 'package:dream_app/domain/entities/dream/dream.dart';

abstract class LocalStorageDatasource {
  Future<int> saveDream(Dream dream);
  Future<void> deleteDream(int id);
  Future<List<Dream?>> loadDreams({int limit = 10, int offset = 0});
  Future<Dream?> getDream(int id);
  Future<void> toggleFavDream(int id);
  Future<List<Dream?>> loadFavoriteDreams({int limit = 10, int offset = 0});
  Future<List<Dream>> getAllDreams();
  Future<void> exportDreams();
}
