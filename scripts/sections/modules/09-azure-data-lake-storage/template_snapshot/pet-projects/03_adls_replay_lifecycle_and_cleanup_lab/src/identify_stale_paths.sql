-- Example review query shape for stale temporary paths
SELECT path, age_days
FROM storage_inventory
WHERE path_class = 'temporary'
  AND age_days > 14;
