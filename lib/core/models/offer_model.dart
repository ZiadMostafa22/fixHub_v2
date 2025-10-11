import 'package:cloud_firestore/cloud_firestore.dart';

enum OfferType { announcement, discount, promotion, news }

class OfferModel {
  final String id;
  final String title;
  final String description;
  final OfferType type;
  final String? imageUrl;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String createdBy; // Admin ID
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? discountPercentage;
  final String? code; // Unique code customers can use to apply discount
  final String? terms;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.discountPercentage,
    this.code,
    this.terms,
  });

  factory OfferModel.fromFirestore(Map<String, dynamic> map, String id) {
    return OfferModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: OfferType.values.firstWhere(
        (e) => e.toString() == 'OfferType.${map['type']}',
        orElse: () => OfferType.announcement,
      ),
      imageUrl: map['imageUrl'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
      isActive: map['isActive'] ?? true,
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      discountPercentage: map['discountPercentage'],
      code: map['code'],
      terms: map['terms'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'discountPercentage': discountPercentage,
      'code': code,
      'terms': terms,
    };
  }

  OfferModel copyWith({
    String? id,
    String? title,
    String? description,
    OfferType? type,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? discountPercentage,
    String? code,
    String? terms,
  }) {
    return OfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      code: code ?? this.code,
      terms: terms ?? this.terms,
    );
  }
}

