scripts/
├── README.md
├── create_module.sh
├── create_section.sh
├── bootstrap_section.sh
├── bootstrap_all.sh
├── check_generator_backed_modules.sh
├── check_foundational_starter_assets.sh
├── run_repo_smoke_checks.sh
│
├── lib/
│   ├── common.sh
│   ├── fs.sh
│   └── section.sh
│
├── sections/
│   ├── modules/
│   │   ├── 00-shell-linux/
│   │   ├── 00-git/
│   │   ├── 01-python/
│   │   │   ├── init.sh
│   │   │   ├── fill_readme.sh
│   │   │   ├── fill_learning_materials.sh
│   │   │   ├── fill_simple_tasks.sh
│   │   │   ├── fill_pet_projects.sh
│   │   │   └── bootstrap.sh
│   │   │
│   │   └── 02-sql/
│   │       ├── init.sh
│   │       ├── fill_readme.sh
│   │       ├── fill_learning_materials.sh
│   │       ├── fill_simple_tasks.sh
│   │       ├── fill_pet_projects.sh
│   │       └── bootstrap.sh
│   │   ├── 03-docker/
│   │   ├── 04-github-actions/
│   │   ├── 05-confluent-kafka/
│   │   ├── 06-spark-pyspark/
│   │   ├── 07-databricks/
│   │   ├── 08-delta-lake/
│   │   ├── 09-azure-data-lake-storage/
│   │   ├── 11-airflow/
│   │   ├── 12-dbt/
│   │   └── 15-raspberry-pi-homelab/
│   │
│   ├── docs/
│   │   ├── init.sh
│   │   ├── fill_readme.sh
│   │   ├── fill_architecture.sh
│   │   ├── fill_system_design.sh
│   │   ├── fill_case_studies.sh
│   │   ├── fill_tradeoffs.sh
│   │   └── bootstrap.sh
│   │
│   ├── shared/
│   │   ├── init.sh
│   │   ├── fill_readmes.sh
│   │   └── bootstrap.sh
│   │
│   ├── ai-learning/
│   │   ├── init.sh
│   │   ├── fill_readme.sh
│   │   ├── fill_comparisons.sh
│   │   ├── fill_language_learning.sh
│   │   ├── fill_anti_patterns.sh
│   │   ├── fill_developer_communication.sh
│   │   └── bootstrap.sh
│   │
│   └── real-projects/
│       ├── init.sh
│       ├── fill_readme.sh
│       └── bootstrap.sh
│
└── old/