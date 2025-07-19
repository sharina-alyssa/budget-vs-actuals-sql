-- Create a Common Table Expression (CTE) named combined_budget_actuals
WITH combined_budget_actuals AS (
  SELECT
    -- Use COALESCE to get department_id from budget or actuals table (whichever is not NULL)
    COALESCE(b.department_id, a.department_id) AS department_id,
    -- Use COALESCE to get the month from budget or actuals table (whichever is not NULL)
    COALESCE(b.month, a.month) AS month,
    -- Select budgeted amount from budget table
    b.budget_amount,
    -- Select actual amount from actuals table
    a.actual_amount
  FROM budget b
  -- Perform FULL OUTER JOIN on budget and actuals tables to include all records from both
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
    WHEN c.budget_amount IS NULL THEN 'No Budget'        -- No budget data available
    WHEN c.actual_amount IS NULL THEN 'No Actuals'       -- No actual spending data available
    WHEN c.actual_amount > c.budget_amount THEN 'Over Budget'   -- Spending exceeds budget
    WHEN c.actual_amount < c.budget_amount THEN 'Under Budget'  -- Spending less than budget
    ELSE 'On Budget'                                     -- Spending equals budget
  END AS budget_status
FROM combined_budget_actuals c
-- Join with departments table to get human-readable department names
LEFT JOIN departments d
  ON c.department_id = d.department_id
-- Order the results by department name and month for readability
ORDER BY department, month;
