with cleaned as (
    select
        toDateTime(transaction_time) as transaction_time,
        nullIf(trimBoth(merch), '') as merchant,
        nullIf(lowerUTF8(trimBoth(cat_id)), '') as category,
        toFloat64(amount) as amount,
        nullIf(lowerUTF8(trimBoth(name_1)), '') as first_name,
        nullIf(lowerUTF8(trimBoth(name_2)), '') as last_name,
        nullIf(upperUTF8(trimBoth(gender)), '') as gender,
        nullIf(upperUTF8(trimBoth(us_state)), '') as state,
        toUInt8(target) as is_fraud
    from {{ source('raw', 'transactions') }}
)

select
    *,
    toDate(transaction_time) as transaction_date,
    {{ dbt_date.day_of_week('transaction_time') }} as day_of_week,
    toHour(transaction_time) as transaction_hour,
    {{ amount_bucket('amount') }} as amount_bucket
from cleaned
