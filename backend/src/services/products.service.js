import { Op } from "sequelize";
import Sale from "../models/sales.model.js";
import Business from "../models/business.model.js";
import { getPeriodDates } from "../utils/period.js";

const getProductPerformance = async (userId, productId, period = "all-time") => {

  // 1️⃣ Find business
  const business = await Business.findOne({ where: { userId } });
  if (!business) throw new Error("Business not found");

  // 2️⃣ Determine date range (same pattern as your insights service)
  const { startDate, endDate } = getPeriodDates(period);
    

  // 3️⃣ Fetch sales for this product
  const sales = await Sale.findAll({
    where: {
      businessId: business.id,
      productId: productId,
      createdAt: {
        [Op.gte]: startDate,
        [Op.lt]: endDate
      }
    }
  });

  // 4️⃣ Handle no sales case
  if (!sales.length) {
    return {
      revenue: 0,
      unitsSold: 0,
      grossProfit: 0,
      marginPercent: 0
    };
  }

  // 5️⃣ Aggregate calculations
  let revenue = 0;
  let grossProfit = 0;
  let unitsSold = 0;

  sales.forEach((sale) => {

    const saleRevenue = sale.selling_price_at_sale * sale.quantity;

    const saleProfit =
      (sale.selling_price_at_sale - sale.cost_price_at_sale) *
      sale.quantity;

    revenue += saleRevenue;
    grossProfit += saleProfit;
    unitsSold += sale.quantity;
  });

  const marginPercent =
    revenue === 0 ? 0 : (grossProfit / revenue) * 100;

  // 6️⃣ Return result
  return {
    period,
    revenue,
    unitsSold,
    grossProfit,
    marginPercent: Number(marginPercent.toFixed(2))
  };
};

export { getProductPerformance };