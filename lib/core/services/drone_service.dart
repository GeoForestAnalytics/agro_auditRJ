import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_exif/native_exif.dart';
import 'package:geolocator/geolocator.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:isar/isar.dart';

class DroneService {
  final ImagePicker _picker = ImagePicker();

  // Função Principal
  Future<void> processDronePhotos(BuildContext context, Project project) async {
    try {
      // 1. Selecionar Múltiplas Fotos
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isEmpty) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator()),
      );

      final isar = LocalDB.instance;
      int matcheslocalizado = 0;
      List<String> logs = [];

      // 2. Carregar as Fazendas do Projeto
      final properties = await isar.propertyItems
          .filter()
          .project((q) => q.idEqualTo(project.id))
          .findAll();

      if (properties.isEmpty) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhuma fazenda cadastrada com coordenadas!")),
        );
        return;
      }

      // 3. Processar cada foto
      await isar.writeTxn(() async {
        for (var image in images) {
          final exif = await Exif.fromPath(image.path);
          final latLong = await exif.getLatLong();
          await exif.close();

          if (latLong != null) {
            // Temos GPS na foto! Vamos procurar a fazenda mais próxima.
            // Raio de tolerância: 2000 metros (2km) do ponto sede
            double bestDistance = 2000; 
            PropertyItem? bestMatch;

            for (var prop in properties) {
              if (prop.referenceLat != null && prop.referenceLong != null) {
                double distance = Geolocator.distanceBetween(
                  latLong.latitude, latLong.longitude,
                  prop.referenceLat!, prop.referenceLong!
                );

                if (distance < bestDistance) {
                  bestDistance = distance;
                  bestMatch = prop;
                }
              }
            }

            // Se achou uma fazenda compatível
            if (bestMatch != null) {
              // Inicializa a lista se for nula
              bestMatch.dronePhotoPaths = [...?bestMatch.dronePhotoPaths, image.path];
              
              // Opcional: Atualiza status se ainda estava pendente
              if (bestMatch.status == AuditStatus.pendente) {
                bestMatch.status = AuditStatus.localizado;
              }
              
              await isar.propertyItems.put(bestMatch);
              matcheslocalizado++;
              logs.add("Foto vinculada a: ${bestMatch.name}");
            }
          }
        }
      });

      // 4. Resultado
      Navigator.pop(context); // Fecha loading
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Processamento Concluído"),
          content: Text(
            "Fotos processadas: ${images.length}\n"
            "Vínculos automáticos: $matcheslocalizado\n\n"
            "As fotos foram anexadas às fazendas baseadas na localização GPS."
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );

    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Fecha loading se der erro
      debugPrint("Erro Drone: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao processar: $e")),
      );
    }
  }
}