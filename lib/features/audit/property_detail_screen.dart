import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Adicionado
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/providers/audit_providers.dart'; // Adicionado
import 'package:agro_audit_rj/features/audit/camera_capture_screen.dart';
import 'package:gap/gap.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget { // Trocado para Consumer
  final PropertyItem item;
  const PropertyDetailScreen({super.key, required this.item});

  @override
  ConsumerState<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  late TextEditingController _obsController;
  late AuditStatus _selectedStatus;
  late List<String> _photos;

  @override
  void initState() {
    super.initState();
    _obsController = TextEditingController(text: widget.item.obsField);
    _selectedStatus = widget.item.status;
    _photos = widget.item.photoPaths?.toList() ?? [];
  }

  Future<void> _saveChanges() async {
    widget.item.status = _selectedStatus;
    widget.item.obsField = _obsController.text;
    widget.item.photoPaths = _photos;
    
    // Usando o repositório para salvar (Padrão Riverpod)
    await ref.read(auditRepositoryProvider).updateProperty(widget.item);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fazenda Atualizada!")));
      Navigator.pop(context);
    }
  }

  Future<void> _addPhoto() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => CameraCaptureScreen(assetName: widget.item.name))
    );
    if (result != null && result is Map) {
      setState(() {
        _photos.add(result['path']);
        if (_selectedStatus == AuditStatus.pending) _selectedStatus = AuditStatus.found;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Propriedade"),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _saveChanges)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Vistoria Local (Chão)", style: TextStyle(fontWeight: FontWeight.bold)),
            const Gap(10),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length + 1,
                itemBuilder: (context, index) {
                  if (index == _photos.length) {
                    return GestureDetector(
                      onTap: _addPhoto,
                      child: Container(
                        width: 100, margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo), Text("Adicionar")]),
                      ),
                    );
                  }
                  return Container(
                    width: 140, margin: const EdgeInsets.only(right: 10),
                    child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(_photos[index]), fit: BoxFit.cover)),
                  );
                },
              ),
            ),
            if (widget.item.dronePhotoPaths != null && widget.item.dronePhotoPaths!.isNotEmpty) ...[
              const Gap(20),
              const Text("Imagens de Drone", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              const Gap(10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.item.dronePhotoPaths!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100, margin: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(widget.item.dronePhotoPaths![index]), fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
            ],
            const Gap(20),
            Text(widget.item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Gap(20),
            const Text("Observações Agrícolas", style: TextStyle(fontWeight: FontWeight.bold)),
            const Gap(8),
            TextField(controller: _obsController, maxLines: 5, decoration: const InputDecoration(border: OutlineInputBorder())),
          ],
        ),
      ),
    );
  }
}