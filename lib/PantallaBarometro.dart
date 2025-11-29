import 'package:flutter/material.dart';

class PantallaBarometro extends StatelessWidget {
  const PantallaBarometro({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barómetro')),
      body: const Center(child: Text('Aquí irá la presión (Punto 5)')),
    );
  }
}