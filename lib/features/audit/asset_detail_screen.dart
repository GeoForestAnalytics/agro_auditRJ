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
  late FinalidadeBem _finalidade;
  late NivelEssencialidade _essencialidade;
  late List<String> _photos;

  @override
  void initState() {
    super.initState();
    _obsController = TextEditingController(text: widget.item.obsField);
    _selectedStatus = widget.item.status;
    _finalidade = widget.item.finalidade;
    _essencialidade = widget.item.nivelEssencialidade;
    _photos = widget.item.photoPaths?.toList() ?? [];
  }

  Future<void> _save() async {
    widget.item.obsField = _obsController.text;
    widget.item.status = _selectedStatus;
    widget.item.finalidade = _finalidade;
    widget.item.nivelEssencialidade = _essencialidade;
    widget.item.photoPaths = _photos;

    await ref.read(auditRepositoryProvider).updateAsset(widget.item);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Coleta Técnica Salva!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ficha Técnica"),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("REGISTRO FOTOGRÁFICO", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
                      child: Container(width: 100, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add_a_photo)),
                    );
                  }
                  return Container(
                    width: 100, margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(_photos[i]), fit: BoxFit.cover)),
                  );
                },
              ),
            ),
            
            const Gap(30),
            Text(widget.item.description, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Número de Série: ${widget.item.serialNumber ?? 'N/A'}", style: const TextStyle(color: Colors.grey)),
            
            const Divider(height: 50),
            const Text("PARÂMETROS PARA ESSENCIALIDADE (HUB)", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
            const Gap(15),

            const Text("Finalidade do Bem na Unidade:"),
            DropdownButton<FinalidadeBem>(
              value: _finalidade,
              isExpanded: true,
              items: FinalidadeBem.values.map((f) => DropdownMenuItem(
                value: f, 
                child: Text(f.name.toUpperCase().replaceAll('TratosCulturais', 'TRATOS CULTURAIS')),
              )).toList(),
              onChanged: (val) => setState(() => _finalidade = val!),
            ),

            const Gap(20),

            const Text("Grau de Essencialidade Técnica:"),
            const Gap(8),
            SegmentedButton<NivelEssencialidade>(
              segments: const [
                ButtonSegment(value: NivelEssencialidade.maxima, label: Text("MÁXIMA")),
                ButtonSegment(value: NivelEssencialidade.media, label: Text("MÉDIA")),
                ButtonSegment(value: NivelEssencialidade.minima, label: Text("MÍNIMA")),
              ],
              selected: {_essencialidade},
              onSelectionChanged: (val) => setState(() => _essencialidade = val.first),
            ),

            const Gap(30),
            const Text("OBSERVAÇÕES DO PERITO", style: TextStyle(fontWeight: FontWeight.bold)),
            const Gap(8),
            TextField(
              controller: _obsController, 
              maxLines: 4, 
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Descreva o estado do ativo ou condições especiais...")
            ),
          ],
        ),
      ),
    );
  }
}