airflow-dbt-comparador
-----------------------------

DBT project for load silver tables 

Quickstart
----------

Install the latest dbt if you haven't installed it yet (this requires
and vi environment):

    pip install \
      dbt-core \
      dbt-postgres \
      dbt-bigquery

Install the packages that use the project

    dbt deps --project-dir dbt

Run the project

    dbt run --project-dir dbt | dbt build --project-dir dbt

Optional commands
-----------------

Also you can select the model to run

    dbt run -s [model-name] --project-dir dbt

If for one reason you can't clean up the project you could use this command:

    dbt clean --project-dir dbt