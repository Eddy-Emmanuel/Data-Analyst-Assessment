-- Select key customer info and metrics for high-value users
SELECT 
    u.id AS owner_id,  -- Customer unique ID (aliased as owner_id)
    
    -- Merge first_name and last_name into a single NAME column
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Count distinct savings plans where is_regular_savings = 1
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    
    -- Count distinct investment plans where is_a_fund = 1
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    
    -- Sum confirmed deposit amounts (convert from kobo to Naira)
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits

FROM users_customuser u

-- Join plans owned by the user
JOIN plans_plan p ON u.id = p.owner_id

-- Left join to savings to include all deposits even if no savings exist for some plans
LEFT JOIN savings_savingsaccount s 
    ON s.owner_id = u.id
    AND s.plan_id = p.id
    AND s.confirmed_amount > 0

-- Only active plans
WHERE 
    p.is_archived = 0 
    AND p.is_deleted = 0 

GROUP BY u.id, u.first_name, u.last_name

-- Filter users with at least 1 savings plan AND 1 investment plan
HAVING 
    savings_count >= 1 
    AND investment_count >= 1

-- Order by highest total deposits first
ORDER BY total_deposits DESC;