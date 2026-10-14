.print === Export the orders table to Parquet on S3
COPY orders TO (getvariable('bucket') || '/analytics/orders.parquet') (FORMAT parquet);

.print === Parquet metadata (one row per column)
SELECT path_in_schema, type, compression, total_compressed_size, total_uncompressed_size
FROM parquet_metadata(getvariable('bucket') || '/analytics/orders.parquet');

.print === Hive partitioning by product
COPY orders TO (getvariable('bucket') || '/analytics/orders_by_product') (FORMAT parquet, PARTITION_BY (product));

SELECT file FROM glob(getvariable('bucket') || '/analytics/orders_by_product/**');

.print === Partition pruning
EXPLAIN ANALYZE
SELECT count(*)
FROM read_parquet(getvariable('bucket') || '/analytics/orders_by_product/*/*.parquet')
WHERE product = 'cookie';