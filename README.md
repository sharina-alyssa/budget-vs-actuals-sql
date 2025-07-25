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
    COALESCE(b.month, a.month) AS month,  -- Get month from either table
    b.budget_amount,
    a.actual_amount
  FROM budget b
  FULL OUTER JOIN actuals a
    ON b.department_id = a.department_id AND b.month = a.month
)
SELECT
  -- Get the department name from departments table; if NULL, default to 'Unknown'
  COALESCE(d.department_name, 'Unknown') AS department,
  -- Select the month from combined results
  c.month,
  -- Select the budgeted amount
  c.budget_amount,
  -- Select the actual spending amount
  c.actual_amount,
  -- Calculate variance as actual minus budget
  (c.actual_amount - c.budget_amount) AS variance,
  -- Classify budget status based on comparison and presence of data
  CASE
    WHEN c.budget_amount IS NULL THEN 'No Budget'  -- No budget data available
    WHEN c.actual_amount IS NULL THEN 'No Actuals'  -- No actual spending data available
    WHEN c.actual_amount > c.budget_amount THEN 'Over Budget'  -- Spending exceeds budget
    WHEN c.actual_amount < c.budget_amount THEN 'Under Budget'  -- Spending less than budget
    ELSE 'On Budget'  -- Spending equals budget
  END AS budget_status
FROM combined_budget_actuals c
-- Join with departments table to get human-readable department names
LEFT JOIN departments d
  ON c.department_id = d.department_id
-- Order the results by department name and month for readability
ORDER BY department, month;

```
---

## Results & Insights

| Department  | Month    | Budget  | Actual  | Variance | Status        |
|-------------|----------|---------|---------|----------|---------------|
| Engineering | 2024-01  | 30,000  | N/A     | N/A      | No Actuals    |
| HR          | 2024-01  | N/A     | 15,000  | N/A      | No Budget     |
| Marketing   | 2024-01  | 20,000  | 22,000  | 2,000    | Over Budget   |
| Sales       | 2024-01  | 25,000  | 24,000  | -1,000   | Under Budget  |

--- 

### Key Insights:

**Engineering** has no actual spending recorded, which could indicate either missing data or a delay in reporting. This needs immediate data validation to ensure accurate variance analysis.

**HR** spent $15,000 without an allocated budget, signaling a potential budget planning gap or unapproved spending. A financial review is required to verify and allocate these expenses properly.

**Marketing** overspent by $2,000 in January, suggesting higher-than-expected campaign or promotional costs. Further analysis is needed to determine if this overspend was strategic or an overrun.

**Sale**s was $1,000 under budget, which reflects effective cost control or possibly underutilization of allocated resources. This trend should be evaluated for potential cost savings or missed opportunities.

---

### Conclusion & Next Steps ### 

The analysis highlights areas requiring immediate management action:

- Validate missing data for Engineering and investigate HR’s unbudgeted spending to ensure accurate financial tracking.
- Review Marketing’s overspend to determine if adjustments in future budgets or cost controls are needed.
- Leverage Sales’ under-budget performance to optimize resource allocation or reallocate unused funds.

Next steps for management include improving the budgeting process, implementing real-time variance tracking, and enhancing forecasting models to prevent unplanned variances.

## Visualization ## 

To enhance insights, I created a **Budget vs. Actuals chart**:

![Budget vs Actual Chart](images/budget_vs_actual_chart.png)

--- 

## Technologies Used

- **PostgreSQL** – For SQL queries, joins, and variance analysis.  
- **Excel** – For optional visualization and pivot tables.  
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
