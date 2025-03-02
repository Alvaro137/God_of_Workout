// challenges_screen.dart
import 'package:flutter/material.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de pestañas internas
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Desafíos'),
                Tab(text: 'Mundo'),
                Tab(text: 'Métricas'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('Contenido de Desafíos')),
                Center(child: Text('Contenido de Mundo')),
                Center(child: Text('Contenido de Métricas')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
