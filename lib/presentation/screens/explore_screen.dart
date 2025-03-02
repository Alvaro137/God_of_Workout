// presentation/screens/explore_screen.dart
import 'package:flutter/material.dart';
import '../../data/db_helper.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Map<String, dynamic>> routines = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    print(
      'Llamada a _initDatabase, comprueba que ahora se encuentre o copie bien',
    );
    await DBHelper
        .instance
        .database; // Inicializa la base de datos (onCreate se ejecutará si no existe)
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final data = await DBHelper.instance.getRoutines();
    setState(() {
      routines = data;
    });
  }

  // Se utiliza Dismissible para detectar el swipe y registrar la acción
  void _onDismissed(DismissDirection direction) async {
    if (currentIndex >= routines.length) return;
    final routineId = routines[currentIndex]['id'];
    String action;
    // Si se desliza de izquierda a derecha, se considera "guardar"
    if (direction == DismissDirection.startToEnd) {
      action = 'guardar';
    } else {
      // Desliza de derecha a izquierda: "descartar"
      action = 'descartar';
    }
    await DBHelper.instance.insertSwipeInteraction({
      'routine_id': routineId,
      'action': action,
    });
    setState(() {
      currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay rutinas o se han mostrado todas, muestra un mensaje
    if (routines.isEmpty || currentIndex >= routines.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Explora Rutinas')),
        body: const Center(child: Text('No hay más rutinas')),
      );
    }

    // Muestra la rutina actual en una tarjeta deslizable
    //TODO: comprueba que la rutina no tenga ya una interacción guardada
    final routine = routines[currentIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Explora Rutinas')),
      body: Center(
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          onDismissed: _onDismissed,
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.save, color: Colors.white, size: 36),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 36),
          ),
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 4,
            child: Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                routine['name'] ?? 'Rutina sin nombre',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
