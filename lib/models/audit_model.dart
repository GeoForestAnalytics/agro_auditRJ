import 'package:isar/isar.dart';

part 'audit_model.g.dart';

@collection
class Project {
  Id id = Isar.autoIncrement;
  late String name;
  late DateTime createdAt;
  String? description;

  final assets = IsarLinks<AssetItem>();
  final properties = IsarLinks<PropertyItem>();
}

@collection
class AssetItem {
  Id id = Isar.autoIncrement;

  late String description;
  String? serialNumber;
  String? plate;
  late String category;
  
  String? municipality;
  String? state;

  @Enumerated(EnumType.ordinal)
  AuditStatus status = AuditStatus.pending;

  String? obsField;
  DateTime? auditDate;
  List<String>? photoPaths;
  double? auditLat;
  double? auditLong;

  @Backlink(to: 'assets')
  final project = IsarLink<Project>();
}

@collection
class PropertyItem {
  Id id = Isar.autoIncrement;

  late String name;
  late String matricula;
  late String city;
  String? state;
  double? referenceLat; 
  double? referenceLong;

  List<String>? dronePhotoPaths;

  @Enumerated(EnumType.ordinal)
  AuditStatus status = AuditStatus.pending;

  String? obsField;
  DateTime? auditDate;
  List<String>? photoPaths;
  
  // --- NOVOS CAMPOS PARA O GPS DA VISTORIA ---
  double? auditLat;  // <--- NOVO
  double? auditLong; // <--- NOVO
  // ------------------------------------------

  @Backlink(to: 'properties')
  final project = IsarLink<Project>();
}

enum AuditStatus { pending, found, notFound, seized }