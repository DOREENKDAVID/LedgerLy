double calculateProductProfit(double sellingPrice, double buyingPrice) {
  return sellingPrice - buyingPrice;
}

double calculateTotalAmount(int quantity, double unitPrice) {
  return quantity * unitPrice;
}

double calculateProfitAtSale(double finalUnitPrice, double costPriceAtSale, int quantity) {
  return (finalUnitPrice - costPriceAtSale) * quantity;
}

double safePercent(double numerator, double denominator) {
  if (denominator == 0) return 0.0;
  return (numerator / denominator) * 100.0;
}
