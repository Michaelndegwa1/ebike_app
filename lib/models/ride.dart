class Ride {
  final String id;
  final String bikeId;
  final DateTime startTime;
  DateTime? endTime;
  double distance;
  int duration;
  double calories;
  double co2Saved;
  double cost;
  RideStatus status;

  Ride({
    required this.id,
    required this.bikeId,
    required this.startTime,
    this.endTime,
    this.distance = 0,
    this.duration = 0,
    this.calories = 0,
    this.co2Saved = 0,
    this.cost = 0,
    this.status = RideStatus.active,
  });

  void updateMetrics(int seconds) {
    duration = seconds;
    distance = (seconds * 0.05).clamp(0, 100);
    calories = (seconds * 0.8);
    co2Saved = (distance * 0.15);
    cost = (duration * 5.0 / 60); // KSh 5 per minute
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      bikeId: json['bikeId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      distance: json['distance'],
      duration: json['duration'],
      calories: json['calories'],
      co2Saved: json['co2Saved'],
      cost: json['cost'],
      status: RideStatus.values.firstWhere(
            (e) => e.toString() == json['status'],
        orElse: () => RideStatus.completed,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bikeId': bikeId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'distance': distance,
      'duration': duration,
      'calories': calories,
      'co2Saved': co2Saved,
      'cost': cost,
      'status': status.toString(),
    };
  }
}

enum RideStatus { active, completed, cancelled }