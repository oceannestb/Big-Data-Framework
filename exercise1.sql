.print === Exercise 1: average orders per user and average quantity per order
SELECT
  count(*) AS total_orders,
  count(DISTINCT user_uuid) AS users_with_orders,
  round(count(*) * 1.0 / count(DISTINCT user_uuid), 2) AS avg_orders_per_user,
  round(avg(quantity), 2) AS avg_quantity_per_order
FROM orders;

