/*
Проект: Анализ задержек и стоимости логистических доставок
Автор: [Ваше Имя]
Дата: 2026-10-21
Описание: Исследовательский анализ данных (EDA) для выявления узких мест в логистике.
*/

-- 1. Базовый расчет процента опозданий по типам транспорта
SELECT 
    vehicle_type,
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN delay_minutes > 0 THEN 1 ELSE 0 END) AS delayed_deliveries,
    ROUND(
        (SUM(CASE WHEN delay_minutes > 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS delay_rate_pct,
    ROUND(AVG(delay_minutes)::numeric, 2) AS avg_delay_minutes
FROM 
    public.synthetic_transportation
GROUP BY 
    vehicle_type
ORDER BY 
    delay_rate_pct DESC;

-- 2. Двумерный анализ: Погода + Тип транспорта (Топ-10 худших комбинаций)
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
HAVING 
    COUNT(*) > 1000 
ORDER BY 
    delay_rate_pct DESC
LIMIT 10;

-- 3. Оконная функция: Топ-3 самых дорогих доставок для каждого типа транспорта
WITH RankedDeliveries AS (
    SELECT 
        vehicle_type,
        delivery_id,
        delivery_cost,
        distance_km,
        ROW_NUMBER() OVER (
            PARTITION BY vehicle_type 
            ORDER BY delivery_cost DESC
        ) AS cost_rank
    FROM 
        public.synthetic_transportation
)
SELECT 
    vehicle_type,
    delivery_id,
    ROUND(delivery_cost::numeric, 2) AS cost,
    ROUND(distance_km::numeric, 2) AS distance
FROM 
    RankedDeliveries
WHERE 
    cost_rank <= 3
ORDER BY 
    vehicle_type, 
    cost DESC;
