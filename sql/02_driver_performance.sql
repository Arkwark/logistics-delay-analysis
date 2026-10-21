SELECT 
    CASE 
        WHEN driver_experience_years < 2 THEN '1. Новички (0-2 года)'
        WHEN driver_experience_years BETWEEN 2 AND 5 THEN '2. Средний опыт (2-5 лет)'
        WHEN driver_experience_years BETWEEN 5 AND 10 THEN '3. Опытные (5-10 лет)'
        ELSE '4. Ветераны (10+ лет)'
    END AS experience_group,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(delay_minutes)::numeric, 2) AS avg_delay_minutes,
    ROUND(AVG(driver_rating)::numeric, 2) AS avg_rating,
    -- Считаем процент успешных доставок (delivery_success = 1)
    ROUND((SUM(delivery_success) * 100.0) / COUNT(*), 2) AS success_rate_pct
FROM 
    public.synthetic_transportation
GROUP BY 
    experience_group
ORDER BY 
    experience_group;