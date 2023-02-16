{{
    config(
        cluster_by = ['username'],
        partition_by = {"field": "created_at", "data_type": "timestamp", "granularity": "day"},
        tags = ['gold'],
        schema='gold_test',
        materialized = 'incremental',
        unique_key = ['username'],
        on_schema_change='append_new_columns'
    )
}}
SELECT
  *,
  CASE
      WHEN fhoffa.x.random_int(0, 10) < 5 THEN TRUE
    ELSE
      FALSE
  END
  AS is_active
FROM {{ ref('payment_details') }}