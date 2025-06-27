import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lugar.dart';
import '../Screens/MapaSeleccionScreen.dart';
import 'package:latlong2/latlong.dart';

class AgregarLugarScreen extends StatefulWidget {
  @override
  _AgregarLugarScreenState createState() => _AgregarLugarScreenState();
}

class _AgregarLugarScreenState extends State<AgregarLugarScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  List<File> _fotos = [];

  // Campos del formulario
  String nombre = "";
  String descripcion = "";
  int cantPersonas = 1;
  int cantCamas = 1;
  int cantBanios = 1;
  int cantHabitaciones = 1;
  bool tieneWifi = false;
  int cantVehiculosParqueo = 0;
  String precioNoche = "";
  String costoLimpieza = "";
  String ciudad = "";
  String latitud = "-17.78";
  String longitud = "-63.18";

  Future<void> _pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _fotos = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> _guardarLugar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("ID guardado: ${prefs.getInt('id')}"); // → debe mostrar un número
      int? arrendatarioId = prefs.getInt('id');

      if (arrendatarioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario no autenticado")),
        );
        return;
      }

      Lugar nuevoLugar = Lugar(
        nombre: nombre,
        descripcion: descripcion,
        cantPersonas: cantPersonas,
        cantCamas: cantCamas,
        cantBanios: cantBanios,
        cantHabitaciones: cantHabitaciones,
        tieneWifi: tieneWifi,
        cantVehiculosParqueo: cantVehiculosParqueo,
        precioNoche: precioNoche,
        costoLimpieza: costoLimpieza,
        ciudad: ciudad,
        latitud: latitud,
        longitud: longitud,
        arrendatarioId: arrendatarioId,
      );

      final lugarResponse = await http.post(
        Uri.parse("https://261d-200-87-196-6.ngrok-free.app/api/lugares"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(nuevoLugar.toJson()),
      );

      if (lugarResponse.statusCode == 200 || lugarResponse.statusCode == 201) {
        final lugarData = jsonDecode(lugarResponse.body);
        final int lugarId = lugarData['id'];

        // Subir fotos si hay
        for (File foto in _fotos) {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse("https://261d-200-87-196-6.ngrok-free.app/api/lugares/$lugarId/foto"),
          );
          request.files.add(
            await http.MultipartFile.fromPath('foto', foto.path),
          );
          await request.send();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lugar agregado exitosamente")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar el lugar")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Lugar")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nombre"),
                onSaved: (value) => nombre = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Descripción"),
                onSaved: (value) => descripcion = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Ciudad"),
                onSaved: (value) => ciudad = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Precio por noche"),
                keyboardType: TextInputType.number,
                onSaved: (value) => precioNoche = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Costo de limpieza"),
                keyboardType: TextInputType.number,
                onSaved: (value) => costoLimpieza = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Cantidad de personas"),
                keyboardType: TextInputType.number,
                onSaved: (value) => cantPersonas = int.tryParse(value!) ?? 1,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Cantidad de camas"),
                keyboardType: TextInputType.number,
                onSaved: (value) => cantCamas = int.tryParse(value!) ?? 1,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Cantidad de baños"),
                keyboardType: TextInputType.number,
                onSaved: (value) => cantBanios = int.tryParse(value!) ?? 1,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Cantidad de habitaciones"),
                keyboardType: TextInputType.number,
                onSaved: (value) => cantHabitaciones = int.tryParse(value!) ?? 1,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Cantidad de vehículos en parqueo"),
                keyboardType: TextInputType.number,
                onSaved: (value) => cantVehiculosParqueo = int.tryParse(value!) ?? 0,
              ),
              SwitchListTile(
                title: Text("¿Tiene Wifi?"),
                value: tieneWifi,
                onChanged: (val) => setState(() => tieneWifi = val),
              ),
              ElevatedButton(
                onPressed: () async {
                  LatLng? punto = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapaSeleccionScreen()),
                  );

                  if (punto != null) {
                    setState(() {
                      latitud = punto.latitude.toString();
                      longitud = punto.longitude.toString();
                    });
                  }
                },
                child: Text("Poner marcador en el mapa"),
              ),
              if (latitud.isNotEmpty && longitud.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text("Ubicación: $latitud, $longitud"),
                ),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text("Seleccionar fotos (${_fotos.length})"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarLugar,
                child: Text("Guardar Lugar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
