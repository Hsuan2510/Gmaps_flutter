import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'directions_repository.dart';

class MapPage3 extends StatefulWidget {
  const MapPage3({Key? key}) : super(key: key);

  @override
  State<MapPage3> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage3> {
  static const LatLng _center = LatLng(48.1536847311587, 11.553155053435953);
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  MapType _currentMapType = MapType.normal;
  final DirectionsRepository _repository = DirectionsRepository();

  void initState() {
    super.initState();
    init();
  }

  void init() {
    _markers.add(
      Marker(
        markerId: MarkerId(_center.toString()),
        position: _center,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Demo'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            markers: _markers,
            onTap: (LatLng position) {
              _addMarker(position); // 在用户点击的位置添加新的标记
            },
            polylines: _polylines,
            mapType: _currentMapType,
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Opacity(
              opacity: 0.8,
              child: FloatingActionButton(
                onPressed: _changeMapType,
                child: const Icon(Icons.map),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addMarker(LatLng position) async {
    setState(() {
      if (_markers.length == 2) {
        _markers.remove(_markers.elementAt(1));
      }
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
      _updatePolyline();
    });
  }

  void _updatePolyline() async {
    _polylines.clear();
    if (_markers.length == 2) {
      LatLng start = _markers.elementAt(0).position;
      LatLng end = _markers.elementAt(1).position;

      Directions? directions = await _repository.getDirections(start, end);
      if (directions != null) {
        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: directions.polyline,
              width: 5,
              color: Colors.black,
            ),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Walk Details'), // 對話框標題
                content: Column( // 對話框內容為列
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total Duration: ${directions.totalDuration}'), // 顯示走路時間
                    Text('Total Distance: ${directions.totalDistance}'), // 顯示走路距離
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        });
      }
    }
  }

  void _changeMapType() {
    setState(() {
      if (_currentMapType == MapType.normal) {
        _currentMapType = MapType.satellite;
      } else if (_currentMapType == MapType.satellite) {
        _currentMapType = MapType.hybrid;
      } else if (_currentMapType == MapType.hybrid) {
        _currentMapType = MapType.terrain;
      } else {
        _currentMapType = MapType.normal;
      }
    });
  }
}
