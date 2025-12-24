import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Corrigido de localizadoation para foundation
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

class ReportService {
  static Future<void> generateProjectReport(
      Project project, List<AssetItem> assets, List<PropertyItem> properties) async {
    
    final tempDir = await getTemporaryDirectory();
    final String fileName = 'Relatorio_${project.name.replaceAll(' ', '_')}.html';
    final targetFile = File('${tempDir.path}/$fileName');
    final sink = targetFile.openWrite();

    // 1. CABEÇALHO E ESTILOS CSS (Visual Profissional Verde Agro)
    sink.writeln('''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          body { font-family: sans-serif; color: #333; padding: 20px; max-width: 900px; margin: auto; }
          h1 { color: #1B5E20; text-align: center; border-bottom: 2px solid #2E7D32; padding-bottom: 10px; }
          h2 { background: #2E7D32; color: white; padding: 10px; border-radius: 5px; margin-top: 30px; font-size: 18px; }
          
          /* Tabela de Resumo */
          table { width: 100%; border-collapse: collapse; margin: 20px 0; font-size: 14px; }
          th { background: #E8F5E9; border: 1px solid #ccc; padding: 10px; text-align: left; }
          td { border: 1px solid #ccc; padding: 10px; }
          .status-localizado { color: green; font-weight: bold; }
          .status-pendente { color: orange; font-weight: bold; }
          .status-problema { color: red; font-weight: bold; }

          /* Cards de Fotos */
          .item-card { border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 25px; page-break-inside: avoid; background: #fafafa; }
          .item-title { font-size: 16px; font-weight: bold; color: #1B5E20; margin-bottom: 10px; }
          .photo-grid { text-align: center; }
          .photo-grid img { max-width: 100%; height: auto; border: 3px solid #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.2); margin-bottom: 10px; border-radius: 4px; }
          .metadata { font-size: 12px; color: #666; background: #eee; padding: 10px; border-radius: 4px; margin-top: 10px; line-height: 1.5; }
          .obs-box { font-style: italic; color: #444; margin-top: 10px; border-left: 4px solid #2E7D32; padding-left: 10px; }
        </style>
      </head>
      <body>
        <h1>LAUDO DE VISTORIA: ${project.name.toUpperCase()}</h1>
        <p style="text-align:center">Data de Emissão: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}</p>
    ''');

    // 2. QUADRO RESUMO (MAQUINÁRIO)
    if (assets.isNotEmpty) {
      sink.writeln('<h2>1. RESUMO DOS ATIVOS (BENS)</h2>');
      sink.writeln('<table><tr><th>Descrição</th><th>Série / Identificação</th><th>Status</th></tr>');
      for (var a in assets) {
        String statusLabel = a.status.name.toUpperCase();
        String cssClass = 'status-pendente';
        if (a.status == AuditStatus.localizado) cssClass = 'status-localizado';
        if (a.status == AuditStatus.apreendido) cssClass = 'status-problema';

        sink.writeln('<tr><td>${a.description}</td><td>${a.serialNumber ?? '-'}</td><td class="$cssClass">$statusLabel</td></tr>');
      }
      sink.writeln('</table>');
    }

    // 3. DETALHAMENTO FOTOGRÁFICO - BENS
    if (assets.isNotEmpty) {
      sink.writeln('<h2>2. REGISTRO FOTOGRÁFICO DETALHADO</h2>');
      for (var a in assets) {
        sink.writeln('<div class="item-card">');
        sink.writeln('<div class="item-title">Item: ${a.description}</div>');
        
        if (a.photoPaths != null && a.photoPaths!.isNotEmpty) {
          sink.writeln('<div class="photo-grid">');
          for (var path in a.photoPaths!) {
            // Processamento pesado em Isolate (compute) para não travar o app
            final b64 = await compute(_resizeAndEncode, path);
            if (b64 != null) {
              sink.writeln('<img src="data:image/jpeg;base64,$b64"><br>');
            }
          }
          sink.writeln('</div>');
        }

        sink.writeln('<div class="metadata">');
        sink.writeln('<strong>Coordenadas:</strong> Lat ${a.auditLat ?? 0} | Long ${a.auditLong ?? 0}<br>');
        sink.writeln('<strong>Identificação:</strong> Série: ${a.serialNumber ?? '-'} | Placa: ${a.plate ?? '-'}<br>');
        sink.writeln('<strong>Localidade:</strong> ${a.municipality ?? '-'} / ${a.state ?? '-'}');
        sink.writeln('</div>');

        if (a.obsField != null && a.obsField!.isNotEmpty) {
          sink.writeln('<div class="obs-box"><strong>Parecer Técnico:</strong> ${a.obsField}</div>');
        }
        sink.writeln('</div>');
      }
    }

    // 4. REGISTRO FOTOGRÁFICO - FAZENDAS
    if (properties.isNotEmpty) {
      sink.writeln('<h2>3. VISTORIA DE PROPRIEDADES (IMÓVEIS)</h2>');
      for (var p in properties) {
        sink.writeln('<div class="item-card">');
        sink.writeln('<div class="item-title">Fazenda: ${p.name}</div>');
        sink.writeln('<p>Matrícula: ${p.matricula} | Local: ${p.city}</p>');
        
        // Fotos de Chão
        if (p.photoPaths != null && p.photoPaths!.isNotEmpty) {
          sink.writeln('<p><strong>Vistoria Local:</strong></p>');
          for (var path in p.photoPaths!) {
            final b64 = await compute(_resizeAndEncode, path);
            if (b64 != null) sink.writeln('<img src="data:image/jpeg;base64,$b64"><br>');
          }
        }

        // Fotos de Drone
        if (p.dronePhotoPaths != null && p.dronePhotoPaths!.isNotEmpty) {
          sink.writeln('<p><strong>Imagens Aéreas (Drone):</strong></p>');
          for (var path in p.dronePhotoPaths!) {
            final b64 = await compute(_resizeAndEncode, path);
            if (b64 != null) sink.writeln('<img src="data:image/jpeg;base64,$b64"><br>');
          }
        }

        if (p.obsField != null && p.obsField!.isNotEmpty) {
          sink.writeln('<div class="obs-box"><strong>Observações Agrícolas:</strong> ${p.obsField}</div>');
        }
        sink.writeln('</div>');
      }
    }

    sink.writeln('</body></html>');
    await sink.flush();
    await sink.close();

    // Compartilha o arquivo
    await Share.shareXFiles([XFile(targetFile.path)], text: 'Laudo de Coleta - ${project.name}');
  }

  // Função auxiliar para reduzir imagem antes de colocar no HTML
  static String? _resizeAndEncode(String path) {
    final file = File(path);
    if (!file.existsSync()) return null;
    try {
      img.Image? image = img.decodeImage(file.readAsBytesSync());
      if (image == null) return null;
      
      // Redimensiona para 1000px para manter qualidade sem ser gigante
      if (image.width > 1000) {
        image = img.copyResize(image, width: 1000);
      }
      
      return base64Encode(img.encodeJpg(image, quality: 75));
    } catch (e) {
      return null;
    }
  }
}