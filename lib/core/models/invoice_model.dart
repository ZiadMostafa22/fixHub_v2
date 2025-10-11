import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus { pending, paid, failed, refunded }
enum PaymentMethod { cash, card, online }

class InvoiceItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String? partNumber;

  InvoiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.partNumber,
  });

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      partNumber: map['partNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'partNumber': partNumber,
    };
  }

  double get totalPrice => price * quantity;
}

class InvoiceModel {
  final String id;
  final String bookingId;
  final String userId;
  final List<InvoiceItem> items;
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double totalAmount;
  final PaymentStatus paymentStatus;
  final PaymentMethod? paymentMethod;
  final String? paymentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;
  final String? notes;

  InvoiceModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.totalAmount,
    required this.paymentStatus,
    this.paymentMethod,
    this.paymentId,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
    this.notes,
  });

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'] ?? '',
      bookingId: map['bookingId'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => InvoiceItem.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      taxRate: (map['taxRate'] ?? 0).toDouble(),
      taxAmount: (map['taxAmount'] ?? 0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${map['paymentStatus']}',
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: map['paymentMethod'] != null 
          ? PaymentMethod.values.firstWhere(
              (e) => e.toString() == 'PaymentMethod.${map['paymentMethod']}',
            )
          : null,
      paymentId: map['paymentId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      paidAt: map['paidAt'] != null 
          ? (map['paidAt'] as Timestamp).toDate() 
          : null,
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paymentMethod': paymentMethod?.toString().split('.').last,
      'paymentId': paymentId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
      'notes': notes,
    };
  }
}
