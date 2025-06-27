import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaSeleccionScreen extends StatefulWidget {
  @override
  _MapaSeleccionScreenState createState() => _MapaSeleccionScreenState();
}

class _MapaSeleccionScreenState extends State<MapaSeleccionScreen> {
  LatLng? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Seleccionar ubicación")),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-17.7833, -63.1821),
          zoom: 13.0,
          onTap: (tapPosition, point) {
            setState(() => _selectedPoint = point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          if (_selectedPoint != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedPoint!,
                  width: 40,
                  height: 40,
                  child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                )
              ],
            ),
        ],
      ),
      floatingActionButton: _selectedPoint != null
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, _selectedPoint);
        },
        label: Text("Confirmar"),
        icon: Icon(Icons.check),
      )
          : null,
    );
  }
}
