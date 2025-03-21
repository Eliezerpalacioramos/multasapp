import 'package:flutter/material.dart';

class FotoAudioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {
            // Lógica para tomar fotos
          },
        ),
        IconButton(
          icon: Icon(Icons.mic),
          onPressed: () {
            // Lógica para grabar audio
          },
        ),
      ],
    );
  }
}
