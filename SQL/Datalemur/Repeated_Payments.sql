-- Sometimes, payment transactions are repeated by accident; it could be due to user error, API failure or a retry error that causes a credit card to be charged twice.

-- Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. Count such repeated payments.

-- Assumptions:

-- The first transaction of such payments should not be counted as a repeated payment. This means, if there are two transactions performed by a merchant with the same credit card and for the same amount within 10 minutes, there will only be 1 repeated payment.
-- transactions Table:
-- Column Name	Type
-- transaction_id	integer
-- merchant_id	integer
-- credit_card_id	integer
-- amount	integer
-- transaction_timestamp	datetime
-- transactions Example Input:
-- transaction_id	merchant_id	credit_card_id	amount	transaction_timestamp
-- 1	101	1	100	09/25/2022 12:00:00
-- 2	101	1	100	09/25/2022 12:08:00
-- 3	101	1	100	09/25/2022 12:28:00
-- 4	102	2	300	09/25/2022 12:00:00
-- 6	102	2	400	09/25/2022 14:00:00

-- The main idea of this question is to use window function LAG to get the previous time and then subtract it to get the time difference
-- Then group by merchant, carc, amount to get same transactions, and use extract to fetch the timediff in epoch / 60 to get in minutes

with transactions_count as (
select 
merchant_id,
credit_card_id,
transaction_timestamp,
lag(transaction_timestamp) over(partition by merchant_id, credit_card_id, amount
            order by transaction_timestamp) as lagged_ts
            from transactions
),

minute_calculator as (
select *,
extract(epoch from transaction_timestamp - lagged_ts)/60 as minutes_per_transaction
from transactions_count
)
select count(merchant_id) as payment_count
from minute_calculator 
where minutes_per_transaction>=10