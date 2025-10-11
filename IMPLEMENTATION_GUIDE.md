# Car Maintenance System - Advanced Features Implementation Guide

## Overview
This guide provides implementation details for the requested advanced features:
1. Fix overflow in add service items dialog
2. Rating system for completed services
3. Analytics dashboard
4. Enhanced technician profile
5. Editable customer profile

---

## 1. Fix Overflow in Add Service Items Dialog

### Problem
Dialog content overflows on smaller screens.

### Solution
Use `flutter_screenutil` for responsive sizing.

### Implementation
**File:** `lib/features/technician/presentation/pages/job_details_page.dart`

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _ServiceItemDialogState extends State<_ServiceItemDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Service Item', style: TextStyle(fontSize: 16.sp)),
      contentPadding: EdgeInsets.all(16.w),
      content: Container(
        width: 0.85.sw, // 85% of screen width
        constraints: BoxConstraints(maxHeight: 0.7.sh), // Max 70% screen height
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ServiceItemModel>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Select Service/Part',
                    labelStyle: TextStyle(fontSize: 14.sp),
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                  // ... rest of dropdown
                ),
                SizedBox(height: 12.h),
                if (_selectedItem != null) ...[
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: \$${_selectedItem!.price.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                        ),
                        if (_selectedItem!.description != null)
                          Text(
                            _selectedItem!.description!,
                            style: TextStyle(fontSize: 11.sp),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(fontSize: 14.sp),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  ),
                  // ... validator
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // ... create item
              Navigator.pop(context);
            }
          },
          child: Text('Add', style: TextStyle(fontSize: 14.sp)),
        ),
      ],
    );
  }
}
```

---

## 2. Rating System Implementation

### A. Update Booking Model

**File:** `lib/core/models/booking_model.dart`

Add rating field:
```dart
class BookingModel {
  // Existing fields...
  final double? rating; // Customer rating (1-5)
  final String? ratingComment; // Optional comment
  final DateTime? ratedAt;

  BookingModel({
    // ... existing parameters
    this.rating,
    this.ratingComment,
    this.ratedAt,
  });

  // Update fromFirestore
  factory BookingModel.fromFirestore(Map<String, dynamic> map, String id) {
    return BookingModel(
      // ... existing fields
      rating: map['rating']?.toDouble(),
      ratingComment: map['ratingComment'],
      ratedAt: map['ratedAt'] != null ? (map['ratedAt'] as Timestamp).toDate() : null,
    );
  }

  // Update toFirestore
  Map<String, dynamic> toFirestore() {
    return {
      // ... existing fields
      'rating': rating,
      'ratingComment': ratingComment,
      'ratedAt': ratedAt != null ? Timestamp.fromDate(ratedAt!) : null,
    };
  }

  // Update copyWith
  BookingModel copyWith({
    // ... existing parameters
    double? rating,
    String? ratingComment,
    DateTime? ratedAt,
  }) {
    return BookingModel(
      // ... existing fields
      rating: rating ?? this.rating,
      ratingComment: ratingComment ?? this.ratingComment,
      ratedAt: ratedAt ?? this.ratedAt,
    );
  }
}
```

### B. Create Rating Dialog Widget

**File:** `lib/core/widgets/rating_dialog.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Add to pubspec.yaml

class RatingDialog extends StatefulWidget {
  final Function(double rating, String comment) onSubmit;
  
  const RatingDialog({super.key, required this.onSubmit});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 5.0;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate This Service'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How would you rate your service experience?'),
          const SizedBox(height: 20),
          RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Comments (Optional)',
              border: OutlineInputBorder(),
              hintText: 'Share your experience...',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(_rating, _commentController.text);
            Navigator.pop(context);
          },
          child: const Text('Submit Rating'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
```

### C. Add Rating to Booking Provider

**File:** `lib/core/providers/booking_provider.dart`

Add method:
```dart
Future<bool> rateBooking(String bookingId, double rating, String comment) async {
  try {
    await FirebaseService.bookingsCollection.doc(bookingId).update({
      'rating': rating,
      'ratingComment': comment,
      'ratedAt': Timestamp.now(),
    });
    await loadBookings(state.bookings.first.userId);
    return true;
  } catch (e) {
    debugPrint('Error rating booking: $e');
    return false;
  }
}
```

### D. Show Rating Dialog After Completed Service

**File:** `lib/features/customer/presentation/pages/customer_history_page.dart`

Add button for unrated completed bookings:
```dart
if (booking.status == BookingStatus.completed && booking.rating == null)
  ElevatedButton.icon(
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => RatingDialog(
          onSubmit: (rating, comment) async {
            final success = await ref
                .read(bookingProvider.notifier)
                .rateBooking(booking.id, rating, comment);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'Rating submitted!' : 'Failed to submit rating'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            }
          },
        ),
      );
    },
    icon: const Icon(Icons.star),
    label: const Text('Rate Service'),
    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
  ),
```

---

## 3. Analytics Dashboard Implementation

### Create Analytics Page

**File:** `lib/features/admin/presentation/pages/admin_analytics_page_new.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:car_maintenance_system_new/core/providers/booking_provider.dart';
import 'package:car_maintenance_system_new/core/models/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAnalyticsPage extends ConsumerStatefulWidget {
  const AdminAnalyticsPage({super.key});

  @override
  ConsumerState<AdminAnalyticsPage> createState() => _AdminAnalyticsPageState();
}

