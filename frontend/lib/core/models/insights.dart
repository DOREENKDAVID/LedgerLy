class InsightsModel {
  final String period;
  final double totalRevenue;
  final double totalExpenses;
  final double grossProfit;
  final double netProfit;
  final double profitMargin;
  final double netProfitMargin;

  InsightsModel({
    required this.period,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.grossProfit,
    required this.netProfit,
    required this.profitMargin,
    required this.netProfitMargin,
  });

  factory InsightsModel.fromJson(Map<String, dynamic> json) => InsightsModel(
        period: json['period'] as String,
        totalRevenue: (json['totals']['totalRevenue'] as num).toDouble(),
        totalExpenses: (json['totals']['totalExpenses'] as num).toDouble(),
        grossProfit: (json['totals']['grossProfit'] as num).toDouble(),
        netProfit: (json['totals']['netProfit'] as num).toDouble(),
        profitMargin: (json['totals']['profitMargin'] as num).toDouble(),
        netProfitMargin: (json['totals']['netProfitMargin'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'period': period,
        'totals': {
          'totalRevenue': totalRevenue,
          'totalExpenses': totalExpenses,
          'grossProfit': grossProfit,
          'netProfit': netProfit,
          'profitMargin': profitMargin,
          'netProfitMargin': netProfitMargin,
        }
      };
}
