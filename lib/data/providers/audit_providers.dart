import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_audit_rj/data/repositories/audit_repository.dart';
import 'package:agro_audit_rj/models/audit_model.dart';

// Provider do Repositório (Simples)
final auditRepositoryProvider = Provider((ref) => AuditRepository());

// StreamProvider para Bens (Assets) - Ele atualiza a tela automaticamente quando o banco muda
final assetsStreamProvider = StreamProvider.family<List<AssetItem>, int>((ref, projectId) {
  final repository = ref.watch(auditRepositoryProvider);
  return repository.watchAssets(projectId);
});

// StreamProvider para Fazendas (Properties)
final propertiesStreamProvider = StreamProvider.family<List<PropertyItem>, int>((ref, projectId) {
  final repository = ref.watch(auditRepositoryProvider);
  return repository.watchProperties(projectId);
});