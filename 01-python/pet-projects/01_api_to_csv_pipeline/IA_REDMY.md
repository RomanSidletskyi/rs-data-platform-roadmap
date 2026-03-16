## Як запускати

У папці проєкту:
```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python src/main.py
```

## Що станеться після запуску

Пайплайн:

зробить запит до API

збереже raw JSON у data/raw/

витягне поля з selected_fields

збереже CSV у data/processed/

запише логи в logs/pipeline.log

## Що ще треба підправити, щоб було зовсім акуратно

У README.md можна вже писати, що проєкт підтримує:

modular structure

retry logic

raw and processed outputs

execution logging

config-driven field selection

## Швидкі команди для створення файлів

```
mkdir -p src config data/raw data/processed logs tests

touch src/main.py
touch src/api_client.py
touch src/processor.py
touch src/writer.py
touch src/config_loader.py
touch requirements.txt
touch .env.example
touch config/config.yaml
```
## Одна важлива деталь

Зараз .env.example ще не використовується в коді. Це нормально для першої working version.
На наступному кроці можна зробити version 2, де:

URL можна перевизначати через .env

LOG_LEVEL реально використовується

додається quarantine для bad records

додаються unit tests

Найлогічніший наступний крок — одразу зробити version 2 з .env support і кращим logging.