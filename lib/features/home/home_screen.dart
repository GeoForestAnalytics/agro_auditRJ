import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_audit_rj/data/providers/audit_providers.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/features/audit/audit_screen.dart'; // Import da tela real
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:isar/isar.dart';

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
          decoration: const InputDecoration(labelText: 'Nome do Cliente / Grupo', border: OutlineInputBorder()),
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
                    final newProject = Project()..name = textController.text..createdAt = DateTime.now();
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
        content: Text('Isso apagará tudo de "${project.name}".'),
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
          if (projects.isEmpty) return const Center(child: Text('Nenhum projeto ainda. Clique no +'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Color(0xFF2E7D32), child: Icon(Icons.agriculture, color: Colors.white)),
                  title: Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Criado em: ${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}'),
                  trailing: PopupMenuButton(
                    onSelected: (val) {
                      if (val == 'edit') _showProjectDialog(context, project: project);
                      if (val == 'delete') _confirmDelete(context, project);
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                      const PopupMenuItem(value: 'delete', child: Text('Excluir', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => AuditScreen(project: project))),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProjectDialog(context),
        label: const Text('Novo Projeto'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}