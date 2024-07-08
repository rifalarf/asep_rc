import 'dart:convert';

class Stock {
  final String id;
  final String name;
  final int qty;
  final String attr;
  final double weight;
  final String issuer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Stock({
    required this.id,
    required this.name,
    required this.qty,
    required this.attr,
    required this.weight,
    required this.issuer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      name: json['name'] ?? '',
      qty: json['qty'] ?? 0,
      attr: json['attr'] ?? '',
      weight: (json['weight'] as num).toDouble(),
      issuer: json['issuer'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  static List<Stock> fromJsonList(String jsonString) {
    final data = json.decode(jsonString) as List;
    return data.map((item) => Stock.fromJson(item)).toList();
  }
}
