// presentation/screens/progress_screen.dart
import 'package:flutter/material.dart';
import '../../appconstants.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Progress Screen',
        style: TextStyle(fontSize: 24, color: AppConstants.colorText),
      ),
    );
  }
}
