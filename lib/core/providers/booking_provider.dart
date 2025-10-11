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
      if (role == 'admin' || role == 'technician') {
        // Admin and Technician see all bookings - can use orderBy directly
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
      if (role != 'admin' && role != 'technician') {
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
    if (role == 'admin' || role == 'technician') {
      // Admin and Technician see all bookings - can use orderBy directly
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
        if (role != 'admin' && role != 'technician') {
          bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
        
        if (kDebugMode) {
          print('🔄 Real-time update: ${bookings.length} bookings');
          for (var booking in bookings.take(3)) {
            print('  - ${booking.id}: ${booking.status}');
          }
        }
        
        state = state.copyWith(bookings: bookings, isLoading: false);
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
      
      // Update Firestore - the real-time listener will automatically update state
      await FirebaseService.bookingsCollection.doc(bookingId).update(updates);
      
      if (kDebugMode) {
        print('✅ Booking updated successfully in Firebase - real-time listener will update state');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating booking: $e');
      }
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    return updateBooking(bookingId, {
      'status': 'cancelled',
      'updatedAt': Timestamp.now(),
    });
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
}

