
export const getPeriodDates = (period) => {
  const now = new Date();
  let startDate, endDate;

  switch (period) {
    case 'daily':
      startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      endDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
      break;

    case 'weekly':
      const firstDayOfWeek = now.getDate() - now.getDay();
      startDate = new Date(now.getFullYear(), now.getMonth(), firstDayOfWeek);
      endDate = new Date(now.getFullYear(), now.getMonth(), firstDayOfWeek + 7);
      break;

    case 'monthly':
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
      endDate = new Date(now.getFullYear(), now.getMonth() + 1, 1);
      break;

    default:
      startDate = new Date(0);
      endDate = now;
  }
  return { startDate, endDate };
}