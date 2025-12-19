// lib/features/audit/audit_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:gap/gap.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/features/audit/camera_capture_screen.dart';
import 'package:agro_audit_rj/features/audit/asset_detail_screen.dart';
import 'package:agro_audit_rj/features/audit/property_detail_screen.dart'; // Tela de Detalhes da Fazenda
import 'package:agro_audit_rj/core/services/report_service.dart';
import 'package:agro_audit_rj/core/services/drone_service.dart'; // Serviço do Drone

class AuditScreen extends StatefulWidget {
  final Project project;
  const AuditScreen({super.key, required this.project});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen>
    with SingleTickerProviderStateMixin {
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

  // === FUNÇÃO: GERAR RELATÓRIO COMPLETO (BENS + FAZENDAS) ===
  Future<void> _exportToWord() async {
    setState(() => _isLoading = true);
    try {
      // 1. Busca Bens
      final assets = await LocalDB.instance.assetItems
          .filter()
          .project((q) => q.idEqualTo(widget.project.id))
          .findAll();

      // 2. Busca Fazendas (ISSO FALTAVA NO SEU CÓDIGO)
      final properties = await LocalDB.instance.propertyItems
          .filter()
          .project((q) => q.idEqualTo(widget.project.id))
          .findAll();

      // 3. Gera Relatório Unificado
      await ReportService.generateProjectReport(
          widget.project, assets, properties);
    } catch (e) {
      debugPrint("Erro ao exportar: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // === FUNÇÃO: IMPORTAR BENS (COLUNAS A ATÉ F) ===
  Future<void> _importAssetsExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (result != null) {
        setState(() => _isLoading = true);
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        final isar = LocalDB.instance;

        await isar.writeTxn(() async {
          final sheet = excel.tables[excel.tables.keys.first];
          if (sheet != null) {
            for (var i = 1; i < sheet.rows.length; i++) {
              var row = sheet.rows[i];
              if (row.isEmpty) continue;

              final newItem = AssetItem()
                ..description = row[0]?.value?.toString() ?? 'Sem Descrição'
                ..serialNumber =
                    (row.length > 1 ? row[1]?.value?.toString() : '') ?? ''
                ..plate =
                    (row.length > 2 ? row[2]?.value?.toString() : '') ?? ''
                ..category =
                    (row.length > 3 ? row[3]?.value?.toString() : '') ?? 'Geral'
                ..municipality =
                    (row.length > 4 ? row[4]?.value?.toString() : '') ?? ''
                ..state =
                    (row.length > 5 ? row[5]?.value?.toString() : '') ?? ''
                ..status = AuditStatus.pending;

              await isar.assetItems.put(newItem);

              newItem.project.value = widget.project;
              await newItem.project.save();
              widget.project.assets.add(newItem);
            }
            await widget.project.assets.save();
          }
        });
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Erro na importação de bens: $e");
    }
  }

  // === FUNÇÃO: IMPORTAR FAZENDAS (COLUNAS A ATÉ F) ===
  Future<void> _importPropertiesExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

      if (result != null) {
        setState(() => _isLoading = true);
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        final isar = LocalDB.instance;

        await isar.writeTxn(() async {
          final sheet = excel.tables[excel.tables.keys.first];
          if (sheet != null) {
            for (var i = 1; i < sheet.rows.length; i++) {
              var row = sheet.rows[i];
              if (row.isEmpty) continue;

              final newProp = PropertyItem()
                ..name = row[0]?.value?.toString() ?? 'Fazenda sem Nome'
                ..matricula =
                    (row.length > 1 ? row[1]?.value?.toString() : '') ?? ''
                ..city = (row.length > 2 ? row[2]?.value?.toString() : '') ?? ''
                ..state =
                    (row.length > 3 ? row[3]?.value?.toString() : '') ?? ''
                ..referenceLat = double.tryParse(
                    row.length > 4 ? row[4]?.value?.toString() ?? '' : '')
                ..referenceLong = double.tryParse(
                    row.length > 5 ? row[5]?.value?.toString() ?? '' : '');

              await isar.propertyItems.put(newProp);
              newProp.project.value = widget.project;
              await newProp.project.save();
              widget.project.properties.add(newProp);
            }
            await widget.project.properties.save();
          }
        });
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Erro na importação de fazendas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.project.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Auditoria em andamento',
                style: TextStyle(fontSize: 12)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.agriculture), text: 'Bens'),
            Tab(icon: Icon(Icons.landscape), text: 'Fazendas'),
          ],
        ),
        actions: [
          if (_isLoading)
            const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Colors.white))
          else ...[
            IconButton(
              icon: const Icon(Icons.description),
              onPressed: _exportToWord,
              tooltip: "Gerar Relatório",
            ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.agriculture,
                              color: Colors.green),
                          title: const Text("Importar Lista de Bens"),
                          subtitle: const Text(
                              "Colunas A-F: Desc, Série, Placa, Cat, Mun, UF"),
                          onTap: () {
                            Navigator.pop(context);
                            _importAssetsExcel();
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.landscape, color: Colors.brown),
                          title: const Text("Importar Lista de Fazendas"),
                          subtitle: const Text(
                              "Colunas A-F: Nome, Mat, Cid, UF, Lat, Long"),
                          onTap: () {
                            Navigator.pop(context);
                            _importPropertiesExcel();
                          },
                        ),
                        const Gap(10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ]
        ],
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AssetsListTab(project: widget.project, onImport: _importAssetsExcel),
          PropertiesListTab(
              project: widget.project, onImport: _importPropertiesExcel),
        ],
      ),
    );
  }
}

