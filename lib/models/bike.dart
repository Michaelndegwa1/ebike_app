class Bike {
  final String id;
  final String location;
  final double latitude;
  final double longitude;
  final int battery;
  final double distance;
  final BikeType type;
  final bool isAvailable;

  Bike({
    required this.id,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.battery,
    required this.distance,
    required this.type,
    this.isAvailable = true,
  });

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      battery: json['battery'],
      distance: json['distance'],
      type: json['type'] == 'Premium' ? BikeType.premium : BikeType.standard,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'battery': battery,
      'distance': distance,
      'type': type == BikeType.premium ? 'Premium' : 'Standard',
      'isAvailable': isAvailable,
    };
  }
}

enum BikeType { standard, premium }