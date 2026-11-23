FROM apache/airflow:3.0.3-python3.12

RUN pip install --no-cache-dir \
    "apache-airflow==3.0.3" \
    apache-airflow-providers-snowflake \
    apache-airflow-providers-fab \
    --constraint "${HOME}/constraints.txt"

RUN python -m venv /opt/airflow/dbt_venv && \
    /opt/airflow/dbt_venv/bin/pip install --no-cache-dir \
    "dbt-core>=1.10.5,<2" \
    "dbt-snowflake>=1.10,<2"