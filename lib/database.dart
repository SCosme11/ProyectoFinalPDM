import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AdministradorBaseDatos{ //Para que únicamente haya una instancia de la bd en la aplicación.
  static final AdministradorBaseDatos instancia = AdministradorBaseDatos._init();
  static Database? _baseDatos;

  //constructor
  AdministradorBaseDatos._init();

  //Future porque es una operación que tarda un poco de tiempo.
  Future<Database> get baseDatos async{
    if(_baseDatos != null) return _baseDatos!;

    _baseDatos = await _initBD('montana_explorer.db');
    return _baseDatos!;
  }

  Future<Database> _initBD(String nombreArchivo) async{
    final rutaDirectorio = await getDatabasesPath();
    final rutaCompleta = join(rutaDirectorio, nombreArchivo);

    return await openDatabase(
      rutaCompleta,
      version: 1,
      onCreate: _crearBD //Metodo que crea las tablas
    );
  }

  //Creación de las tablas
  Future _crearBD(Database db, int version) async{
    //Tabla formulario
    await db.execute('''
      CREATE TABLE bitacora (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre_ruta TEXT,
        clima TEXT,
        distancia_km REAL,
        telefono_emergencia TEXT,
        fecha_viaje TEXT
      )
    ''');

    //tabla magnetómetro
    await db.execute('''
      CREATE TABLE magnetometro(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        x REAL,
        y REAL,
        z REAL,
        tiempo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE barometro(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        presion REAL,
        tiempo TEXT
      )
    ''');
  }

  //Métodos CRUD
  //Bitacora
  Future<int> insertarBitacora(Map<String, dynamic> fila) async {
    final db = await instancia.baseDatos;
    return await db.insert('bitacora', fila);
  }

  Future<List<Map<String, dynamic>>> obtenerBitacoras() async {
    final db = await instancia.baseDatos;
    return await db.query('bitacora', orderBy: 'fecha_viaje DESC');
  }

  //Magnetómetro
  Future<int> insertarMagnetometro(double x, double y, double z) async {
    final db = await instancia.baseDatos;
    Map<String, dynamic> fila = {
      'x': x,
      'y': y,
      'z': z,
      'tiempo': DateTime.now().toIso8601String(),
    };
    return await db.insert('magnetometro', fila);
  }

  Future<List<Map<String, dynamic>>> obtenerMagnetometro() async {
    final db = await instancia.baseDatos;
    return await db.query('magnetometro', orderBy: 'tiempo DESC');
  }

  //Barómetro
  Future<int> insertarBarometro(double presion) async {
    final db = await instancia.baseDatos;
    Map<String, dynamic> fila = {
      'presion': presion,
      'tiempo': DateTime.now().toIso8601String(),
    };
    return await db.insert('barometro', fila);
  }

  Future<List<Map<String, dynamic>>> obtenerBarometro() async {
    final db = await instancia.baseDatos;
    return await db.query('barometro', orderBy: 'tiempo DESC');
  }

}