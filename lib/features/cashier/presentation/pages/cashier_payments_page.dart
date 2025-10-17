import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CashierPaymentsPage extends StatelessWidget {
  const CashierPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for payments
    final List<Map<String, dynamic>> demoPayments = [
      {
        'id': '1',
        'customerName': 'Ahmed Mohamed',
        'serviceType': 'Oil Change',
        'carMake': 'Toyota',
        'carModel': 'Camry',
        'amount': '150',
        'status': 'pending',
        'date': '2024-03-15',
        'time': '10:00 AM',
      },
      {
        'id': '2',
        'customerName': 'Omar Ibrahim',
        'serviceType': 'Brake Service',
        'carMake': 'Honda',
        'carModel': 'Civic',
        'amount': '300',
        'status': 'completed',
        'date': '2024-03-15',
        'time': '2:00 PM',
      },
      {
        'id': '3',
        'customerName': 'Mohamed Ali',
        'serviceType': 'Engine Check',
        'carMake': 'Nissan',
        'carModel': 'Altima',
        'amount': '200',
        'status': 'pending',
        'date': '2024-03-14',
        'time': '9:00 AM',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter payments
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: demoPayments.length,
        itemBuilder: (context, index) {
          final payment = demoPayments[index];
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
                          color: _getStatusColor(payment['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          _getStatusIcon(payment['status']),
                          size: 24.sp,
                          color: _getStatusColor(payment['status']),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment['serviceType'],
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${payment['carMake']} ${payment['carModel']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Customer: ${payment['customerName']}',
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
                          Text(
                            '${payment['amount']} EGP',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: _getStatusColor(payment['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              _getStatusText(payment['status']),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: _getStatusColor(payment['status']),
                                fontWeight: FontWeight.w500,
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
                              'Date & Time',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${payment['date']} at ${payment['time']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (payment['status'] == 'pending')
                        ElevatedButton(
                          onPressed: () {
                            // Process payment
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Process Payment'),
                        ),
                    ],
                  ),
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
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}