import 'package:flutter/material.dart';

class PantallaMagnetometro extends StatelessWidget {
  const PantallaMagnetometro({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Magnetómetro')),
      body: const Center(child: Text('Aquí irán los sensores X, Y, Z (Punto 4)')),
    );
  }
}