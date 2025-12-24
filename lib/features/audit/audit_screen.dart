import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:gap/gap.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/providers/audit_providers.dart';
import 'package:agro_audit_rj/features/audit/camera_capture_screen.dart';
import 'package:agro_audit_rj/features/audit/asset_detail_screen.dart';
import 'package:agro_audit_rj/features/audit/property_detail_screen.dart';
import 'package:agro_audit_rj/features/map/map_screen.dart'; // Import do Mapa
import 'package:agro_audit_rj/core/services/report_service.dart';
import 'package:agro_audit_rj/core/services/drone_service.dart';

class AuditScreen extends ConsumerStatefulWidget {
  final Project project;
  const AuditScreen({super.key, required this.project});

  @override
  ConsumerState<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends ConsumerState<AuditScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

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

  Future<void> _importExcel(bool isAsset) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
      if (result == null) return;
      setState(() => _isLoading = true);
      final bytes = File(result.files.single.path!).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables[excel.tables.keys.first];
      if (sheet != null) {
        if (isAsset) {
          List<AssetItem> items = [];
          for (var i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            if (row.isEmpty) continue;
            items.add(AssetItem()
              ..description = row[0]?.value?.toString() ?? 'S/D'
              ..serialNumber = (row.length > 1 ? row[1]?.value?.toString() : '') ?? ''
              ..plate = (row.length > 2 ? row[2]?.value?.toString() : '') ?? ''
              ..category = 'Geral'
              ..status = AuditStatus.pending);
          }
          await ref.read(auditRepositoryProvider).saveAssets(items, widget.project);
        } else {
          List<PropertyItem> props = [];
          for (var i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            if (row.isEmpty) continue;
            props.add(PropertyItem()
              ..name = row[0]?.value?.toString() ?? 'S/N'
              ..matricula = (row.length > 1 ? row[1]?.value?.toString() : '') ?? ''
              ..city = (row.length > 2 ? row[2]?.value?.toString() : '') ?? ''
              ..status = AuditStatus.pending);
          }
          await ref.read(auditRepositoryProvider).saveProperties(props, widget.project);
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          if (_isLoading)
            const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: Colors.white))
          else ...[
            // NOVO BOTÃO: MAPA DO PROJETO
            IconButton(
              icon: const Icon(Icons.map_outlined),
              tooltip: "Ver Coletas no Mapa",
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => MapScreen(projectId: widget.project.id)
              )),
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () async {
                setState(() => _isLoading = true);
                final assets = await ref.read(auditRepositoryProvider).getAssetsSync(widget.project.id);
                final props = await ref.read(auditRepositoryProvider).getPropertiesSync(widget.project.id);
                await ReportService.generateProjectReport(widget.project, assets, props);
                setState(() => _isLoading = false);
              },
            ),
            IconButton(icon: const Icon(Icons.file_upload), onPressed: () {
              showModalBottomSheet(context: context, builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(leading: const Icon(Icons.agriculture), title: const Text("Excel Bens"), onTap: () { Navigator.pop(context); _importExcel(true); }),
                ListTile(leading: const Icon(Icons.landscape), title: const Text("Excel Fazendas"), onTap: () { Navigator.pop(context); _importExcel(false); }),
              ])));
            }),
          ]
        ],
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: 'Bens'), Tab(text: 'Fazendas')]),
      ),
      body: TabBarView(controller: _tabController, children: [
        _AssetsTab(projectId: widget.project.id),
        _PropertiesTab(project: widget.project),
      ]),
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
      data: (assets) => ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: assets.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = assets[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: item.status == AuditStatus.found ? Colors.green : Colors.grey,
              child: Icon(item.status == AuditStatus.found ? Icons.check : Icons.priority_high, color: Colors.white, size: 18),
            ),
            title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Série: ${item.serialNumber ?? 'N/A'}"),
            trailing: IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () async {
                final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => CameraCaptureScreen(assetName: item.description)));
                if (res != null) {
                  item.status = AuditStatus.found;
                  item.photoPaths = [...?item.photoPaths, res['path']];
                  item.auditLat = res['lat'];
                  item.auditLong = res['long'];
                  item.auditDate = DateTime.now();
                  await ref.read(auditRepositoryProvider).updateAsset(item);
                }
              },
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AssetDetailScreen(item: item))),
          );
        },
      ),
    );
  }
}

class _PropertiesTab extends ConsumerWidget {
  final Project project;
  const _PropertiesTab({required this.project});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propsAsync = ref.watch(propertiesStreamProvider(project.id));
    return propsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Erro: $e")),
      data: (props) => Column(children: [
        Padding(padding: const EdgeInsets.all(8.0), child: SizedBox(width: double.infinity, child: ElevatedButton.icon(
          icon: const Icon(Icons.flight_takeoff), label: const Text("Processar Drone"),
          onPressed: () => DroneService().processDronePhotos(context, project),
        ))),
        Expanded(child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: props.length, separatorBuilder: (_, __) => const Divider(), itemBuilder: (context, index) {
          final item = props[index];
          return ListTile(
            leading: Icon(Icons.landscape, color: item.status == AuditStatus.found ? Colors.green : Colors.brown[300]),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.city),
            trailing: IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () async {
              final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => CameraCaptureScreen(assetName: item.name)));
              if (res != null) {
                item.status = AuditStatus.found;
                item.photoPaths = [...?item.photoPaths, res['path']];
                item.auditLat = res['lat']; item.auditLong = res['long']; item.auditDate = DateTime.now();
                await ref.read(auditRepositoryProvider).updateProperty(item);
              }
            }),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailScreen(item: item))),
          );
        }))
      ]),
    );
  }
}