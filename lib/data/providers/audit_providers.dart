import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_audit_rj/data/repositories/audit_repository.dart';
import 'package:agro_audit_rj/models/audit_model.dart';

final auditRepositoryProvider = Provider((ref) => AuditRepository());

// Provider para a lista de projetos da Home
final projectsStreamProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(auditRepositoryProvider).watchProjects();
});

// Providers para itens de um projeto específico
final assetsStreamProvider = StreamProvider.family<List<AssetItem>, int>((ref, projectId) {
  return ref.watch(auditRepositoryProvider).watchAssets(projectId);
});

final propertiesStreamProvider = StreamProvider.family<List<PropertyItem>, int>((ref, projectId) {
  return ref.watch(auditRepositoryProvider).watchProperties(projectId);
});