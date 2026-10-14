.print === Exercise 4: month-over-month variation of quantity per product (%)
-- First and last months are partial, so their variations are not meaningful.
WITH monthly AS (
  SELECT strftime(date, '%Y-%m') AS month, product, sum(quantity) AS quantity
  FROM orders
  GROUP BY month, product
),
with_previous AS (
  SELECT
    month,
    product,
    quantity,
    lag(quantity) OVER (PARTITION BY product ORDER BY month) AS previous_quantity
  FROM monthly
)
SELECT
  month,
  product,
  quantity,
  previous_quantity,
  round(100.0 * (quantity - previous_quantity) / previous_quantity, 1) AS variation_pct
FROM with_previous
ORDER BY product, month;

