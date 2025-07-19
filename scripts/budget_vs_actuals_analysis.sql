SELECT 
  COALESCE(d.department_name, 'Unknown') AS department,
  b.month,
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
