SET enable_external_file_cache = false;
EXPLAIN ANALYZE
FROM read_parquet(getvariable('bucket') || '/large/orders.parquet')
SELECT count(*) WHERE date >= '2026-10-10';
