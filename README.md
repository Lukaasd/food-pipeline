# FOOD Data Pipeline

**De archivos de pedidos y reseñas a un sistema de análisis que se actualiza con Airflow.**

Este proyecto toma siete CSV de un dataset de Zomato y los convierte en tablas que permiten comparar ventas, tiempos de entrega y desempeño de restaurantes. También clasifica reseñas con un modelo local y ofrece un explorador donde se pueden hacer preguntas en español y consultar los comentarios que respaldan cada respuesta.

## Qué podés explorar

| Pregunta | Qué entrega el proyecto |
| --- | --- |
| ¿Qué ciudades concentran más ventas? | Pedidos, ventas de pedidos entregados y ticket promedio por día y ciudad. |
| ¿En qué ciudades y horarios tardan más las entregas? | Mediana y percentil 90, con el conteo de entregas que tienen un tiempo registrado. |
| ¿Cómo se comparan los restaurantes? | Volumen de pedidos, importe entregado, puntuación y tiempo promedio. |
| ¿De qué se quejan los clientes? | Un resumen de las reseñas clasificadas por ciudad, tema y sentimiento, y un buscador que muestra las reseñas originales. |

## Cómo funciona

1. **Carga.** Airflow lleva los CSV de Amazon S3 a Snowflake.
2. **Transformación.** dbt limpia los datos, comprueba claves y relaciones, y construye el modelo analítico. Los pedidos y sus líneas se guardan por separado para poder sumar ventas sin duplicar importes.
3. **Enriquecimiento.** Ollama clasifica un lote de reseñas pendientes. Airflow actualiza el mart de reseñas con los resultados.
4. **Exploración.** Una app de Streamlit busca comentarios similares a la pregunta y genera una respuesta con citas. El índice se prepara por separado a partir de una muestra de hasta 500 reseñas.

El DAG `food_batch` se verificó de punta a punta con sus cuatro tareas en `Success`. El enriquecimiento usa un lote predeterminado de cinco reseñas por ejecución, así que el mart de sentimiento describe las reseñas procesadas hasta el momento.

## Recorrer el proyecto

- [Arquitectura e instalación](docs/arquitectura.md) · cómo se conectan las piezas y cómo reproducir el pipeline.
- [Diagrama del DAG](docs/food_batch.mmd) · qué ejecuta Airflow y en qué orden.
- [Modelo de datos](docs/modelo_de_datos.md) · qué representa cada tabla y cómo unir los hechos con sus dimensiones.
- [Métricas](docs/metricas.md) · definiciones, fórmulas y ejemplos de interpretación.

**Herramientas** · Amazon S3, Snowflake, dbt, Apache Airflow, Docker Compose, Python, Ollama y Streamlit. El repositorio incluye código y configuración de ejemplo. Los CSV y las credenciales se preparan en cada entorno.

