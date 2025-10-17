import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data for users
    final List<Map<String, dynamic>> demoUsers = [
      {
        'id': '1',
        'name': 'Ahmed Mohamed',
        'email': 'ahmed@email.com',
        'phone': '+20 123 456 7890',
        'role': 'customer',
        'status': 'active',
        'joinDate': '2024-01-15',
        'totalBookings': 5,
      },
      {
        'id': '2',
        'name': 'Mohamed Ali',
        'email': 'mohamed@email.com',
        'phone': '+20 987 654 3210',
        'role': 'technician',
        'status': 'active',
        'joinDate': '2024-01-10',
        'totalBookings': 12,
      },
      {
        'id': '3',
        'name': 'Omar Ibrahim',
        'email': 'omar@email.com',
        'phone': '+20 555 123 4567',
        'role': 'customer',
        'status': 'inactive',
        'joinDate': '2024-02-01',
        'totalBookings': 2,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new user
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: demoUsers.length,
        itemBuilder: (context, index) {
          final user = demoUsers[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16.h),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.r,
                        backgroundColor: _getRoleColor(user['role']).withOpacity(0.1),
                        child: Icon(
                          _getRoleIcon(user['role']),
                          color: _getRoleColor(user['role']),
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'],
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              user['email'],
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              user['phone'],
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
                              color: _getStatusColor(user['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              user['status'].toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: _getStatusColor(user['status']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            user['role'].toUpperCase(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: _getRoleColor(user['role']),
                              fontWeight: FontWeight.w500,
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
                              'Join Date',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              user['joinDate'],
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
                              'Total Bookings',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${user['totalBookings']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                // Edit user
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                              onPressed: () {
                                // Delete user
                              },
                            ),
                          ],
                        ),
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

  Color _getRoleColor(String role) {
    switch (role) {
      case 'customer':
        return Colors.blue;
      case 'technician':
        return Colors.green;
      case 'admin':
        return Colors.red;
      case 'cashier':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'customer':
        return Icons.person;
      case 'technician':
        return Icons.build;
      case 'admin':
        return Icons.admin_panel_settings;
      case 'cashier':
        return Icons.payment;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}