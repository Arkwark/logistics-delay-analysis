-- 5.Подготовка данных для тепловой карты (погода × тип транспорта) с целью выявления самых уязвимых комбинаций условий и транспорта.

SELECT 
    weather_condition,
    vehicle_type,
    COUNT(*) AS total_deliveries,
    ROUND(
        (SUM(CASE WHEN delay_minutes > 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS delay_rate_pct
FROM 
    public.synthetic_transportation
GROUP BY 
    weather_condition, 
    vehicle_type
ORDER BY 
    delay_rate_pct DESC;
