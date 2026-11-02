# dbt: транзакции и фрод

Данные: `homework.transactions` из [hw2](https://github.com/mvsamorodova/hw2).
Макрос `prepare_source` создаёт представление `transactions_db.transactions` со схемой из задания:
`amt`, `state`, `category` переименовываются, остальные поля извлекаются из `raw_json`.


## Запуск

```bash
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
docker compose -f /Users/msamorodova/Documents/hw2/docker-compose.yml -f "$PWD/clickhouse.override.yml" up -d --wait clickhouse
```

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
export DBT_PROFILES_DIR="$PWD"
dbt deps
dbt run-operation prepare_source
dbt run
dbt --no-use-colors test | tee dbt-test.log
dbt docs generate
dbt docs serve --port 8082
```

## Витрины

- `mart_daily_state_metrics`: количество, сумма, средний чек, P95, доля крупных транзакций.
- `mart_fraud_by_category`: количество транзакций и фродов, fraud_rate, суммы.
- `mart_fraud_by_state`: fraud_rate, уникальные клиенты и мерчанты, суммы.
- `mart_hourly_fraud_pattern`: фрод по дням недели и часам, флаг повышенного риска.

Крупная транзакция: сумма >= 1000. 
Клиент определяется парой имя и фамилия: отдельного ID клиента в исходных данных нет.

## Пакеты и тесты

- `dbt_utils`: уникальность составных ключей витрин.
- `dbt_date`: день недели с адаптацией для ClickHouse.
- `dbt_expectations`: границы часов и процентных метрик.
- Базовые тесты: `not_null`, `unique`, `accepted_values`.
- Singular tests: `assert_no_negative_amounts`, `assert_fraud_rate_bounds`.
