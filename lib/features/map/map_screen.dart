import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isar/isar.dart';
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir Waze/Maps

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  // Ponto inicial (Brasil Central - ou mude para sua região)
  static const CameraPosition _kBrasil = CameraPosition(
    target: LatLng(-15.7942, -47.8822),
    zoom: 4,
  );

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  // Busca as fazendas no banco e cria os pinos
  Future<void> _loadFarms() async {
    final isar = LocalDB.instance;
    // Pega todas as propriedades que tenham GPS cadastrado
    final farms = await isar.propertyItems
        .filter()
        .referenceLatIsNotNull()
        .referenceLongIsNotNull()
        .findAll();

    for (var farm in farms) {
      if (farm.referenceLat != 0 && farm.referenceLong != 0) {
        _markers.add(
          Marker(
            markerId: MarkerId(farm.id.toString()),
            position: LatLng(farm.referenceLat!, farm.referenceLong!),
            infoWindow: InfoWindow(
              title: farm.name,
              snippet: 'Matrícula: ${farm.matricula}',
              onTap: () {
                // Ao clicar no balãozinho do pino
                _showNavigationOptions(farm);
              },
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Pinos Verdes (Agro)
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Função para abrir GPS externo
  void _showNavigationOptions(PropertyItem farm) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.map, color: Colors.blue),
                title: const Text('Abrir no Google Maps'),
                onTap: () {
                  Navigator.pop(context);
                  _launchMaps(farm.referenceLat!, farm.referenceLong!, 'google');
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_car, color: Colors.indigo),
                title: const Text('Abrir no Waze'),
                onTap: () {
                  Navigator.pop(context);
                  _launchMaps(farm.referenceLat!, farm.referenceLong!, 'waze');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchMaps(double lat, double long, String type) async {
    Uri uri;
    if (type == 'waze') {
      // Esquema do Waze
      uri = Uri.parse("waze://?ll=$lat,$long&navigate=yes");
    } else {
      // Esquema do Google Maps
      uri = Uri.parse("google.navigation:q=$lat,$long");
    }

    try {
      if (!await launchUrl(uri)) {
        // Fallback para abrir no navegador se não tiver o app
        final webUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$long");
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Erro ao abrir mapa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa das Propriedades"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.hybrid, // Satélite + Ruas
              initialCameraPosition: _kBrasil,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                // Se tiver pinos, ajusta o zoom para mostrar todos
                if (_markers.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    // ignore: invalid_use_of_visible_for_testing_member
                    controller.animateCamera(CameraUpdate.newLatLngBounds(_getBounds(_markers), 50));
                  });
                }
              },
              markers: _markers,
              myLocationEnabled: true, // Mostra bolinha azul de onde eu estou
              myLocationButtonEnabled: true,
            ),
    );
  }

  // Função matemática auxiliar para calcular o zoom perfeito
  LatLngBounds _getBounds(Set<Marker> markers) {
    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLong = markers.first.position.longitude;
    double maxLong = markers.first.position.longitude;

    for (var m in markers) {
      if (m.position.latitude < minLat) minLat = m.position.latitude;
      if (m.position.latitude > maxLat) maxLat = m.position.latitude;
      if (m.position.longitude < minLong) minLong = m.position.longitude;
      if (m.position.longitude > maxLong) maxLong = m.position.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    );
  }
}