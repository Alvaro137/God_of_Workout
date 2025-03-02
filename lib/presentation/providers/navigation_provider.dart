// presentation/providers/navigation_provider.dart
import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    print("Llamada a navigation provider: setindex");
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
