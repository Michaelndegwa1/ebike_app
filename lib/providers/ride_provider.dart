import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/ride.dart';
import '../models/bike.dart';

class RideProvider with ChangeNotifier {
  Ride? _currentRide;
  List<Ride> _rideHistory = [];
  Timer? _rideTimer;

  Ride? get currentRide => _currentRide;
  List<Ride> get rideHistory => _rideHistory;
  bool get isRiding => _currentRide != null && _currentRide!.status == RideStatus.active;

  void startRide(Bike bike) {
    _currentRide = Ride(
      id: 'R${DateTime.now().millisecondsSinceEpoch}',
      bikeId: bike.id,
      startTime: DateTime.now(),
    );

    _rideTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentRide != null) {
        final elapsed = DateTime.now().difference(_currentRide!.startTime).inSeconds;
        _currentRide!.updateMetrics(elapsed);
        notifyListeners();
      }
    });

    notifyListeners();
  }

  void endRide() {
    if (_currentRide != null) {
      _currentRide!.endTime = DateTime.now();
      _currentRide!.status = RideStatus.completed;
      _rideHistory.insert(0, _currentRide!);
      _rideTimer?.cancel();
      notifyListeners();
    }
  }

  void clearCurrentRide() {
    _currentRide = null;
    notifyListeners();
  }

  double get totalDistance => _rideHistory.fold(0, (sum, ride) => sum + ride.distance);
  double get totalCO2Saved => _rideHistory.fold(0, (sum, ride) => sum + ride.co2Saved);
  int get totalRides => _rideHistory.length;

  @override
  void dispose() {
    _rideTimer?.cancel();
    super.dispose();
  }
}