import 'package:flutter/foundation.dart';
import '../models/bike.dart';

class BikeProvider with ChangeNotifier {
  List<Bike> _bikes = [];
  Bike? _selectedBike;

  List<Bike> get bikes => _bikes;
  Bike? get selectedBike => _selectedBike;
  List<Bike> get availableBikes => _bikes.where((b) => b.isAvailable).toList();

  BikeProvider() {
    _loadMockBikes();
  }

  void _loadMockBikes() {
    _bikes = [
      Bike(
        id: 'KB001',
        location: 'Konza Plaza',
        latitude: -1.1027,
        longitude: 37.0779,
        battery: 95,
        distance: 0.2,
        type: BikeType.standard,
      ),
      Bike(
        id: 'KB002',
        location: 'Tech Hub Station',
        latitude: -1.1037,
        longitude: 37.0789,
        battery: 78,
        distance: 0.5,
        type: BikeType.premium,
      ),
      Bike(
        id: 'KB003',
        location: 'Innovation Center',
        latitude: -1.1047,
        longitude: 37.0799,
        battery: 100,
        distance: 0.3,
        type: BikeType.premium,
      ),
      Bike(
        id: 'KB004',
        location: 'Residential Block A',
        latitude: -1.1017,
        longitude: 37.0769,
        battery: 62,
        distance: 0.8,
        type: BikeType.standard,
      ),
      Bike(
        id: 'KB005',
        location: 'Smart City Mall',
        latitude: -1.1057,
        longitude: 37.0809,
        battery: 88,
        distance: 1.2,
        type: BikeType.premium,
      ),
    ];
    notifyListeners();
  }

  void selectBike(Bike bike) {
    _selectedBike = bike;
    notifyListeners();
  }

  void clearSelection() {
    _selectedBike = null;
    notifyListeners();
  }

  void refreshBikes() {
    _loadMockBikes();
  }
}
