import 'package:isar/isar.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/models/audit_model.dart';

class AuditRepository {
  final isar = LocalDB.instance;

  // Streams Reativos
  Stream<List<AssetItem>> watchAssets(int projectId) {
    return isar.assetItems
        .filter()
        .project((q) => q.idEqualTo(projectId))
        .watch(fireImmediately: true);
  }

  Stream<List<PropertyItem>> watchProperties(int projectId) {
    return isar.propertyItems
        .filter()
        .project((q) => q.idEqualTo(projectId))
        .watch(fireImmediately: true);
  }

  // Escrita em Lote (Alta Performance)
  Future<void> saveAssets(List<AssetItem> items, Project project) async {
    await isar.writeTxn(() async {
      await isar.assetItems.putAll(items);
      for (var item in items) {
        item.project.value = project;
      }
      await project.assets.save();
    });
  }

  Future<void> saveProperties(List<PropertyItem> items, Project project) async {
    await isar.writeTxn(() async {
      await isar.propertyItems.putAll(items);
      for (var item in items) {
        item.project.value = project;
      }
      await project.properties.save();
    });
  }
}