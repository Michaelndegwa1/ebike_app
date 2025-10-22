import 'package:flutter/material.dart';
import '../models/bike.dart';

class BikeCard extends StatelessWidget {
  final Bike bike;
  final VoidCallback? onUnlock;
  final VoidCallback? onNavigate;

  const BikeCard({
    Key? key,
    required this.bike,
    this.onUnlock,
    this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: bike.isAvailable
              ? LinearGradient(
            colors: bike.type == BikeType.premium
                ? [Colors.purple.shade400, Colors.purple.shade600]
                : [Colors.blue.shade400, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : LinearGradient(
            colors: [Colors.grey.shade400, Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        bike.type == BikeType.premium ? Icons.electric_bike : Icons.pedal_bike,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bike.type == BikeType.premium ? 'Premium' : 'Standard',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: bike.isAvailable ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: bike.isAvailable ? Colors.green : Colors.red, width: 1.5),
                  ),
                  child: Text(
                    bike.isAvailable ? 'Available' : 'In Use',
                    style: TextStyle(
                      color: bike.isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Bike #${bike.id}',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    bike.location,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  icon: Icons.battery_charging_full,
                  value: '${bike.battery}%',
                  color: _getBatteryColor(bike.battery),
                ),
                _buildStatItem(
                  icon: Icons.straighten,
                  value: '${bike.distance.toStringAsFixed(1)} km',
                  color: Colors.white,
                ),
                _buildStatItem(
                  icon: Icons.payments,
                  value: bike.type == BikeType.premium ? 'KSh 7/min' : 'KSh 5/min',
                  color: Colors.greenAccent,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: bike.isAvailable ? onUnlock : null,
                    icon: Icon(bike.isAvailable ? Icons.lock_open : Icons.lock, size: 20),
                    label: Text(
                      bike.isAvailable ? 'Unlock' : 'Unavailable',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bike.isAvailable ? Colors.white : Colors.grey.shade400,
                      foregroundColor: bike.isAvailable
                          ? (bike.type == BikeType.premium ? Colors.purple.shade700 : Colors.blue.shade700)
                          : Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                  ),
                  child: const Icon(Icons.navigation, size: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  Color _getBatteryColor(int battery) {
    if (battery > 60) return Colors.greenAccent;
    if (battery > 30) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}