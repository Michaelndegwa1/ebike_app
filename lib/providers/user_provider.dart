import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  double _balance = 250.0;
  int _ecoPoints = 145;
  String _userName = 'Michael Ndegwa';
  String _userPhone = '+254 706 548 047';

  double get balance => _balance;
  int get ecoPoints => _ecoPoints;
  String get userName => _userName;
  String get userPhone => _userPhone;

  void deductBalance(double amount) {
    _balance -= amount;
    notifyListeners();
  }

  void addBalance(double amount) {
    _balance += amount;
    notifyListeners();
  }

  void addEcoPoints(int points) {
    _ecoPoints += points;
    notifyListeners();
  }
}