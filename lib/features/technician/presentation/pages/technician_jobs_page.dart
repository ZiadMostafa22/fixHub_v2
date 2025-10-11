import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:car_maintenance_system_new/core/providers/auth_provider.dart';
import 'package:car_maintenance_system_new/core/providers/booking_provider.dart';
import 'package:car_maintenance_system_new/core/providers/car_provider.dart';
import 'package:car_maintenance_system_new/core/models/booking_model.dart';

class TechnicianJobsPage extends ConsumerStatefulWidget {
  const TechnicianJobsPage({super.key});

  @override
  ConsumerState<TechnicianJobsPage> createState() => _TechnicianJobsPageState();
}

class _TechnicianJobsPageState extends ConsumerState<TechnicianJobsPage> {
  String _filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        // Start real-time listener for bookings
        ref.read(bookingProvider.notifier).startListening(user.id, role: 'technician');
        ref.read(carProvider.notifier).loadCars('');
      }
    });
  }

  @override
  void dispose() {
    // Stop listening when page is disposed
    ref.read(bookingProvider.notifier).stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final carState = ref.watch(carProvider);
    final user = ref.read(authProvider).user;
    
    // Filter bookings - show unassigned jobs (available) OR jobs assigned to this technician
    final filteredBookings = bookingState.bookings.where((booking) {
      // Show jobs that are either unassigned (available work) OR assigned to this technician
      final isUnassigned = booking.assignedTechnicians == null || booking.assignedTechnicians!.isEmpty;
      final isAssignedToMe = booking.assignedTechnicians != null && 
                            booking.assignedTechnicians!.isNotEmpty && 
                            booking.assignedTechnicians!.contains(user?.id);
      final canSeeJob = isUnassigned || isAssignedToMe;
      
      if (!canSeeJob) return false;
      
      // Then apply status filter
      if (_filterStatus == 'all') return true;
      if (_filterStatus == 'pending') return booking.status == BookingStatus.pending || booking.status == BookingStatus.confirmed;
      if (_filterStatus == 'in_progress') return booking.status == BookingStatus.inProgress;
      if (_filterStatus == 'completed') return booking.status == BookingStatus.completed;
      return true;
    }).toList();
    
    // Sort by scheduled date
    filteredBookings.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Jobs'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterStatus = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Jobs')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
            ],
          ),
        ],
      ),
      body: bookingState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredBookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.work,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _filterStatus == 'all' ? 'No jobs assigned' : 'No $_filterStatus jobs',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your assigned jobs will appear here',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    
                    // Get car info
                    final car = carState.cars.where((c) => c.id == booking.carId).firstOrNull;
                    final carName = car != null ? '${car.make} ${car.model} (${car.year})' : 'Unknown Car';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _getMaintenanceTypeName(booking.maintenanceType),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(booking.status).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _getStatusName(booking.status),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _getStatusColor(booking.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.directions_car, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    carName,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('MMM dd, yyyy').format(booking.scheduledDate),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  booking.timeSlot,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            if (booking.description != null && booking.description!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                booking.description!,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => context.go('/technician/job-details/${booking.id}'),
                                icon: Icon(
                                  booking.status == BookingStatus.inProgress 
                                      ? Icons.build 
                                      : booking.status == BookingStatus.completed
                                          ? Icons.check_circle
                                          : Icons.play_arrow,
                                ),
                                label: Text(
                                  booking.status == BookingStatus.inProgress 
                                      ? 'Continue Work & Complete Job' 
                                      : booking.status == BookingStatus.completed
                                          ? 'View Invoice'
                                          : 'Start Job & Add Invoice',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: booking.status == BookingStatus.inProgress 
                                      ? Colors.blue 
                                      : booking.status == BookingStatus.completed
                                          ? Colors.green
                                          : Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _getMaintenanceTypeName(MaintenanceType type) {
    switch (type) {
      case MaintenanceType.regular:
        return 'Regular Maintenance';
      case MaintenanceType.inspection:
        return 'Inspection';
      case MaintenanceType.repair:
        return 'Repair Service';
      case MaintenanceType.emergency:
        return 'Emergency Service';
    }
  }

  String _getStatusName(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.inProgress:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }
}
