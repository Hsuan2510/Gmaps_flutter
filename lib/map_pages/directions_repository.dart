import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository { // 路線信息存儲庫
  final Dio _dio = Dio(); // get the directions from the Google Maps Directions API
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json'; // Google Maps Directions API URL

  Future<Directions?> getDirections(LatLng origin, LatLng destination) async { //
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': 'AIzaSyAn-Dx8xBKOEodyVemjCPrkNQRyt0CAgvE', // Google Maps Directions API key
          'mode': 'walking', //
        },
      );

      if (response.statusCode == 200) {
        return Directions.fromMap(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class Directions {
  final List<LatLng> polyline;
  final String totalDuration; // 總時間
  final String totalDistance; // 總距離

  Directions({
    required this.polyline,
    required this.totalDuration,
    required this.totalDistance,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    final List<LatLng> polyline = _decodePolyline(map['routes'][0]['overview_polyline']['points']);
    final String totalDuration = _extractTotalDuration(map);
    final String totalDistance = _extractTotalDistance(map);
    return Directions(polyline: polyline, totalDuration: totalDuration, totalDistance: totalDistance);
  }

  // 提取總時間的方法
  static String _extractTotalDuration(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) return '';
    final data = Map<String, dynamic>.from(map['routes'][0]);
    if ((data['legs'] as List).isEmpty) return '';
    final leg = data['legs'][0];
    return leg['duration']['text'];
  }
  static String _extractTotalDistance(Map<String, dynamic> map) {
    if ((map['routes'] as List).isEmpty) return '';
    final data = Map<String, dynamic>.from(map['routes'][0]);
    if ((data['legs'] as List).isEmpty) return '';
    final leg = data['legs'][0];
    return leg['distance']['text'];
  }
  static List<LatLng> _decodePolyline(String encoded) {
    // 解碼多段線字符串
    List<LatLng> points = <LatLng>[];
    int index = 0;
    int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latlng = lat / 1E5;
      double lnglng = lng / 1E5;

      LatLng position = LatLng(latlng, lnglng);
      points.add(position);
    }

    return points;
  }
}
