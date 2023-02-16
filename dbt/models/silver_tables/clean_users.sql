{{
config(
    cluster_by = ['username'],
    partition_by = {"field": "created_at", "data_type": "timestamp", "granularity": "day"},
    tags = ['silver'],
    schema='silver_test',
    materialized = 'incremental',
    unique_key = ['username'],
    on_schema_change='append_new_columns'
)
}}
WITH
  clean_users AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY username ORDER BY created_at DESC) AS last_row,
    CURRENT_TIMESTAMP() AS updated_at
  FROM (
    SELECT
      username,
      age,
      CAST(created_date || ' 00:00:00 ' || time_zone AS timestamp) AS created_at,
      city,
      country,
      address,
      current_position,
      current_company,
      salary
    FROM
      `raw_test.free_users`
    UNION ALL
    SELECT
      username,
      age,
      CAST(created_date || ' 00:00:00 ' || time_zone AS timestamp) AS created_at,
      city,
      country,
      address,
      current_position,
      current_company,
      salary
    FROM
      `raw_test.users` ) AS t )
SELECT
  * EXCEPT(last_row)
FROM
  clean_users
WHERE
  TRUE
  AND last_row = 1