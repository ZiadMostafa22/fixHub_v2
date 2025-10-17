import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomerCarsPage extends StatelessWidget {
  const CustomerCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for cars
    final List<Map<String, dynamic>> demoCars = [
      {
        'id': '1',
        'make': 'Toyota',
        'model': 'Camry',
        'year': '2020',
        'plateNumber': 'ABC-123',
        'color': 'White',
        'mileage': '45000',
        'lastServiceDate': '2024-01-15',
        'nextServiceDate': '2024-04-15',
      },
      {
        'id': '2',
        'make': 'Honda',
        'model': 'Civic',
        'year': '2019',
        'plateNumber': 'XYZ-789',
        'color': 'Black',
        'mileage': '38000',
        'lastServiceDate': '2024-02-10',
        'nextServiceDate': '2024-05-10',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/customer/add-car');
            },
          ),
        ],
      ),
      body: demoCars.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No cars added yet',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add your first car to get started',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/customer/add-car');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Car'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: demoCars.length,
              itemBuilder: (context, index) {
                final car = demoCars[index];
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
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.directions_car,
                                size: 30.sp,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${car['make']} ${car['model']}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${car['year']} • ${car['plateNumber']}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${car['color']} • ${car['mileage']} km',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    // Navigate to edit car page
                                    break;
                                  case 'delete':
                                    // Show delete confirmation
                                    break;
                                  case 'service_history':
                                    // Navigate to service history
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'service_history',
                                  child: Row(
                                    children: [
                                      Icon(Icons.history),
                                      SizedBox(width: 8),
                                      Text('Service History'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16.sp,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Next Service: ${car['nextServiceDate']}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/customer/add-car');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}