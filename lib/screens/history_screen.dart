import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Monthly Summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This Month',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MonthlyStatItem(
                      label: 'Rides',
                      value: '${rideProvider.totalRides}',
                      color: Colors.green,
                    ),
                    _MonthlyStatItem(
                      label: 'Distance',
                      value: '${rideProvider.totalDistance.toStringAsFixed(1)} km',
                      color: Colors.blue,
                    ),
                    _MonthlyStatItem(
                      label: 'CO₂ Saved',
                      value: '${rideProvider.totalCO2Saved.toStringAsFixed(1)} kg',
                      color: Colors.green.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Ride List
          Expanded(
            child: rideProvider.rideHistory.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pedal_bike,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No rides yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start your first ride!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: rideProvider.rideHistory.length,
              itemBuilder: (context, index) {
                final ride = rideProvider.rideHistory[index];
                return _RideHistoryCard(
                  date: ride.startTime,
                  duration: ride.duration,
                  distance: ride.distance,
                  cost: ride.cost,
                  co2Saved: ride.co2Saved,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MonthlyStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _RideHistoryCard extends StatelessWidget {
  final DateTime date;
  final int duration;
  final double distance;
  final double cost;
  final double co2Saved;

  const _RideHistoryCard({
    required this.date,
    required this.duration,
    required this.distance,
    required this.cost,
    required this.co2Saved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(date),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${duration ~/ 60} minutes',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                'KSh ${cost.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${distance.toStringAsFixed(2)} km',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.eco, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${co2Saved.toStringAsFixed(2)} kg CO₂',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}