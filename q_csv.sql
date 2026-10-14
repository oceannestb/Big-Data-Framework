SET enable_external_file_cache = false;
EXPLAIN ANALYZE
FROM read_csv(getvariable('bucket') || '/large/orders.csv', strict_mode=false)
SELECT product, sum(quantity) GROUP BY product;
