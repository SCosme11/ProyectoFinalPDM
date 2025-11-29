import 'package:flutter/material.dart';
import 'database.dart';

import 'PantallaRegistro.dart';
import 'PantallaBarometro.dart';
import 'PantallaHistorial.dart';
import 'PantallaLogsSensores.dart';
import 'PantallaMagnetometro.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explorador de Montaña',
      debugShowCheckedModeBanner: false, //Quita la etiqueta de "debug".

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      //RUTAS
      initialRoute: '/',
      routes: {
        '/': (context) => PantallaBienvenida(),
        '/registro': (context) => PantallaRegistro(),
        '/historial': (context) => PantallaHistorial(),
        '/magnetometro': (context) => PantallaMagnetometro(),
        '/barometro': (context) => PantallaBarometro(),
        '/logs': (context) => PantallaLogsSensores(),
      },
    );
  }
}

class PantallaBienvenida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoTrek'),
      ),

      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.terrain, size: 100, color: Colors.green,),
                  SizedBox(height: 20,),
                  Text('¡Bienvenido Explorador!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10,),
                  Text('Selecciona una herramienta para comenzar tu aventura',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 40,),
                  _BotonMenu(
                    texto: 'Nueva Bitácora (Registro)',
                    icono: Icons.edit_note,
                    ruta: '/registro',
                  ),
                  _BotonMenu(
                    texto: 'Historial de Viajes',
                    icono: Icons.history_edu,
                    ruta: '/historial',
                  ),
                  Divider(),
                  _BotonMenu(
                    texto: 'Magnetómetro',
                    icono: Icons.explore,
                    ruta: '/magnetometro'
                  ),
                  _BotonMenu(
                    texto: 'Barómetro',
                    icono: Icons.speed,
                    ruta: '/barometro'
                  ),
                  Divider(),
                  _BotonMenu(
                    texto: 'Datos',
                    icono: Icons.data_usage,
                    ruta: '/logs',
                  )
                ],
              ),
            ),
        ),
      ),
    );
  }
}

class _BotonMenu extends StatelessWidget {
  final String texto;
  final IconData icono;
  final String ruta;
  
  const _BotonMenu({
    required this.texto,
    required this.icono,
    required this.ruta
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
              onPressed: (){
                Navigator.pushNamed(context, ruta);
              }, 
              icon: Icon(icono),
              label: Text(texto, style: TextStyle(fontSize: 16),),
          ),
        ),
    );
  }
}