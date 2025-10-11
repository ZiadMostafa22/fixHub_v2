import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_maintenance_system_new/core/models/car_model.dart';
import 'package:car_maintenance_system_new/core/services/firebase_service.dart';

final carProvider = StateNotifierProvider<CarNotifier, CarState>((ref) {
  return CarNotifier();
});

// Type alias for convenience
typedef Car = CarModel;

class CarState {
  final List<Car> cars;
  final bool isLoading;
  final String? error;

  CarState({
    this.cars = const [],
    this.isLoading = false,
    this.error,
  });

  CarState copyWith({
    List<Car>? cars,
    bool? isLoading,
    String? error,
  }) {
    return CarState(
      cars: cars ?? this.cars,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CarNotifier extends StateNotifier<CarState> {
  CarNotifier() : super(CarState());

  Future<void> loadCars(String userId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // If userId is empty, load all cars (for admin/technician)
      final query = userId.isEmpty
          ? FirebaseService.carsCollection.orderBy('createdAt', descending: true)
          : FirebaseService.carsCollection.where('userId', isEqualTo: userId);
      
      final snapshot = await query.get();
      
      var cars = snapshot.docs
          .map((doc) => Car.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // Sort in memory if we used where clause (to avoid composite index requirement)
      if (userId.isNotEmpty) {
        cars.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      
      state = state.copyWith(cars: cars, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addCar(Car car) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final docRef = await FirebaseService.carsCollection.add(car.toFirestore());
      final newCar = car.copyWith(id: docRef.id);
      
      state = state.copyWith(
        cars: [newCar, ...state.cars],
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateCar(String carId, Map<String, dynamic> updates) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await FirebaseService.carsCollection.doc(carId).update(updates);
      
      final updatedCars = state.cars.map((car) {
        if (car.id == carId) {
          return Car.fromFirestore(
            {...car.toFirestore(), ...updates},
            carId,
          );
        }
        return car;
      }).toList();
      
      state = state.copyWith(cars: updatedCars, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteCar(String carId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await FirebaseService.carsCollection.doc(carId).delete();
      
      final updatedCars = state.cars.where((car) => car.id != carId).toList();
      state = state.copyWith(cars: updatedCars, isLoading: false);
      
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

