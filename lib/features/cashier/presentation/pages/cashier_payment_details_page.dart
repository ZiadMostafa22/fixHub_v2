import 'package:flutter/material.dart';

class CashierPaymentDetailsPage extends StatelessWidget {
  final String bookingId;
  
  const CashierPaymentDetailsPage({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: const Center(
        child: Text('Payment Details - Demo UI'),
      ),
    );
  }
}