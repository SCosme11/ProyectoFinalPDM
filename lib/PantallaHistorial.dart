import 'package:flutter/material.dart';

class PantallaHistorial extends StatelessWidget {
  const PantallaHistorial({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Bitácoras')),
      body: const Center(child: Text('Aquí irá la lista de SQLite (Punto 3)')),
    );
  }
}