import 'package:isar/isar.dart';

part 'audit_model.g.dart';

// Finalidades para o HUB de inteligência
enum FinalidadeBem { preparoSolo, plantio, colheita, logistica, manutencao, tratosCulturais, pecuaria }
enum NivelEssencialidade { maxima, media, minima }
enum AuditStatus { pendente, localizado, naoLocalizado, apreendido }

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
  AuditStatus status = AuditStatus.pendente;

  // --- NOVOS CAMPOS PARA O HUB ---
  @Enumerated(EnumType.ordinal)
  FinalidadeBem finalidade = FinalidadeBem.logistica;

  @Enumerated(EnumType.ordinal)
  NivelEssencialidade nivelEssencialidade = NivelEssencialidade.maxima;
  // -------------------------------

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

  // Tipologia para essencialidade no HUB
  String tipologia = "Produção Ativa"; 

  @Enumerated(EnumType.ordinal)
  AuditStatus status = AuditStatus.pendente;

  String? obsField;
  DateTime? auditDate;
  List<String>? photoPaths;
  
  double? auditLat;
  double? auditLong;

  @Backlink(to: 'properties')
  final project = IsarLink<Project>();
}