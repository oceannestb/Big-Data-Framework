.print === Quantity per product and share of total
SELECT
  product,
  count(*) AS orders,
  sum(quantity) AS quantity,
  round(100 * sum(quantity) / sum(sum(quantity)) OVER (), 1) AS share_pct
FROM orders
GROUP BY product
ORDER BY quantity DESC;

.print === Orders per month
SELECT date_trunc('month', date) AS month, count(*) AS orders, sum(quantity) AS quantity
FROM orders
GROUP BY month
ORDER BY month;

.print === Top 5 customers
SELECT u.username, u.name, count(*) AS orders, sum(o.quantity) AS quantity
FROM orders o
JOIN users u ON o.user_uuid = u.uuid
GROUP BY ALL
ORDER BY quantity DESC
LIMIT 5;

.print === Orders per age group (at the date of the first order)
SELECT
  (date_diff('year', u.birthdate, (SELECT min(date)::DATE FROM orders)) // 20) * 20 AS age_group,
  count(DISTINCT u.uuid) AS users,
  count(*) AS orders,
  round(avg(o.quantity), 2) AS avg_quantity
FROM orders o
JOIN users u ON o.user_uuid = u.uuid
GROUP BY age_group
ORDER BY age_group;

.print === Daily quantity, cumulative and 7-day moving average
WITH daily AS (
  SELECT date::DATE AS day, sum(quantity) AS quantity
  FROM orders
  GROUP BY day
)
SELECT
  day,
  quantity,
  sum(quantity) OVER (ORDER BY day) AS cumulative,
  round(avg(quantity) OVER (ORDER BY day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 1) AS avg_7d
FROM daily
ORDER BY day
LIMIT 10;

.print === Best-selling product of each month
SELECT strftime(date, '%Y-%m') AS month, product, sum(quantity) AS quantity
FROM orders
GROUP BY month, product
QUALIFY rank() OVER (PARTITION BY month ORDER BY sum(quantity) DESC) = 1
ORDER BY month;

.print === Pivot: quantity of each product per month
PIVOT (SELECT strftime(date, '%Y-%m') AS month, product, quantity FROM orders)
ON product
USING sum(quantity)
ORDER BY month;
