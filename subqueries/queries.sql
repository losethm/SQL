/* Find the employees who's salary is more than the average earned by all employees */
-- Step 1 Find average salary
-- Step 2 filter employees based on result from step 1
SELECT 
  AVG(salary) AS avg_salary 
FROM 
  employee;
SELECT 
  * 
FROM 
  employee 
WHERE 
  salary > (
    SELECT 
      AVG(salary) AS avg_salary 
    FROM 
      employee
  ) 
ORDER BY 
  salary DESC;

-- Alternate Query using FROM clause
SELECT 
  e.* 
FROM 
  employee AS e 
  JOIN (
    SELECT 
      AVG(salary) AS salary 
    FROM 
      employee
  ) AS avg_sal ON e.salary > avg_sal.salary 
ORDER BY 
  e.salary DESC;


/* Find the employees who earn the highest salary in each department. */
--Step 1 find highest salary in each department
--Step 2 filter employees base on result from step 1
-- Step 1
SELECT 
  dept_name, 
  MAX(salary) as top_salary 
FROM 
  employee 
GROUP BY 
  dept_name;
-- Step 2
SELECT 
  e.* 
FROM 
  employee e 
  JOIN (
    SELECT 
      dept_name, 
      MAX(salary) as top_salary 
    FROM 
      employee 
    GROUP BY 
      dept_name
  ) sub ON e.dept_name = sub.dept_name 
  AND e.salary = sub.top_salary


/* Find departments that do not have any employees */
-- Find all departments that are in employee table
SELECT 
  DISTINCT dept_name 
FROM 
  employee;
SELECT 
  dept_name 
FROM 
  department 
WHERE 
  dept_name NOT IN (
    SELECT 
      DISTINCT dept_name 
    FROM 
      employee
  )

/* Find the employees in each department who earn more than the average salary in that department */
-- Step 1 Find average salary by department
-- Step 2 filter employees by step 1
SELECT 
  dept_name, 
  AVG(salary) 
FROM 
  employee 
GROUP BY 
  dept_name;
SELECT 
  e.* 
FROM 
  employee e 
  JOIN (
    SELECT 
      dept_name, 
      AVG(salary) AS avg_salary 
    FROM 
      employee 
    GROUP BY 
      dept_name
  ) sub ON e.dept_name = sub.dept_name 
  AND e.salary > sub.avg_salary;


/* Find store's who's sales were better than the average sales across all stores */
-- Step 1 find total sales for each store
-- Step 2 find average sales for each store
-- Filter stores by step 2
-- Total sales for each store
SELECT 
  store_name, 
  SUM(price * quantity) AS total_sales 
FROM 
  sales 
GROUP BY 
  store_name;
-- Average sales for all stores
SELECT 
  AVG(total_sales) AS avg_sales 
FROM 
  (
    SELECT 
      store_name, 
      SUM(price * quantity) AS total_sales 
    FROM 
      sales 
    GROUP BY 
      store_name
  ) sub;
SELECT 
  sales.store_name, 
  sales.total_sales 
FROM 
  (
    SELECT 
      store_name, 
      SUM(price * quantity) AS total_sales 
    FROM 
      sales 
    GROUP BY 
      store_name
  ) sales 
  JOIN (
    SELECT 
      AVG(total_sales) AS avg_sales 
    FROM 
      (
        SELECT 
          store_name, 
          SUM(price * quantity) AS total_sales 
        FROM 
          sales 
        GROUP BY 
          store_name
      ) avg_sales
  ) AS sub ON sales.total_sales > sub.avg_sales;

-- Better way of solvig using CTE

-- Better way of solvig using CTE
with cte AS (
  SELECT 
    store_name, 
    SUM(price * quantity) AS total_sales 
  FROM 
    sales 
  GROUP BY 
    store_name
) 
SELECT 
  store_name, 
  total_sales 
FROM 
  cte 
  JOIN (
    SELECT 
      AVG(total_sales) AS sales 
    FROM 
      cte x
  ) avg_sales ON cte.total_sales > avg_sales.sales


/* Find all employees and add detail to employees who earn more than the average of all employees */
SELECT 
  *, 
  (
    CASE WHEN salary > (
      SELECT 
        AVG(salary) 
      FROM 
        employee
    ) THEN 'Higher than average' ELSE 'Lower than average' END
  ) as salary_benchmark 
FROM 
  employee;


/* Find stores who have sold more units than average units by all stores */

-- Using CTE
WITH total_units AS (
  SELECT 
    store_name, 
    SUM(quantity) AS units_sold 
  FROM 
    sales 
  GROUP BY 
    store_name
) 
SELECT 
  store_name, 
  units_sold 
FROM 
  total_units 
WHERE 
  units_sold > (
    SELECT 
      AVG(units_sold) 
    FROM 
      total_units
  );
