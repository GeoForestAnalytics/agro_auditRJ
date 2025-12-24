import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agro_audit_rj/data/providers/audit_providers.dart';
import 'package:agro_audit_rj/models/audit_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends ConsumerStatefulWidget {
  final int? projectId; 
  const MapScreen({super.key, this.projectId});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  void _updateMarkers(List<AssetItem> assets, List<PropertyItem> properties) {
    _markers.clear();

    // 1. PINOS DE FAZENDAS (SEDE - AZUL)
    for (var prop in properties) {
      if (prop.referenceLat != null && prop.referenceLong != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('prop_${prop.id}'),
            position: LatLng(prop.referenceLat!, prop.referenceLong!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              title: "Sede: ${prop.name}",
              snippet: "Clique para navegar",
              onTap: () => _launchGPS(prop.referenceLat!, prop.referenceLong!),
            ),
          ),
        );
      }
    }

    // 2. PINOS DE COLETA (LOCAL ONDE A FOTO FOI TIRADA - VERDE)
    for (var asset in assets) {
      if (asset.auditLat != null && asset.auditLong != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('asset_${asset.id}'),
            position: LatLng(asset.auditLat!, asset.auditLong!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: "Item: ${asset.description}",
              snippet: "Status: ${asset.status.name.toUpperCase()}",
            ),
          ),
        );
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _launchGPS(double lat, double long) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
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
      LatLngBounds(southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong)), 50
    ));
  }

  @override
  Widget build(BuildContext context) {
    final assetsAsync = widget.projectId != null 
        ? ref.watch(assetsStreamProvider(widget.projectId!))
        : ref.watch(allAssetsStreamProvider);

    final propsAsync = widget.projectId != null
        ? ref.watch(propertiesStreamProvider(widget.projectId!))
        : ref.watch(allPropertiesStreamProvider);

    assetsAsync.whenData((assets) {
      propsAsync.whenData((props) => _updateMarkers(assets, props));
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestão Georreferenciada"),
        actions: [
          IconButton(icon: const Icon(Icons.center_focus_strong), onPressed: _fitBounds),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(target: LatLng(-15.7, -47.8), zoom: 4),
        mapType: MapType.hybrid,
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (c) => _mapController = c,
      ),
    );
  }
}