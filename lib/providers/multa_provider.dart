import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/multa.dart';

class MultaProvider with ChangeNotifier {
  List<Multa> _multas = [];
  String marcaVehiculo = '';
  String modeloVehiculo = '';
  String colorVehiculo = '';
  int anioVehiculo = 0;
  String placaVehiculo = '';
  String chasisVehiculo = '';

  List<Multa> get multas => _multas;

  final List<String> infracciones = [
    'Exceso de velocidad',
    'Estacionamiento en lugar prohibido',
    'No usar el cinturón de seguridad',
    'Conducir bajo los efectos del alcohol',
    'No respetar las señales de tránsito',
    'Uso del teléfono móvil mientras se conduce',
    'No llevar luces encendidas en horarios establecidos',
    'Conducir sin licencia',
    'No respetar el semáforo en rojo',
    'No ceder el paso a peatones',
    'Cambio de carril sin señalización',
    'Conducir en sentido contrario',
    'Transportar más pasajeros de los permitidos',
    'No portar el seguro obligatorio',
    'No portar la documentación del vehículo',
    'No respetar los límites de carga permitidos',
    'Conducir sin placas o con placas alteradas',
    'No respetar la prioridad de paso',
    'No usar casco (en el caso de motociclistas)',
    'Arrojar basura o objetos desde el vehículo',
  ];

  Future<void> buscarDatosVehiculo(String codigoMarbete) async {
    final url = Uri.parse('https://api.adamix.net/itla.php?m=$codigoMarbete');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['error'] != null && data['error'].isNotEmpty) {
        throw Exception(data['error']);
      }

      // Asignar los datos del vehículo
      marcaVehiculo = data['marca'];
      modeloVehiculo = data['modelo'];
      colorVehiculo = data['color'];
      anioVehiculo = int.parse(data['anio']);
      placaVehiculo = data['placa'];
      chasisVehiculo = data['chasis'];

      notifyListeners();
    } else {
      throw Exception('Error al obtener los datos del vehículo');
    }
  }

  Future<void> agregarMulta(Multa multa) async {
    _multas.add(multa);
    notifyListeners();
  }

  void borrarTodasLasMultas() {
    _multas.clear();
    notifyListeners();
  }
}
