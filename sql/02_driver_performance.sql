-- 2. Анализ эффективности водителей по стажу.
--    Проверка гипотезы о том, что ветеранам достаются более сложные (длинные и дорогие) маршруты, что влияет на процент успешных доставок.

SELECT 
    CASE 
        WHEN driver_experience_years < 2 THEN '1. Новички (0-2 года)'
        WHEN driver_experience_years >= 2 AND driver_experience_years < 5 THEN '2. Средний опыт (2-5 лет)'
        WHEN driver_experience_years >= 5 AND driver_experience_years < 10 THEN '3. Опытные (5-10 лет)'
        ELSE '4. Ветераны (10+ лет)'
    END AS experience_group,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(delay_minutes)::numeric, 2) AS avg_delay_minutes,
    ROUND(AVG(driver_rating)::numeric, 2) AS avg_rating,
    ROUND((SUM(delivery_success) * 100.0) / COUNT(*), 2) AS success_rate_pct,
    -- Добавляем проверку гипотезы о сложности маршрутов
    ROUND(AVG(distance_km)::numeric, 2) AS avg_distance_km,
    ROUND(AVG(delivery_cost)::numeric, 2) AS avg_delivery_cost
FROM 
    public.synthetic_transportation
GROUP BY 
    experience_group
ORDER BY 
    experience_group;
