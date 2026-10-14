SELECT row_group_id, row_group_num_rows, stats_min, stats_max
FROM parquet_metadata(getvariable('bucket') || '/large/orders.parquet')
WHERE path_in_schema = 'date';
