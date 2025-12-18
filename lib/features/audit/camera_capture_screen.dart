import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img; // A lib de processamento
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class CameraCaptureScreen extends StatefulWidget {
  final String assetName;

  const CameraCaptureScreen({super.key, required this.assetName});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.medium);
    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() => _isProcessing = true);

      // 1. Captura GPS
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      // 2. Tira a foto
      XFile rawPhoto = await _controller!.takePicture();
      
      // 3. Processamento de Imagem (O OVERLAY)
      final bytes = await File(rawPhoto.path).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image != null) {
        // Redimensionar para não travar a memória (Full HD é suficiente)
        image = img.copyResize(image, width: 1280);

        String timestamp = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
        String infoText = "${widget.assetName}\nLAT: ${position.latitude.toStringAsFixed(6)}\nLONG: ${position.longitude.toStringAsFixed(6)}\nDATA: $timestamp";

        // Desenhar um retângulo semi-transparente no rodapé
        img.fillRect(
          image,
          x1: 0, y1: image.height - 120,
          x2: image.width, y2: image.height,
          color: img.ColorRgba8(0, 0, 0, 150),
        );

        // Escrever o texto (Usando fonte padrão da lib)
        img.drawString(
          image,
          infoText,
          font: img.arial24,
          x: 20,
          y: image.height - 100,
          color: img.ColorRgba8(255, 255, 255, 255),
        );

        // 4. Salvar a foto final
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = 'audit_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = '${directory.path}/$fileName';
        
        File(filePath).writeAsBytesSync(img.encodeJpg(image, quality: 85));

        // Retornar o caminho da foto e as coordenadas para a tela anterior
        if (mounted) {
          Navigator.pop(context, {
            'path': filePath,
            'lat': position.latitude,
            'long': position.longitude,
          });
        }
      }
    } catch (e) {
      print("Erro na captura: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Vistoria")),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 10),
                  Text("Processando Imagem GPS...", style: TextStyle(color: Colors.white)),
                ],
              )),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing ? null : _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}