import { getAccountingInsights } from '../services/accounting.service.js';

export const getInsights = async (req, res) => {
  try {
    const userId = req.user.id; // from authentication
    const period = req.query.period || 'all-time';

    const summaryWithInsights = await getAccountingInsights(userId, period);
    res.status(200).json({
      netProfit: summaryWithInsights.netProfit || 0,
      totalRevenue: summaryWithInsights.totalRevenue || 0,
      totalExpenses: summaryWithInsights.totalExpenses || 0,
      grossProfit: summaryWithInsights.grossProfit || 0,
      profitMargin: summaryWithInsights.profitMargin || 0,
      topProducts: summaryWithInsights.topProducts || [],
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message || 'Failed to generate insights' });
  }
};
