import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/features/audit/camera_capture_screen.dart'; // Import da câmera
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
  late List<String> _photos; // Lista local para gerenciar na tela

  @override
  void initState() {
    super.initState();
    _obsController = TextEditingController(text: widget.item.obsField);
    _selectedStatus = widget.item.status;
    _photos = widget.item.photoPaths?.toList() ?? [];
  }

  Future<void> _saveChanges() async {
    final isar = LocalDB.instance;
    await isar.writeTxn(() async {
      widget.item.status = _selectedStatus;
      widget.item.obsField = _obsController.text;
      widget.item.photoPaths = _photos; // Salva a lista de fotos atualizada
      await isar.assetItems.put(widget.item);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Salvo!")));
      Navigator.pop(context);
    }
  }

  // Função para tirar NOVA foto
  Future<void> _addPhoto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraCaptureScreen(assetName: widget.item.description))
    );

    if (result != null && result is Map) {
      setState(() {
        _photos.add(result['path']); // Adiciona na lista visual
        // Se ainda estava pendente, muda pra encontrado
        if (_selectedStatus == AuditStatus.pending) {
          _selectedStatus = AuditStatus.found; 
        }
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Bem"),
        actions: [
          IconButton(icon: const Icon(Icons.check, color: Colors.white), onPressed: _saveChanges),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GALERIA DE FOTOS ---
            const Text("Evidências Fotográficas", style: TextStyle(fontWeight: FontWeight.bold)),
            const Gap(10),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length + 1, // +1 para o botão de adicionar
                itemBuilder: (context, index) {
                  // Botão de Adicionar (Último item)
                  if (index == _photos.length) {
                    return GestureDetector(
                      onTap: _addPhoto,
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.add_a_photo, size: 30), Text("Adicionar")],
                        ),
                      ),
                    );
                  }

                  // Card da Foto
                  return Stack(
                    children: [
                      Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(_photos[index]), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: 15, top: 5,
                        child: InkWell(
                          onTap: () => _removePhoto(index),
                          child: const CircleAvatar(backgroundColor: Colors.red, radius: 10, child: Icon(Icons.close, size: 12, color: Colors.white)),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),

            const Gap(20),
            Text(widget.item.description, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Série: ${widget.item.serialNumber ?? '-'}", style: const TextStyle(color: Colors.grey)),
            
            const Gap(24),
            const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: AuditStatus.values.map((s) {
                return ChoiceChip(
                  label: Text(_statusLabel(s)),
                  selected: _selectedStatus == s,
                  onSelected: (v) => setState(() => _selectedStatus = s),
                  selectedColor: _statusColor(s).withOpacity(0.3),
                );
              }).toList(),
            ),

            const Gap(24),
            const Text("Observações", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _obsController, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder())),
          ],
        ),
      ),
    );
  }

  String _statusLabel(AuditStatus s) => s.toString().split('.').last.toUpperCase();
  Color _statusColor(AuditStatus s) => s == AuditStatus.found ? Colors.green : Colors.orange;
}