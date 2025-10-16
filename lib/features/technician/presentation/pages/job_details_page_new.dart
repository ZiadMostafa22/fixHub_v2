import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_maintenance_system_new/core/models/booking_model.dart';
import 'package:car_maintenance_system_new/core/models/car_model.dart';
import 'package:car_maintenance_system_new/core/models/service_item_model.dart';
import 'package:car_maintenance_system_new/core/providers/booking_provider.dart';
import 'package:car_maintenance_system_new/core/providers/car_provider.dart';
import 'package:car_maintenance_system_new/core/constants/service_items_constants.dart';

class JobDetailsPage extends ConsumerStatefulWidget {
  final String bookingId;

  const JobDetailsPage({super.key, required this.bookingId});

  @override
  ConsumerState<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends ConsumerState<JobDetailsPage> {
  final List<ServiceItemModel> _serviceItems = [];
  final _laborCostController = TextEditingController();
  final _technicianNotesController = TextEditingController();
  
  BookingModel? _booking;
  CarModel? _car;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookingDetails();
    });
  }

  void _loadBookingDetails() {
    final bookingState = ref.read(bookingProvider);
    final carState = ref.read(carProvider);

    _booking = bookingState.bookings.firstWhere((b) => b.id == widget.bookingId);
    _car = carState.cars.where((c) => c.id == _booking!.carId).firstOrNull;

    // Load existing service items if any
    if (_booking!.serviceItems != null) {
      _serviceItems.clear();
      _serviceItems.addAll(_booking!.serviceItems!);
    }
    
    // Set labor cost with default if empty
    if (_booking!.laborCost != null) {
      _laborCostController.text = _booking!.laborCost!.toStringAsFixed(2);
    } else if (_booking!.status == BookingStatus.inProgress) {
      // Set default labor cost for this maintenance type
      final defaultLabor = ServiceItemsConstants.getDefaultLaborCost(_booking!.maintenanceType);
      _laborCostController.text = defaultLabor.toStringAsFixed(2);
    }
    
    if (_booking!.technicianNotes != null) {
      _technicianNotesController.text = _booking!.technicianNotes!;
    }
    
    setState(() {});
  }

  Future<Map<String, String>> _getUserInfo(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (userDoc.exists) {
        final data = userDoc.data()!;
        return <String, String>{
          'name': data['name']?.toString() ?? 'Unknown',
          'phone': data['phone']?.toString() ?? 'N/A',
        };
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }

    return <String, String>{'name': 'Unknown', 'phone': 'N/A'};
  }

  @override
  void dispose() {
    // Auto-save on exit if there are unsaved changes
    if (_hasUnsavedChanges && _booking?.status == BookingStatus.inProgress) {
      _saveProgressSilently();
    }
    _laborCostController.dispose();
    _technicianNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Job Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final subtotal = _calculateSubtotal();
    final subtotalAfterDiscount = _calculateSubtotalAfterDiscount();
    final tax = subtotalAfterDiscount * 0.10; // 10% tax on discounted amount
    final total = subtotalAfterDiscount + tax;

    // Calculate hours worked if job is completed
    final hoursWorked = _booking!.hoursWorked;

    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges && _booking!.status == BookingStatus.inProgress) {
          await _saveProgressSilently();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Job Details'),
          actions: [
            if (_booking!.status == BookingStatus.inProgress)
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Save Progress',
                onPressed: _saveProgress,
              ),
            if (_booking!.status == BookingStatus.inProgress)
              TextButton.icon(
                onPressed: _saveAndComplete,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text('Complete', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMaintenanceTypeName(_booking!.maintenanceType),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<Map<String, String>>(
                        future: _getUserInfo(_booking!.userId),
                        builder: (context, snapshot) {
                          final customerName = snapshot.data?['name'] ?? 'Loading...';
                          return Text('Customer: $customerName');
                        },
                      ),
                      if (_car != null) ...[
                        Text('Car: ${_car!.make} ${_car!.model}'),
                        Text('Plate: ${_car!.licensePlate}'),
                      ],
                      Text('Date: ${DateFormat('MMM dd, yyyy').format(_booking!.scheduledDate)}'),
                      Text('Time: ${_booking!.timeSlot}'),
                      if (_booking!.description != null && _booking!.description!.isNotEmpty)
                        Text('Description: ${_booking!.description}'),
                      if (_booking!.startedAt != null)
                        Text('Started: ${DateFormat('MMM dd, HH:mm').format(_booking!.startedAt!)}'),
                      if (_booking!.completedAt != null) ...[
                        Text('Completed: ${DateFormat('MMM dd, HH:mm').format(_booking!.completedAt!)}'),
                        Text('Hours Worked: ${hoursWorked.toStringAsFixed(2)}h',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Service Items Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Service Items & Parts',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: _booking!.status == BookingStatus.inProgress ? _addServiceItem : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_serviceItems.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.build, size: 48, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            'No items added yet',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          if (_booking!.status == BookingStatus.inProgress)
                            TextButton.icon(
                              onPressed: _addServiceItem,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Item'),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ..._serviceItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(_getItemIcon(item.type)),
                      ),
                      title: Text(
                        item.name,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: ${item.type.toString().split('.').last}'),
                          Text('Price: \$${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                          if (item.description != null && item.description!.isNotEmpty)
                            Text('Note: ${item.description}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          if (_booking!.status == BookingStatus.inProgress)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeServiceItem(index),
                            ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                }),

              const SizedBox(height: 24),

              // Labor Cost
              Text(
                'Labor Cost',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _laborCostController,
                enabled: _booking!.status == BookingStatus.inProgress,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Labor Cost',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  hintText: '0.00',
                ),
                onChanged: (value) {
                  setState(() {
                    _hasUnsavedChanges = true;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Technician Notes
              Text(
                'Technician Notes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _technicianNotesController,
                enabled: _booking!.status == BookingStatus.inProgress,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  hintText: 'Add any notes about the service...',
                ),
                onChanged: (value) {
                  setState(() {
                    _hasUnsavedChanges = true;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Invoice Summary
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:'),
                          Text('\$${subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Show discount if applied
                      if (_booking!.discountPercentage != null && _booking!.discountPercentage! > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Discount (${_booking!.discountPercentage}%):',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                                if (_booking!.offerCode != null)
                                  Text(
                                    'Code: ${_booking!.offerCode}',
                                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                                  ),
                              ],
                            ),
                            Text(
                              '-\$${_booking!.discountAmount.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tax (10%):'),
                          Text('\$${tax.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              if (_booking!.status == BookingStatus.pending)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _startJob,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Job'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

              if (_booking!.status == BookingStatus.inProgress)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _saveProgress,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Progress'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _saveAndComplete,
                        icon: const Icon(Icons.check_circle),
                        label: const Text(
                          'Complete Job',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateSubtotal() {
    double itemsTotal = _serviceItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
    double laborCost = double.tryParse(_laborCostController.text) ?? 0;
    return itemsTotal + laborCost;
  }
  
  double _calculateSubtotalAfterDiscount() {
    double subtotal = _calculateSubtotal();
    
    // Apply discount if present
    if (_booking!.discountPercentage != null && _booking!.discountPercentage! > 0) {
      double discountAmount = subtotal * (_booking!.discountPercentage! / 100.0);
      return subtotal - discountAmount;
    }
    
    return subtotal;
  }

  void _addServiceItem() {
    // Get predefined items for this maintenance type
    final predefinedItems = ServiceItemsConstants.getItemsForType(_booking!.maintenanceType);
    
    showDialog(
      context: context,
      builder: (context) => _ServiceItemDialog(
        predefinedItems: predefinedItems,
        onAdd: (item) {
          setState(() {
            _serviceItems.add(item);
            _hasUnsavedChanges = true;
          });
        },
      ),
    );
  }

  void _removeServiceItem(int index) {
    setState(() {
      _serviceItems.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _startJob() async {
    final success = await ref.read(bookingProvider.notifier).updateBooking(
      _booking!.id,
      {
        'status': BookingStatus.inProgress.toString().split('.').last,
        'startedAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job started!'), backgroundColor: Colors.green),
        );
        _loadBookingDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to start job'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveProgress() async {
    final laborCost = double.tryParse(_laborCostController.text) ?? 0;
    final tax = _calculateSubtotalAfterDiscount() * 0.10;

    // Preserve discount information when saving progress
    final Map<String, dynamic> updateData = {
      'serviceItems': _serviceItems.map((item) => item.toMap()).toList(),
      'laborCost': laborCost,
      'tax': tax,
      'technicianNotes': _technicianNotesController.text,
      'updatedAt': Timestamp.now(),
    };
    
    // Preserve discount fields if they exist
    if (_booking!.offerCode != null) {
      updateData['offerCode'] = _booking!.offerCode;
      updateData['offerTitle'] = _booking!.offerTitle;
      updateData['discountPercentage'] = _booking!.discountPercentage;
    }

    final success = await ref.read(bookingProvider.notifier).updateBooking(
      _booking!.id,
      updateData,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Progress saved!' : 'Failed to save progress'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      
      if (success) {
        setState(() {
          _hasUnsavedChanges = false;
        });
        _loadBookingDetails();
      }
    }
  }

  Future<void> _saveProgressSilently() async {
    final laborCost = double.tryParse(_laborCostController.text) ?? 0;
    final tax = _calculateSubtotalAfterDiscount() * 0.10;

    // Preserve discount information when auto-saving
    final Map<String, dynamic> updateData = {
      'serviceItems': _serviceItems.map((item) => item.toMap()).toList(),
      'laborCost': laborCost,
      'tax': tax,
      'technicianNotes': _technicianNotesController.text,
      'updatedAt': Timestamp.now(),
    };
    
    // Preserve discount fields if they exist
    if (_booking!.offerCode != null) {
      updateData['offerCode'] = _booking!.offerCode;
      updateData['offerTitle'] = _booking!.offerTitle;
      updateData['discountPercentage'] = _booking!.discountPercentage;
    }

    await ref.read(bookingProvider.notifier).updateBooking(
      _booking!.id,
      updateData,
    );
  }

  Future<void> _saveAndComplete() async {
    print('🔧 Complete job called');
    
    // Validate that service items or labor cost is added
    if (_serviceItems.isEmpty && (_laborCostController.text.isEmpty || double.tryParse(_laborCostController.text) == 0)) {
      print('❌ Validation failed: No service items or labor cost');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one service items or labor cost'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final laborCost = double.tryParse(_laborCostController.text) ?? 0;
    final tax = _calculateSubtotalAfterDiscount() * 0.10;
    
    print('💰 Labor: \$$laborCost, Tax: \$$tax (on discounted subtotal)');
    print('📦 Service items: ${_serviceItems.length}');
    print('📝 Notes: ${_technicianNotesController.text}');

    print('📤 Updating booking ${_booking!.id}...');
    
    // Preserve discount information from the original booking
    final Map<String, dynamic> updateData = {
      'serviceItems': _serviceItems.map((item) => item.toMap()).toList(),
      'laborCost': laborCost,
      'tax': tax,
      'technicianNotes': _technicianNotesController.text,
      'status': BookingStatus.completed.toString().split('.').last,
      'completedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };
    
    // Preserve discount fields if they exist
    if (_booking!.offerCode != null) {
      updateData['offerCode'] = _booking!.offerCode;
      updateData['offerTitle'] = _booking!.offerTitle;
      updateData['discountPercentage'] = _booking!.discountPercentage;
      print('💰 Preserving discount: ${_booking!.offerCode} (${_booking!.discountPercentage}%)');
    }
    
    final success = await ref.read(bookingProvider.notifier).updateBooking(
      _booking!.id,
      updateData,
    );

    print('📥 Complete job result: $success');

    if (mounted) {
      print('🏠 Widget still mounted');
      if (success) {
        print('✅ Job completed successfully, closing page');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job completed successfully!'), backgroundColor: Colors.green),
        );
        context.pop();
      } else {
        print('❌ Failed to complete job');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to complete job'), 
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      print('❌ Widget not mounted anymore');
    }
  }

  String _getMaintenanceTypeName(MaintenanceType type) {
    switch (type) {
      case MaintenanceType.regular:
        return 'Regular Maintenance';
      case MaintenanceType.inspection:
        return 'Inspection';
      case MaintenanceType.repair:
        return 'Repair Service';
      case MaintenanceType.emergency:
        return 'Emergency Service';
    }
  }

  IconData _getItemIcon(ServiceItemType type) {
    switch (type) {
      case ServiceItemType.part:
        return Icons.settings;
      case ServiceItemType.labor:
        return Icons.build;
      case ServiceItemType.service:
        return Icons.car_repair;
    }
  }
}

// Dialog for adding service items with predefined items dropdown
class _ServiceItemDialog extends StatefulWidget {
  final Function(ServiceItemModel) onAdd;
  final List<ServiceItemModel> predefinedItems;

  const _ServiceItemDialog({
    required this.onAdd,
    required this.predefinedItems,
  });

  @override
  State<_ServiceItemDialog> createState() => _ServiceItemDialogState();
}

class _ServiceItemDialogState extends State<_ServiceItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  ServiceItemModel? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Service Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ServiceItemModel>(
                value: _selectedItem,
                decoration: const InputDecoration(
                  labelText: 'Select Service/Part',
                  border: OutlineInputBorder(),
                ),
                items: widget.predefinedItems.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${item.price.toStringAsFixed(2)} - ${item.type.toString().split('.').last}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an item';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              if (_selectedItem != null) ...[
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${_selectedItem!.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (_selectedItem!.description != null)
                          Text(_selectedItem!.description!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final item = ServiceItemModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _selectedItem!.name,
                type: _selectedItem!.type,
                price: _selectedItem!.price,
                quantity: int.parse(_quantityController.text),
                description: _selectedItem!.description,
              );
              widget.onAdd(item);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}


