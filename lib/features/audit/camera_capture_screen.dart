import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';

class ImageProcessData {
  final Uint8List bytes;
  final String assetName;
  final double lat;
  final double long;
  final String timestamp;
  final String tempPath;
  ImageProcessData({required this.bytes, required this.assetName, required this.lat, required this.long, required this.timestamp, required this.tempPath});
}

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
    await [Permission.camera, Permission.location].request();
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  static Future<String> _processImage(ImageProcessData data) async {
    img.Image? image = img.decodeImage(data.bytes);
    if (image!.width > 1280) image = img.copyResize(image, width: 1280);
    
    img.fillRect(image, x1: 0, y1: image.height - 100, x2: image.width, y2: image.height, color: img.ColorRgba8(0, 0, 0, 180));
    img.drawString(image, "${data.assetName}\nLat: ${data.lat.toStringAsFixed(5)} Long: ${data.long.toStringAsFixed(5)}\n${data.timestamp}", 
        font: img.arial24, x: 20, y: image.height - 90, color: img.ColorRgba8(255, 255, 255, 255));

    final path = '${data.tempPath}/img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    File(path).writeAsBytesSync(img.encodeJpg(image, quality: 85));
    return path;
  }

  Future<void> _takePicture() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    
    final pos = await Geolocator.getCurrentPosition();
    final raw = await _controller!.takePicture();
    final bytes = await File(raw.path).readAsBytes();
    final dir = await getApplicationDocumentsDirectory();

    final finalPath = await compute(_processImage, ImageProcessData(
      bytes: bytes, assetName: widget.assetName, lat: pos.latitude, long: pos.longitude,
      timestamp: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()), tempPath: dir.path
    ));

    await Gal.putImage(finalPath, album: 'Agro Audit');
    if (mounted) Navigator.pop(context, {'path': finalPath, 'lat': pos.latitude, 'long': pos.longitude});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_controller!),
          if (_isProcessing) const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _takePicture, child: const Icon(Icons.camera_alt)),
    );
  }
}