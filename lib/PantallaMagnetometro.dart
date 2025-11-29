import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'database.dart';

class PantallaMagnetometro extends StatefulWidget {
  @override 
  State<PantallaMagnetometro> createState() => _PantallaMagnetometroState();
}

class _PantallaMagnetometroState extends State<PantallaMagnetometro> {
  double _x = 0, _y = 0, _z = 0;
  
  StreamSubscription<MagnetometerEvent>? _streamSubscription;
  
  @override
  void initState(){
    super.initState();
    _iniciarSensor();
  }
  
  @override
  void dispose() { //Sirve para no gastar bateria
    _streamSubscription?.cancel();
    super.dispose();
  }
  
  void _iniciarSensor() {
    _streamSubscription = magnetometerEventStream().listen((MagnetometerEvent event){
      if(mounted){
        setState(() {
          _x = event.x;
          _y = event.y;
          _z = event.z;
        });
      }
    });
  }
  
  void _guardarLectura() async {
    await AdministradorBaseDatos.instancia.insertarMagnetometro(_x, _y, _z);
    
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Row(
              children: [
                Icon(Icons.save, color: Colors.white),
                SizedBox(width: 10),
                Text('Coordenada guardada', style: TextStyle(color: Colors.white)),
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
        title: Text('BRÚJULA DIGITAL'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, size: 80, color: Colors.white24),
            SizedBox(height: 20),
            Text("Sensor Magnetómetro",
              style: TextStyle(color: Colors.white54, fontSize: 16, letterSpacing: 1.5),
            ),
            SizedBox(height: 40),
            _TarjetaValor(eje: "X", valor: _x, color: Colors.redAccent),
            SizedBox(height: 15),
            _TarjetaValor(eje: "Y", valor: _y, color: Colors.greenAccent),
            SizedBox(height: 15),
            _TarjetaValor(eje: "Z", valor: _z, color: Colors.blueAccent),
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                  onPressed: _guardarLectura, 
                  icon: Icon(Icons.save_as),
                  label: Text("GUARDAR LECTURA ACTUAL"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAcento,
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
              ),
            ),
            SizedBox(height: 20),
            Text("Apunta hacia el norte magnético para calibrar",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

class _TarjetaValor extends StatelessWidget {
  final String eje;
  final double valor;
  final Color color;
  
  const _TarjetaValor({
   required this.eje,
   required this.valor,
   required this.color
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              eje,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Text(
            valor.toStringAsFixed(2),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w300,
              fontFamily: 'Courier',
            ),
          ),
          Text("µT", style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }
}