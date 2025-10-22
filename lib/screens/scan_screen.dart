import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bike_provider.dart';
import '../providers/ride_provider.dart';
import 'ride_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _bikeIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Scan QR Code'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Corner decorations
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.green, width: 4),
                            left: BorderSide(color: Colors.green, width: 4),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.green, width: 4),
                            right: BorderSide(color: Colors.green, width: 4),
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.green, width: 4),
                            left: BorderSide(color: Colors.green, width: 4),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.green, width: 4),
                            right: BorderSide(color: Colors.green, width: 4),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    // QR Icon
                    Center(
                      child: Icon(
                        Icons.qr_code_2,
                        size: 120,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    // Scanning line
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (context, double value, child) {
                        return Positioned(
                          top: value * 250,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.green,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      onEnd: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Position QR code within the frame',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  'OR',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bikeIdController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter Bike ID (e.g., KB001)',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.pedal_bike, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _unlockByBikeId(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Unlock Bike',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _unlockByBikeId(BuildContext context) {
    final bikeId = _bikeIdController.text.trim().toUpperCase();
    final bikeProvider = Provider.of<BikeProvider>(context, listen: false);
    final rideProvider = Provider.of<RideProvider>(context, listen: false);

    final bike = bikeProvider.bikes.firstWhere(
          (b) => b.id == bikeId,
      orElse: () => bikeProvider.bikes.first,
    );

    if (bike.id == bikeId) {
      bikeProvider.selectBike(bike);
      rideProvider.startRide(bike);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RideScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bike $bikeId not found. Using ${bike.id} for demo.'),
          backgroundColor: Colors.orange,
        ),
      );

      bikeProvider.selectBike(bike);
      rideProvider.startRide(bike);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RideScreen()),
      );
    }
  }

  @override
  void dispose() {
    _bikeIdController.dispose();
    super.dispose();
  }
}
