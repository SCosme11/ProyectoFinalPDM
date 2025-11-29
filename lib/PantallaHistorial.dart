import 'package:flutter/material.dart';
import 'database.dart';

class PantallaHistorial extends StatefulWidget {
  @override
  State<PantallaHistorial> createState() => _PantallaHistorialState();
}

class _PantallaHistorialState extends State<PantallaHistorial> {
  late Future<List<Map<String, dynamic>>> _listaViajes;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    setState(() {
      _listaViajes = AdministradorBaseDatos.instancia.obtenerBitacoras();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HISTORIAL DE EXPEDICIONES'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _listaViajes,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError){
              return Center(child: Text("Error al cargar datos: ${snapshot.error}"));
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off, size: 80, color: Colors.white24),
                    SizedBox(height: 20),
                    Text("No hay expediciones registradas", style: TextStyle(color: Colors.white54)),
                  ],
                ),
              );
            }

            final viajes = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: viajes.length,
              itemBuilder: (context, index) {
                final viaje = viajes[index];
                return _TarjetaViaje(viaje: viaje);
              },
            );
          }
      ),
    );
  }
}

class _TarjetaViaje extends StatelessWidget {
  final Map<String, dynamic> viaje;

  const _TarjetaViaje({required this.viaje});

  @override
  Widget build(BuildContext context) {
    final colorAcento = Theme.of(context).primaryColor;
    final colorFondoTarjeta = Theme.of(context).cardColor;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: colorFondoTarjeta,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white10),
      ),
      elevation: 4,
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                        viaje['nombre_ruta'] ?? 'Sin Nombre',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorAcento.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      viaje['fecha_viaje'] ?? 'S/F',
                      style: TextStyle(
                        color: colorAcento,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              Divider(color: Colors.white12),
              SizedBox(height: 12),
              Row(
                children: [
                _DatoIcono(
                  icono: Icons.straighten,
                  valor: "${viaje['distancia_km']} km",
                  etiqueta: "Distancia",
                ),
                  SizedBox(width: 20),
                  _DatoIcono(
                    icono: Icons.cloud,
                    valor: viaje['clima'] ?? '-',
                    etiqueta: "Clima",
                  ),
                ],
              ),
              SizedBox(height: 15),
              if(viaje['telefono_emergencia'] != null && viaje['telefono_emergencia'].toString().isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.phone_in_talk, size: 16, color: Colors.white54,),
                    SizedBox(width: 8),
                    Text(
                      "Emergencia: ${viaje['telefono_emergencia']}",
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),

            ],
          ),
      ),
    );
  }
}

class _DatoIcono extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;

  const _DatoIcono({
   required this.icono,
   required this.valor,
   required this.etiqueta
});

  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        Icon(icono, color: Colors.white70, size: 20),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(valor,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
            ),
            Text(etiqueta,
              style: TextStyle(color: Colors.white38, fontSize: 11),
            )
          ],
        )
      ],
    );
  }
}
