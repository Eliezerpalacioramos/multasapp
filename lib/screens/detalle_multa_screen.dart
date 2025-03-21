import 'package:flutter/material.dart';
import '../models/multa.dart';

class DetalleMultaScreen extends StatelessWidget {
  final Multa multa;

  DetalleMultaScreen(this.multa);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la Multa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código de Marbete: ${multa.codigoMarbete}'),
            Text('Marca: ${multa.marca}'),
            Text('Modelo: ${multa.modelo}'),
            Text('Color: ${multa.color}'),
            Text('Año: ${multa.anio}'), // Ensure this is 'anio'
            Text('Placa: ${multa.placa}'),
            Text('Chasis: ${multa.chasis}'), // Display the chassis number
            Text('Tipo de Infracción: ${multa.tipoInfraccion}'),
            Text('Fecha y Hora: ${multa.fechaHora.toLocal().toString().split(' ')[0]}'),
            Text('Descripción: ${multa.descripcion}'),
          ],
        ),
      ),
    );
  }
}
