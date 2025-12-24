import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_audit_rj/data/providers/audit_providers.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/features/audit/audit_screen.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:isar/isar.dart';
import 'package:gap/gap.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showProjectDialog(BuildContext context, {Project? project}) {
    final textController = TextEditingController(text: project?.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project == null ? 'Novo Projeto' : 'Editar Projeto'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Nome do Cliente / Grupo', 
            border: OutlineInputBorder()
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                final isar = LocalDB.instance;
                await isar.writeTxn(() async {
                  if (project == null) {
                    final newProject = Project()
                      ..name = textController.text
                      ..createdAt = DateTime.now();
                    await isar.projects.put(newProject);
                  } else {
                    project.name = textController.text;
                    await isar.projects.put(project);
                  }
                });
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Projeto?'),
        content: Text('Isso apagará tudo de "${project.name}". Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final isar = LocalDB.instance;
              await isar.writeTxn(() async {
                await isar.assetItems.filter().project((q) => q.idEqualTo(project.id)).deleteAll();
                await isar.propertyItems.filter().project((q) => q.idEqualTo(project.id)).deleteAll();
                await isar.projects.delete(project.id);
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Agro Audit RJ'), centerTitle: true),
      body: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Erro: $err")),
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(child: Text('Nenhum projeto ainda. Clique no +'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return _ProjectCard(
                project: project,
                onEdit: () => _showProjectDialog(context, project: project),
                onDelete: () => _confirmDelete(context, project),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProjectDialog(context),
        label: const Text('Novo Projeto'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
    );
  }
}

/// Widget interno para o Card de Projeto com barra de progresso reativa
class _ProjectCard extends ConsumerWidget {
  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuta apenas os bens deste projeto para calcular o progresso
    final assetsAsync = ref.watch(assetsStreamProvider(project.id));

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (ctx) => AuditScreen(project: project))
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF2E7D32),
                    child: Icon(Icons.agriculture, color: Colors.white),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                        Text(
                          'Criado em: ${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    onSelected: (val) {
                      if (val == 'edit') onEdit();
                      if (val == 'delete') onDelete();
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: 'edit', child: Text('Editar Nome')),
                      const PopupMenuItem(
                        value: 'delete', 
                        child: Text('Excluir Tudo', style: TextStyle(color: Colors.red))
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(16),
              
              // SEÇÃO DE PROGRESSO (DASHBOARD)
              assetsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
                data: (assets) {
                  if (assets.isEmpty) {
                    return const Text("Nenhum bem importado", style: TextStyle(fontSize: 12, color: Colors.grey));
                  }

                  final total = assets.length;
                  final localizado = assets.where((a) => a.status == AuditStatus.localizado).length;
                  final progress = total > 0 ? localizado / total : 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Progresso da Coleta", 
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[700])
                          ),
                          Text(
                            "$localizado / $total itens", 
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))
                          ),
                        ],
                      ),
                      const Gap(6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          color: progress == 1.0 ? Colors.blue : const Color(0xFF2E7D32),
                          minHeight: 8,
                        ),
                      ),
                      if (progress == 1.0)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text("✅ Coleta de campo concluída!", style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}