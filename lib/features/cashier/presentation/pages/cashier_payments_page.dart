import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:car_maintenance_system_new/core/providers/auth_provider.dart';
import 'package:car_maintenance_system_new/core/providers/booking_provider.dart';
import 'package:car_maintenance_system_new/core/providers/car_provider.dart';
import 'package:car_maintenance_system_new/core/models/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CashierPaymentsPage extends ConsumerStatefulWidget {
  const CashierPaymentsPage({super.key});

  @override
  ConsumerState<CashierPaymentsPage> createState() => _CashierPaymentsPageState();
}

class _CashierPaymentsPageState extends ConsumerState<CashierPaymentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Cache for user names
  final Map<String, String> _userNames = {};

  Future<String> _getUserName(String userId) async {
    if (_userNames.containsKey(userId)) {
      return _userNames[userId]!;
    }
    
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (userDoc.exists) {
        final userName = userDoc.data()?['name'] ?? 'Unknown Customer';
        _userNames[userId] = userName;
        return userName;
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    }
    
    _userNames[userId] = 'Unknown Customer';
    return 'Unknown Customer';
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        // Start real-time listening for all bookings
        ref.read(bookingProvider.notifier).startListening(user.id, role: 'cashier');
      }
      // Load car details
      ref.read(carProvider.notifier).loadCars('');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    try {
      ref.read(bookingProvider.notifier).stopListening();
    } catch (e) {
      debugPrint('Payments page disposed, listener cleanup skipped: $e');
    }
    super.dispose();
  }

  Future<void> _refreshData() async {
    final user = ref.read(authProvider).user;
    if (user != null) {
      await ref.read(bookingProvider.notifier).loadBookings(user.id, role: 'cashier');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    
    // Filter bookings
    final pendingPayments = bookingState.bookings
        .where((b) => b.status == BookingStatus.completedPendingPayment)
        .toList();
    
    final completedPayments = bookingState.bookings
        .where((b) => b.status == BookingStatus.completed && b.isPaid)
        .toList()
      ..sort((a, b) => b.paidAt!.compareTo(a.paidAt!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pending'),
                  SizedBox(width: 8.w),
                  if (pendingPayments.isNotEmpty)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.orange,
                      child: Text(
                        '${pendingPayments.length}',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pending Payments Tab
          RefreshIndicator(
            onRefresh: _refreshData,
            child: pendingPayments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No pending payments',
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: pendingPayments.length,
                    itemBuilder: (context, index) {
                      final booking = pendingPayments[index];
                      return _buildPaymentCard(booking, isPending: true);
                    },
                  ),
          ),
          
          // Completed Payments Tab
          RefreshIndicator(
            onRefresh: _refreshData,
            child: completedPayments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No completed payments',
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: completedPayments.length,
                    itemBuilder: (context, index) {
                      final booking = completedPayments[index];
                      return _buildPaymentCard(booking, isPending: false);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BookingModel booking, {required bool isPending}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () {
          // Both pending and completed payments are clickable
          context.go('/cashier/payment/${booking.id}');
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice #${booking.id.substring(0, 8)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        FutureBuilder<String>(
                          future: _getUserName(booking.userId),
                          builder: (context, snapshot) {
                            final customerName = snapshot.data ?? 'Loading...';
                            return Text(
                              'Customer: $customerName',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 4.h),
                        if (booking.completedAt != null)
                          Text(
                            'Completed: ${DateFormat('dd/MM/yyyy HH:mm').format(booking.completedAt!)}',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${booking.totalCost.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: isPending ? Colors.orange : Colors.green,
                        ),
                      ),
                      if (!isPending && booking.paidAt != null)
                        Text(
                          DateFormat('dd/MM HH:mm').format(booking.paidAt!),
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Car Details Section
              Consumer(
                builder: (context, ref, child) {
                  final carState = ref.watch(carProvider);
                  final car = carState.cars.isEmpty 
                      ? null 
                      : carState.cars.where((c) => c.id == booking.carId).firstOrNull;
                  
                  if (car != null) {
                    return Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 16.sp,
                            color: Colors.blue.shade700,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${car.year} ${car.make} ${car.model}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                Text(
                                  '${car.color} • ${car.licensePlate}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              SizedBox(height: 12.h),
              
              if (!isPending && booking.paymentMethod != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getPaymentIcon(booking.paymentMethod!),
                        size: 16.sp,
                        color: Colors.green.shade700,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _getPaymentMethodName(booking.paymentMethod!),
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              
              if (isPending)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/cashier/payment/${booking.id}');
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Receive Payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.digital:
        return Icons.phone_android;
    }
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.digital:
        return 'Digital Wallet';
    }
  }
}
