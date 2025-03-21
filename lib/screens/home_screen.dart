import 'package:flutter/material.dart';
import 'acerca_de_screen.dart'; // Import AcercaDeScreen

import 'package:provider/provider.dart';
import '../providers/multa_provider.dart';
import 'registro_multa_screen.dart';
import 'detalle_multa_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final multaProvider = Provider.of<MultaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Multas'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              multaProvider.borrarTodasLasMultas();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset('assets/semaforo.jpg', width: 100, height: 100), // Add the image here
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AcercaDeScreen()),
              );
            },
            child: Text('Acerca de'), // Button to navigate to AcercaDeScreen

          ),

          Expanded(
            child: ListView.builder(
              itemCount: multaProvider.multas.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(multaProvider.multas[i].placa),
                subtitle: Text(multaProvider.multas[i].tipoInfraccion),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleMultaScreen(multaProvider.multas[i]),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistroMultaScreen()),
          );
        },
      ),
    );
  }
}
