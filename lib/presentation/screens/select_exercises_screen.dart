import 'package:flutter/material.dart';
import 'package:gow_v3/data/db_helper.dart';

class SelectExercisesScreen extends StatefulWidget {
  const SelectExercisesScreen({Key? key}) : super(key: key);

  @override
  _SelectExercisesScreenState createState() => _SelectExercisesScreenState();
}

class _SelectExercisesScreenState extends State<SelectExercisesScreen> {
  // Filtros
  double difficultyFilter =
      100.0; // Filtra ejercicios con dificultad ≤ este valor
  int?
  selectedSport; // 0: Calisthenics, 1: Gym, 2: Athletics, null: Todos los deportes
  List<String> selectedMaterials = [];
  List<String> selectedMuscles = [];
  String searchQuery = "";

  // Listado de ejercicios obtenidos de la DB
  List<Map<String, dynamic>> availableExercises = [];
  bool isLoading = true;

  // Listas para filtros
  final List<String> availableMaterials = [
    "Ninguno",
    "Banca",
    "Barra",
    "Dumbbell",
    "TRX",
    "Kettlebell",
  ];
  final List<String> availableMuscles = [
    "Chest",
    "Legs",
    "Arms",
    "Back",
    "Abs",
    "Glutes",
  ];
  final List<String> availableSports = [
    "Cualquiera",
    "Calistenia",
    "Gym",
    "Atletismo",
  ];

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    List<Map<String, dynamic>> exercises =
        await DBHelper.instance.getExercises();
    setState(() {
      availableExercises = exercises;
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> get filteredExercises {
    return availableExercises.where((exercise) {
      bool matchesDifficulty =
          (exercise['difficulty'] ?? 0) <= difficultyFilter;
      bool matchesSport =
          selectedSport == null || exercise['sport_id'] == selectedSport;
      bool matchesMaterial =
          selectedMaterials.isEmpty ||
          selectedMaterials.every((material) {
            return ((exercise['materials'] as String?)?.toLowerCase().contains(
                  material.toLowerCase(),
                ) ??
                false);
          });
      bool matchesMuscle =
          selectedMuscles.isEmpty ||
          selectedMuscles.every((muscle) {
            return ((exercise['muscles'] as String?)?.toLowerCase().contains(
                  muscle.toLowerCase(),
                ) ??
                false);
          });
      bool matchesSearch =
          searchQuery.isEmpty ||
          ((exercise['name'] as String?)?.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ??
              false);
      return matchesDifficulty &&
          matchesSport &&
          matchesMaterial &&
          matchesMuscle &&
          matchesSearch;
    }).toList();
  }

  Future<void> _selectMaterials() async {
    final List<String> tempSelected = List.from(selectedMaterials);
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Selecciona Materiales",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableMaterials.length,
                    itemBuilder: (context, index) {
                      final material = availableMaterials[index];
                      final isSelected = tempSelected.contains(material);
                      return CheckboxListTile(
                        title: Text(material),
                        value: isSelected,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (bool? value) {
                          setStateModal(() {
                            if (value == true) {
                              tempSelected.add(material);
                            } else {
                              tempSelected.remove(material);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      selectedMaterials = tempSelected;
                    });
                  },
                  child: const Text("Hecho"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectMuscles() async {
    final List<String> tempSelected = List.from(selectedMuscles);
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Selecciona Músculos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableMuscles.length,
                    itemBuilder: (context, index) {
                      final muscle = availableMuscles[index];
                      final isSelected = tempSelected.contains(muscle);
                      return CheckboxListTile(
                        title: Text(muscle),
                        value: isSelected,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (bool? value) {
                          setStateModal(() {
                            if (value == true) {
                              tempSelected.add(muscle);
                            } else {
                              tempSelected.remove(muscle);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      selectedMuscles = tempSelected;
                    });
                  },
                  child: const Text("Hecho"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectSport() async {
    int? tempSelectedSport = selectedSport;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  availableSports.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String sport = entry.value;
                    return ListTile(
                      title: Text(sport),
                      trailing:
                          tempSelectedSport == (idx == 0 ? null : idx - 1)
                              ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                              : null,
                      onTap: () {
                        setStateModal(() {
                          tempSelectedSport = (idx == 0 ? null : idx - 1);
                        });
                        Navigator.pop(context);
                        setState(() {
                          selectedSport = tempSelectedSport;
                        });
                      },
                    );
                  }).toList(),
            );
          },
        );
      },
    );
  }

  // Resetea todos los filtros a sus valores por defecto
  void _resetFilters() {
    setState(() {
      difficultyFilter = 100.0;
      selectedSport = null;
      selectedMaterials = [];
      selectedMuscles = [];
      searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios'),
        actions: [
          IconButton(
            onPressed: _resetFilters,
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Filters",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar por nombre",
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 8),
            // Slider de dificultad
            Row(
              children: [
                Text(
                  "Dificultad ≤ ${difficultyFilter.toInt()}",
                  style: TextStyle(color: colorScheme.onBackground),
                ),
                Expanded(
                  child: Slider(
                    value: difficultyFilter,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    activeColor: colorScheme.primary,
                    label: difficultyFilter.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        difficultyFilter = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Filtros: Deporte, Materiales y Músculos con contador
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectSport,
                  child: Text(
                    selectedSport == null
                        ? "Deporte"
                        : (selectedSport == 0
                            ? "Calistenia"
                            : selectedSport == 1
                            ? "Gym"
                            : "Atletismo"),
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectMaterials,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Materiales"),
                      if (selectedMaterials.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: colorScheme.primary,
                          child: Text(
                            "${selectedMaterials.length}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectMuscles,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Músculos"),
                      if (selectedMuscles.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: colorScheme.primary,
                          child: Text(
                            "${selectedMuscles.length}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Lista de ejercicios filtrados
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredExercises.isEmpty
                      ? const Center(
                        child: Text(
                          "No se encontraron ejercicios con los filtros aplicados.",
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = filteredExercises[index];
                          return Card(
                            color: colorScheme.surface,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              title: Text(
                                exercise['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Dificultad: ${exercise['difficulty']}\n"
                                "Deporte: ${exercise['sport_id'] == 0
                                    ? "Calistenia"
                                    : exercise['sport_id'] == 1
                                    ? "Gym"
                                    : "Atletismo"}",
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                              isThreeLine: true,
                              onTap: () {
                                // Al seleccionar el ejercicio se envía el dato de vuelta
                                Navigator.pop(context, exercise);
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
