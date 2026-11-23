# Métricas de negocio

Los marts viven en `FOOD.MARTS`. La granularidad indica qué representa cada fila y determina cómo se pueden combinar los resultados. Los importes de la demo se interpretan en rupias indias (INR). Los tiempos se expresan en minutos.

## Ingresos diarios por ciudad

Modelo [mart_daily_city_revenue.sql](../dbt/models/marts/reporting/mart_daily_city_revenue.sql). Una fila por `order_date` y ciudad del restaurante. Usa `fct_orders` y toma la ciudad de `dim_restaurants`. Si falta, usa `Unknown`.

| Métrica | Cálculo | Interpretación |
| --- | --- | --- |
| `orders` | `COUNT(*)` | Pedidos de todos los estados en el grupo. |
| `delivered_orders` | `COUNT_IF(is_delivered)` | Pedidos entregados. |
| `cancel_rate` | Pedidos con estado `CANCELLED` ÷ todos los pedidos, redondeado a 4 decimales. | Una proporción de 0,15 equivale a 15 %. Los reembolsos tienen su propio estado. |
| `gmv` | Suma de `sales_amount` de pedidos entregados. | Importe final de entregas según la definición del proyecto. Puede incluir componentes ya incorporados en el importe de origen. |
| `aov` | `gmv` ÷ pedidos entregados, redondeado a 2 decimales. | Ticket promedio por pedido entregado. |

Ejemplo: con 10 pedidos, 8 entregados, 2 cancelados y un importe entregado de ₹2.400, la tasa de cancelación es 20 % y el AOV es ₹300. El mart usa `COUNT_IF`, que puede dejar `NULL` en un grupo sin coincidencias. Para presentar un conteo o una tasa sin cancelaciones como cero, aplicá `COALESCE`. Para un AOV sin entregas, conservá el valor ausente.

Para calcular el AOV mensual de cada ciudad, dividí la suma del GMV por la suma de pedidos entregados. Promediar los AOV diarios daría el mismo peso a días con distinto volumen. Para obtener una tasa de cancelación exacta a otra granularidad, recalculá numerador y denominador desde `fct_orders`.

~~~sql
SELECT DATE_TRUNC('month', order_date) AS mes,
       city,
       SUM(gmv) AS gmv_inr,
       ROUND(SUM(gmv) / NULLIF(SUM(delivered_orders), 0), 2) AS aov_inr
FROM FOOD.MARTS.MART_DAILY_CITY_REVENUE
GROUP BY 1, 2;
~~~

[Referencia de COUNT_IF en Snowflake](https://docs.snowflake.com/en/sql-reference/functions/count_if)

## Tiempos de entrega

Modelo [mart_delivery_sla.sql](../dbt/models/marts/reporting/mart_delivery_sla.sql). Una fila por ciudad de restaurante y hora en la que se hizo el pedido, de 0 a 23. Agrupa los pedidos entregados de todo el período disponible.

| Métrica | Cálculo |
| --- | --- |
| `delivered_orders` | Cuenta todos los pedidos entregados del grupo. |
| `orders_with_delivery_time` | Cuenta entregados con `delivery_time_min` presente. |
| `p50` | Mediana del tiempo de entrega, redondeada a un decimal. |
| `p90` | Percentil continuo 90 del tiempo de entrega, redondeado a un decimal. |

Si el p50 es 28 y el p90 es 50, la mitad de las entregas con tiempo registrado tardó aproximadamente hasta 28 minutos y alrededor del 90 % tardó hasta 50 minutos. El p90 permite observar la parte lenta de la distribución. La interpolación puede producir un valor que no aparece como tiempo exacto en ningún pedido. El modelo describe tiempos y cobertura, sin una meta contractual configurada. Para un p90 global, calculalo sobre los tiempos individuales en `fct_orders`.

## Rendimiento por restaurante

Modelo [mart_restaurant_performance.sql](../dbt/models/marts/reporting/mart_restaurant_performance.sql). Agrupa por ID de restaurante y sus atributos de la dimensión, nombre, ciudad y cocina.

| Métrica | Cálculo |
| --- | --- |
| `orders` | Total de pedidos en todos los estados. |
| `delivered_orders` | Pedidos entregados. |
| `delivered_sales_amount` | Suma de `sales_amount` de pedidos entregados, en INR. |
| `avg_customer_rating` | Media de las puntuaciones presentes de pedidos entregados, con dos decimales. |
| `avg_delivery_min` | Media de los tiempos presentes de pedidos entregados, con un decimal. |

El importe entregado mide volumen transaccionado. El modelo carece de datos para calcular margen o ingreso neto de la plataforma. Conviene interpretar las medias junto al volumen y recalcularlas sobre los datos de detalle cuando cambie la agrupación.

## Reseñas enriquecidas

Modelo [mart_review_insights.sql](../dbt/models/marts/reporting/mart_review_insights.sql). Una fila por ciudad, tema y etiqueta de sentimiento. Toma la clasificación más reciente por `review_id` y la une con `stg_reviews` para recuperar ciudad y estrellas. Las reseñas que todavía esperan clasificación quedan fuera del mart.

| Métrica | Cálculo |
| --- | --- |
| `reviews` | Cantidad de reseñas enriquecidas que coinciden con `stg_reviews` en el grupo. |
| `avg_sentiment_score` | Media del puntaje asignado por Ollama, en escala de −1 a 1 y redondeada a tres decimales. |
| `avg_star_rating` | Media de las estrellas presentes de la reseña original, redondeada a dos decimales. |
| `flagged_issues` | Reseñas con `key_issue` presente y no vacío. |

El puntaje de sentimiento estima intensidad a partir del texto. Las estrellas son la valoración del cliente. Una reseña positiva puede incluir un problema puntual y sumar a `flagged_issues`. El lote se selecciona entre reseñas pendientes ordenadas por ID, por lo que su distribución de temas y sentimientos describe la cobertura procesada.

~~~sql
SELECT city, SUM(reviews) AS resenas_negativas
FROM FOOD.MARTS.MART_REVIEW_INSIGHTS
WHERE topic = 'delivery' AND sentiment_label = 'negative'
GROUP BY city
ORDER BY resenas_negativas DESC;
~~~

