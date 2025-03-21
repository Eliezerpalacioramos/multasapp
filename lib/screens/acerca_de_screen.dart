import 'package:flutter/material.dart';

class AcercaDeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/agente.jpg'), // Agrega una imagen en assets
            ),
            SizedBox(height: 20),
            Text('Nombre: Eliezer Palacio Ramos'),
            Text('Matrícula: 2023-1009'),
            SizedBox(height: 20),
            Text('"La seguridad vial es responsabilidad de todos."'),
          ],
        ),
      ),
    );
  }
}
