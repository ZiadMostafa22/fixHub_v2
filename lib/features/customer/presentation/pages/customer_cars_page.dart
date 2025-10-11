import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:car_maintenance_system_new/core/providers/auth_provider.dart';
import 'package:car_maintenance_system_new/core/providers/car_provider.dart';

class CustomerCarsPage extends ConsumerStatefulWidget {
  const CustomerCarsPage({super.key});

  @override
  ConsumerState<CustomerCarsPage> createState() => _CustomerCarsPageState();
}

class _CustomerCarsPageState extends ConsumerState<CustomerCarsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        ref.read(carProvider.notifier).loadCars(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final carState = ref.watch(carProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/customer/add-car');
            },
          ),
        ],
      ),
      body: carState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : carState.cars.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.directions_car,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No cars registered yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add your first car to get started',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.go('/customer/add-car'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Car'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: carState.cars.length,
                  itemBuilder: (context, index) {
                    final car = carState.cars[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.directions_car, size: 30),
                        ),
                        title: Text(
                          '${car.make} ${car.model}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text('Year: ${car.year}'),
                            Text('Color: ${car.color}'),
                            Text('Plate: ${car.licensePlate}'),
                            if (car.vin != null) Text('VIN: ${car.vin}'),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) async {
                            if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Car'),
                                  content: const Text(
                                    'Are you sure you want to delete this car?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                final success = await ref
                                    .read(carProvider.notifier)
                                    .deleteCar(car.id);
                                
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Car deleted successfully'
                                          : 'Failed to delete car',
                                    ),
                                    backgroundColor:
                                        success ? Colors.green : Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
