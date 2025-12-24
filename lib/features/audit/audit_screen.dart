import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/providers/audit_providers.dart';
import 'package:agro_audit_rj/features/audit/camera_capture_screen.dart';
import 'package:agro_audit_rj/features/audit/asset_detail_screen.dart';
import 'package:agro_audit_rj/features/audit/property_detail_screen.dart';
import 'package:agro_audit_rj/core/services/report_service.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:isar/isar.dart';

class AuditScreen extends ConsumerStatefulWidget {
  final Project project;
  const AuditScreen({super.key, required this.project});

  @override
  ConsumerState<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends ConsumerState<AuditScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _exportReport() async {
    setState(() => _isGenerating = true);
    try {
      final repo = ref.read(auditRepositoryProvider);
      // Busca dados via Repository para o laudo
      final assets = await repo.getAssetsSync(widget.project.id);
      final properties = await repo.getPropertiesSync(widget.project.id);
      
      await ReportService.generateProjectReport(widget.project, assets, properties);
    } catch (e) {
      debugPrint("Erro no Relatório: $e");
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          if (_isGenerating)
            const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: Colors.white))
          else
            IconButton(
              icon: const Icon(Icons.picture_as_pdf), 
              onPressed: _exportReport,
              tooltip: "Gerar Relatório",
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Bens'), Tab(text: 'Fazendas')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AssetsTab(projectId: widget.project.id),
          _PropertiesTab(projectId: widget.project.id),
        ],
      ),
    );
  }
}

class _AssetsTab extends ConsumerWidget {
  final int projectId;
  const _AssetsTab({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetsStreamProvider(projectId));

    return assetsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Erro: $e")),
      data: (assets) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: assets.length,
        itemBuilder: (context, index) {
          final item = assets[index];
          return Card(
            child: ListTile(
              title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Série: ${item.serialNumber ?? 'N/A'}"),
              trailing: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.green),
                onPressed: () async {
                  final res = await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CameraCaptureScreen(assetName: item.description)
                  ));
                  if (res != null) {
                    await LocalDB.instance.writeTxn(() async {
                      item.status = AuditStatus.found;
                      item.photoPaths = [...?item.photoPaths, res['path']];
                      item.auditLat = res['lat'];
                      item.auditLong = res['long'];
                      await LocalDB.instance.assetItems.put(item);
                    });
                  }
                },
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => AssetDetailScreen(item: item)
              )),
            ),
          );
        },
      ),
    );
  }
}

class _PropertiesTab extends ConsumerWidget {
  final int projectId;
  const _PropertiesTab({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesStreamProvider(projectId));

    return propertiesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Erro: $e")),
      data: (properties) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final item = properties[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.landscape, color: Colors.brown),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.city),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => PropertyDetailScreen(item: item)
              )),
            ),
          );
        },
      ),
    );
  }
}