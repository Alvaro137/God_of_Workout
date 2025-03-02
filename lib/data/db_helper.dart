import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data'; // This import is required for ByteData
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // Singleton pattern for a single instance of the database
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the pre-populated database from assets if it doesn't exist locally.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    // Check if the database exists
    bool exists = await databaseExists(path);
    if (!exists) {
      print("Base de datos no encontrada. Copiandola desde assets...");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print("Error creando directorio: $e");
      }
      // Copy from assets
      ByteData data = await rootBundle.load('assets/app.db');
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);
      print("Base de datos copiada correctamente.");
    } else {
      print("Base de datos ya existe.");
    }

    // Open the database without creating tables (since it's prepopulated)
    return await openDatabase(path, version: 1, onOpen: _onOpen);
  }

  Future _onOpen(Database db) async {
    print("Base de datos abierta.");
    // Perform any integrity checks or migrations if needed.
  }

  // CRUD methods (assuming the tables/columns exist in app.db)

  // Insert a new routine (for user-defined routines)
  Future<int> insertRoutine(Map<String, dynamic> routine) async {
    print('Calling insertRoutine');
    Database db = await instance.database;
    return await db.insert('Routines', routine);
  }

  // Get all routines (predefined and user-added)
  Future<List<Map<String, dynamic>>> getRoutines() async {
    print('Calling getRoutines');
    Database db = await instance.database;
    return await db.query('Routines');
  }

  Future<List<Map<String, dynamic>>> getExercises() async {
    print('Calling getExercises');
    Database db = await instance.database;
    return await db.query('Exercises');
  }

  // Insert a new exercise (for user-defined exercises)
  Future<int> insertExercise(Map<String, dynamic> exercise) async {
    print('Calling insertExercise');
    Database db = await instance.database;
    return await db.insert('Exercises', exercise);
  }

  // Insert a new routine-exercise relationship
  Future<int> insertRoutineExercise(
    Map<String, dynamic> routineExercise,
  ) async {
    print('Calling insertRoutineExercise');
    Database db = await instance.database;
    return await db.insert('RoutineExercises', routineExercise);
  }

  // Insert a new swipe interaction (assumes a 'swipe_interactions' column exists in Routines)
  Future<int> insertSwipeInteraction(Map<String, dynamic> interaction) async {
    print('Calling insertSwipeInteraction');
    Database db = await instance.database;
    // Example: interaction includes 'routine_id' and 'action' (e.g., "guardar" or "descartar")
    int routineId = interaction['routine_id'];
    String action = interaction['action'];
    return await db.update(
      'Routines',
      {'swipe_interactions': action},
      where: 'id = ?',
      whereArgs: [routineId],
    );
  }

  // Get routines that have a swipe interaction value (non-null)
  Future<List<Map<String, dynamic>>> getSwipeInteractions() async {
    print('Calling getSwipeInteractions');
    Database db = await instance.database;
    return await db.query('Routines', where: "swipe_interactions IS NOT NULL");
  }
}
