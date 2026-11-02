{% macro prepare_source() %}
    {% do run_query('create database if not exists transactions_db') %}
    {% set sql %}
        create view if not exists transactions_db.transactions as
        select
            parseDateTimeBestEffort(JSONExtractString(raw_json, 'transaction_time')) as transaction_time,
            JSONExtractString(raw_json, 'merch') as merch,
            category as cat_id,
            toFloat64(amt) as amount,
            JSONExtractString(raw_json, 'name_1') as name_1,
            JSONExtractString(raw_json, 'name_2') as name_2,
            JSONExtractString(raw_json, 'gender') as gender,
            state as us_state,
            toFloat64(JSONExtractString(raw_json, 'lat')) as lat,
            toFloat64(JSONExtractString(raw_json, 'lon')) as lon,
            toFloat64(JSONExtractString(raw_json, 'merchant_lat')) as merchant_lat,
            toFloat64(JSONExtractString(raw_json, 'merchant_lon')) as merchant_lon,
            toUInt8(JSONExtractString(raw_json, 'target')) as target
        from homework.transactions
    {% endset %}
    {% do run_query(sql) %}
{% endmacro %}
