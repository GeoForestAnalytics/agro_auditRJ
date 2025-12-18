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
import 'package:agro_audit_rj/core/services/report_service.dart'; // Import vital para o Word

class AuditScreen extends StatefulWidget {
  final Project project;
  const AuditScreen({super.key, required this.project});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> with SingleTickerProviderStateMixin {
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

  // === FUNÇÃO: GERAR RELATÓRIO WORD ===
  Future<void> _exportToWord() async {
    setState(() => _isLoading = true);
    try {
      // Busca os itens atualizados no banco para o relatório
      final assets = await LocalDB.instance.assetItems
          .filter()
          .project((q) => q.idEqualTo(widget.project.id))
          .findAll();
      
      // Chama o serviço que configuramos com o template.docx
      await ReportService.generateProjectReport(widget.project, assets);
    } catch (e) {
      debugPrint("Erro ao exportar: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // === FUNÇÃO: IMPORTAR BENS (COLUNAS A ATÉ F) ===
  Future<void> _importAssetsExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, 
        allowedExtensions: ['xlsx']
      );

      if (result != null) {
        setState(() => _isLoading = true);
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        final isar = LocalDB.instance;

        await isar.writeTxn(() async {
          final sheet = excel.tables[excel.tables.keys.first];
          if (sheet != null) {
            // Pula o cabeçalho (i=1)
            for (var i = 1; i < sheet.rows.length; i++) {
              var row = sheet.rows[i];
              if (row.isEmpty) continue;

              final newItem = AssetItem()
                ..description = row[0]?.value?.toString() ?? 'Sem Descrição'
                ..serialNumber = (row.length > 1 ? row[1]?.value?.toString() : '') ?? ''
                ..plate = (row.length > 2 ? row[2]?.value?.toString() : '') ?? ''
                ..category = (row.length > 3 ? row[3]?.value?.toString() : '') ?? 'Geral'
                ..municipality = (row.length > 4 ? row[4]?.value?.toString() : '') ?? '' // Coluna E
                ..state = (row.length > 5 ? row[5]?.value?.toString() : '') ?? ''        // Coluna F
                ..status = AuditStatus.pending;

              await isar.assetItems.put(newItem);
              
              // Vincula o item ao projeto atual (Backlink)
              newItem.project.value = widget.project;
              await newItem.project.save();
              
              // Adiciona na lista de links do projeto
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
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, 
        allowedExtensions: ['xlsx']
      );

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
                ..matricula = (row.length > 1 ? row[1]?.value?.toString() : '') ?? ''
                ..city = (row.length > 2 ? row[2]?.value?.toString() : '') ?? ''
                ..state = (row.length > 3 ? row[3]?.value?.toString() : '') ?? '' // Coluna D
                ..referenceLat = double.tryParse(row.length > 4 ? row[4]?.value?.toString() ?? '' : '') // Coluna E
                ..referenceLong = double.tryParse(row.length > 5 ? row[5]?.value?.toString() ?? '' : ''); // Coluna F

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
            Text(widget.project.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            Tab(icon: Icon(Icons.landscape), text: 'Fazendas'),
          ],
        ),
        actions: [
          if (_isLoading)
            const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(color: Colors.white))
          else ...[
            // BOTÃO 1: EXPORTAR WORD
            IconButton(
              icon: const Icon(Icons.description), 
              onPressed: _exportToWord,
              tooltip: "Gerar Relatório Word",
            ),
            // BOTÃO 2: IMPORTAR (MENU SUSPENSO)
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
                          leading: const Icon(Icons.agriculture, color: Colors.green),
                          title: const Text("Importar Lista de Bens"),
                          subtitle: const Text("Colunas A-F: Desc, Série, Placa, Cat, Mun, UF"),
                          onTap: () { Navigator.pop(context); _importAssetsExcel(); },
                        ),
                        ListTile(
                          leading: const Icon(Icons.landscape, color: Colors.brown),
                          title: const Text("Importar Lista de Fazendas"),
                          subtitle: const Text("Colunas A-F: Nome, Mat, Cid, UF, Lat, Long"),
                          onTap: () { Navigator.pop(context); _importPropertiesExcel(); },
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
          // ABA 1: LISTA DE BENS
          AssetsListTab(project: widget.project, onImport: _importAssetsExcel),
          // ABA 2: LISTA DE FAZENDAS
          PropertiesListTab(project: widget.project, onImport: _importPropertiesExcel),
        ],
      ),
    );
  }
}

// === WIDGET: ABA DE BENS ===
class AssetsListTab extends StatefulWidget {
  final Project project;
  final VoidCallback onImport;
  const AssetsListTab({super.key, required this.project, required this.onImport});

  @override
  State<AssetsListTab> createState() => _AssetsListTabState();
}

class _AssetsListTabState extends State<AssetsListTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Impede o erro de "Stream already listened"

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<AssetItem>>(
      stream: LocalDB.instance.assetItems
          .filter()
          .project((q) => q.idEqualTo(widget.project.id))
          .watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final assets = snapshot.data!;
        
        if (assets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const Icon(Icons.list_alt, size: 60, color: Colors.grey),
                const Gap(16),
                const Text("Nenhum bem importado."),
                ElevatedButton(onPressed: widget.onImport, child: const Text("Importar Excel"))
              ]
            )
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
                backgroundColor: item.status == AuditStatus.found ? Colors.green : Colors.grey,
                child: Icon(item.status == AuditStatus.found ? Icons.check : Icons.priority_high, color: Colors.white, size: 16),
              ),
              title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Loc: ${item.municipality} - ${item.state}'),
              trailing: IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () async {
                  final result = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => CameraCaptureScreen(assetName: item.description))
                  );
                  if (result != null && result is Map) {
                    await LocalDB.instance.writeTxn(() async {
                      item.status = AuditStatus.found;
                      item.photoPaths = [result['path']];
                      item.auditLat = result['lat'];
                      item.auditLong = result['long'];
                      item.auditDate = DateTime.now();
                      await LocalDB.instance.assetItems.put(item);
                    });
                  }
                },
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AssetDetailScreen(item: item))),
            );
          },
        );
      },
    );
  }
}

// === WIDGET: ABA DE FAZENDAS ===
class PropertiesListTab extends StatefulWidget {
  final Project project;
  final VoidCallback onImport;
  const PropertiesListTab({super.key, required this.project, required this.onImport});

  @override
  State<PropertiesListTab> createState() => _PropertiesListTabState();
}

class _PropertiesListTabState extends State<PropertiesListTab> with AutomaticKeepAliveClientMixin {
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
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final props = snapshot.data!;
        
        if (props.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const Icon(Icons.landscape, size: 60, color: Colors.grey),
                const Gap(16),
                const Text("Nenhuma fazenda importada."),
                ElevatedButton(onPressed: widget.onImport, child: const Text("Importar Excel"))
              ]
            )
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: props.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final prop = props[index];
            return ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF2E7D32), child: Icon(Icons.map, color: Colors.white, size: 16)),
              title: Text(prop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${prop.matricula} | ${prop.city} - ${prop.state}'),
              onTap: () => debugPrint("Detalhes da fazenda"),
            );
          },
        );
      },
    );
  }
}