// presentation/screens/select_exercises_screen.dart
import 'package:flutter/material.dart';

class SelectExercisesScreen extends StatefulWidget {
  const SelectExercisesScreen({super.key});

  @override
  _SelectExercisesScreenState createState() => _SelectExercisesScreenState();
}

class _SelectExercisesScreenState extends State<SelectExercisesScreen> {
  // Lista simulada de ejercicios disponibles
  final List<Map<String, dynamic>> availableExercises = [
    {
      'id': 1,
      'name': 'Flexiones',
      'difficulty': 'fácil',
      'material': 'Ninguno',
      'sport': 'calistenia',
    },
    {
      'id': 2,
      'name': 'Sentadillas',
      'difficulty': 'medio',
      'material': 'Ninguno',
      'sport': 'calistenia',
    },
    {
      'id': 3,
      'name': 'Press de banca',
      'difficulty': 'difícil',
      'material': 'Banca, barra',
      'sport': 'gimnasio',
    },
    // Puedes añadir más ejercicios
  ];

  // Lista de ejercicios seleccionados
  List<Map<String, dynamic>> selectedExercises = [];

  // Filtros simples (puedes ampliar según tus necesidades)
  String filterDifficulty = '';
  String filterMaterial = '';
  String filterSport = '';

  List<Map<String, dynamic>> get filteredExercises {
    return availableExercises.where((exercise) {
      bool matchesDifficulty =
          filterDifficulty.isEmpty ||
          exercise['difficulty'].toString().toLowerCase().contains(
            filterDifficulty.toLowerCase(),
          );
      bool matchesMaterial =
          filterMaterial.isEmpty ||
          exercise['material'].toString().toLowerCase().contains(
            filterMaterial.toLowerCase(),
          );
      bool matchesSport =
          filterSport.isEmpty ||
          exercise['sport'].toString().toLowerCase().contains(
            filterSport.toLowerCase(),
          );
      return matchesDifficulty && matchesMaterial && matchesSport;
    }).toList();
  }

  // Alterna la selección de un ejercicio
  void _toggleExerciseSelection(Map<String, dynamic> exercise) {
    setState(() {
      if (selectedExercises.contains(exercise)) {
        selectedExercises.remove(exercise);
      } else {
        // Se agregan parámetros por defecto para series y repeticiones
        selectedExercises.add({...exercise, 'series': 3, 'reps': 10});
      }
    });
  }

  // Devuelve la lista de ejercicios seleccionados
  void _confirmSelection() {
    Navigator.pop(context, selectedExercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Ejercicios')),
      body: Column(
        children: [
          // Filtros simples
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Filtrar por dificultad',
              ),
              onChanged: (value) {
                setState(() {
                  filterDifficulty = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Filtrar por material',
              ),
              onChanged: (value) {
                setState(() {
                  filterMaterial = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Filtrar por deporte',
              ),
              onChanged: (value) {
                setState(() {
                  filterSport = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                final isSelected = selectedExercises.contains(exercise);
                return ListTile(
                  title: Text(exercise['name']),
                  subtitle: Text(
                    'Dificultad: ${exercise['difficulty']} - Material: ${exercise['material']}',
                  ),
                  trailing: Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected ? Colors.green : null,
                  ),
                  onTap: () => _toggleExerciseSelection(exercise),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _confirmSelection,
            child: const Text('Confirmar selección'),
          ),
        ],
      ),
    );
  }
}
