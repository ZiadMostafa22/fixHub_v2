import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_maintenance_system_new/core/models/booking_model.dart';
import 'package:car_maintenance_system_new/core/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

// Type alias for convenience
typedef Booking = BookingModel;

class BookingState {
  final List<Booking> bookings;
  final bool isLoading;
  final String? error;

  BookingState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
  });

  BookingState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(BookingState());
  
  StreamSubscription<QuerySnapshot>? _bookingsSubscription;

  Future<void> loadBookings(String userId, {String? role}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      Query query;
      if (role == 'admin' || role == 'technician' || role == 'cashier') {
        // Admin, Technician, and Cashier see all bookings - can use orderBy directly
        query = FirebaseService.bookingsCollection.orderBy('createdAt', descending: true);
      } else {
        // Customer sees only their bookings - can't combine where + orderBy without composite index
        query = FirebaseService.bookingsCollection.where('userId', isEqualTo: userId);
      }
      
      final snapshot = await query.get();
      
      var bookings = snapshot.docs
          .map((doc) => Booking.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // Sort in memory if we didn't use orderBy in the query
      if (role != 'admin' && role != 'technician' && role != 'cashier') {
        bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      
      if (kDebugMode) {
        print('📋 Loaded ${bookings.length} bookings');
        for (var booking in bookings) {
          print('  - ${booking.id}: ${booking.status}');
        }
      }
      
      state = state.copyWith(bookings: bookings, isLoading: false);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading bookings: $e');
      }
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Start listening to real-time updates
  void startListening(String userId, {String? role}) {
    // Cancel any existing subscription
    _bookingsSubscription?.cancel();
    
    Query query;
    if (role == 'admin' || role == 'technician' || role == 'cashier') {
      // Admin, Technician, and Cashier see all bookings - can use orderBy directly
      query = FirebaseService.bookingsCollection.orderBy('createdAt', descending: true);
    } else {
      // Customer sees only their bookings - can't combine where + orderBy without composite index
      // So we'll just use where and sort in memory
      query = FirebaseService.bookingsCollection.where('userId', isEqualTo: userId);
    }
    
    _bookingsSubscription = query
        .snapshots()
        .listen(
      (snapshot) {
        var bookings = snapshot.docs
            .map((doc) => Booking.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        
        // Sort in memory if we didn't use orderBy in the query
        if (role != 'admin' && role != 'technician' && role != 'cashier') {
          bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
        
        if (kDebugMode) {
          print('🔄 Real-time update: ${bookings.length} bookings');
          for (var booking in bookings.take(3)) {
            print('  - ${booking.id}: ${booking.status}');
          }
          // Debug: Check for bookings with discount info
          for (var booking in bookings) {
            if (booking.offerCode != null || booking.discountPercentage != null) {
              print('💰 Found booking with discount: ${booking.id}');
              print('   - Code: ${booking.offerCode}');
              print('   - Title: ${booking.offerTitle}');
              print('   - %: ${booking.discountPercentage}');
            }
          }
        }
        
        // Only update if we have meaningful changes to prevent UI flicker
        if (bookings.length != state.bookings.length || 
            bookings.any((booking) => !state.bookings.any((b) => b.id == booking.id && b.status == booking.status))) {
          state = state.copyWith(bookings: bookings, isLoading: false);
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('❌ Error in real-time listener: $error');
        }
        state = state.copyWith(error: error.toString());
      },
    );
  }

  // Stop listening to real-time updates
  void stopListening() {
    _bookingsSubscription?.cancel();
    _bookingsSubscription = null;
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  Future<bool> createBooking(Booking booking) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Debug: Print booking data before saving
      if (kDebugMode) {
        print('📤 Creating booking with data:');
        print('  - ID: ${booking.id}');
        print('  - User ID: ${booking.userId}');
        print('  - Offer Code: ${booking.offerCode}');
        print('  - Offer Title: ${booking.offerTitle}');
        print('  - Discount %: ${booking.discountPercentage}');
        print('  - Firestore data: ${booking.toFirestore()}');
      }
      
      // Add to Firestore - the real-time listener will automatically add it to state
      await FirebaseService.bookingsCollection.add(booking.toFirestore());
      
      if (kDebugMode) {
        print('✅ Booking created successfully - real-time listener will update state');
      }
      
      state = state.copyWith(isLoading: false);
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating booking: $e');
      }
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateBooking(String bookingId, Map<String, dynamic> updates) async {
    try {
      if (kDebugMode) {
        print('📝 Updating booking $bookingId with: $updates');
      }
      
      // Simple update to Firestore - let real-time listener handle state update
      await FirebaseService.bookingsCollection.doc(bookingId).update(updates);
      
      if (kDebugMode) {
        print('✅ Booking updated successfully - real-time listener will update state');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating booking: $e');
      }
      return false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      if (kDebugMode) {
        print('🚫 Cancelling booking $bookingId');
      }
      
      // Immediately update local state first to prevent loading issues
      final updatedBookings = state.bookings.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            status: BookingStatus.cancelled,
            updatedAt: DateTime.now(),
          );
        }
        return booking;
      }).toList();
      
      state = state.copyWith(bookings: updatedBookings);
      
      // Update Firestore (non-blocking)
      FirebaseService.bookingsCollection.doc(bookingId).update({
        'status': 'cancelled',
        'updatedAt': Timestamp.now(),
      }).catchError((error) {
        if (kDebugMode) {
          print('❌ Firestore update error (non-critical): $error');
        }
        // Don't fail the operation if Firestore update fails
        // The local state is already updated
      });
      
      if (kDebugMode) {
        print('✅ Booking $bookingId cancelled successfully');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cancelling booking $bookingId: $e');
      }
      return false;
    }
  }

  Future<bool> updateBookingStatus(
    String bookingId,
    BookingStatus status, {
    DateTime? completedAt,
  }) async {
    final updates = <String, dynamic>{
      'status': status.toString().split('.').last,
      'updatedAt': Timestamp.now(),
    };
    
    if (completedAt != null) {
      updates['completedAt'] = Timestamp.fromDate(completedAt);
    }
    
    return updateBooking(bookingId, updates);
  }

  List<Booking> get upcomingBookings {
    return state.bookings
        .where((b) => b.status == BookingStatus.pending || b.status == BookingStatus.confirmed)
        .toList();
  }

  List<Booking> get completedBookings {
    return state.bookings
        .where((b) => b.status == BookingStatus.completed)
        .toList();
  }

  Future<bool> rateBooking(String bookingId, double rating, String comment) async {
    try {
      await FirebaseService.bookingsCollection.doc(bookingId).update({
        'rating': rating,
        'ratingComment': comment.trim(),
        'ratedAt': Timestamp.now(),
      });
      
      // Reload bookings
      final firstBooking = state.bookings.firstOrNull;
      if (firstBooking != null) {
        await loadBookings(firstBooking.userId);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error rating booking: $e');
      return false;
    }
  }

  Future<bool> processPayment({
    required String bookingId,
    required String cashierId,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      await FirebaseService.bookingsCollection.doc(bookingId).update({
        'status': 'completed',
        'isPaid': true,
        'paidAt': Timestamp.now(),
        'cashierId': cashierId,
        'paymentMethod': paymentMethod.toString().split('.').last,
        'updatedAt': Timestamp.now(),
      });
      
      // Reload bookings using cashier ID with cashier role
      await loadBookings(cashierId, role: 'cashier');
      
      return true;
    } catch (e) {
      debugPrint('Error processing payment: $e');
      return false;
    }
  }
}

