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
SELECT
  cu.username,
  cu.age,
  cu.created_at,
  cu.city,
  cu.country,
  cu.address,
  cu.current_position,
  cu.current_company,
  cu.salary,
  cu.updated_at,
  case when s.subscription_level is null then 'Free' else s.subscription_level end as subscription_level,
  case when p.price is null then 0 else p.price end as price,
  case when p.description is null then 'Free plan' else p.description end as description,
FROM {{ ref('clean_users') }} cu
LEFT JOIN `raw_test.subscription` s ON s.username = cu.username
LEFT JOIN `raw_test.prices` p ON p.subscription_level = s.subscription_level