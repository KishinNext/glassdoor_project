from airflow import DAG
from datetime import timedelta
from airflow.utils.task_group import TaskGroup
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import (
    KubernetesPodOperator
)
image = 'us-docker.pkg.dev/refined-network-373614/demo/project-demo:latest'

project_dir = 'dbt'

task_default_args = {
    'owner': 'test',
    'start_date': '2020-01-01',
    'depends_on_past': False,
}

list_dbt_silver_models = [
    'silver_tables.clean_users',
    'silver_tables.payment_details'
]

list_dbt_gold_models = [
    'gold_tables.model_users'
]


with DAG(
    dag_id='dbt-demo',
    description='orchestrate the ETLs that bring data to the co schema',
    schedule_interval='25/30 0-2,11-23 * * *',
    dagrun_timeout=timedelta(minutes=60),
    concurrency=4,
    max_active_runs=1,
    catchup=False,
    default_args=task_default_args,
    tags=['dbt']
) as dbt_dag:
    silver_process = TaskGroup(group_id='silver_process', dag=dbt_dag)
    gold_process = TaskGroup(group_id='gold_process', dag=dbt_dag)

    generic_silver_dbt_tasks = {
        model: KubernetesPodOperator(
            task_id=model,
            name=model,
            cmds=["sh", "-c", f"dbt deps && dbt build -s {model}"],
            task_group=silver_process,
            namespace="default",
            image_pull_policy='Always',
            image=image,
            get_logs=True,
            dag=dbt_dag,
            is_delete_operator_pod=True,
            startup_timeout_seconds=360,
            in_cluster=False,
            config_file="/home/airflow/composer_kube_config",
            affinity={
                "nodeAffinity": {
                    "requiredDuringSchedulingIgnoredDuringExecution": {
                        "nodeSelectorTerms": [
                            {
                                "matchExpressions": [
                                    {
                                        "key": "cloud.google.com/gke-nodepool",
                                        "operator": "In",
                                        "values": [
                                            "default-pool"
                                        ],
                                    }
                                ]
                            }
                        ]
                    }
                }
            }
        )
        for model in list_dbt_silver_models
    }

    generic_gold_dbt_tasks = {
        model: KubernetesPodOperator(
            task_id=model,
            name=model,
            cmds=["sh", "-c", f"dbt deps && dbt build -s {model}"],
            task_group=gold_process,
            namespace="default",
            image_pull_policy='Always',
            image=image,
            get_logs=True,
            dag=dbt_dag,
            is_delete_operator_pod=True,
            startup_timeout_seconds=360,
            in_cluster=False,
            config_file="/home/airflow/composer_kube_config",
            affinity={
                "nodeAffinity": {
                    "requiredDuringSchedulingIgnoredDuringExecution": {
                        "nodeSelectorTerms": [
                            {
                                "matchExpressions": [
                                    {
                                        "key": "cloud.google.com/gke-nodepool",
                                        "operator": "In",
                                        "values": [
                                            "default-pool"
                                        ],
                                    }
                                ]
                            }
                        ]
                    }
                }
            }
        )
        for model in list_dbt_gold_models
    }

    silver_process  >>  gold_process