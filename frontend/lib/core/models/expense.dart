class ExpenseModel {
  final int id;
  final String category;
  final String description;
  final double amount;
  final int businessId;

  ExpenseModel({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.businessId,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json['id'] as int,
        category: json['category'] as String,
        description: json['description'] as String,
        amount: (json['amount'] as num).toDouble(),
        businessId: json['businessId'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'description': description,
        'amount': amount,
        'businessId': businessId,
      };
}
