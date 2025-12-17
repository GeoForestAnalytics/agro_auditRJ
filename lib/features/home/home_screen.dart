import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:gap/gap.dart';
// IMPORTANTE: Use o nome do seu projeto aqui
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/models/audit_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Função para criar um novo projeto
  void _createNewProject() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Projeto de Auditoria'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Nome do Cliente / Grupo',
            hintText: 'Ex: Grupo Garcia',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                // 1. Cria o objeto
                final newProject = Project()
                  ..name = textController.text
                  ..createdAt = DateTime.now();

                // 2. Salva no Banco (Isar)
                final isar = LocalDB.instance;
                await isar.writeTxn(() async {
                  await isar.projects.put(newProject);
                });

                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agro Audit RJ'),
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder<List<Project>>(
        // O segredo: Isso aqui fica vigiando o banco de dados em tempo real
        stream: LocalDB.instance.projects
            .where()
            .sortByName()
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final projects = snapshot.data!;

          if (projects.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  Gap(16),
                  Text(
                    'Nenhum projeto ainda.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text('Clique no + para começar.'),
                ],
              ),
            );
          }

          // Lista de Projetos
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
                    backgroundColor: Color(0xFF2E7D32), // Verde Agro
                    child: Icon(Icons.agriculture, color: Colors.white),
                  ),
                  title: Text(
                    project.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Criado em: ${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Aqui vamos navegar para a tela de detalhes depois
                    print('Clicou no projeto: ${project.name}');
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewProject,
        label: const Text('Novo Projeto'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
    );
  }
}
