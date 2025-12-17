import 'package:isar/isar.dart';

// O arquivo .g.dart será gerado automaticamente depois
part 'audit_model.g.dart';

@collection
class Project {
  Id id = Isar.autoIncrement;

  late String name; // Ex: "Grupo Garcia"
  late DateTime createdAt;
  String? description;

  // Um projeto tem vários itens de maquinário
  final assets = IsarLinks<AssetItem>();

  // Um projeto tem várias propriedades (fazendas)
  final properties = IsarLinks<PropertyItem>();
}

@collection
class AssetItem {
  Id id = Isar.autoIncrement;

  // --- Dados do Excel ---
  late String description; // "Trator John Deere"
  String? serialNumber; // "CTP 4965..."
  String? plate; // "ABC-1234"
  late String category; // "Maquinário"

  // --- Dados da Auditoria ---
  @Enumerated(EnumType.ordinal)
  AuditStatus status = AuditStatus.pending;

  String? obsField;
  DateTime? auditDate;

  // Caminhos das fotos no celular
  List<String>? photoPaths;

  // Onde foi encontrado
  double? auditLat;
  double? auditLong;
}

@collection
class PropertyItem {
  Id id = Isar.autoIncrement;

  late String name; // "Fazenda Cedral"
  late String matricula; // "906"
  late String city;

  // Ponto de referência para o match do drone
  double? referenceLat;
  double? referenceLong;

  List<String>? dronePhotoPaths;
}

enum AuditStatus {
  pending, // Pendente
  found, // Encontrado
  notFound, // Não Encontrado
  seized, // Apreendido
}
