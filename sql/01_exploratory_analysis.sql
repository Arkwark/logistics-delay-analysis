-- 1. Базовый расчет процента опозданий по типам транспорта (+ медиана)
SELECT 
    vehicle_type,
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN delay_minutes > 0 THEN 1 ELSE 0 END) AS delayed_deliveries,
    ROUND(
        (SUM(CASE WHEN delay_minutes > 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS delay_rate_pct,
    ROUND(AVG(delay_minutes)::numeric, 2) AS avg_delay_minutes,
    -- Добавляем медиану задержки
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY delay_minutes)::numeric, 
        2
    ) AS median_delay_minutes
FROM 
    public.synthetic_transportation
GROUP BY 
    vehicle_type
ORDER BY 
    delay_rate_pct DESC;