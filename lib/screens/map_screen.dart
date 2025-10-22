// ============================================
// FILE: lib/screens/map_screen.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bike_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the BikeProvider from the widget tree
    final bikeProvider = Provider.of<BikeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            // Future feature: center map on user's GPS
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Centering map on your location...')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // MAP VIEW (Placeholder for now)
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text(
                'Google Map Placeholder\n(To be replaced with google_maps_flutter)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // ============================================
          // BIKE MARKERS INFO PANEL (bottom sheet style)
          // ============================================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar (UI detail)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Scrollable horizontal list of available bikes
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: bikeProvider.availableBikes.length,
                      itemBuilder: (context, index) {
                        final bike = bikeProvider.availableBikes[index];

                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                bike.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bike.location,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.battery_charging_full,
                                    size: 16,
                                    color: bike.battery > 70
                                        ? Colors.green
                                        : bike.battery > 30
                                        ? Colors.orange
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${bike.battery}%'),
                                  const Spacer(),
                                  Text(
                                    '${bike.distance.toStringAsFixed(1)} km',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
