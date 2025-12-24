import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/providers/audit_providers.dart';
import 'package:agro_audit_rj/features/audit/camera_capture_screen.dart';
import 'package:gap/gap.dart';

class AssetDetailScreen extends ConsumerStatefulWidget {
  final AssetItem item;
  const AssetDetailScreen({super.key, required this.item});

  @override
  ConsumerState<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends ConsumerState<AssetDetailScreen> {
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

  Future<void> _save() async {
    widget.item.obsField = _obsController.text;
    widget.item.status = _selectedStatus;
    widget.item.photoPaths = _photos;
    await ref.read(auditRepositoryProvider).updateAsset(widget.item);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Atualizado com sucesso!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vistoria do Bem"),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Evidências", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Gap(10),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length + 1,
                itemBuilder: (ctx, i) {
                  if (i == _photos.length) {
                    return GestureDetector(
                      onTap: () async {
                        final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => CameraCaptureScreen(assetName: widget.item.description)));
                        if (res != null) setState(() => _photos.add(res['path']));
                      },
                      child: Container(width: 100, color: Colors.grey[200], child: const Icon(Icons.add_a_photo)),
                    );
                  }
                  return Container(
                    width: 100, 
                    margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(_photos[i]), fit: BoxFit.cover)),
                  );
                },
              ),
            ),
            const Gap(20),
            Text(widget.item.description, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Série: ${widget.item.serialNumber ?? 'N/A'}", style: const TextStyle(color: Colors.grey)),
            const Gap(20),
            const Text("Status da Auditoria", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: AuditStatus.values.map((s) => ChoiceChip(
                label: Text(s.name.toUpperCase()),
                selected: _selectedStatus == s,
                onSelected: (val) => setState(() => _selectedStatus = s),
              )).toList(),
            ),
            const Gap(20),
            const Text("Observações Técnicas", style: TextStyle(fontWeight: FontWeight.bold)),
            const Gap(8),
            TextField(controller: _obsController, maxLines: 4, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Descreva o estado do bem...")),
          ],
        ),
      ),
    );
  }
}