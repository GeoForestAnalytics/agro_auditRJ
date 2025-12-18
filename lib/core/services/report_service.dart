import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:intl/intl.dart';

class ReportService {
  static Future<void> generateProjectReport(
      Project project, 
      List<AssetItem> assets, 
      List<PropertyItem> properties
  ) async {
    try {
      debugPrint("--- Gerando Relatório Web ---");
      final StringBuffer html = StringBuffer();

      // Cabeçalho HTML
      html.writeln('''
        <!DOCTYPE html>
        <html lang="pt-BR">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Relatório ${project.name}</title>
          <style>
            body { font-family: Helvetica, Arial, sans-serif; padding: 15px; background-color: #fff; color: #333; }
            h1 { color: #1B5E20; text-align: center; font-size: 20px; }
            h2 { color: #2E7D32; border-bottom: 2px solid #2E7D32; margin-top: 30px; font-size: 16px; }
            
            /* Tabelas */
            table { width: 100%; border-collapse: collapse; margin-bottom: 15px; font-size: 12px; }
            th { background-color: #2E7D32; color: white; padding: 8px; border: 1px solid #ccc; }
            td { padding: 8px; border: 1px solid #ccc; vertical-align: top; }
            tr:nth-child(even) { background-color: #f9f9f9; }

            /* Fotos */
            .photo-card { border: 1px solid #ddd; padding: 10px; margin-bottom: 20px; border-radius: 8px; background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
            .photo-card img { width: 100%; height: auto; border-radius: 4px; margin-top: 5px; }
            .caption { font-weight: bold; margin-top: 8px; font-size: 14px; }
            .details { font-size: 12px; color: #555; margin-top: 4px; }
            
            .status-ok { color: green; font-weight: bold; }
            .status-alert { color: orange; font-weight: bold; }
            .status-danger { color: red; font-weight: bold; }
          </style>
        </head>
        <body>
          <br>
          <h1>LAUDO DE VISTORIA: ${project.name.toUpperCase()}</h1>
          <p style="text-align: center">Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}</p>
          <hr>
      ''');

      // 1. Tabela Resumo
      if (assets.isNotEmpty) {
        html.writeln('<h2>1. RESUMO DOS BENS</h2>');
        html.writeln('<table><thead><tr><th>Bem</th><th>Série</th><th>Status</th></tr></thead><tbody>');
        for (var asset in assets) {
          String classe = asset.status == AuditStatus.found ? "status-ok" : "status-danger";
          html.writeln('<tr><td>${asset.description}</td><td>${asset.serialNumber ?? '-'}</td><td class="$classe">${_translateStatus(asset.status)}</td></tr>');
        }
        html.writeln('</tbody></table>');
      }

      // 2. Fotos Bens
      if (assets.isNotEmpty) {
        html.writeln('<h2>2. FOTOS - MAQUINÁRIO</h2>');
        for (var asset in assets) {
          if (asset.photoPaths != null && asset.photoPaths!.isNotEmpty) {
            File f = File(asset.photoPaths!.first);
            if (f.existsSync()) {
              String b64 = base64Encode(f.readAsBytesSync());
              html.writeln('''
                <div class="photo-card">
                  <div class="caption">${asset.description}</div>
                  <div class="details">Série: ${asset.serialNumber ?? '-'} | Placa: ${asset.plate ?? '-'}</div>
                  <img src="data:image/jpeg;base64,$b64">
                  <div class="details">
                    <strong>Status:</strong> ${_translateStatus(asset.status)}<br>
                    <strong>Obs:</strong> ${asset.obsField ?? '-'}
                  </div>
                </div>
              ''');
            }
          }
        }
      }

      // 3. Fotos Fazendas
      if (properties.isNotEmpty) {
        html.writeln('<h2>3. FOTOS - IMÓVEIS</h2>');
        for (var prop in properties) {
          // Foto de Chão
          if (prop.photoPaths != null && prop.photoPaths!.isNotEmpty) {
            File f = File(prop.photoPaths!.first);
            if (f.existsSync()) {
              String b64 = base64Encode(f.readAsBytesSync());
              html.writeln('''
                <div class="photo-card">
                  <div class="caption">Fazenda: ${prop.name} (Vistoria Local)</div>
                  <div class="details">Matrícula: ${prop.matricula}</div>
                  <img src="data:image/jpeg;base64,$b64">
                  <div class="details"><strong>Parecer:</strong> ${prop.obsField ?? '-'}</div>
                </div>
              ''');
            }
          }
          // Fotos de Drone
          if (prop.dronePhotoPaths != null) {
            for (var path in prop.dronePhotoPaths!) {
              File f = File(path);
              if (f.existsSync()) {
                String b64 = base64Encode(f.readAsBytesSync());
                html.writeln('''
                  <div class="photo-card">
                    <div class="caption">Imagem Aérea (Drone) - ${prop.name}</div>
                    <img src="data:image/jpeg;base64,$b64">
                  </div>
                ''');
              }
            }
          }
        }
      }

      html.writeln('</body></html>');

      final tempDir = await getTemporaryDirectory();
      final safeName = project.name.replaceAll(RegExp(r'[^\w\s]+'), '');
      
      // Salva como HTML para evitar erro de corrompido
      final String fileName = 'Relatorio_${safeName}.html'; 
      
      final targetFile = File('${tempDir.path}/$fileName');
      await targetFile.writeAsString(html.toString());
      
      await Share.shareXFiles(
        [XFile(targetFile.path)],
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 300, 300),
      );

    } catch (e) {
      debugPrint("ERRO: $e");
    }
  }

  static String _translateStatus(AuditStatus status) {
    switch (status) {
      case AuditStatus.pending: return "PENDENTE";
      case AuditStatus.found: return "LOCALIZADO";
      case AuditStatus.notFound: return "NÃO LOCALIZADO";
      case AuditStatus.seized: return "APREENDIDO";
    }
  }
}