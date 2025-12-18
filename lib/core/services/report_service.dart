import 'dart:io';
import 'package:flutter/services.dart';
import 'package:docx_template/docx_template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class ReportService {
  static Future<void> generateProjectReport(Project project, List<AssetItem> assets) async {
    try {
      debugPrint("--- Iniciando Geração de Relatório Profissional ---");

      // 1. Carrega os dados brutos do asset
      final ByteData assetData = await rootBundle.load('assets/template.docx');
      
      // 2. FORÇA A CRIAÇÃO DE UMA LISTA TOTALMENTE NOVA E MODIFICÁVEL
      // O método List.from garante que não seja uma "view" do asset original
      final Uint8List templateBytes = Uint8List.fromList(
        assetData.buffer.asUint8List(assetData.offsetInBytes, assetData.lengthInBytes)
      );

      // 3. Inicializa o template com os bytes mutáveis
      final docx = await DocxTemplate.fromBytes(templateBytes);

      // 4. Prepara as linhas da tabela
      final List<RowContent> rowList = [];
      for (var asset in assets) {
        final String loc = "${asset.municipality ?? ''} - ${asset.state ?? ''}";
        
        final row = RowContent()
          ..add(TextContent("item_name", asset.description))
          ..add(TextContent("item_status", _translateStatus(asset.status)))
          ..add(TextContent("item_loc", loc))
          ..add(TextContent("item_obs", asset.obsField ?? "-"));
        
        rowList.add(row);
      }

      // 5. Monta o conteúdo
      final Content content = Content();
      content.add(TextContent("name", project.name));
      content.add(TextContent("date", DateFormat('dd/MM/yyyy').format(DateTime.now())));
      content.add(TextContent("description", project.description ?? "Relatório gerado pelo sistema AgroAudit RJ."));
      
      // Adiciona a tabela (Verifique se o Título 'items' está no Texto Alt da tabela no Word)
      content.add(TableContent("items", rowList));

      // 6. Gera o documento (AQUI É ONDE DAVA O ERRO)
      debugPrint("Processando a lógica de preenchimento do Word...");
      final d = await docx.generate(content);

      if (d != null) {
        // 7. Salva o arquivo final
        final tempDir = await getTemporaryDirectory();
        final String fileName = 'Relatorio_${project.name}_${DateTime.now().millisecondsSinceEpoch}.docx';
        final targetFile = File('${tempDir.path}/$fileName');
        
        await targetFile.writeAsBytes(d, flush: true);
        debugPrint("Sucesso! Relatório pronto para envio.");

        // 8. Abre o menu de compartilhamento
        await Share.shareXFiles(
          [XFile(targetFile.path)],
          text: 'Vistoria AgroAudit - ${project.name}',
        );
      }
    } catch (e, stack) {
      debugPrint("ERRO CRÍTICO: $e");
      debugPrint("LOCAL: $stack");
    }
  }

  static String _translateStatus(AuditStatus status) {
    switch (status) {
      case AuditStatus.pending: return "PENDENTE";
      case AuditStatus.found: return "ENCONTRADO";
      case AuditStatus.notFound: return "NÃO LOCALIZADO";
      case AuditStatus.seized: return "APREENDIDO";
    }
  }
}