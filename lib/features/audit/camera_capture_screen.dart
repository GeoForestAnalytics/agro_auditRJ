import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img; 
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart'; 
import 'package:gal/gal.dart'; 

class CameraCaptureScreen extends StatefulWidget {
  final String assetName;

  const CameraCaptureScreen({super.key, required this.assetName});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  bool _isProcessing = false;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _initCameraAndPermissions();
  }

  // Função para remover acentos (A lib de imagem não aceita acentos)
  String _removeAcentos(String str) {
    var comAcento = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var semAcento = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    for (int i = 0; i < comAcento.length; i++) {
      str = str.replaceAll(comAcento[i], semAcento[i]);
    }
    return str;
  }

  Future<void> _initCameraAndPermissions() async {
    // Pede permissões
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permissão de câmera negada."))
        );
        Navigator.pop(context);
      }
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      final firstCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        firstCamera, 
        ResolutionPreset.medium, 
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Erro Câmera: $e");
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isProcessing) return;

    try {
      setState(() {
        _isProcessing = true;
        _statusMessage = "Capturando...";
      });

      Position? position;
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
           // Tenta pegar GPS por 3 segundos
           position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 3), 
          );
        }
      } catch (e) {
        debugPrint("GPS: $e");
      }

      double lat = position?.latitude ?? 0.0;
      double long = position?.longitude ?? 0.0;

      setState(() => _statusMessage = "Processando...");

      XFile rawPhoto = await _controller!.takePicture();
      final bytes = await File(rawPhoto.path).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image != null) {
        // Redimensiona se for muito grande (HD)
        if (image.width > 1280) {
          image = img.copyResize(image, width: 1280);
        }

        String timestamp = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
        
        // Limpa o texto (Remove acentos)
        String nomeLimpo = _removeAcentos(widget.assetName);
        
        // Texto formatado
        String infoText = "$nomeLimpo\nLat: ${lat.toStringAsFixed(5)}  Long: ${long.toStringAsFixed(5)}\nData: $timestamp";

        // Tarja preta
        img.fillRect(
          image,
          x1: 0, y1: image.height - 100,
          x2: image.width, y2: image.height,
          color: img.ColorRgba8(0, 0, 0, 180),
        );

        // Texto (Fonte MENOR: arial24)
        img.drawString(
          image,
          infoText,
          font: img.arial24,
          x: 20,
          y: image.height - 90,
          color: img.ColorRgba8(255, 255, 255, 255),
        );

        // Salvar interno
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = 'audit_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = '${directory.path}/$fileName';
        
        File(filePath).writeAsBytesSync(img.encodeJpg(image, quality: 85));

        // Salvar na Galeria
        try {
          if (await Gal.hasAccess() || await Gal.requestAccess()) {
            await Gal.putImage(filePath, album: 'Agro Audit');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Salvo na Galeria! 📸"), duration: Duration(seconds: 1))
              );
            }
          }
        } catch (e) {
          debugPrint("Galeria erro: $e");
        }

        if (mounted) {
          Navigator.pop(context, {
            'path': filePath,
            'lat': lat,
            'long': long,
          });
        }
      }
    } catch (e) {
      debugPrint("Erro fatal: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
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
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Foto"), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Center(child: CameraPreview(_controller!)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: _isProcessing ? Colors.grey : Colors.white,
        onPressed: _isProcessing ? null : _takePicture,
        child: const Icon(Icons.camera_alt, color: Colors.black, size: 40),
      ),
    );
  }
}