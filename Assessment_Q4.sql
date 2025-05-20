-- Q4: Customer Lifetime Value (CLV) Estimation
-- Objective: Estimate CLV using a simplified model based on:
-- - Customer tenure in months since signup
-- - Total number of transactions
-- - Profit per transaction assumed as 0.1% of transaction value

WITH customer_transactions AS (
    SELECT
        sa.owner_id,
        -- Sum of all confirmed inflow amounts per customer (in base units)
        SUM(sa.confirmed_amount) AS total_transaction_value,
        -- Count of all transactions per customer
        COUNT(*) AS total_transactions
    FROM savings_savingsaccount sa
    -- Optional: filter transactions by status if required
    GROUP BY sa.owner_id
),

customer_tenure AS (
    SELECT
        u.id AS customer_id,
        u.name,
        -- Calculate number of months since customer signup
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
),

clv_calculation AS (
    SELECT
        ct.owner_id AS customer_id,
        ut.name,
        ut.tenure_months,
        ct.total_transactions,
        
        -- Calculate total profit assuming 0.1% profit margin (i.e., divide total by 1000)
        ROUND(ct.total_transaction_value / 1000, 2) AS total_profit,

        -- Calculate estimated CLV using formula:
        -- CLV = (average transactions per month * 12) * average profit per transaction
        ROUND(
            (
                (ct.total_transactions / NULLIF(ut.tenure_months, 0)) * 12
                * (ct.total_transaction_value / 1000) / NULLIF(ct.total_transactions, 0)
            ), 
            2
        ) AS estimated_clv
    FROM customer_transactions ct
    JOIN customer_tenure ut ON ct.owner_id = ut.customer_id
)

-- Output customers ranked by estimated CLV in descending order
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM clv_calculation
ORDER BY estimated_clv DESC;
