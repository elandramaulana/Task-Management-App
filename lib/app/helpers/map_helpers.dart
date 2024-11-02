import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// OSMF's Tile Server
const String tileLayerUrl = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";

// request permission to get current device location
Future<LatLng?> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      return null;
    }
  }
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return LatLng(position.latitude, position.longitude);
}

// create marker
Marker createMarker(LatLng point, Color color, double size, IconData icon) {
  return Marker(
    point: point,
    width: size,
    height: size,
    child: Icon(icon, color: color, size: size),
  );
}

// create polyline
Polyline createPolyline(List<LatLng> points, Color color) {
  return Polyline(
    points: points,
    strokeWidth: 4.0,
    color: color,
  );
}
