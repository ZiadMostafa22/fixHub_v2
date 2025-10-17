import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerHistoryPage extends StatelessWidget {
  const CustomerHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for service history
    final List<Map<String, dynamic>> demoHistory = [
      {
        'id': '1',
        'carMake': 'Toyota',
        'carModel': 'Camry',
        'serviceType': 'Oil Change',
        'date': '2024-03-05',
        'price': '150',
        'technicianName': 'Ahmed Hassan',
        'rating': 5,
      },
      {
        'id': '2',
        'carMake': 'Honda',
        'carModel': 'Civic',
        'serviceType': 'Brake Service',
        'date': '2024-02-20',
        'price': '300',
        'technicianName': 'Mohamed Ali',
        'rating': 4,
      },
      {
        'id': '3',
        'carMake': 'Toyota',
        'carModel': 'Camry',
        'serviceType': 'Engine Check',
        'date': '2024-01-15',
        'price': '200',
        'technicianName': 'Ahmed Hassan',
        'rating': 5,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service History'),
      ),
      body: demoHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No service history',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your completed services will appear here',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: demoHistory.length,
              itemBuilder: (context, index) {
                final history = demoHistory[index];
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
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.done_all,
                                size: 24.sp,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    history['serviceType'],
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${history['carMake']} ${history['carModel']}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Completed on ${history['date']}',
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
                                  '${history['price']} EGP',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < history['rating']
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 16.sp,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16.sp,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Technician: ${history['technicianName']}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
}