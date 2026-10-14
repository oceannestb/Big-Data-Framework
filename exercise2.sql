.print === Exercise 2: first and last order of each user, and days between
SELECT
  u.username,
  min(o.date) AS first_order,
  max(o.date) AS last_order,
  date_diff('day', min(o.date), max(o.date)) AS days_between
FROM orders o
JOIN users u ON o.user_uuid = u.uuid
GROUP BY u.uuid, u.username
ORDER BY days_between DESC
LIMIT 10;

