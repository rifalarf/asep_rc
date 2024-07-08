import 'dart:convert';

class Sales {
  final String id;
  final String buyer;
  final String phone;
  final String date;
  final String status;
  final String issuer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Sales({
    required this.id,
    required this.buyer,
    required this.phone,
    required this.date,
    required this.status,
    required this.issuer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      id: json['id'],
      buyer: json['buyer'] ?? '',
      phone: json['phone'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      issuer: json['issuer'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  static List<Sales> fromJsonList(String jsonString) {
    final data = json.decode(jsonString) as List;
    return data.map((item) => Sales.fromJson(item)).toList();
  }
}
