import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:intl/intl.dart';

class ExportService {
  /// Gera uma planilha Excel editável com todos os dados coletados
  static Future<void> exportProjectData(
      Project project, List<AssetItem> assets, List<PropertyItem> properties) async {
    var excel = Excel.createExcel();
    
    // --- ABA 1: BENS (MAQUINÁRIO) ---
    // No Excel v4, acessamos a aba e definimos o nome
    Sheet assetSheet = excel['Maquinário'];
    excel.delete('Sheet1'); // Remove a aba padrão vazia

    // Cabeçalho dos Bens (Cada item precisa ser um CellValue)
    assetSheet.appendRow([
      TextCellValue('Descrição'),
      TextCellValue('Série'),
      TextCellValue('Placa'),
      TextCellValue('Categoria'),
      TextCellValue('Município'),
      TextCellValue('UF'),
      TextCellValue('Status'),
      TextCellValue('Data da Coleta'),
      TextCellValue('Latitude (GPS)'),
      TextCellValue('Longitude (GPS)'),
      TextCellValue('Observações'),
    ]);

    for (var a in assets) {
      assetSheet.appendRow([
        TextCellValue(a.description),
        TextCellValue(a.serialNumber ?? ''),
        TextCellValue(a.plate ?? ''),
        TextCellValue(a.category),
        TextCellValue(a.municipality ?? ''),
        TextCellValue(a.state ?? ''),
        TextCellValue(a.status.name.toUpperCase()),
        TextCellValue(a.auditDate != null 
            ? DateFormat('dd/MM/yyyy HH:mm').format(a.auditDate!) 
            : 'Pendente'),
        DoubleCellValue(a.auditLat ?? 0.0),
        DoubleCellValue(a.auditLong ?? 0.0),
        TextCellValue(a.obsField ?? ''),
      ]);
    }

    // --- ABA 2: FAZENDAS ---
    Sheet propSheet = excel['Fazendas'];
    propSheet.appendRow([
      TextCellValue('Nome da Propriedade'),
      TextCellValue('Matrícula'),
      TextCellValue('Cidade'),
      TextCellValue('UF'),
      TextCellValue('Status'),
      TextCellValue('Lat Sede (Ref)'),
      TextCellValue('Long Sede (Ref)'),
      TextCellValue('Lat Vistoria'),
      TextCellValue('Long Vistoria'),
      TextCellValue('Parecer'),
    ]);

    for (var p in properties) {
      propSheet.appendRow([
        TextCellValue(p.name),
        TextCellValue(p.matricula),
        TextCellValue(p.city),
        TextCellValue(p.state ?? ''),
        TextCellValue(p.status.name.toUpperCase()),
        DoubleCellValue(p.referenceLat ?? 0.0),
        DoubleCellValue(p.referenceLong ?? 0.0),
        DoubleCellValue(p.auditLat ?? 0.0),
        DoubleCellValue(p.auditLong ?? 0.0),
        TextCellValue(p.obsField ?? ''),
      ]);
    }

    // --- SALVAMENTO E COMPARTILHAMENTO ---
    final directory = await getTemporaryDirectory();
    final String fileName = "COLETA_${project.name.replaceAll(' ', '_')}.xlsx";
    final String fullPath = "${directory.path}/$fileName";
    
    final fileBytes = excel.save();
    if (fileBytes != null) {
      File(fullPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      
      await Share.shareXFiles(
        [XFile(fullPath)],
        text: 'Dados Coletados em Campo: ${project.name}',
      );
    }
  }
}