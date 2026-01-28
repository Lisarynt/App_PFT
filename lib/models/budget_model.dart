class BudgetModel {
  final String? id; // dari MockAPI
  final String userId;
  final String category;
  final double amount;
  final String period; // monthly, weekly, yearly
  final DateTime startDate;
  final DateTime endDate;

  BudgetModel({
    this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  // =====================
  // FROM JSON (MockAPI)
  // =====================
  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      userId: json['userId'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      period: json['period'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  // =====================
  // TO JSON (MockAPI)
  // =====================
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'category': category,
      'amount': amount,
      'period': period,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
