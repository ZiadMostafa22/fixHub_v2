import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TechnicianJobsPage extends StatelessWidget {
  const TechnicianJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for jobs
    final List<Map<String, dynamic>> demoJobs = [
      {
        'id': '1',
        'customerName': 'Ahmed Mohamed',
        'carMake': 'Toyota',
        'carModel': 'Camry',
        'serviceType': 'Oil Change',
        'status': 'in_progress',
        'scheduledDate': '2024-03-15',
        'scheduledTime': '10:00 AM',
        'estimatedDuration': '1 hour',
        'priority': 'normal',
      },
      {
        'id': '2',
        'customerName': 'Omar Ibrahim',
        'carMake': 'Honda',
        'carModel': 'Civic',
        'serviceType': 'Brake Service',
        'status': 'pending',
        'scheduledDate': '2024-03-15',
        'scheduledTime': '2:00 PM',
        'estimatedDuration': '2 hours',
        'priority': 'high',
      },
      {
        'id': '3',
        'customerName': 'Mohamed Ali',
        'carMake': 'Nissan',
        'carModel': 'Altima',
        'serviceType': 'Engine Check',
        'status': 'completed',
        'scheduledDate': '2024-03-14',
        'scheduledTime': '9:00 AM',
        'estimatedDuration': '1.5 hours',
        'priority': 'normal',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter jobs
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: demoJobs.length,
        itemBuilder: (context, index) {
          final job = demoJobs[index];
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
                          color: _getStatusColor(job['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          _getStatusIcon(job['status']),
                          size: 24.sp,
                          color: _getStatusColor(job['status']),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['serviceType'],
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${job['carMake']} ${job['carModel']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Customer: ${job['customerName']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: _getStatusColor(job['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              _getStatusText(job['status']),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: _getStatusColor(job['status']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          if (job['priority'] == 'high')
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'HIGH',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
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
                              'Scheduled',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${job['scheduledDate']} at ${job['scheduledTime']}',
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
                              job['estimatedDuration'],
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (job['status'] == 'pending' || job['status'] == 'in_progress') ...[
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        if (job['status'] == 'pending')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Start job
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Start Job'),
                            ),
                          ),
                        if (job['status'] == 'in_progress') ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Pause job
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.orange,
                                side: const BorderSide(color: Colors.orange),
                              ),
                              child: const Text('Pause'),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Complete job
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Complete'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
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
      case 'pending':
        return Icons.schedule;
      case 'in_progress':
        return Icons.build;
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
      case 'pending':
        return 'Pending';
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