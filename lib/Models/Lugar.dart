class Lugar {
  final int? id;
  final String nombre;
  final String descripcion;
  final int cantPersonas;
  final int cantCamas;
  final int cantBanios;
  final int cantHabitaciones;
  final bool tieneWifi;
  final int cantVehiculosParqueo;
  final String precioNoche;
  final String costoLimpieza;
  final String ciudad;
  final String latitud;
  final String longitud;
  final int arrendatarioId;

  Lugar({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.cantPersonas,
    required this.cantCamas,
    required this.cantBanios,
    required this.cantHabitaciones,
    required this.tieneWifi,
    required this.cantVehiculosParqueo,
    required this.precioNoche,
    required this.costoLimpieza,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
    required this.arrendatarioId,
  });

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      cantPersonas: json['cantPersonas'],
      cantCamas: json['cantCamas'],
      cantBanios: json['cantBanios'],
      cantHabitaciones: json['cantHabitaciones'],
      tieneWifi: json['tieneWifi'] == 1,
      cantVehiculosParqueo: json['cantVehiculosParqueo'],
      precioNoche: json['precioNoche'].toString(),
      costoLimpieza: json['costoLimpieza'].toString(),
      ciudad: json['ciudad'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      arrendatarioId: json['arrendatario_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "descripcion": descripcion,
      "cantPersonas": cantPersonas,
      "cantCamas": cantCamas,
      "cantBanios": cantBanios,
      "cantHabitaciones": cantHabitaciones,
      "tieneWifi": tieneWifi ? 1 : 0,
      "cantVehiculosParqueo": cantVehiculosParqueo,
      "precioNoche": precioNoche,
      "costoLimpieza": costoLimpieza,
      "ciudad": ciudad,
      "latitud": latitud,
      "longitud": longitud,
      "arrendatario_id": arrendatarioId,
    };
  }
}
