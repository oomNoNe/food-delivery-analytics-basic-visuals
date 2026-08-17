# FoodOps Analytics: Delivery Performance & Growth Diagnostics
🇹🇭 [อ่านภาษาไทย](./README_TH.md)
**Business question:** Why are deliveries slow in some cities? Are our promo codes worth the money?

This project looks at 8,000 food delivery orders in 6 Thai cities (Jan 2025–Mar 2026). It covers the full analyst workflow: clean the data, explore it, run statistics, write SQL, and build a dashboard.

**[▶ View Live Dashboard](https://app.powerbi.com/view?r=eyJrIjoiMWU5OTIzYWQtYTQ2Ni00MDBkLWI4MjItODg4Mjk4NjE5YWU5IiwidCI6ImNmODFmMWRmLWRlNTktNGMyOS05MWRhLWEyZGZkMDRhYTc1MSIsImMiOjEwfQ%3D%3D)**

---

## Key Findings

| Finding | Evidence | Why it matters |
|---|---|---|
| **Traffic is the real problem, not the city** | Delivery time depends mostly on traffic and distance (R² = 0.90). Severe traffic: 49.3 min. Low traffic: 26.8 min. City itself made no real difference. | Fix routing and courier planning, not city-by-city rules. |
| **Promo codes don't raise order size** | Avg order value: ฿252.62 with promo vs. ฿250.65 without (~฿2 difference), but promos cost ฿99,004 in discounts. | The current promo type may not be worth the cost. Test other ideas, like free delivery. |
| **Phuket has the most cancelled orders** | 5.73% of Phuket orders are cancelled — the highest of all 6 cities (vs. 3.51% in Khon Kaen, the lowest). | Check what's going wrong in Phuket: restaurants, couriers, or demand. |
| **Slow delivery hurts customer ratings** | Longer delivery time clearly lowers customer rating (p < 0.001), even after controlling for other factors. | Faster delivery also means happier customers, not just better ops numbers. |

---

## Hypothesis Testing

Each finding is backed by a formal regression test (R), not just a visual comparison.

| Hypothesis (H0: no effect) | Result | Conclusion |
|---|---|---|
| Traffic level has no effect on delivery time | p < 2e-16 for every traffic level | **Reject H0** — traffic has a real, strong effect |
| Distance has no effect on delivery time | p < 2e-16 | **Reject H0** — distance is a major driver |
| City has no effect on delivery time (traffic, weather, distance controlled) | p > 0.26 for every city | **Fail to reject H0** — city does not matter on its own |
| Delivery time has no effect on customer rating | p < 2e-16 | **Reject H0** — slower delivery really lowers ratings |

### Model 1: Delivery Time
`delivery_time_min ~ traffic_level + distance_km + prep_time_min + weather + courier_vehicle + city + hour`

**R² = 0.8997 | p-value < 2.2e-16**

<img width="835" height="550" alt="image" src="https://github.com/user-attachments/assets/eb09e336-16ed-48e6-90ee-b984cfc95332" />
<img width="769" height="487" alt="image" src="https://github.com/user-attachments/assets/48f7b7d3-1994-472b-b8aa-8ab9bcae2d2a" />


### Model 2: Customer Rating
`customer_rating ~ delivery_time_min + distance_km + prep_time_min + traffic_level + weather + city + restaurant_category`

**R² = 0.301 | p-value < 2.2e-16 | delivery_time_min coefficient = -0.0156** (each extra minute of delivery lowers rating by ~0.016)

<img width="660" height="649" alt="image" src="https://github.com/user-attachments/assets/434a741d-1f19-44d3-bc24-496acef86338" />
<img width="663" height="591" alt="image" src="https://github.com/user-attachments/assets/5d0a8a8d-010c-4ccc-a5d3-c6b92f5ad2e8" />


Full R script: [`r/regression_analysis.R`](./r/regression_analysis.R)

---

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
food-delivery-analytics/
├── README.md
├── notebooks/
│   └── analysis.ipynb          # Python: cleaning + exploration
├── r/
│   └── regression_analysis.R   # R: regression models
├── sql/
│   └── sql_queries.sql         # SQL: 6 business questions
├── data/
│   └── food_clean.csv          # Clean dataset used everywhere
└── assets/
    └── (regression output screenshots used in this README)
```

## How the Analysis Was Done

- **Regression models (R):** One model tests what affects delivery time. Another tests what affects customer rating.
- **SQL queries:** Answer the same business questions as the Python analysis, just written in SQL. Results were checked against the Python output to make sure they match.
- **Dashboard:** Uses the same cleaned CSV file as every other part of the project, so all numbers stay consistent.

## Limitations & Next Steps

- The data is synthetic and covers a short time period, so seasonal patterns are hard to see.
- About 9% of `customer_rating` values are missing. It's not confirmed whether this is random, so the rating model may be slightly biased.
- Next steps: run a real A/B test on promo types, and try building a model that predicts delivery time in advance (not just explains it).
