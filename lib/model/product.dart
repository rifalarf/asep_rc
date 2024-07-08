import 'dart:convert';

class Product {
  final String id;
  final String name;
  final double price;
  final int qty;
  final String attr;
  final double weight;
  final String issuer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.attr,
    required this.weight,
    required this.issuer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      qty: json['qty'] ?? 0,
      attr: json['attr'] ?? '',
      weight: (json['weight'] as num).toDouble(),
      issuer: json['issuer'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  static List<Product> fromJsonList(String jsonString) {
    final data = json.decode(jsonString) as List;
    return data.map((item) => Product.fromJson(item)).toList();
  }
}
