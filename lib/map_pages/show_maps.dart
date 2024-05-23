import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _center = LatLng(48.1536847311587, 11.553155053435953);

  late GoogleMapController _googleMapController;
  BitmapDescriptor? _customMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    final BitmapDescriptor customMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 10)), // Adjust the size as needed
      'asset/image/thumb-down.png',
    );
    setState(() {
      _customMarker = customMarker;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;

    if (_customMarker != null) {
      _googleMapController.showMarkerInfoWindow(const MarkerId('_customMarker'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Demo'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _center,
          zoom: 13.0,
        ),
        onMapCreated: _onMapCreated,
        markers: _customMarker == null
            ? {
          Marker(
            markerId: const MarkerId('_currentLocation'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: _center,
          ),
        }
            : {
          // Marker(
          //   markerId: const MarkerId('_currentLocation'),
          //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          //   position: _center,
          // ),
          Marker(
            markerId: const MarkerId('_customMarker'),
            icon: _customMarker!,
            position: _center,
            infoWindow: const InfoWindow(title: 'Custom Marker', snippet: 'This is a custom marker'),
          ),
        },
      ),
    );
  }
}
