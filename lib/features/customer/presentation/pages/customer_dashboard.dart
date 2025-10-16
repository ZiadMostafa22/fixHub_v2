import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:car_maintenance_system_new/core/providers/auth_provider.dart';
import 'package:car_maintenance_system_new/core/providers/booking_provider.dart';
import 'package:car_maintenance_system_new/core/providers/car_provider.dart';
import 'package:car_maintenance_system_new/features/shared/presentation/pages/settings_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/widgets/quick_actions.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/widgets/upcoming_appointments.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/widgets/active_services.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/widgets/missed_appointments.dart';
import 'package:car_maintenance_system_new/core/models/booking_model.dart';

class CustomerDashboard extends ConsumerStatefulWidget {
  const CustomerDashboard({super.key});

  @override
  ConsumerState<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends ConsumerState<CustomerDashboard> {
  @override
  void initState() {
    super.initState();
    // Start real-time listeners for bookings and load cars when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        // Start real-time listener for bookings
        ref.read(bookingProvider.notifier).startListening(user.id);
        // Load cars (one-time)
        ref.read(carProvider.notifier).loadCars(user.id);
      }
    });
  }

  @override
  void dispose() {
    // Stop listening when dashboard is disposed
    // Wrap in try-catch to handle cases where widget is already disposed during logout
    try {
      ref.read(bookingProvider.notifier).stopListening();
    } catch (e) {
      // Widget was already disposed, safe to ignore
      debugPrint('Dashboard disposed, listener cleanup skipped: $e');
    }
    super.dispose();
  }

  Future<void> _refreshData() async {
    final user = ref.read(authProvider).user;
    if (user != null) {
      await ref.read(bookingProvider.notifier).loadBookings(user.id);
      await ref.read(carProvider.notifier).loadCars(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ${user?.name ?? 'Customer'}',
          style: TextStyle(fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 22.sp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, size: 22.sp),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good ${_getGreeting()}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'How can we help you with your car today?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 16.h),
            const QuickActions(),
            
            SizedBox(height: 24.h),
            
            // Upcoming Appointments (only show section if there are appointments)
            Consumer(
              builder: (context, ref, child) {
                final bookingState = ref.watch(bookingProvider);
                final upcomingBookings = bookingState.bookings.where((booking) {
                  return (booking.status == BookingStatus.pending ||
                          booking.status == BookingStatus.confirmed) &&
                         booking.scheduledDate.isAfter(DateTime.now());
                }).toList();
                
                if (upcomingBookings.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Appointments',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    const UpcomingAppointments(),
                    SizedBox(height: 24.h),
                  ],
                );
              },
            ),
            
            // Missed Appointments (show if any exist)
            const MissedAppointments(),
            
            // Active Services (In Progress & Pending Payment)
            const ActiveServices(),
            
            SizedBox(height: 24.h),
            
          ],
        ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedFontSize: 12.sp,
        unselectedFontSize: 10.sp,
        iconSize: 24.sp,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              context.go('/customer/cars');
              break;
            case 2:
              context.go('/customer/offers');
              break;
            case 3:
              context.go('/customer/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'My Cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }
}