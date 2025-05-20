-- Q3: Account Inactivity Alert
-- Objective: Identify all active accounts (savings or investment plans) that have had no deposit transactions in the past 365 days

WITH latest_transaction AS (
    SELECT
        sa.plan_id,
        MAX(sa.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount sa
    -- Optional: Uncomment the following line to consider only successful inflow transactions
    -- WHERE sa.transaction_status = 'successful'
    GROUP BY sa.plan_id
),

active_plans AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS plan_type,
        p.is_deleted,
        p.is_archived
    FROM plans_plan p
    WHERE p.is_deleted = 0 AND p.is_archived = 0  -- Include only active plans
),

inactive_plans AS (
    SELECT
        ap.plan_id,
        ap.owner_id,
        ap.plan_type,
        lt.last_transaction_date,
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS days_inactive
    FROM latest_transaction lt
    JOIN active_plans ap ON lt.plan_id = ap.plan_id
    WHERE DATEDIFF(CURDATE(), lt.last_transaction_date) > 365
)

SELECT * 
FROM inactive_plans
ORDER BY days_inactive DESC;
