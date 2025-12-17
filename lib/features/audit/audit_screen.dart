import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:file_picker/file_picker.dart'; // Para pegar o arquivo
import 'package:excel/excel.dart'; // Para ler o Excel
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/local_db.dart';

class AuditScreen extends StatefulWidget {
  final Project project;

  const AuditScreen({super.key, required this.project});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false; // Para mostrar o "carregando"

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // --- FUNÇÃO DE IMPORTAR EXCEL ---
  Future<void> _importExcel() async {
    try {
      // 1. Abre o seletor de arquivos do celular
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'], // Só aceita Excel
      );

      if (result != null) {
        setState(() => _isLoading = true);

        // 2. Lê os bytes do arquivo
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        final isar = LocalDB.instance;
        int count = 0;

        // 3. Abre transação no Banco
        await isar.writeTxn(() async {
          // Pega a primeira aba da planilha
          final sheet = excel.tables[excel.tables.keys.first];
          
          if (sheet != null) {
            // Pula a primeira linha (cabeçalho) e lê o resto
            for (var i = 1; i < sheet.rows.length; i++) {
              var row = sheet.rows[i];
              
              // Garante que a linha não está vazia
              if (row.isEmpty) continue;

              // --- CORREÇÃO AQUI ---
              // Usamos o operador "??" para garantir que nunca seja nulo
              
              // 1. Descrição (Obrigatória)
              final descricao = row[0]?.value?.toString() ?? 'Sem Descrição';
              
              // 2. Série (Pode ser nulo, mas convertemos pra String vazia se der erro)
              final serie = (row.length > 1 ? row[1]?.value?.toString() : null) ?? '';
              
              // 3. Placa
              final placa = (row.length > 2 ? row[2]?.value?.toString() : null) ?? '';
              
              // 4. Categoria (Obrigatória - O erro estava aqui)
              // Se a célula for nula ou não existir, assume 'Geral'
              final categoria = (row.length > 3 ? row[3]?.value?.toString() : null) ?? 'Geral';

              final newItem = AssetItem()
                ..description = descricao
                ..serialNumber = serie
                ..plate = placa
                ..category = categoria
                ..status = AuditStatus.pending;

              // Salva no banco
              await isar.assetItems.put(newItem);
              
              // Vincula ao Projeto atual
              widget.project.assets.add(newItem);
            }
            // Salva o vínculo
            await widget.project.assets.save();
          }
        });

        setState(() => _isLoading = false);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Importação concluída com sucesso!')),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Erro ao importar: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao ler arquivo: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.project.name, style: const TextStyle(fontSize: 18)),
            const Text('Auditoria em andamento', style: TextStyle(fontSize: 12)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.agriculture), text: 'Bens'),
            Tab(icon: Icon(Icons.landscape), text: 'Propriedades'),
          ],
        ),
        actions: [
          // Botão de Importar no topo
          if (_isLoading)
            const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: Colors.white))
          else
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: _importExcel,
              tooltip: "Importar Excel",
            ),
        ],
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ABA 1: LISTA DE BENS (Conectada ao Banco)
          _buildAssetsList(),
          
          // ABA 2: LISTA DE PROPRIEDADES (Futuro)
          const Center(child: Text('Em breve: Importação de Propriedades')),
        ],
      ),
    );
  }

  Widget _buildAssetsList() {
    // Escuta as mudanças nos itens deste projeto específico
    return StreamBuilder<void>(
      stream: widget.project.assets.filter().findAll().asStream(), // Gatilho simples
      builder: (context, _) {
        // Carrega os itens atualizados
        final assets = widget.project.assets.toList();

        if (assets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.list_alt, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Nenhum bem importado ainda.'),
                TextButton.icon(
                  onPressed: _importExcel, 
                  icon: const Icon(Icons.upload), 
                  label: const Text('Importar Planilha')
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: assets.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final item = assets[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(item.status),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
              title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Série: ${item.serialNumber ?? '-'} | Placa: ${item.plate ?? '-'}'),
              trailing: const Icon(Icons.camera_alt_outlined),
              onTap: () {
                // Aqui vamos abrir a CÂMERA futuramente
                print('Clicou no item: ${item.description}');
              },
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(AuditStatus status) {
    switch (status) {
      case AuditStatus.pending: return Colors.grey;
      case AuditStatus.found: return Colors.green;
      case AuditStatus.notFound: return Colors.red;
      case AuditStatus.seized: return Colors.orange;
    }
  }
}