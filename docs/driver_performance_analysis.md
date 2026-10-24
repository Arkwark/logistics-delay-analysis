SELECT 

&#x20;   CASE 

&#x20;       WHEN driver\_experience\_years < 2 THEN '1. Новички (0-2 года)'

&#x20;       WHEN driver\_experience\_years >= 2 AND driver\_experience\_years < 5 THEN '2. Средний опыт (2-5 лет)'

&#x20;       WHEN driver\_experience\_years >= 5 AND driver\_experience\_years < 10 THEN '3. Опытные (5-10 лет)'

&#x20;       ELSE '4. Ветераны (10+ лет)'

&#x20;   END AS experience\_group,

&#x20;   COUNT(\*) AS total\_deliveries,

&#x20;   ROUND(AVG(delay\_minutes)::numeric, 2) AS avg\_delay\_minutes,

&#x20;   ROUND(AVG(driver\_rating)::numeric, 2) AS avg\_rating,

&#x20;   ROUND((SUM(delivery\_success) \* 100.0) / COUNT(\*), 2) AS success\_rate\_pct,

&#x20;   -- Добавляем проверку гипотезы о сложности маршрутов

&#x20;   ROUND(AVG(distance\_km)::numeric, 2) AS avg\_distance\_km,

&#x20;   ROUND(AVG(delivery\_cost)::numeric, 2) AS avg\_delivery\_cost

FROM 

&#x20;   public.synthetic\_transportation

GROUP BY 

&#x20;   experience\_group

ORDER BY 

&#x20;   experience\_group;



&#x20;

Анализ показал, что у ветеранов средняя дистанция составляет 157,7 км, что примерно в 2 раза больше (79,87 км), чем у новичков.

Это подтверждает гипотезу о том, что снижение успешности связано со сложностью маршрутов, а не с квалификацией водителей.

