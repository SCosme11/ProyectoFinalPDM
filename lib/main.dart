import 'package:flutter/material.dart';
import 'database.dart';

import 'PantallaRegistro.dart';
import 'PantallaBarometro.dart';
import 'PantallaHistorial.dart';
import 'PantallaLogsSensores.dart';
import 'PantallaMagnetometro.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Color colorFondo = Color(0xFF121212);
  Color colorTarjetas = Color(0xFF1E1E1E);
  Color colorAcentado = Color(0xFFFF6D00);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explorador de Montaña',
      debugShowCheckedModeBanner: false, //Quita la etiqueta de "debug".

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: colorFondo,
        primaryColor: colorAcentado,
        colorScheme: ColorScheme.dark(
          primary: colorAcentado,
          secondary: colorAcentado,
          surface: colorTarjetas,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colorFondo,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
          iconTheme: IconThemeData(color: colorAcentado),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorTarjetas,
            foregroundColor: colorAcentado,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: colorAcentado.withOpacity(0.3), width: 1)
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20)
          )
        )
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('ECOTREK'),
        backgroundColor: Colors.transparent,
      ),

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/main.jpg'),
                  fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
              ),
            ),
          ),
          SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 120),
                      Text(
                        'BIENVENIDO\nEXPLORADOR.',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Las cumbres más altas del mundo esperan. Registra tu ascenso, monitorea el entorno y conquista tus límites.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 60),

                      const Divider(color: Color(0xFFFF6D00)),
                      const SizedBox(height: 20),


                      _BotonMenu(
                        texto: 'Nueva Bitácora',
                        subtexto: 'Registra una nueva expedición.',
                        icono: Icons.add_location_alt_outlined,
                        ruta: '/registro',
                        esPrincipal: true,
                      ),
                      const SizedBox(height: 15),
                      _BotonMenu(
                        texto: 'Historial de Viajes',
                        subtexto: 'Revisa tus conquistas anteriores.',
                        icono: Icons.history,
                        ruta: '/historial',
                      ),
                      const SizedBox(height: 30),
                      const Text("HERRAMIENTAS DE CAMPO", style: TextStyle(color: Color(0xFFFF6D00), letterSpacing: 1.2)),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                              child: _BotonHerramienta(
                                  texto: 'Brújula',
                                  icono: Icons.explore_outlined,
                                  ruta: '/magnetometro'
                              )
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                              child: _BotonHerramienta(
                                  texto: 'Altímetro',
                                  icono: Icons.speed_outlined,
                                  ruta: '/barometro'
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _BotonMenu(
                        texto: 'Centro de Datos (Logs)',
                        subtexto: 'Datos crudos de sensores.',
                        icono: Icons.data_usage,
                        ruta: '/logs',
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}

class _BotonMenu extends StatelessWidget {
  final String texto;
  final String subtexto;
  final IconData icono;
  final String ruta;
  final bool esPrincipal;
  
  const _BotonMenu({
    required this.texto,
    required this.subtexto,
    required this.icono,
    required this.ruta,
    this.esPrincipal = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorNaranja = theme.primaryColor;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, ruta),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: esPrincipal ? colorNaranja.withOpacity(0.1) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: esPrincipal ? colorNaranja : Colors.white12,
            width: 1
          ),
        ),
        child: Row(
          children: [
            Icon(icono, color: esPrincipal ? colorNaranja : Colors.white70, size: 30,),
            SizedBox(width: 16,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(texto, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: esPrincipal ? Colors.white : Colors.white70),),
                    Text(subtexto, style: TextStyle(fontSize: 12, color: Colors.white38),),
                  ],
                ),
            ),
            Icon(Icons.arrow_forward_ios, color: esPrincipal ? colorNaranja : Colors.white30, size: 16,),
          ],
        ),
      ),
    );
  }
}

class _BotonHerramienta extends StatelessWidget {
  final String texto;
  final IconData icono;
  final String ruta;

  const _BotonHerramienta({super.key, required this.texto, required this.icono, required this.ruta});

  @override
  Widget build(BuildContext context) {
    final colorNaranja = Theme.of(context).primaryColor;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ruta),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12)
        ),
        child: Column(
          children: [
            Icon(icono, color: colorNaranja, size: 28),
            const SizedBox(height: 10),
            Text(texto, style: const TextStyle(color: Colors.white70))
          ],
        ),
      ),
    );
  }
}