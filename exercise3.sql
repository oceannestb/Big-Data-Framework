
.print === Exercise 3: hour of the day with the highest quantity sold
SELECT hour(date) AS hour, sum(quantity) AS quantity
FROM orders
GROUP BY hour
ORDER BY quantity DESC
LIMIT 1;
