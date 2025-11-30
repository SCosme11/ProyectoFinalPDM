import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'database.dart';

class PantallaBarometro extends StatefulWidget {

  @override
  State<PantallaBarometro> createState() => _PantallaBarometroState();
}

class _PantallaBarometroState extends State<PantallaBarometro> {
  double _presion = 0.0;

  StreamSubscription<BarometerEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _iniciarBarometro();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _iniciarBarometro() {
    _subscription = barometerEventStream().listen(
        (BarometerEvent event) {
          if(mounted){
            setState(() {
              _presion = event.pressure;
            });
          }
        },
      onError: (error) {
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sensor de barómetro no detectado/disponible')),
            );
          }
      },
    );
  }

  void _guardarPresion() async {
    await AdministradorBaseDatos.instancia.insertarBarometro(_presion);

    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Row(
              children: [
                Icon(Icons.cloud_upload, color: Colors.white),
                SizedBox(width: 10),
                Text('Presión atmosférica registrada', style: TextStyle(color: Colors.white)),
              ],
            ),
          backgroundColor: Color(0xFF1E1E1E),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorAcento = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('MONITOR ATMOSFÉRICO'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.speed, size: 80, color: Colors.white24),
            SizedBox(height: 20),
            Text("Presión Barométrica", style: TextStyle(color: Colors.white54, fontSize: 16, letterSpacing: 1.5)),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorAcento.withOpacity(0.5),
                  width: 3
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorAcento.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _presion.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text("hPa",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white38,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                  onPressed: _guardarPresion,
                  icon: Icon(Icons.save),
                  label: Text("GUARDAR PRESIÓN ACTUAL"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAcento,
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
              ),
            ),
            SizedBox(height: 20),
            Text("Nota: Requiere sensor físico de barómetro.",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}