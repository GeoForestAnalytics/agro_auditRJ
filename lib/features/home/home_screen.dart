import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/features/audit/audit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // Função para Criar ou Editar Projeto
  void _showProjectDialog({Project? project}) {
    final textController = TextEditingController(text: project?.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project == null ? 'Novo Projeto' : 'Editar Projeto'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Nome do Cliente / Grupo',
            border: OutlineInputBorder(),
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
                    // Novo
                    final newProject = Project()
                      ..name = textController.text
                      ..createdAt = DateTime.now();
                    await isar.projects.put(newProject);
                  } else {
                    // Editar
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

  // Função para Excluir Projeto e seus itens (Cascata)
  void _confirmDelete(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Projeto?'),
        content: Text('Isso apagará todos os tratores e fazendas de "${project.name}". Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final isar = LocalDB.instance;
              await isar.writeTxn(() async {
                // Apaga os itens vinculados primeiro para limpar o banco
                await isar.assetItems.filter().project((q) => q.idEqualTo(project.id)).deleteAll();
                await isar.propertyItems.filter().project((q) => q.idEqualTo(project.id)).deleteAll();
                // Apaga o projeto
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agro Audit RJ'), centerTitle: true),
      body: StreamBuilder<List<Project>>(
        stream: LocalDB.instance.projects.where().sortByName().watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final projects = snapshot.data!;

          if (projects.isEmpty) {
            return const Center(child: Text('Nenhum projeto ainda. Clique no +'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF2E7D32),
                    child: Icon(Icons.agriculture, color: Colors.white),
                  ),
                  title: Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Criado em: ${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}'),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Editar Nome')),
                      const PopupMenuItem(value: 'delete', child: Text('Excluir Tudo', style: TextStyle(color: Colors.red))),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') _showProjectDialog(project: project);
                      if (value == 'delete') _confirmDelete(project);
                    },
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AuditScreen(project: project)));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProjectDialog(),
        label: const Text('Novo Projeto'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
    );
  }
}