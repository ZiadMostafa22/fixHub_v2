import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Ahmed Mohamed',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'ahmed.mohamed@email.com',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '+20 123 456 7890',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Profile Options
            _buildProfileOption(
              context,
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'Update your personal details',
              onTap: () {},
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.directions_car,
              title: 'My Cars',
              subtitle: 'Manage your vehicles',
              onTap: () {
                context.go('/customer/cars');
              },
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.calendar_today,
              title: 'My Bookings',
              subtitle: 'View and manage appointments',
              onTap: () {
                context.go('/customer/bookings');
              },
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.history,
              title: 'Service History',
              subtitle: 'View past services',
              onTap: () {
                context.go('/customer/history');
              },
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.local_offer,
              title: 'Special Offers',
              subtitle: 'View available discounts',
              onTap: () {
                context.go('/customer/offers');
              },
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {},
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {},
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {},
            ),
            
            SizedBox(height: 32.h),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.go('/login');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}