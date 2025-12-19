// lib/core/services/report_service.dart
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
      debugPrint("--- Gerando Relatório HTML Completo ---");
      final StringBuffer html = StringBuffer();

      // ESTILOS CSS (Visual Profissional)
      html.writeln('''
        <!DOCTYPE html>
        <html lang="pt-BR">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Relatório ${project.name}</title>
          <style>
            body { font-family: Helvetica, Arial, sans-serif; padding: 20px; background-color: #fff; color: #333; max-width: 800px; margin: auto; }
            h1 { color: #1B5E20; text-align: center; font-size: 24px; margin-bottom: 5px; }
            h2 { color: #2E7D32; border-bottom: 2px solid #2E7D32; margin-top: 40px; font-size: 18px; padding-bottom: 5px; }
            
            /* Tabela Resumo */
            table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 12px; }
            th { background-color: #2E7D32; color: white; padding: 8px; border: 1px solid #ccc; text-align: left; }
            td { padding: 8px; border: 1px solid #ccc; vertical-align: top; }
            tr:nth-child(even) { background-color: #f9f9f9; }

            /* Cartão de Foto */
            .photo-card { 
                border: 1px solid #ddd; 
                padding: 15px; 
                margin-bottom: 30px; 
                border-radius: 8px; 
                background: #fdfdfd; 
                text-align: center;
                page-break-inside: avoid;
            }
            .photo-card img { 
                max-width: 100%; 
                height: auto; 
                border: 1px solid #333;
                margin-bottom: 10px;
            }
            .caption { font-weight: bold; font-size: 14px; margin-bottom: 5px; }
            .details { font-size: 12px; color: #555; text-align: left; margin-top: 10px; padding-top: 10px; border-top: 1px dashed #ccc; }
            
            .status-found { color: green; font-weight: bold; }
            .status-missing { color: red; font-weight: bold; }
            .status-warning { color: orange; font-weight: bold; }
          </style>
        </head>
        <body>
          <br>
          <h1>LAUDO DE VISTORIA: ${project.name.toUpperCase()}</h1>
          <p style="text-align: center">Data da Emissão: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}</p>
          <hr>
      ''');

      // 1. TABELA RESUMO (BENS)
      if (assets.isNotEmpty) {
        html.writeln('<h2>1. RESUMO DOS BENS</h2>');
        html.writeln('<table><thead><tr><th>Descrição</th><th>Série</th><th>Status</th></tr></thead><tbody>');
        for (var asset in assets) {
          String css = _getCssClass(asset.status);
          html.writeln('<tr><td>${asset.description}</td><td>${asset.serialNumber ?? '-'}</td><td class="$css">${_translateStatus(asset.status)}</td></tr>');
        }
        html.writeln('</tbody></table>');
      }

      // 2. FOTOS DETALHADAS (BENS)
      if (assets.isNotEmpty) {
        html.writeln('<h2>2. REGISTRO FOTOGRÁFICO - MAQUINÁRIO</h2>');
        int count = 1;
        
        for (var asset in assets) {
          // Verifica se tem fotos
          if (asset.photoPaths != null && asset.photoPaths!.isNotEmpty) {
            String fotosHtml = "";
            
            // LOOP DE FOTOS: Gera o HTML para TODAS as fotos do item
            for (var path in asset.photoPaths!) {
              File f = File(path);
              if (f.existsSync()) {
                String b64 = base64Encode(f.readAsBytesSync());
                fotosHtml += '<img src="data:image/jpeg;base64,$b64"><br>';
              }
            }

            String ids = "Série: ${asset.serialNumber ?? '-'} | Placa: ${asset.plate ?? '-'}";
            
            html.writeln('''
              <div class="photo-card">
                <div class="caption">Figura $count - ${asset.description}</div>
                
                $fotosHtml
                
                <div class="details">
                  <strong>Identificação:</strong> $ids<br>
                  <strong>Status:</strong> <span class="${_getCssClass(asset.status)}">${_translateStatus(asset.status)}</span><br>
                  <strong>Local:</strong> ${asset.municipality}/${asset.state}<br>
                  <strong>Obs:</strong> ${asset.obsField ?? '-'}
                </div>
              </div>
            ''');
            count++;
          }
        }
      }

      // 3. FOTOS FAZENDAS
      if (properties.isNotEmpty) {
        html.writeln('<h2>3. REGISTRO FOTOGRÁFICO - IMÓVEIS</h2>');
        for (var prop in properties) {
          String fotosHtml = "";
          
          // Fotos de Chão
          if (prop.photoPaths != null) {
            for (var path in prop.photoPaths!) {
              File f = File(path);
              if (f.existsSync()) {
                String b64 = base64Encode(f.readAsBytesSync());
                fotosHtml += '<p><strong>Vistoria Local:</strong></p><img src="data:image/jpeg;base64,$b64"><br>';
              }
            }
          }
          
          // Fotos de Drone
          if (prop.dronePhotoPaths != null) {
            for (var path in prop.dronePhotoPaths!) {
              File f = File(path);
              if (f.existsSync()) {
                String b64 = base64Encode(f.readAsBytesSync());
                fotosHtml += '<p><strong>Aérea (Drone):</strong></p><img src="data:image/jpeg;base64,$b64"><br>';
              }
            }
          }

          if (fotosHtml.isNotEmpty) {
            html.writeln('''
              <div class="photo-card">
                <div class="caption">Propriedade: ${prop.name}</div>
                <div class="details">Matrícula: ${prop.matricula}</div>
                $fotosHtml
                <div class="details"><strong>Parecer:</strong> ${prop.obsField ?? '-'}</div>
              </div>
            ''');
          }
        }
      }

      html.writeln('</body></html>');

      // SALVAR E COMPARTILHAR
      final tempDir = await getTemporaryDirectory();
      final safeName = project.name.replaceAll(RegExp(r'[^\w\s]+'), '');
      
      // Salva como .html para abrir perfeitamente no celular
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

  static String _getCssClass(AuditStatus status) {
    switch (status) {
      case AuditStatus.found: return "status-found";
      case AuditStatus.notFound: return "status-warning";
      case AuditStatus.seized: return "status-missing";
      default: return "";
    }
  }
}