SELECT 
    -- Извлекаем день недели (1 = Понедельник, 7 = Воскресенье)
    EXTRACT(ISODOW FROM dispatch_date::date) AS day_of_week_num,
    -- Превращаем номер дня в читаемое название
    TO_CHAR(dispatch_date::date, 'Day') AS day_of_week_name,
    COUNT(*) AS total_deliveries,
    -- Считаем среднюю задержку
    ROUND(AVG(delay_minutes)::numeric, 2) AS avg_delay_minutes,
    -- Считаем процент опозданий
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