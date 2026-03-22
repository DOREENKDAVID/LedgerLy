import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://router.huggingface.co/v1",
  apiKey: process.env.HF_TOKEN,
});


export const generateInsights = async (financialData) => {
  try {
    const completion = await client.chat.completions.create({
      model: "Qwen/Qwen2.5-7B-Instruct",
      messages: [
        {
          role: "system",
          content: `
You are a financial advisor helping small business owners understand their business performance.

Analyze the numbers provided and generate **specific insights**.

Rules:
- Do NOT give advice.
- Do NOT give recommendations.
- Do NOT predict future performance.
- Do NOT invent numbers.
- Refer to the owner or business name if provided.
- Mention the revenue, profit and expense performance.
- Identify strengths and risks.
- Give 3 short actionable insights.
- Do NOT say "numbers were not provided".


Write 3–5 sentences in plain language that help the business owner understand what is happening.

Tone must be:
calm, supportive, observational.

Avoid accounting jargon.
`,


        },
        {
          role: "user",
          content: `Analyze this SME financial data:\n\n${financialData}`
        }
      ],
    });

    return completion.choices[0].message.content;

  } catch (error) {
    console.error("AI Error:", error);
    return "AI insights unavailable at the moment.";
  }
};
// export const generateInsights = async (metrics) => {

//   const payload = `
// Period: ${metrics.period}

// Total revenue: ₦${metrics.totalRevenue} (${metrics.revenueDelta})
// Total gross profit: ₦${metrics.grossProfit} (${metrics.grossProfitDelta})
// Total expenses: ₦${metrics.expenses} (${metrics.expensesDelta})
// Net profit: ₦${metrics.netProfit}

// Top product: ${metrics.topProductName} (₦${metrics.topProductProfit} gross profit)

// Weak margin products: ${metrics.weakMarginCount}
// `;

//   const response = await client.chat.completions.create({
//     model: "Qwen/Qwen2.5-7B-Instruct",
//     messages: [
//       {
//         role: "system",
//         content: `
// You are a financial interpretation assistant for SME retail businesses.

// Explain the business performance using only the numbers provided.

// Rules:
// - Do NOT give advice.
// - Do NOT give recommendations.
// - Do NOT predict future performance.
// - Do NOT invent numbers.

// Write 3–5 sentences in plain language that help the business owner understand what is happening.

// Tone must be:
// calm, supportive, observational.

// Avoid accounting jargon.
// `,
//       },
//       {
//         role: "user",
//         content: payload,
//       },
//     ],
//     max_tokens: 180,
//     temperature: 0.4,
//   });

//   return response.choices[0].message.content;
// };