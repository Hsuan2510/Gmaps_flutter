import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage2 extends StatefulWidget {
  const MapPage2({Key? key}) : super(key: key);

  @override
  State<MapPage2> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage2> {
  static const LatLng _center = LatLng(48.1536847311587, 11.553155053435953);
  Set<Marker> _markers = {}; // 改为可变集合以便添加新标记
  Set<Polyline> _polylines = {}; // 改为可变集合以便添加新多段线
  MapType _currentMapType = MapType.normal; // 地图类型

  //一開始要有個初始化
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
            child: Opacity(opacity: 0.8,
              child: FloatingActionButton(
              onPressed: _changeMapType,// 切換地圖類型
              child: const Icon(Icons.map),
            ),)
          ),
        ],
      ),
    );
  }
  void _addMarker(LatLng position) {
    setState(() {
      // 添加新的标记到集合中
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
  void _updatePolyline() {
    // clear the existing polyline
    _polylines.clear();
    // if there are two markers, draw a polyline between them
    if (_markers.length == 2) {
      LatLng start = _markers.elementAt(0).position;
      LatLng end = _markers.elementAt(1).position;
      // add a polyline with two points
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [start, end],
          width: 5,
          color: Colors.black,
        ),
      );
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


