import 'package:isar/isar.dart';

part 'audit_model.g.dart';

// 1. Definições de finalidade para a "inteligência" do Hub (Nomes em PT-BR)
enum FinalidadeBem { 
  preparoSolo, 
  plantio, 
  colheita, 
  logistica, 
  manutencao, 
  tratosCulturais, 
  pecuaria 
}

enum NivelEssencialidade { 
  maxima, 
  media, 
  minima 
}

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

  // --- NOVOS CAMPOS PARA O HUB DE ESSENCIALIDADE (EM PORTUGUÊS) ---
  @Enumerated(EnumType.ordinal)
  FinalidadeBem finalidade = FinalidadeBem.logistica;

  @Enumerated(EnumType.ordinal)
  NivelEssencialidade nivelEssencialidade = NivelEssencialidade.maxima;

  String? obsField; // Detalhes sobre o estado de conservação
  // ----------------------------------------------------------------

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

  // Tipologia da Fazenda para o Hub (Sede, Produção, Logística, etc)
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

enum AuditStatus { pendente, localizado, naolocalizado, apreendido }