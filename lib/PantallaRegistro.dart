import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //formato de fecha
import 'database.dart';

class PantallaRegistro extends StatefulWidget{
  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  //Clave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  //Controladores
  final TextEditingController _rutaController = TextEditingController();
  final TextEditingController _climaController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  //Seleccionar fecha
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1960),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                  surface: Color(0xFF1E1E1E),
                  onSurface: Colors.white,
                )
              ),
              child: child!,
          );
        },
    );

    if(picked != null){
      setState(() {
        _fechaController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  //Guardamos en la BD
  void _guardarDatos() async {
    if(_formKey.currentState!.validate()){
      Map<String, dynamic> nuevaBitacora = {
        'nombre_ruta': _rutaController.text,
        'clima': _climaController.text,
        'distancia_km': double.parse(_distanciaController.text),
        'telefono_emergencia': _telefonoController.text,
        'fecha_viaje': _fechaController.text,
      };

      await AdministradorBaseDatos.instancia.insertarBitacora(nuevaBitacora);

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                  SizedBox(width: 10),
                  Text('Bitácora registrada con éxito'),
                ],
              ),
            backgroundColor: Color(0xFF1E1E1E),
          ),
        );
        Navigator.pop(context); //Regresa menú principal
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorAcento = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('NUEVA BITÁCORA'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Detalles de la Expedición",
                  style: TextStyle(color: Colors.white54, fontSize: 24, letterSpacing: 1.0),
                ),
                SizedBox(height: 20),
                _crearInput(
                  controller: _rutaController,
                  label: "Nombre de la Ruta/Montaña",
                  icon: Icons.landscape,
                  keyboard: TextInputType.text,
                ),
                SizedBox(height: 15),
                _crearInput(
                    controller: _climaController,
                    label: "Condición Climática",
                    icon: Icons.cloud,
                    keyboard: TextInputType.text,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        child: _crearInput(
                            controller: _distanciaController,
                            label: "Distancia",
                            icon: Icons.straighten,
                            keyboard: TextInputType.numberWithOptions(decimal: true),
                        ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: GestureDetector(
                          onTap: () => _seleccionarFecha(context),
                          child: AbsorbPointer(
                            child: _crearInput(
                                controller: _fechaController,
                                label: "Fecha",
                                icon: Icons.calendar_today,
                                keyboard: TextInputType.datetime,
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                _crearInput(
                    controller: _telefonoController,
                    label: "Teléfono de Emergencia",
                    icon: Icons.phone_outlined,
                    keyboard: TextInputType.phone,
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                    onPressed: _guardarDatos,
                    icon: Icon(Icons.save_alt),
                    label: Text("REGISTRAR EN BITÁCORA"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorAcento,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                )
              ],
            )
        ),
      ),
    );

  }
}

Widget _crearInput(
{
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required TextInputType keyboard,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboard,
    style: TextStyle(color: Colors.white),
    validator: (value) {
      if(value == null || value.isEmpty){
        return 'Este campo es obligatorio';
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white54),
      filled: true,
      fillColor: Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFFF6D00)),
      )
    ),
  );
}