// === ABA DE BENS (MAQUINÁRIO) ===
class AssetsListTab extends StatefulWidget {
  final Project project;
  final VoidCallback onImport;
  const AssetsListTab(
      {super.key, required this.project, required this.onImport});

  @override
  State<AssetsListTab> createState() => _AssetsListTabState();
}

class _AssetsListTabState extends State<AssetsListTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<AssetItem>>(
      stream: LocalDB.instance.assetItems
          .filter()
          .project((q) => q.idEqualTo(widget.project.id))
          .watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final assets = snapshot.data!;

        if (assets.isEmpty) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Icon(Icons.list_alt, size: 60, color: Colors.grey),
                const Gap(16),
                const Text("Nenhum bem importado."),
                ElevatedButton(
                    onPressed: widget.onImport,
                    child: const Text("Importar Excel"))
              ]));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: assets.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final item = assets[index];

            Color corStatus;
            IconData iconeStatus;

            switch (item.status) {
              case AuditStatus.found:
                corStatus = Colors.green;
                iconeStatus = Icons.check;
                break;
              case AuditStatus.notFound:
                corStatus = Colors.orange;
                iconeStatus = Icons.search_off;
                break;
              case AuditStatus.seized:
                corStatus = Colors.red;
                iconeStatus = Icons.gavel;
                break;
              case AuditStatus.pending:
              default:
                corStatus = Colors.grey;
                iconeStatus = Icons.priority_high;
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: corStatus,
                child: Icon(iconeStatus, color: Colors.white, size: 18),
              ),
              title: Text(item.description,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Loc: ${item.municipality} - ${item.state}'),

              // --- CORRIGIDO: Botão de Câmera dos BENS ---
              trailing: IconButton(
                icon: Icon(Icons.camera_alt_outlined, color: corStatus),
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraCaptureScreen(
                              assetName: item.description)));
                  if (result != null && result is Map) {
                    await LocalDB.instance.writeTxn(() async {
                      item.status = AuditStatus.found;
                      List<String> currentPhotos =
                          item.photoPaths?.toList() ?? [];
                      currentPhotos.add(result['path']);
                      item.photoPaths = currentPhotos;
                      item.auditLat = result['lat'];
                      item.auditLong = result['long'];
                      item.auditDate = DateTime.now();
                      await LocalDB.instance.assetItems.put(item);
                    });
                  }
                },
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssetDetailScreen(item: item))),
            );
          },
        );
      },
    );
  }
}

// === ABA DE FAZENDAS (PROPRIEDADES) ===
class PropertiesListTab extends StatefulWidget {
  final Project project;
  final VoidCallback onImport;
  const PropertiesListTab(
      {super.key, required this.project, required this.onImport});

  @override
  State<PropertiesListTab> createState() => _PropertiesListTabState();
}

class _PropertiesListTabState extends State<PropertiesListTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<PropertyItem>>(
      stream: LocalDB.instance.propertyItems
          .filter()
          .project((q) => q.idEqualTo(widget.project.id))
          .watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final props = snapshot.data!;

        if (props.isEmpty) {
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Icon(Icons.landscape, size: 60, color: Colors.grey),
                const Gap(16),
                const Text("Nenhuma fazenda importada."),
                ElevatedButton(
                    onPressed: widget.onImport,
                    child: const Text("Importar Excel"))
              ]));
        }

        return Column(
          children: [
            // --- BOTÃO DO DRONE ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.flight_takeoff),
                  label: const Text("Processar Fotos de Drone (Galeria)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    DroneService().processDronePhotos(context, widget.project);
                  },
                ),
              ),
            ),

            // --- LISTA ---
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: props.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final prop = props[index];

                  Color corStatus;
                  IconData iconeStatus;

                  switch (prop.status) {
                    case AuditStatus.found:
                      corStatus = Colors.green;
                      iconeStatus = Icons.check;
                      break;
                    case AuditStatus.notFound:
                      corStatus = Colors.orange;
                      iconeStatus = Icons.search_off;
                      break;
                    default:
                      corStatus = Colors.grey;
                      iconeStatus = Icons.landscape;
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: corStatus,
                      child: Icon(iconeStatus, color: Colors.white, size: 18),
                    ),
                    title: Text(prop.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${prop.matricula} | ${prop.city}'),

                    // --- CORRIGIDO: Botão de Câmera das FAZENDAS ---
                    trailing: IconButton(
                      icon: Icon(Icons.camera_alt_outlined, color: corStatus),
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CameraCaptureScreen(assetName: prop.name)));

                        if (result != null && result is Map) {
                          await LocalDB.instance.writeTxn(() async {
                            prop.status = AuditStatus.found;
                            prop.photoPaths = [result['path']];
                            prop.auditDate = DateTime.now();
                            // Salvando GPS da vistoria
                            prop.auditLat = result['lat'];
                            prop.auditLong = result['long'];

                            await LocalDB.instance.propertyItems.put(prop);
                          });
                        }
                      },
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PropertyDetailScreen(item: prop))),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
