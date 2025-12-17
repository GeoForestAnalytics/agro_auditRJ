import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:agro_audit_rj/models/audit_model.dart'; // Importa seus modelos

class LocalDB {
  static late Isar _isar;

  // Inicializa o banco ao abrir o app
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    // Abre o banco com os Esquemas (Schemas) gerados pelo Isar
    _isar = await Isar.open(
      [ProjectSchema, AssetItemSchema, PropertyItemSchema],
      directory: dir.path,
    );
  }

  // Atalho para acessar o banco de qualquer lugar do app
  static Isar get instance => _isar;
}
