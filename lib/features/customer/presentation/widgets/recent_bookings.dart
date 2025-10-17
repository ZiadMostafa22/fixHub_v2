import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentBookings extends StatelessWidget {
  const RecentBookings({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for recent bookings
    final List<Map<String, dynamic>> recentBookings = [
      {
        'id': '1',
        'serviceType': 'Oil Change',
        'carMake': 'Toyota',
        'carModel': 'Camry',
        'date': '2024-03-05',
        'status': 'completed',
        'price': '150',
      },
      {
        'id': '2',
        'serviceType': 'Brake Service',
        'carMake': 'Honda',
        'carModel': 'Civic',
        'date': '2024-02-20',
        'status': 'completed',
        'price': '300',
      },
      {
        'id': '3',
        'serviceType': 'Engine Check',
        'carMake': 'Toyota',
        'carModel': 'Camry',
        'date': '2024-01-15',
        'status': 'completed',
        'price': '200',
      },
    ];

    if (recentBookings.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Icon(
                Icons.receipt_long,
                size: 48.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                'No recent bookings',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your service history will appear here',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: recentBookings.map((booking) {
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        booking['serviceType'],
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '${booking['carMake']} ${booking['carModel']}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16.sp,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          booking['date'],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
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
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}