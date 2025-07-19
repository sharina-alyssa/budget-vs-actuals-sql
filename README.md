# Budget vs Actuals Analysis Using PostgreSQL

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
- **FULL OUTER JOIN** used to combine `budget` and `actuals` so no data is excluded.
- **COALESCE()** applied to handle `NULL` values and provide default values like `'Unknown'`.
- **Variance** calculated as `(actual_amount - budget_amount)`.
- **CASE statements** classify records into:
  - `Over Budget`
  - `Under Budget`
  - `On Budget`
  - `No Budget` (missing budget)
  - `No Actuals` (missing actuals)

---

## Core SQL Query
```sql
SELECT 
  COALESCE(d.department_name, 'Unknown') AS department,
  COALESCE(b.month, a.month) AS month,
  b.budget_amount,
  a.actual_amount,
  (a.actual_amount - b.budget_amount) AS variance,
  CASE
    WHEN b.budget_amount IS NULL THEN 'No Budget'
    WHEN a.actual_amount IS NULL THEN 'No Actuals'
    WHEN a.actual_amount > b.budget_amount THEN 'Over Budget'
    WHEN a.actual_amount < b.budget_amount THEN 'Under Budget'
    ELSE 'On Budget'
  END AS budget_status
FROM budget b
FULL OUTER JOIN actuals a 
  ON b.department_id = a.department_id AND b.month = a.month
FULL OUTER JOIN departments d 
  ON COALESCE(b.department_id, a.department_id) = d.department_id;
