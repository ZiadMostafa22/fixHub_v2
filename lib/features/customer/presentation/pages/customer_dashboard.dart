import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_cars_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_bookings_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_history_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_offers_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_profile_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/widgets/quick_actions.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/widgets/upcoming_appointments.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/widgets/active_services.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/widgets/missed_appointments.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _DashboardHome(),
    const CustomerCarsPage(),
    const CustomerBookingsPage(),
    const CustomerHistoryPage(),
    const CustomerOffersPage(),
    const CustomerProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
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
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
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
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Ahmed Mohamed!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your car maintenance efficiently',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick Actions
            const QuickActions(),
            const SizedBox(height: 24),
            
            // Upcoming Appointments
            const UpcomingAppointments(),
            const SizedBox(height: 24),
            
            // Active Services
            const ActiveServices(),
            const SizedBox(height: 24),
            
            // Missed Appointments
            const MissedAppointments(),
          ],
        ),
      ),
    );
  }
}