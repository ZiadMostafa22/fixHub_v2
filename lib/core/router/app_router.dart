import 'package:go_router/go_router.dart';
import 'package:car_maintenance_system_new/features/auth/presentation/pages/login_page.dart';
import 'package:car_maintenance_system_new/features/auth/presentation/pages/register_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_dashboard.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_cars_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_bookings_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_history_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_profile_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/customer_offers_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/new_booking_page.dart';
import 'package:car_maintenance_system_new/features/customer/presentation/pages/add_car_page.dart';
import 'package:car_maintenance_system_new/features/technician/presentation/pages/technician_dashboard.dart';
import 'package:car_maintenance_system_new/features/technician/presentation/pages/technician_jobs_page.dart';
import 'package:car_maintenance_system_new/features/technician/presentation/pages/technician_profile_page.dart';
import 'package:car_maintenance_system_new/features/technician/presentation/pages/job_details_page.dart';
import 'package:car_maintenance_system_new/features/admin/presentation/pages/admin_dashboard.dart';
import 'package:car_maintenance_system_new/features/admin/presentation/pages/admin_users_page.dart';
import 'package:car_maintenance_system_new/features/admin/presentation/pages/admin_technicians_page.dart';
import 'package:car_maintenance_system_new/features/admin/presentation/pages/admin_bookings_page.dart';
import 'package:car_maintenance_system_new/features/admin/presentation/pages/admin_offers_page.dart';
import 'package:car_maintenance_system_new/features/admin/presentation/pages/admin_analytics_page.dart';
import 'package:car_maintenance_system_new/features/admin/presentation/pages/admin_invite_codes_page.dart';
import 'package:car_maintenance_system_new/features/cashier/presentation/pages/cashier_dashboard.dart';
import 'package:car_maintenance_system_new/features/cashier/presentation/pages/cashier_payments_page.dart';
import 'package:car_maintenance_system_new/features/cashier/presentation/pages/cashier_payment_details_page.dart';
import 'package:car_maintenance_system_new/features/cashier/presentation/pages/cashier_profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Authentication
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Customer Routes
      GoRoute(
        path: '/customer',
        builder: (context, state) => const CustomerDashboard(),
        routes: [
          GoRoute(
            path: 'cars',
            builder: (context, state) => const CustomerCarsPage(),
          ),
          GoRoute(
            path: 'add-car',
            builder: (context, state) => const AddCarPage(),
          ),
          GoRoute(
            path: 'bookings',
            builder: (context, state) => const CustomerBookingsPage(),
          ),
          GoRoute(
            path: 'new-booking',
            builder: (context, state) => const NewBookingPage(),
          ),
          GoRoute(
            path: 'history',
            builder: (context, state) => const CustomerHistoryPage(),
          ),
          GoRoute(
            path: 'offers',
            builder: (context, state) => const CustomerOffersPage(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const CustomerProfilePage(),
          ),
        ],
      ),
      
      // Technician Routes
      GoRoute(
        path: '/technician',
        builder: (context, state) => const TechnicianDashboard(),
        routes: [
          GoRoute(
            path: 'jobs',
            builder: (context, state) => const TechnicianJobsPage(),
          ),
          GoRoute(
            path: 'job-details/:bookingId',
            builder: (context, state) {
              final bookingId = state.pathParameters['bookingId']!;
              return JobDetailsPage(bookingId: bookingId);
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const TechnicianProfilePage(),
          ),
        ],
      ),
      
      // Admin Routes
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
        routes: [
          GoRoute(
            path: 'users',
            builder: (context, state) => const AdminUsersPage(),
          ),
          GoRoute(
            path: 'technicians',
            builder: (context, state) => const AdminTechniciansPage(),
          ),
          GoRoute(
            path: 'bookings',
            builder: (context, state) => const AdminBookingsPage(),
          ),
          GoRoute(
            path: 'analytics',
            builder: (context, state) => const AdminAnalyticsPage(),
          ),
          GoRoute(
            path: 'invite-codes',
            builder: (context, state) => const AdminInviteCodesPage(),
          ),
          GoRoute(
            path: 'offers',
            builder: (context, state) => const AdminOffersPage(),
          ),
        ],
      ),
      
      // Cashier Routes
      GoRoute(
        path: '/cashier',
        builder: (context, state) => const CashierDashboard(),
        routes: [
          GoRoute(
            path: 'payments',
            builder: (context, state) => const CashierPaymentsPage(),
          ),
          GoRoute(
            path: 'payment/:bookingId',
            builder: (context, state) {
              final bookingId = state.pathParameters['bookingId']!;
              return CashierPaymentDetailsPage(bookingId: bookingId);
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const CashierProfilePage(),
          ),
        ],
      ),
    ],
  );
}
