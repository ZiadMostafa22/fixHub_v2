import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NewBookingPage extends StatefulWidget {
  const NewBookingPage({super.key});

  @override
  State<NewBookingPage> createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCar = 'Toyota Camry';
  String _selectedService = 'Oil Change';
  String _selectedDate = '';
  String _selectedTime = '';
  String _selectedTechnician = 'Ahmed Hassan';
  final _notesController = TextEditingController();

  final List<String> _cars = ['Toyota Camry', 'Honda Civic'];
  final List<String> _services = [
    'Oil Change',
    'Brake Service',
    'Engine Check',
    'Tire Rotation',
    'Air Filter Replacement',
    'Battery Check',
  ];
  final List<String> _technicians = [
    'Ahmed Hassan',
    'Mohamed Ali',
    'Omar Ibrahim',
  ];
  final List<String> _timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _selectedDate.isNotEmpty && _selectedTime.isNotEmpty) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back
      context.go('/customer/bookings');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Booking'),
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: const Text(
              'Book',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Selection
              Text(
                'Service Details',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Car Selection
              DropdownButtonFormField<String>(
                value: _selectedCar,
                decoration: InputDecoration(
                  labelText: 'Select Car',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                items: _cars.map((car) {
                  return DropdownMenuItem(
                    value: car,
                    child: Text(car),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCar = value!;
                  });
                },
              ),
              
              SizedBox(height: 16.h),
              
              // Service Type Selection
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: InputDecoration(
                  labelText: 'Service Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                items: _services.map((service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedService = value!;
                  });
                },
              ),
              
              SizedBox(height: 16.h),
              
              // Technician Selection
              DropdownButtonFormField<String>(
                value: _selectedTechnician,
                decoration: InputDecoration(
                  labelText: 'Preferred Technician',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                items: _technicians.map((technician) {
                  return DropdownMenuItem(
                    value: technician,
                    child: Text(technician),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTechnician = value!;
                  });
                },
              ),
              
              SizedBox(height: 24.h),
              
              // Date and Time Selection
              Text(
                'Schedule',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Date Selection
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = '${date.day}/${date.month}/${date.year}';
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
                      SizedBox(width: 12.w),
                      Text(
                        _selectedDate.isEmpty ? 'Select Date' : _selectedDate,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: _selectedDate.isEmpty ? Colors.grey[600] : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Time Selection
              Text(
                'Available Time Slots',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _timeSlots.map((time) {
                  final isSelected = _selectedTime == time;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              SizedBox(height: 24.h),
              
              // Additional Notes
              Text(
                'Additional Notes',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 16.h),
              
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Any special requests or notes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // Service Summary
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildSummaryRow('Service', _selectedService),
                    _buildSummaryRow('Car', _selectedCar),
                    _buildSummaryRow('Technician', _selectedTechnician),
                    _buildSummaryRow('Date', _selectedDate.isEmpty ? 'Not selected' : _selectedDate),
                    _buildSummaryRow('Time', _selectedTime.isEmpty ? 'Not selected' : _selectedTime),
                    SizedBox(height: 12.h),
                    const Divider(),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estimated Price',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '150 EGP',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}