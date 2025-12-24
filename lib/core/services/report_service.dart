import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:image/image.dart' as img;

class ReportService {
  static Future<void> generateProjectReport(Project project, List<AssetItem> assets, List<PropertyItem> properties) async {
    final tempDir = await getTemporaryDirectory();
    final targetFile = File('${tempDir.path}/Relatorio_${project.id}.html');
    final sink = targetFile.openWrite();

    sink.writeln('<html><head><style>img { max-width: 600px; display: block; margin: 20px 0; border: 2px solid #333; }</style></head><body>');
    sink.writeln('<h1>RELATÓRIO: ${project.name}</h1>');

    for (var asset in assets) {
      sink.writeln('<h3>${asset.description} - Status: ${asset.status.name}</h3>');
      if (asset.photoPaths != null) {
        for (var path in asset.photoPaths!) {
          final b64 = await compute(_resizeAndEncode, path);
          if (b64 != null) sink.writeln('<img src="data:image/jpeg;base64,$b64">');
        }
      }
    }

    sink.writeln('</body></html>');
    await sink.flush();
    await sink.close();
    await Share.shareXFiles([XFile(targetFile.path)]);
  }

  static String? _resizeAndEncode(String path) {
    final file = File(path);
    if (!file.existsSync()) return null;
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    if (image == null) return null;
    if (image.width > 800) image = img.copyResize(image, width: 800);
    return base64Encode(img.encodeJpg(image, quality: 70));
  }
}