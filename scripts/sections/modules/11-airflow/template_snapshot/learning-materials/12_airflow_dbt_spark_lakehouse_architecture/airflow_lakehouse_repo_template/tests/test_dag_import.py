from airflow.models import DagBag

def test_no_import_errors():
    dag_bag = DagBag()
    assert len(dag_bag.import_errors) == 0, dag_bag.import_errors

def test_dag_exists():
    dag_bag = DagBag()
    assert "orders_pipeline_runtime_safe" in dag_bag.dags
