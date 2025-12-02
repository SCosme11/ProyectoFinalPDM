import 'package:flutter/material.dart';
import 'database.dart';

class PantallaLogsSensores extends StatefulWidget {

  @override
  State<PantallaLogsSensores> createState() => _PantallaLogsSensoresState();
}

class _PantallaLogsSensoresState extends State<PantallaLogsSensores> {
  late Future<List<List<Map<String, dynamic>>>> _futureDatos;

  @override
  void initState() {
    super.initState();
    _cargarLogs();
  }

  void _cargarLogs() {
    setState(() {
      _futureDatos = Future.wait([
        AdministradorBaseDatos.instancia.obtenerMagnetometro(),
        AdministradorBaseDatos.instancia.obtenerBarometro(),
      ]);
    });
  }

  void _confirmarBorrado(int id, bool esMagnetometro){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("¿Borrar lectura?", style: TextStyle(color: Colors.white)),
            content: Text("¿Deseas eliminar este registro del sensor?", style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                  child: Text("CANCELAR", style: TextStyle(color: Colors.white54)),
                  onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                  child: Text("BORRAR", style: TextStyle(color: Colors.redAccent)),
                  onPressed: () async {
                    if(esMagnetometro){
                      await AdministradorBaseDatos.instancia.eliminarMagnetometro(id);
                    }else {
                      await AdministradorBaseDatos.instancia.eliminarBarometro(id);
                    }
                    Navigator.of(context).pop();
                    _cargarLogs();
                  },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('CENTRO DE DATOS (LOGS)'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _cargarLogs,
          )
        ],
      ),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
          future: _futureDatos,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }else if(snapshot.hasData){
              final logsMagnetometro = snapshot.data![0];
              final logsBarometro = snapshot.data![1];

              return OrientationBuilder(
                  builder: (context, orientation) {
                    final listaMag = _SeccionSensor(
                      titulo: "Historial Magnetómetro",
                      icono: Icons.explore,
                      colorIcono: Colors.redAccent,
                      datos: logsMagnetometro,
                      esMagnetometro: true,
                      onDelete:(id) => _confirmarBorrado(id, true),
                    );

                    final listaBar = _SeccionSensor(
                      titulo: "Historial Barómetro",
                      icono: Icons.speed,
                      colorIcono: Colors.blueAccent,
                      datos: logsBarometro,
                      esMagnetometro: false,
                      onDelete: (id) => _confirmarBorrado(id, false),
                    );

                    if(orientation == Orientation.portrait) {
                      return Column(
                        children: [
                          Expanded(child: listaMag),
                          Divider(height: 1, color: Colors.white24),
                          Expanded(child: listaBar),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(child: listaMag),
                          VerticalDivider(width: 1, color: Colors.white24),
                          Expanded(child: listaBar),
                        ],
                      );
                    }
                  },
              );
            } else {
              return Center(child: Text("No hay datos disponibles"),);
            }
          }
      ),
    );
  }
}

class _SeccionSensor extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color colorIcono;
  final List<Map<String, dynamic>> datos;
  final bool esMagnetometro;
  final Function(int) onDelete;

  const _SeccionSensor({
    required this.titulo,
    required this.icono,
    required this.colorIcono,
    required this.datos,
    required this.esMagnetometro,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            color: Color(0xFF1E1E1E),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icono, color: colorIcono, size: 20),
                SizedBox(width: 10),
                Text(
                  titulo,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: datos.isEmpty ? Center(
                child: Text("Sin registros", style: TextStyle(color: Colors.white24)),
              ) : ListView.builder(
                  itemCount: datos.length,
                  itemBuilder: (context, index) {
                    final item = datos[index];
                    final fechaRaw = item['tiempo'] ?? item['marca_tiempo'];
                    final fecha = fechaRaw != null ? fechaRaw.toString().split('.')[0].replaceAll('T', ' ') : 'S/F';

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Color(0xFF2C2C2C),
                      child: ListTile(
                        leading: Icon(Icons.data_array, color: colorIcono.withOpacity(0.5), size: 18),
                        title: esMagnetometro ? Text("X: ${item['x'].toStringAsFixed(1)} | Y: ${item['y'].toStringAsFixed(1)} | Z: ${item['z'].toStringAsFixed(1)}",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Courier'),
                        ) : Text("${item['presion'].toStringAsFixed(1)} hPa",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(fecha, style: TextStyle(color: Colors.white38, fontSize: 11)),
                        dense: true,
                        trailing: IconButton(
                            icon: Icon(Icons.close, color: Colors.white24, size: 18),
                            onPressed: () => onDelete(item['id']),
                        ),
                      ),
                    );
                  }
              )
          )
        ],
      ),
    );
  }
}