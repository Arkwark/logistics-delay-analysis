-- 4. Выявление дней недели с наибольшим процентом опозданий и средней задержкой для оптимизации графика работы склада и распределения ресурсов.

SELECT 
    EXTRACT(ISODOW FROM dispatch_date::date) AS day_of_week_num,
    TO_CHAR(dispatch_date::date, 'Day') AS day_of_week_name,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(delay_minutes)::numeric, 2) AS avg_delay_minutes,
    ROUND(
        (SUM(CASE WHEN delay_minutes > 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS delay_rate_pct
FROM 
    public.synthetic_transportation
GROUP BY 
    day_of_week_num, 
    day_of_week_name
ORDER BY 
    day_of_week_num;