class _AdminAnalyticsPageState extends ConsumerState<AdminAnalyticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load all bookings for analytics
      ref.read(bookingProvider.notifier).loadBookings('', role: 'admin');
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    
    // Calculate analytics
    final completedBookings = bookingState.bookings
        .where((b) => b.status == BookingStatus.completed)
        .toList();
    
    // Total revenue
    final totalRevenue = completedBookings.fold<double>(
      0,
      (sum, booking) => sum + booking.totalCost,
    );

    // Revenue by day (last 7 days)
    final Map<String, double> revenueByDay = {};
    final now = DateTime.now();
    for (var i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('MMM dd').format(date);
      revenueByDay[dateStr] = 0;
    }
    
    for (var booking in completedBookings) {
      if (booking.completedAt != null) {
        final dateStr = DateFormat('MMM dd').format(booking.completedAt!);
        if (revenueByDay.containsKey(dateStr)) {
          revenueByDay[dateStr] = (revenueByDay[dateStr] ?? 0) + booking.totalCost;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Summary
            Text(
              'Revenue Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatRow('Total Revenue', '\$${totalRevenue.toStringAsFixed(2)}'),
                    const Divider(),
                    _buildStatRow('Completed Jobs', completedBookings.length.toString()),
                    const Divider(),
                    _buildStatRow(
                      'Average per Job',
                      completedBookings.isEmpty
                          ? '\$0.00'
                          : '\$${(totalRevenue / completedBookings.length).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Revenue Chart
            Text(
              'Revenue by Day (Last 7 Days)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 250,
                  child: _buildRevenueChart(revenueByDay),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Technician Performance
            Text(
              'Top Technicians',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildTopTechnicians(context, completedBookings),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(Map<String, double> data) {
    final entries = data.entries.toList();
    final maxY = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    
    return BarChart(
      BarChartData(
        maxY: maxY * 1.2,
        barGroups: entries.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value,
                color: Colors.blue,
                width: 20,
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < entries.length) {
                  return Text(
                    entries[value.toInt()].key.split(' ')[1],
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }

  Widget _buildTopTechnicians(BuildContext context, List<BookingModel> completedBookings) {
    // Get all technicians with their stats
    final Map<String, Map<String, dynamic>> techStats = {};
    
    for (var booking in completedBookings) {
      if (booking.assignedTechnicians != null) {
        for (var techId in booking.assignedTechnicians!) {
          if (!techStats.containsKey(techId)) {
            techStats[techId] = {
              'completedJobs': 0,
              'totalHours': 0.0,
              'totalRevenue': 0.0,
              'ratings': <double>[],
            };
          }
          techStats[techId]!['completedJobs']++;
          techStats[techId]!['totalHours'] += booking.hoursWorked;
          techStats[techId]!['totalRevenue'] += booking.totalCost;
          if (booking.rating != null) {
            techStats[techId]!['ratings'].add(booking.rating!);
          }
        }
      }
    }
    
    // Calculate average ratings
    final List<MapEntry<String, Map<String, dynamic>>> sortedTechs = techStats.entries.toList();
    for (var entry in sortedTechs) {
      final ratings = entry.value['ratings'] as List<double>;
      entry.value['avgRating'] = ratings.isEmpty
          ? 0.0
          : ratings.reduce((a, b) => a + b) / ratings.length;
    }
    
    // Sort by completed jobs
    sortedTechs.sort((a, b) =>
        (b.value['completedJobs'] as int).compareTo(a.value['completedJobs'] as int));
    
    if (sortedTechs.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('No technician data available')),
        ),
      );
    }
    
    return Column(
      children: sortedTechs.take(5).map((entry) {
        final stats = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(entry.key[0].toUpperCase()),
            ),
            title: Text('Technician ${entry.key.substring(0, 8)}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Completed: ${stats['completedJobs']} jobs'),
                Text('Hours: ${(stats['totalHours'] as double).toStringAsFixed(1)}h'),
                Text('Revenue: \$${(stats['totalRevenue'] as double).toStringAsFixed(2)}'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(
                  (stats['avgRating'] as double).toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      }).toList(),
    );
  }
}
```

---

## 4. Enhanced Technician Profile

Update technician profile to show real stats from bookings.

**File:** `lib/features/technician/presentation/pages/technician_profile_page_new.dart`

See full implementation in repository.

---

## 5. Editable Customer Profile

Create new customer profile page with edit functionality.

**File:** `lib/features/customer/presentation/pages/customer_profile_page_new.dart`

See full implementation in repository.

---

## Required Package Updates

Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter_rating_bar: ^4.0.1  # For rating stars
```

Run: `flutter pub get`

---

## Summary

This guide provides the foundation for implementing all requested features. The key components are:

1. ✅ ScreenUtil integration for responsive dialogs
2. ✅ Complete rating system with database integration
3. ✅ Analytics dashboard with charts and statistics
4. ✅ Enhanced technician profiles with real-time stats
5. ✅ Editable customer profiles

Each section can be implemented incrementally to ensure stability.

