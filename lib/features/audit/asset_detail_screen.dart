import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:gap/gap.dart';

class AssetDetailScreen extends StatefulWidget {
  final AssetItem item;
  const AssetDetailScreen({super.key, required this.item});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  late TextEditingController _obsController;
  late AuditStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _obsController = TextEditingController(text: widget.item.obsField);
    _selectedStatus = widget.item.status;
  }

  // === FUNÇÃO: SALVAR ALTERAÇÕES ===
  Future<void> _saveChanges() async {
    final isar = LocalDB.instance;
    await isar.writeTxn(() async {
      widget.item.status = _selectedStatus;
      widget.item.obsField = _obsController.text;
      await isar.assetItems.put(widget.item);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alterações salvas com sucesso!")),
      );
      Navigator.pop(context);
    }
  }

  // === FUNÇÃO: EXCLUIR ESTE ITEM (Caso importe errado) ===
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir item?"),
        content: const Text("Deseja apagar este item permanentemente da lista?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              final isar = LocalDB.instance;
              await isar.writeTxn(() async {
                await isar.assetItems.delete(widget.item.id);
              });
              if (mounted) {
                Navigator.pop(context); // Fecha o alerta
                Navigator.pop(context); // Volta para a lista
              }
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Bem"),
        actions: [
          // Botão para excluir o item
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _confirmDelete,
            tooltip: "Excluir item",
          ),
          // Botão para salvar
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _saveChanges,
            tooltip: "Salvar",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview da Imagem
            if (widget.item.photoPaths != null && widget.item.photoPaths!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(widget.item.photoPaths!.first),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),

            const Gap(20),
            Text(widget.item.description, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Cidade: ${widget.item.municipality} - ${widget.item.state}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            
            const Gap(24),
            const Text("Status da Auditoria", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Gap(12),
            
            // Seletor de Status (ChoiceChips para não cortar texto)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AuditStatus.values.map((status) {
                final isSelected = _selectedStatus == status;
                return ChoiceChip(
                  label: Text(_translateStatus(status)),
                  selected: isSelected,
                  onSelected: (val) => setState(() => _selectedStatus = status),
                  selectedColor: _getStatusColor(status).withOpacity(0.3),
                  checkmarkColor: _getStatusColor(status),
                );
              }).toList(),
            ),

            const Gap(24),
            const Text("Observações Técnicas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Gap(8),
            TextField(
              controller: _obsController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Descreva o estado do item...",
                border: OutlineInputBorder(),
              ),
            ),

            const Gap(24),
            // Dados Geográficos
            if (widget.item.auditLat != null)
              Card(
                elevation: 0,
                color: Colors.green[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green),
                  title: const Text("Localização da Captura"),
                  subtitle: Text("Lat: ${widget.item.auditLat}\nLong: ${widget.item.auditLong}"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Traduções para evitar textos cortados ou confusos
  String _translateStatus(AuditStatus s) {
    switch (s) {
      case AuditStatus.pending: return "Pendente";
      case AuditStatus.found: return "Encontrado";
      case AuditStatus.notFound: return "Não Localizado";
      case AuditStatus.seized: return "Apreendido";
    }
  }

  Color _getStatusColor(AuditStatus s) {
    switch (s) {
      case AuditStatus.pending: return Colors.grey;
      case AuditStatus.found: return Colors.green;
      case AuditStatus.notFound: return Colors.red;
      case AuditStatus.seized: return Colors.orange;
    }
  }
}