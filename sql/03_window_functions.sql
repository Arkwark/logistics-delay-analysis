WITH DailyCosts AS (
    SELECT 
        dispatch_date::date AS delivery_date,
        SUM(delivery_cost) AS total_cost,
        COUNT(*) AS total_orders
    FROM 
        public.synthetic_transportation
    GROUP BY 
        dispatch_date::date
)
SELECT 
    delivery_date,
    total_cost,
    -- Скользящее среднее за текущий и 2 предыдущих дня
    ROUND(
        AVG(total_cost) OVER (
            ORDER BY delivery_date 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )::numeric, 2
    ) AS moving_avg_3d,
    -- Разница между текущим днем и предыдущим (LAG)
    total_cost - LAG(total_cost) OVER (ORDER BY delivery_date) AS day_over_day_diff
FROM 
    DailyCosts
ORDER BY 
    delivery_date
LIMIT 20;