import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_maintenance_system_new/core/providers/auth_provider.dart';
import 'package:car_maintenance_system_new/core/providers/booking_provider.dart';
import 'package:car_maintenance_system_new/core/models/booking_model.dart';

class TechnicianProfilePage extends ConsumerStatefulWidget {
  const TechnicianProfilePage({super.key});

  @override
  ConsumerState<TechnicianProfilePage> createState() => _TechnicianProfilePageState();
}

class _TechnicianProfilePageState extends ConsumerState<TechnicianProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load bookings for this technician
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        ref.read(bookingProvider.notifier).loadBookings(user.id, role: 'technician');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final bookingState = ref.watch(bookingProvider);
    final user = authState.user;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate real stats from bookings - ONLY jobs where technician is explicitly assigned
    final completedJobs = bookingState.bookings.where((b) =>
      b.status == BookingStatus.completed &&
      b.assignedTechnicians != null && 
      b.assignedTechnicians!.isNotEmpty && 
      b.assignedTechnicians!.contains(user?.id)
    ).length;

    final totalHoursWorked = bookingState.bookings
        .where((b) => 
          b.status == BookingStatus.completed &&
          b.assignedTechnicians != null && 
          b.assignedTechnicians!.isNotEmpty && 
          b.assignedTechnicians!.contains(user?.id)
        )
        .fold<double>(0, (sum, booking) => sum + booking.hoursWorked);
    
    // Responsive sizing
    final horizontalPadding = screenWidth * 0.04 < 12 ? 12.0 : (screenWidth * 0.04 > 16 ? 16.0 : screenWidth * 0.04);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05 < 16 ? 16.0 : (screenWidth * 0.05 > 24 ? 24.0 : screenWidth * 0.05)),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.12 < 40 ? 40.0 : (screenWidth * 0.12 > 50 ? 50.0 : screenWidth * 0.12),
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'T',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08 < 24 ? 24.0 : (screenWidth * 0.08 > 32 ? 32.0 : screenWidth * 0.08),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      user?.name ?? 'Unknown Technician',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05 < 18 ? 18.0 : (screenWidth * 0.05 > 22 ? 22.0 : screenWidth * 0.05),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Text(
                      user?.email ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                        fontSize: screenWidth * 0.038 < 13 ? 13.0 : (screenWidth * 0.038 > 15 ? 15.0 : screenWidth * 0.038),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.004),
                    Text(
                      user?.phone ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: screenWidth * 0.035 < 12 ? 12.0 : (screenWidth * 0.035 > 14 ? 14.0 : screenWidth * 0.035),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: screenHeight * 0.02),
            
            // Performance Summary
            Card(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045 < 16 ? 16.0 : (screenWidth * 0.045 > 20 ? 20.0 : screenWidth * 0.045),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(context, screenWidth, screenHeight, 'Jobs Completed', completedJobs.toString(), Icons.check_circle, Colors.green),
                        _buildStatItem(context, screenWidth, screenHeight, 'Hours Worked', '${totalHoursWorked.toStringAsFixed(0)}h', Icons.schedule, Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: screenHeight * 0.02),
            
            // Profile Options
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Personal Information'),
                    subtitle: const Text('Update your personal details'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to personal info page
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('Work Schedule'),
                    subtitle: const Text('Manage your availability'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to schedule page
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    subtitle: const Text('Manage notification preferences'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to notifications page
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Security'),
                    subtitle: const Text('Change password and security settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to security page
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, double screenWidth, double screenHeight, String label, String value, IconData icon, Color color) {
    final iconSize = screenWidth * 0.1 < 40 ? 40.0 : (screenWidth * 0.1 > 48 ? 48.0 : screenWidth * 0.1);
    return Column(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(iconSize / 2),
          ),
          child: Icon(icon, color: color, size: iconSize * 0.5),
        ),
        SizedBox(height: screenHeight * 0.008),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: screenWidth * 0.045 < 16 ? 16.0 : (screenWidth * 0.045 > 20 ? 20.0 : screenWidth * 0.045),
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontSize: screenWidth * 0.03 < 10 ? 10.0 : (screenWidth * 0.03 > 12 ? 12.0 : screenWidth * 0.03),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
