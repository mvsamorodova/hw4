select
    day_of_week,
    transaction_hour,
    count() as transaction_count,
    countIf(is_fraud = 1) as fraud_count,
    100.0 * countIf(is_fraud = 1) / count() as fraud_rate,
    fraud_rate > (
        select 100.0 * avg(is_fraud) from {{ ref('stg_transactions') }}
    ) as is_high_risk
from {{ ref('stg_transactions') }}
group by day_of_week, transaction_hour
