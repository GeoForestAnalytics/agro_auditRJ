import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_audit_rj/data/providers/audit_providers.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:agro_audit_rj/features/audit/asset_detail_screen.dart';
import 'package:agro_audit_rj/features/audit/property_detail_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  final int? projectId; // Nulo = Mapa Geral | Com ID = Mapa do Projeto
  const MapScreen({super.key, this.projectId});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  static const CameraPosition _kBrasil = CameraPosition(
    target: LatLng(-15.7942, -47.8822),
    zoom: 4,
  );

  void _updateMarkers(List<AssetItem> assets, List<PropertyItem> properties) {
    _markers.clear();

    // 1. PINOS DAS FAZENDAS (AZUL)
    for (var prop in properties) {
      if (prop.referenceLat != null && prop.referenceLong != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('prop_${prop.id}'),
            position: LatLng(prop.referenceLat!, prop.referenceLong!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              title: "🏠 ${prop.name}",
              snippet: "Ver detalhes da propriedade",
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => PropertyDetailScreen(item: prop)
              )),
            ),
          ),
        );
      }
    }

    // 2. PINOS DOS BENS ENCONTRADOS (VERDE / VERMELHO)
    for (var asset in assets) {
      if (asset.auditLat != null && asset.auditLong != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('asset_${asset.id}'),
            position: LatLng(asset.auditLat!, asset.auditLong!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              asset.status == AuditStatus.found ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed
            ),
            infoWindow: InfoWindow(
              title: "🚜 ${asset.description}",
              snippet: "Série: ${asset.serialNumber ?? 'N/A'}",
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => AssetDetailScreen(item: asset)
              )),
            ),
          ),
        );
      }
    }
    setState(() {});
  }

  void _fitBounds() {
    if (_markers.isEmpty) return;
    double minLat = 90.0, maxLat = -90.0, minLong = 180.0, maxLong = -180.0;
    for (var m in _markers) {
      if (m.position.latitude < minLat) minLat = m.position.latitude;
      if (m.position.latitude > maxLat) maxLat = m.position.latitude;
      if (m.position.longitude < minLong) minLong = m.position.longitude;
      if (m.position.longitude > maxLong) maxLong = m.position.longitude;
    }
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong)), 
      50
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Seleção de dados baseada no contexto (Geral vs Projeto)
    final assetsAsync = widget.projectId != null 
      ? ref.watch(assetsStreamProvider(widget.projectId!))
      : ref.watch(allAssetsStreamProvider);

    final propsAsync = widget.projectId != null
      ? ref.watch(propertiesStreamProvider(widget.projectId!))
      : ref.watch(allPropertiesStreamProvider);

    // Monitora mudanças nos dados e atualiza os marcadores
    assetsAsync.whenData((assets) {
      propsAsync.whenData((props) {
        _updateMarkers(assets, props);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectId != null ? "Navegação da Vistoria" : "Mapa Geral de Ativos"),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(icon: const Icon(Icons.center_focus_strong), onPressed: _fitBounds),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _kBrasil,
        mapType: MapType.hybrid,
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          _mapController = controller;
          // Aguarda um pouco para o banco carregar e centraliza
          Future.delayed(const Duration(milliseconds: 800), _fitBounds);
        },
      ),
    );
  }
}