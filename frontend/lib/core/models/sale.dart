class SaleModel {
  final int id;
  final int productId;
  final int businessId;
  final int quantity;
  final double costPriceAtSale;
  final double sellingPriceAtSale;
  final double profit;
  final double totalAmount;

  SaleModel({
    required this.id,
    required this.productId,
    required this.businessId,
    required this.quantity,
    required this.costPriceAtSale,
    required this.sellingPriceAtSale,
    required this.profit,
    required this.totalAmount,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) => SaleModel(
        id: json['id'] as int,
        productId: json['productId'] as int,
        businessId: json['businessId'] as int,
        quantity: json['quantity'] as int,
        costPriceAtSale: (json['costPriceAtSale'] as num).toDouble(),
        sellingPriceAtSale: (json['sellingPriceAtSale'] as num).toDouble(),
        profit: (json['profit'] as num).toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'businessId': businessId,
        'quantity': quantity,
        'costPriceAtSale': costPriceAtSale,
        'sellingPriceAtSale': sellingPriceAtSale,
        'profit': profit,
        'totalAmount': totalAmount,
      };
}
