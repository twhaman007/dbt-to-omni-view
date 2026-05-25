-- Simple dbt model for Snowflake connection testing
select
  current_timestamp() as now,
  'hello dbt' as message
