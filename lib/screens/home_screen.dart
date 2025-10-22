import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bike_provider.dart';
import '../providers/ride_provider.dart';
import '../providers/user_provider.dart';
import '../models/bike.dart';
import '../widgets/bike_card.dart';
import '../widgets/stat_card.dart';
import 'scan_screen.dart';
import 'ride_screen.dart';
import 'history_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bikeProvider = Provider.of<BikeProvider>(context);
    final rideProvider = Provider.of<RideProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Konza E-Ride',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          // Show menu or profile
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Balance',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'KSh ${userProvider.balance.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Top up functionality
                            _showTopUpDialog(context, userProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                          ),
                          child: const Text('Top Up'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Stats
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Expanded(
                    child: CompactStatCard(
                      icon: Icons.pedal_bike,
                      label: 'Total Rides',
                      value: '${rideProvider.totalRides}',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CompactStatCard(
                      icon: Icons.trending_up,
                      label: 'Distance',
                      value: '${rideProvider.totalDistance.toStringAsFixed(1)} km',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CompactStatCard(
                      icon: Icons.eco,
                      label: 'CO₂ Saved',
                      value: '${rideProvider.totalCO2Saved.toStringAsFixed(1)} kg',
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),

            // Nearby Bikes
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  bikeProvider.refreshBikes();
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nearby E-Bikes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapScreen(),
                              ),
                            );
                          },
                          child: const Text('View Map'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...bikeProvider.availableBikes.map((bike) {
                      return BikeCard(
                        bike: bike,
                        onUnlock: () => _unlockBike(context, bike),
                        onNavigate: () => _navigateToBike(context, bike),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }

  void _unlockBike(BuildContext context, Bike bike) {
    final bikeProvider = Provider.of<BikeProvider>(context, listen: false);
    final rideProvider = Provider.of<RideProvider>(context, listen: false);

    bikeProvider.selectBike(bike);
    rideProvider.startRide(bike);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RideScreen()),
    );
  }

  void _navigateToBike(BuildContext context, Bike bike) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening navigation to ${bike.location}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showTopUpDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Top Up Balance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select amount to add:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [100, 200, 500, 1000].map((amount) {
                return ElevatedButton(
                  onPressed: () {
                    userProvider.addBalance(amount.toDouble());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added KSh $amount to your balance'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text('KSh $amount'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}