# Budget vs Actuals Analysis Using PostgreSQL

## Project Highlights 
SQL Concepts: FULL OUTER JOIN, COALESCE, CASE statements, and variance calculations.
Real-World Scenario: Simulates FP&A tasks like budget tracking and variance analysis.
Business Value: Identifies over/under budget trends to improve financial decision-making.
Deliverables: SQL script, sample CSV datasets, and actionable insights.

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

---

## Results & Insights

| Department | Month | Budget | Actual | Variance | Status       |
| ---------- | ----- | ------ | ------ | -------- | ------------ |
| Marketing  | Jan   | 20000  | 22000  | 2000     | Over Budget  |
| Sales      | Jan   | 15000  | NULL   | NULL     | No Actuals   |
| HR         | Jan   | 10000  | 8000   | -2000    | Under Budget |

Key Insights:

Marketing overspent by $2,000 in January.
The Sales department’s actuals are missing, which requires data validation.
30% of departments were under budget in Q1, indicating potential cost-saving trends.

---

## Technologies Used

PostgreSQL – For SQL queries, joins, and variance analysis.
Excel / Power BI – For optional visualization and pivot tables.
CSV Data Files – For budget, actuals, and department datasets.
GitHub – Version control and documentation.

---

## How to Reproduce

Clone this repository:

git clone https://github.com/sharina-alyssa/budget-vs-actuals-sql.git
Create tables for departments, budget, and actuals in PostgreSQL.

Import the CSV files from the data folder into their respective tables.
Run the SQL script in scripts/budget_vs_actuals_analysis.sql.
Export results to CSV or visualize them in Excel/Power B

## Future Improvements

Automate report generation with scheduled SQL jobs or Python scripts.
Add forecasting models based on historical spending trends.
Build interactive dashboards in Power BI to visualize variances dynamically.
Implement data validation checks to flag missing or inconsistent data.
