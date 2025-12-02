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

  // --- LÓGICA DE VALIDACIÓN PERSONALIZADA ---

  String? _validarDistancia(String? value) {
    if (value == null || value.isEmpty) {
      return 'Obligatorio';
    }
    // Intentar convertir a número
    final numero = double.tryParse(value);
    if (numero == null) {
      return 'Solo números';
    }
    if (numero <= 0) {
      return '> 0';
    }
    return null;
  }

  String? _validarTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'Obligatorio';
    }
    // Expresión regular para permitir solo números (entre 7 y 15 dígitos)
    final regex = RegExp(r'^[0-9]{7,15}$');
    if (!regex.hasMatch(value)) {
      return 'Número inválido (7-15 dígitos)';
    }
    return null;
  }

  String? _validarGenerico(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
  // -------------------------------------------

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
    // Esto activa todos los validadores definidos arriba
    if(_formKey.currentState!.validate()){

      try {
        Map<String, dynamic> nuevaBitacora = {
          'nombre_ruta': _rutaController.text.trim(),
          'clima': _climaController.text.trim(),
          'distancia_km': double.parse(_distanciaController.text),
          'telefono_emergencia': _telefonoController.text.trim(),
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
                  Text('Bitácora registrada con éxito', style: TextStyle(color: Colors.white)),
                ],
              ),
              backgroundColor: Color(0xFF1E1E1E),
            ),
          );
          Navigator.pop(context); //Regresa menú principal
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: $e'))
        );
      }
    } else {
      // Feedback visual si el formulario no es válido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor corrige los errores en el formulario'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
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
                  validator: _validarGenerico, // Validador específico
                ),
                SizedBox(height: 15),
                _crearInput(
                  controller: _climaController,
                  label: "Condición Climática",
                  icon: Icons.cloud,
                  keyboard: TextInputType.text,
                  validator: _validarGenerico,
                ),
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alineación para que los mensajes de error no rompan el layout
                  children: [
                    Expanded(
                      child: _crearInput(
                        controller: _distanciaController,
                        label: "Distancia (km)",
                        icon: Icons.straighten,
                        keyboard: TextInputType.numberWithOptions(decimal: true),
                        validator: _validarDistancia, // Validador numérico
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
                            validator: _validarGenerico,
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
                  validator: _validarTelefono, // Validador de teléfono
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

  // Widget refactorizado para aceptar validador personalizado
  Widget _crearInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboard,
    required String? Function(String?) validator, // Parámetro requerido ahora
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(color: Colors.white),
      validator: validator, // Asignamos la función que viene por parámetro
      autovalidateMode: AutovalidateMode.onUserInteraction, // Valida mientras escribes
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
        ),
        errorBorder: OutlineInputBorder( // Borde rojo si hay error
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        errorStyle: TextStyle(color: Colors.redAccent), // Texto de error rojo
      ),
    );
  }
}