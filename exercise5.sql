.print === Exercise 5: users who ordered every product at least once
SELECT u.username, count(DISTINCT o.product) AS products
FROM orders o
JOIN users u ON o.user_uuid = u.uuid
GROUP BY u.uuid, u.username
HAVING count(DISTINCT o.product) = (SELECT count(DISTINCT product) FROM orders)
ORDER BY u.username;