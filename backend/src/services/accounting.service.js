import { Op } from 'sequelize';
import Sale from '../models/sales.model.js';
import Expense from '../models/expenses.model.js';
import Business from '../models/business.model.js';
import Product from '../models/products.model.js';
import { generateInsights } from './ai.service.js';
import { getPeriodDates } from '../utils/period.js';

const getAccountingInsights = async (userId, period = 'all-time') => {
  // 1️⃣ Find the user's business
  const business = await Business.findOne({ where: { userId } });
  if (!business) throw new Error('Business not found');

  // 2️⃣ Determine date range
  const { startDate, endDate } = getPeriodDates(period);

  // 3️⃣ Fetch sales & expenses
  const sales = await Sale.findAll({
  where: {
    businessId: business.id,
    createdAt: { [Op.gte]: startDate, [Op.lt]: endDate }
  }
});

  const expenses = await Expense.findAll({
    where: { businessId: business.id, createdAt: { [Op.gte]: startDate, [Op.lt]: endDate } }
  });
 
  // Total Revenue
  const totalRevenue = sales.reduce((sum, s) => {
    return sum + (s.sellingPriceAtSale * s.quantitySold);
  }, 0);

  // Total COGS
  const totalCOGS = sales.reduce((sum, s) => {
    return sum + (s.costPriceAtSale * s.quantitySold);
  }, 0);

  // Total Product Gross Profit
  const totalProductGrossProfit = sales.reduce((sum, s) => {
  return sum + ((s.sellingPriceAtSale - s.costPriceAtSale) * s.quantitySold);
}, 0);;

  // Total Expenses
  const totalExpenses = expenses.reduce((sum, e) => {
    return sum + parseFloat(e.amount || 0);
  }, 0);


  
  // Net Profit
  const netProfit = totalProductGrossProfit - totalExpenses;

  // Net Profit Margin
  const netProfitMargin =
    totalRevenue > 0 ? (netProfit / totalRevenue) * 100 : 0;
  
 

  // Expense Ratio
  const expenseRatio =
    totalProductGrossProfit > 0
      ? totalExpenses / totalProductGrossProfit
      : 0;
  
  
  let healthScore;

  if (netProfitMargin >= 30 && netProfit > 0) {
    healthScore = "Healthy";
  }
  else if (netProfitMargin >= 10 && netProfit > 0) {
    healthScore = "Moderate";
  }
  else {
    healthScore = "At Risk";
  }
// 5️⃣ Aggregate product-level gross profit
  const productProfits = {};
  sales.forEach(s => {
    const profit = (s.sellingPriceAtSale - s.costPriceAtSale) * s.quantitySold;
    productProfits[s.product_id] = (productProfits[s.product_id] || 0) + profit;
  });

  let productData = '';
  Object.entries(productProfits).forEach(([productId, profit]) => {
    productData += `Product ${productId} Gross Profit: ${profit}\n`;
  });

  // 6️⃣ Include SME owner / business name in financial summary
  const financialData = `
Hello ${business.fullName || 'SME Owner'} of ${business.BusinessName || 'your business'}!
Here are your financials for the period: ${period}.

Total Revenue: ${totalRevenue}
Total COGS: ${totalCOGS}
Total Expenses: ${totalExpenses}
Net Profit: ${netProfit}
Net Profit Margin: ${netProfitMargin.toFixed(2)}%
Expense Ratio: ${expenseRatio.toFixed(2)}

Product-Level Profits:
${productData}
`;

  // 7️⃣ Generate AI insights
  const aiInsights = await generateInsights(financialData);

  // 8️⃣ Return result
  return {
    period,
    totalRevenue,
    totalCOGS,
    totalExpenses,
    totalProductGrossProfit,
    netProfit,
    netProfitMargin,
    expenseRatio,
    salesCount: sales.length,
    expensesCount: expenses.length,
    aiInsights
  };
};
 
export { getAccountingInsights }