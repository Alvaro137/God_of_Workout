import 'package:flutter/material.dart';
import 'select_exercises_screen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _routineNameController = TextEditingController();
  final TextEditingController _routineDescriptionController =
      TextEditingController();

  String _selectedSport = 'calistenia';
  List<Map<String, dynamic>> selectedExercises = [];

  int _restBetweenSets = 30;
  int _restBetweenReps = 10;
  int _timeLimit = 0;

  void _openSelectExercisesScreen() async {
    final result = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(builder: (context) => const SelectExercisesScreen()),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        for (var exercise in result) {
          exercise['series'] ??= 3;
          exercise['reps'] ??= 10;
          selectedExercises.add(exercise);
        }
      });
    }
  }

  void _saveRoutine() {
    if (_formKey.currentState!.validate()) {
      final routineName = _routineNameController.text;
      final routineDescription =
          _routineDescriptionController.text.isNotEmpty
              ? _routineDescriptionController.text
              : 'Rutina creada por el usuario';
      final sportId =
          _selectedSport == 'calistenia'
              ? 0
              : _selectedSport == 'gimnasio'
              ? 1
              : 2;

      print('Guardando rutina: $routineName');
      print('Descripción: $routineDescription');
      print('Sport_id: $sportId');
      print('Descanso entre series: $_restBetweenSets segundos');
      print('Descanso entre repeticiones: $_restBetweenReps segundos');
      print('Límite de tiempo: $_timeLimit minutos');
      print('Ejercicios seleccionados: $selectedExercises');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rutina guardada (simulación)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Rutina'),
        actions: [
          IconButton(
            onPressed: _saveRoutine,
            icon: const Icon(Icons.save),
            tooltip: 'Guardar Rutina',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _routineNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la rutina',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.fitness_center),
                        ),
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Ingresa un nombre'
                                    : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _routineDescriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Descripción (opcional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedSport,
                        decoration: const InputDecoration(
                          labelText: 'Deporte',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.sports),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'calistenia',
                            child: Text('Calistenia'),
                          ),
                          DropdownMenuItem(
                            value: 'gimnasio',
                            child: Text('Gimnasio'),
                          ),
                          DropdownMenuItem(
                            value: 'atletismo',
                            child: Text('Atletismo'),
                          ),
                        ],
                        onChanged:
                            (value) => setState(() => _selectedSport = value!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Descanso entre series: $_restBetweenSets segundos'),
              Slider(
                value: _restBetweenSets.toDouble(),
                min: 10,
                max: 180,
                divisions: 17,
                label: '$_restBetweenSets s',
                onChanged:
                    (value) => setState(() => _restBetweenSets = value.toInt()),
              ),
              const SizedBox(height: 10),
              Text('Descanso entre repeticiones: $_restBetweenReps segundos'),
              Slider(
                value: _restBetweenReps.toDouble(),
                min: 5,
                max: 60,
                divisions: 11,
                label: '$_restBetweenReps s',
                onChanged:
                    (value) => setState(() => _restBetweenReps = value.toInt()),
              ),
              const SizedBox(height: 10),
              Text(
                'Límite de tiempo: ${_timeLimit == 0 ? 'Sin límite' : '$_timeLimit minutos'}',
              ),
              Slider(
                value: _timeLimit.toDouble(),
                min: 0,
                max: 120,
                divisions: 12,
                label: _timeLimit == 0 ? 'Sin límite' : '$_timeLimit min',
                onChanged:
                    (value) => setState(() => _timeLimit = value.toInt()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _openSelectExercisesScreen,
                child: const Text('Seleccionar Ejercicios'),
              ),
              if (selectedExercises.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Ejercicios seleccionados:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = selectedExercises[index];
                    return Card(
                      child: ListTile(
                        title: Text(exercise['name'] ?? 'Sin nombre'),
                        subtitle: Text(
                          'Series: ${exercise['series']}, Reps: ${exercise['reps']}',
                        ),
                        trailing: const Icon(Icons.edit),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
