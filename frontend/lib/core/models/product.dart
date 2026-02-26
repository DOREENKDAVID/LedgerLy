class ProductModel {
  final int id;
  final String productName;
  final String? description;
  final double costPrice;
  final double sellingPrice;
  int quantity;
  final double profit;
  final int businessId;

  ProductModel({
    required this.id,
    required this.productName,
    this.description,
    required this.costPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.profit,
    required this.businessId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as int,
        productName: json['productName'] as String,
        description: json['description'] as String?,
        costPrice: (json['costPrice'] as num).toDouble(),
        sellingPrice: (json['sellingPrice'] as num).toDouble(),
        quantity: json['quantity'] as int,
        profit: (json['profit'] as num).toDouble(),
        businessId: json['businessId'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productName': productName,
        'description': description,
        'costPrice': costPrice,
        'sellingPrice': sellingPrice,
        'quantity': quantity,
        'profit': profit,
        'businessId': businessId,
      };
}
