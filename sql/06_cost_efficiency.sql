SELECT 
    vehicle_type,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(delivery_cost)::numeric, 2) AS avg_cost,
    ROUND(AVG(distance_km)::numeric, 2) AS avg_distance,
    -- Считаем среднюю стоимость за 1 км
    ROUND(AVG(delivery_cost / NULLIF(distance_km, 0))::numeric, 2) AS cost_per_km
FROM 
    public.synthetic_transportation
GROUP BY 
    vehicle_type
ORDER BY 
    cost_per_km DESC;