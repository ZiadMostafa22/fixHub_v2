import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomerBookingsPage extends StatelessWidget {
  const CustomerBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for bookings
    final List<Map<String, dynamic>> demoBookings = [
      {
        'id': '1',
        'carMake': 'Toyota',
        'carModel': 'Camry',
        'serviceType': 'Oil Change',
        'status': 'confirmed',
        'scheduledDate': '2024-03-15',
        'scheduledTime': '10:00 AM',
        'estimatedDuration': '1 hour',
        'price': '150',
        'technicianName': 'Ahmed Hassan',
      },
      {
        'id': '2',
        'carMake': 'Honda',
        'carModel': 'Civic',
        'serviceType': 'Brake Service',
        'status': 'in_progress',
        'scheduledDate': '2024-03-10',
        'scheduledTime': '2:00 PM',
        'estimatedDuration': '2 hours',
        'price': '300',
        'technicianName': 'Mohamed Ali',
      },
      {
        'id': '3',
        'carMake': 'Toyota',
        'carModel': 'Camry',
        'serviceType': 'Engine Check',
        'status': 'completed',
        'scheduledDate': '2024-03-05',
        'scheduledTime': '9:00 AM',
        'estimatedDuration': '1.5 hours',
        'price': '200',
        'technicianName': 'Ahmed Hassan',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/customer/new-booking');
            },
          ),
        ],
      ),
      body: demoBookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No bookings yet',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Book your first service appointment',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/customer/new-booking');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Book Service'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: demoBookings.length,
              itemBuilder: (context, index) {
                final booking = demoBookings[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16.h),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                _getStatusIcon(booking['status']),
                                size: 24.sp,
                                color: _getStatusColor(booking['status']),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking['serviceType'],
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${booking['carMake']} ${booking['carModel']}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${booking['scheduledDate']} at ${booking['scheduledTime']}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                _getStatusText(booking['status']),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: _getStatusColor(booking['status']),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Technician',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    booking['technicianName'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duration',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    booking['estimatedDuration'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '${booking['price']} EGP',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (booking['status'] == 'confirmed' || booking['status'] == 'in_progress') ...[
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Cancel booking
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Reschedule booking
                                  },
                                  child: const Text('Reschedule'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/customer/new-booking');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.blue;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.schedule;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}