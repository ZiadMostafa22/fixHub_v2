enum ServiceItemType { part, labor, service }

class ServiceItemModel {
  final String id;
  final String name;
  final ServiceItemType type;
  final double price;
  final int quantity;
  final String? description;
  
  double get totalPrice => price * quantity;

  ServiceItemModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.quantity = 1,
    this.description,
  });

  factory ServiceItemModel.fromMap(Map<String, dynamic> map) {
    return ServiceItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: ServiceItemType.values.firstWhere(
        (e) => e.toString() == 'ServiceItemType.${map['type']}',
        orElse: () => ServiceItemType.service,
      ),
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'price': price,
      'quantity': quantity,
      'description': description,
    };
  }

  ServiceItemModel copyWith({
    String? id,
    String? name,
    ServiceItemType? type,
    double? price,
    int? quantity,
    String? description,
  }) {
    return ServiceItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
    );
  }
}

