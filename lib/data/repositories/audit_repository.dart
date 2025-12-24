import 'package:isar/isar.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/models/audit_model.dart';

class AuditRepository {
  final isar = LocalDB.instance;

  // Streams para UI Reativa
  Stream<List<Project>> watchProjects() {
    return isar.projects.where().sortByName().watch(fireImmediately: true);
  }

  Stream<List<AssetItem>> watchAssets(int projectId) {
    return isar.assetItems
        .filter().project((q) => q.idEqualTo(projectId))
        .watch(fireImmediately: true);
  }

  Stream<List<PropertyItem>> watchProperties(int projectId) {
    return isar.propertyItems
        .filter().project((q) => q.idEqualTo(projectId))
        .watch(fireImmediately: true);
  }

  // Métodos Sync para o Relatório
  Future<List<AssetItem>> getAssetsSync(int projectId) async {
    return await isar.assetItems
        .filter().project((q) => q.idEqualTo(projectId))
        .findAll();
  }

  Future<List<PropertyItem>> getPropertiesSync(int projectId) async {
    return await isar.propertyItems
        .filter().project((q) => q.idEqualTo(projectId))
        .findAll();
  }

  // Salvamento em Lote
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