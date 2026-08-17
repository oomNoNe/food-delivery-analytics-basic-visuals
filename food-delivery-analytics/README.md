# FoodOps Analytics: Delivery Performance & Growth Diagnostics

**Business question:** Why are deliveries slow in some cities? Are our promo codes worth the money?

This project looks at 8,000 food delivery orders in 6 Thai cities (Jan 2025–Mar 2026). It covers the full analyst workflow: clean the data, explore it, run statistics, write SQL, and build a dashboard.

**[▶ View Live Dashboard](https://app.powerbi.com/view?r=eyJrIjoiMWU5OTIzYWQtYTQ2Ni00MDBkLWI4MjItODg4Mjk4NjE5YWU5IiwidCI6ImNmODFmMWRmLWRlNTktNGMyOS05MWRhLWEyZGZkMDRhYTc1MSIsImMiOjEwfQ%3D%3D)**

---

## Key Findings

| Finding | Evidence | Why it matters |
|---|---|---|
| **Traffic is the real problem, not the city** | Delivery time depends mostly on traffic and distance (R² = 0.90). Severe traffic: 49.3 min. Low traffic: 26.8 min. City itself made no real difference. | Fix routing and courier planning, not city-by-city rules. |
| **Promo codes don't raise order size** | Avg order value: ฿252.62 with promo vs. ฿250.65 without. Only ~฿2 difference. But promos cost ฿99,004 in discounts. | The current promo type may not be worth the cost. Test other ideas, like free delivery. |
| **Phuket has the most cancelled orders** | 5.73% of Phuket orders are cancelled. This is the highest of all 6 cities. Khon Kaen is the lowest, at 3.51%. | Check what's going wrong in Phuket: restaurants, couriers, or demand. |
| **Slow delivery hurts customer ratings** | Longer delivery time clearly lowers customer rating (p < 0.001), even after controlling for other factors. | Faster delivery also means happier customers, not just better ops numbers. |

## Hypothesis Testing

Each finding above is backed by a formal statistical test, not just a visual comparison. Using OLS regression (R), we tested:

| Hypothesis (H0: no effect) | Test | Result | Conclusion |
|---|---|---|---|
| Traffic level has no effect on delivery time | OLS regression, delivery time model | p < 0.001 for every traffic level | **Reject H0** — traffic level has a real effect |
| City has no effect on delivery time (once traffic, weather, distance are controlled for) | OLS regression, delivery time model | p > 0.1 for every city | **Fail to reject H0** — city does not matter on its own |
| Delivery time has no effect on customer rating | OLS regression, rating model | p < 0.001 | **Reject H0** — slower delivery really does lower ratings |
| Distance has no effect on delivery time | OLS regression, delivery time model | p < 0.001 | **Reject H0** — distance is a strong driver |

Full regression output (coefficients, standard errors, R²) is in [`r/regression_analysis.R`](./r/regression_analysis.R).
## Recommendations

1. Focus on courier and route planning during high-traffic hours, not city-specific fixes.
2. Test a new type of promo (like free delivery) before spending more on discounts.
3. Review Phuket operations closely to reduce cancellations.

---

## Tech Stack

| Layer | Tool | What it's for |
|---|---|---|
| Data cleaning & exploration | **Python** (pandas) | Fix messy data, explore basic questions |
| Statistics | **R** | Regression models to test what really drives delivery time and ratings |
| Querying | **SQL** (SQLite) | 6 business questions, using `GROUP BY`, `HAVING`, `CASE WHEN`, and window functions |
| Dashboard | **Power BI** | Interactive charts, filters, published online |

## Repo Structure

```
project1-food-delivery/
├── README.md
├── notebooks/
│   └── analysis.ipynb          # Python: cleaning + exploration
├── r/
│   └── regression_analysis.R   # R: regression models
├── sql/
│   └── sql_queries.sql         # SQL: 6 business questions
├── dashboard/
│   └── Power_BI_food.pbix      # Power BI file
└── data/
    └── food_clean.csv          # Clean dataset used everywhere
```

## How the Analysis Was Done

- **Regression models (R):** One model tests what affects delivery time. Another tests what affects customer rating.
- **SQL queries:** Answer the same business questions as the Python analysis, just written in SQL. Results were checked against the Python output to make sure they match.
- **Dashboard:** Uses the same cleaned CSV file as every other part of the project, so all numbers stay consistent.

## Limitations & Next Steps

- The data is synthetic and covers a short time period, so seasonal patterns are hard to see.
- About 9% of `customer_rating` values are missing. It's not confirmed whether this is random, so the rating model may be slightly biased.
- Next steps: run a real A/B test on promo types, and try building a model that predicts delivery time in advance (not just explains it).
