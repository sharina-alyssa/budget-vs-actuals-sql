# Budget vs Actuals Analysis Using PostgreSQL

## Project Highlights 
- **SQL Concepts:** FULL OUTER JOIN, COALESCE, CASE statements, CTEs, and variance calculations.  
- **Real-World Scenario:** Simulates FP&A tasks like budget tracking and variance analysis.  
- **Business Value:** Identifies over/under budget trends to improve financial decision-making.  
- **Deliverables:** SQL script, sample CSV datasets, and actionable insights.

## Introduction
This project replicates a real-world **FP&A (Financial Planning & Analysis)** task: analyzing **budgeted vs. actual spending** across departments to identify overspending or underspending trends.  
The goal is to produce actionable financial insights and support better **budget control, forecasting, and decision-making**.  

This project highlights my **SQL and financial analysis skills** as I transition into a career in **corporate finance and FP&A**, complementing my **FMVA certification studies** and experience in banking operations.

---

## Business Context
In corporate finance, **budget variance analysis** is critical for:
- Identifying departments or projects that are overspending or underspending.
- Improving forecasting accuracy.
- Enabling management to reallocate resources efficiently.
  
This project demonstrates how SQL can streamline **data preparation and reporting** for FP&A teams.

---

## Objectives
- Combine **budget** and **actual spending** data across multiple departments and months.
- Calculate **variance** and classify performance as **Over Budget**, **Under Budget**, or **On Budget**.
- Gracefully handle missing data (e.g., missing budget or actual values).
- Create a **repeatable SQL query** for automated financial reporting.

---

## Dataset
- **departments.csv** – Contains `department_id` and `department_name`.
- **budget.csv** – Monthly **budgeted amounts** per department.
- **actuals.csv** – Monthly **actual spending amounts** per department.

---

## Technical Approach
- Uses a **Common Table Expression (CTE)** to first combine budget and actuals with a **FULL OUTER JOIN** ensuring no data loss.
- **COALESCE()** handles `NULL` values and ensures correct matching of department IDs and months.
- Calculates **variance** as `(actual_amount - budget_amount)`.
- Uses **CASE statements** to classify each record as:
  - `Over Budget`
  - `Under Budget`
  - `On Budget`
  - `No Budget` (missing budget)
  - `No Actuals` (missing actuals)
- Joins with `departments` table to fetch readable department names.

---

## Core SQL Query

```sql
-- Combine budget and actual spending data with FULL OUTER JOIN in a CTE
WITH combined_budget_actuals AS (
  SELECT
    COALESCE(b.department_id, a.department_id) AS department_id,  -- Get department_id from either table
    COALESCE(b.month, a.month) AS month,                         -- Get month from either table
    b.budget_amount,
    a.actual_amount
  FROM budget b
  FULL OUTER JOIN actuals a
    ON b.department_id = a.department_id AND b.month = a.month
)
SELECT
  COALESCE(d.department_name, 'Unknown') AS department,          -- Use department name or default 'Unknown'
  c.month,
  c.budget_amount,
  c.actual_amount,
  (c.actual_amount - c.budget_amount) AS variance,               -- Calculate variance
  CASE                                                          -- Classify budget status
    WHEN c.budget_amount IS NULL THEN 'No Budget'
    WHEN c.actual_amount IS NULL THEN 'No Actuals'
    WHEN c.actual_amount > c.budget_amount THEN 'Over Budget'
    WHEN c.actual_amount < c.budget_amount THEN 'Under Budget'
    ELSE 'On Budget'
  END AS budget_status
FROM combined_budget_actuals c
LEFT JOIN departments d
  ON c.department_id = d.department_id
ORDER BY department, month;

```
---

## Results & Insights

| Department | Month | Budget | Actual | Variance | Status       |
|------------|-------|--------|--------|----------|--------------|
| Marketing  | Jan   | 20000  | 22000  | 2000     | Over Budget  |
| Sales      | Jan   | 15000  | NULL   | NULL     | No Actuals   |
| HR         | Jan   | 10000  | 8000   | -2000    | Under Budget |

### Key Insights:
- Marketing overspent by $2,000 in January.  
- The Sales department’s actuals are missing, which requires data validation.  
- 30% of departments were under budget in Q1, indicating potential cost-saving trends.

---

## Technologies Used

- **PostgreSQL** – For SQL queries, joins, and variance analysis.  
- **Excel / Power BI** – For optional visualization and pivot tables.  
- **CSV Data Files** – For budget, actuals, and department datasets.  
- **GitHub** – Version control and documentation.

---

## How to Reproduce

1. Clone this repository:
   git clone https://github.com/sharina-alyssa/budget-vs-actuals-sql.git
2. Create tables for departments, budget, and actuals in PostgreSQL.
3. Import the CSV files from the data folder into their respective tables.
4. Run the SQL script located in scripts/budget_vs_actuals_analysis.sql.
5. Export results to CSV or visualize them in Excel/Power BI.

---

## Future Improvements 

- Automate report generation with scheduled SQL jobs or Python scripts.
- Add forecasting models based on historical spending trends.
- Build interactive dashboards in Power BI to visualize variances dynamically.
- Implement data validation checks to flag missing or inconsistent data.

---
