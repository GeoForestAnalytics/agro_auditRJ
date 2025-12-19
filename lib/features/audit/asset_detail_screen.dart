// lib/features/audit/asset_detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/features/audit/camera_capture_screen.dart';
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
  late List<String> _photos;

  @override
  void initState() {
    super.initState();
    _obsController = TextEditingController(text: widget.item.obsField);
    _selectedStatus = widget.item.status;
    // Carrega lista existente ou inicia vazia
    _photos = widget.item.photoPaths?.toList() ?? [];
  }

  Future<void> _saveChanges() async {
    final isar = LocalDB.instance;
    await isar.writeTxn(() async {
      widget.item.status = _selectedStatus;
      widget.item.obsField = _obsController.text;
      widget.item.photoPaths = _photos; // Salva a lista completa
      await isar.assetItems.put(widget.item);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Salvo com sucesso!")));
      Navigator.pop(context);
    }
  }

  Future<void> _addPhoto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraCaptureScreen(assetName: widget.item.description))
    );

    if (result != null && result is Map) {
      setState(() {
        _photos.add(result['path']); // Adiciona na lista visual
        
        // Atualiza GPS se for a primeira foto ou se quiser atualizar sempre
        if (result['lat'] != 0.0) {
           widget.item.auditLat = result['lat'];
           widget.item.auditLong = result['long'];
        }

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
            const Text("Evidências Fotográficas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Gap(10),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length + 1,
                itemBuilder: (context, index) {
                  // Botão Adicionar
                  if (index == _photos.length) {
                    return GestureDetector(
                      onTap: _addPhoto,
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.add_a_photo, color: Colors.black54), Text("Adicionar")],
                        ),
                      ),
                    );
                  }
                  // Foto
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
                          child: const CircleAvatar(backgroundColor: Colors.red, radius: 12, child: Icon(Icons.close, size: 14, color: Colors.white)),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),

            const Gap(20),
            Text(widget.item.description, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Série: ${widget.item.serialNumber ?? 'N/A'}", style: const TextStyle(color: Colors.grey, fontSize: 16)),
            
            const Gap(24),
            const Text("Status da Auditoria", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Gap(8),
            Wrap(
              spacing: 8,
              children: AuditStatus.values.map((s) {
                return ChoiceChip(
                  label: Text(_statusLabel(s)), // Usa a tradução correta agora
                  selected: _selectedStatus == s,
                  onSelected: (v) => setState(() => _selectedStatus = s),
                  selectedColor: _statusColor(s).withOpacity(0.3),
                  labelStyle: TextStyle(color: _selectedStatus == s ? Colors.black : Colors.grey),
                );
              }).toList(),
            ),

            const Gap(24),
            const Text("Observações", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Gap(8),
            TextField(
              controller: _obsController, 
              maxLines: 3, 
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Escreva detalhes sobre o estado de conservação...")
            ),

            const Gap(24),
            // DADOS DE GPS
            if (widget.item.auditLat != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100)
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Localização Capturada:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Lat: ${widget.item.auditLat}"),
                        Text("Long: ${widget.item.auditLong}"),
                      ],
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  // TRADUÇÃO CORRIGIDA (PORTUGUÊS)
  String _statusLabel(AuditStatus s) {
    switch (s) {
      case AuditStatus.pending: return "Pendente";
      case AuditStatus.found: return "Encontrado";
      case AuditStatus.notFound: return "Não Localizado";
      case AuditStatus.seized: return "Apreendido";
    }
  }

  Color _statusColor(AuditStatus s) {
    switch (s) {
      case AuditStatus.found: return Colors.green;
      case AuditStatus.notFound: return Colors.orange;
      case AuditStatus.seized: return Colors.red;
      default: return Colors.grey;
    }
  }
}
