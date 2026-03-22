# Airflow Monitoring, Observability and Alerting

## 1. Monitoring philosophy

### What monitoring means in Airflow

Monitoring is not just checking if tasks failed.

Monitoring is understanding:

- is the system healthy  
- is data correct  
- are pipelines meeting expectations  
- are we approaching failure  

### Observability vs logging

Logging = raw events  
Observability = ability to understand system behavior

Airflow observability includes:

- logs  
- metrics  
- state transitions  
- timing  
- data correctness  

### Good strategy

Monitor:

- system health  
- pipeline behavior  
- data outputs  

### Bad strategy

Monitor only task failures.

### Why bad is bad

- silent data failures  
- delayed detection  
- business impact without visibility  

### Production scenario

All tasks succeed:

- pipeline is green  
- but output table is empty  
- dashboards break  
- no alert triggered  

--------------------------------------------------

## 2. What to monitor

### DAG-level

- DAG run duration  
- success/failure rate  
- SLA miss  

### Task-level

- task duration  
- retries  
- failure rate  

### Scheduler

- scheduling delay  
- parse time  
- loop latency  

### Workers

- CPU usage  
- memory usage  
- running tasks  
- crash frequency  

### Metadata DB

- query latency  
- connection usage  
- table growth  

### Queue

- queue length  
- waiting time  

### External systems

- API latency  
- DB response time  
- storage availability  

### Good strategy

Monitor all layers.

### Bad strategy

Monitor only Airflow UI.

### Why bad is bad

- hidden bottlenecks  
- delayed detection  

--------------------------------------------------

## 3. Logs

### Types of logs

- task logs  
- scheduler logs  
- worker logs  
- webserver logs  

### Task logs

Contain:

- execution output  
- errors  
- context  

### Scheduler logs

Contain:

- DAG parsing  
- scheduling decisions  

### Worker logs

Contain:

- execution environment  
- runtime failures  

### Good strategy

Use centralized logging.

### Bad strategy

Store logs only locally.

### Why bad is bad

- logs lost on restart  
- hard debugging  

### Production scenario

Worker crashes:

- logs lost  
- cannot debug failure  

--------------------------------------------------

## 4. Metrics

### Core metrics

- task duration  
- DAG duration  
- queue time  
- scheduler lag  
- retry count  
- failure rate  

### System metrics

- CPU  
- memory  
- disk  
- DB latency  

### Derived metrics

- throughput  
- tasks per minute  
- backlog size  

### Good strategy

Track trends over time.

### Bad strategy

Look only at current state.

### Why bad is bad

- cannot detect degradation  
- no early warning  

### Production scenario

Queue time slowly increases:

- no alert  
- system degrades  
- eventually SLA missed  

--------------------------------------------------

## 5. Alerting

### What to alert

- task failures (critical only)  
- DAG failures  
- SLA misses  
- scheduler lag  
- queue backlog  
- no data produced  

### What not to alert

- every retry  
- non-critical tasks  

### Good strategy

Alert on meaningful signals.

### Bad strategy

Alert on everything.

### Why bad is bad

- alert fatigue  
- ignored alerts  

### Production scenario

Too many alerts:

- team ignores them  
- real issue missed  

--------------------------------------------------

## 6. SLA and SLO

### SLA

Expected completion time.

### SLO

Internal target performance.

### Good strategy

Define both:

- system SLA  
- business SLA  

### Bad strategy

No SLA definition.

### Why bad is bad

- unclear expectations  
- no accountability  

--------------------------------------------------

## 7. Data quality monitoring

### Key idea

Task success ≠ data correctness

### What to check

- row counts  
- null values  
- missing partitions  
- stale data  

### Good strategy

Add validation tasks.

### Bad strategy

Assume data is correct.

### Why bad is bad

- silent data corruption  

### Production scenario

Pipeline runs:

- output table empty  
- no failure detected  

--------------------------------------------------

## 8. Failure patterns

### Pattern 1: Scheduler lag

- tasks delayed  
- DAG runs late  

### Pattern 2: Worker overload

- queue grows  
- tasks wait  

### Pattern 3: DB slowdown

- scheduler blocked  
- state updates slow  

### Pattern 4: External system failure

- retries increase  
- system load increases  

### Good strategy

Detect early signals.

### Bad strategy

React only after failure.

### Why bad is bad

- cascading failures  

--------------------------------------------------

## 9. Good vs bad monitoring

### Good

- multi-layer monitoring  
- meaningful alerts  
- trend tracking  
- data validation  

### Bad

- only UI  
- only logs  
- no alerts  
- no metrics  

### Why bad is bad

- blind system  
- reactive debugging  

--------------------------------------------------

## 10. Monitoring stack

### Components

- Airflow UI  
- logs  
- metrics system  
- alert system  
- dashboards  

### Good strategy

Use integrated stack.

### Bad strategy

Fragmented tools.

### Why bad is bad

- inconsistent view  
- hard debugging  

--------------------------------------------------

## 11. Anti-patterns

- alert on every retry  
- no alert ownership  
- no metrics baseline  
- ignoring scheduler metrics  
- no data checks  

### Why bad is bad

- noise  
- missed issues  

--------------------------------------------------

## 12. Final checklist

- logs centralized  
- metrics collected  
- alerts configured  
- SLA defined  
- data validated  
- dashboards created  

--------------------------------------------------

# Airflow Monitoring Practical Guide (UI, CLI, Alerts)

## 1. Where to monitor in Airflow UI

Airflow UI is your first monitoring tool. You must know exactly where to look.

### DAGs page

Path:

- Airflow UI → DAGs

What to look at:

- Last run status (green/red)
- Next run time
- DAG paused/unpaused state

#### Good strategy

Check DAG list daily for:

- failed DAGs
- paused DAGs
- missing schedules

#### Bad strategy

Only open DAG when someone reports issue.

#### Why bad is bad

- late detection
- broken pipelines go unnoticed

---

### DAG Runs view

Path:

- Click DAG → "Runs"

What to check:

- run duration
- success/failure patterns
- missing runs

#### Production scenario

If runs are missing:

- scheduler problem
- DAG paused
- schedule misconfigured

---

### Graph view

Path:

- DAG → Graph

What to check:

- failed tasks
- retry loops
- dependency flow

#### Good strategy

Use Graph view to understand failure location.

#### Bad strategy

Check logs without understanding graph.

#### Why bad is bad

- you debug symptoms, not root cause

---

### Gantt view

Path:

- DAG → Gantt

What to check:

- task duration
- slow tasks
- bottlenecks

#### Production scenario

One task suddenly longer:

- upstream system slow
- DB/API degraded

---

### Task Instance view

Path:

- Click task → Task Instance

Check:

- logs
- start/end time
- retries
- duration

---

### Browse menu (important)

Path:

- Browse → Tasks
- Browse → DAG Runs
- Browse → Jobs
- Browse → SLA Misses

#### What to check

- Jobs → scheduler health
- SLA Misses → business failures

---

## 2. How to read logs correctly

### Where logs are

- Task → Log tab

### What to look for

- ERROR lines
- Traceback
- external system errors

---

### Identify type of failure

#### Code error

    Traceback (most recent call last)

→ bug in code

#### Infra error

    Connection timeout / refused

→ DB/API/network issue

#### Airflow error

    Task exited with return code

→ execution issue

---

### Good strategy

Always read full log from start to failure.

### Bad strategy

Jump to last line.

### Why bad is bad

- miss root cause

---

## 3. Airflow CLI commands

### List DAGs

    airflow dags list

---

### Check DAG

    airflow dags show <dag_id>

---

### Test DAG (no scheduler)

    airflow dags test <dag_id> 2024-01-01

---

### Test single task

    airflow tasks test <dag_id> <task_id> 2024-01-01

---

### Check task state

    airflow tasks state <dag_id> <task_id> 2024-01-01

---

### List running tasks

    airflow tasks list <dag_id>

---

### Good strategy

Use CLI for debugging without scheduler.

### Bad strategy

Debug only through UI.

### Why bad is bad

- slower debugging
- limited control

---

## 4. How to detect system problems

### Scheduler lag

Symptoms:

- DAG runs delayed
- tasks stuck in "scheduled"

Where to see:

- DAG Runs view
- Jobs → scheduler

---

### Queue backlog

Symptoms:

- tasks stuck in "queued"

Where to see:

- Graph view
- task states

---

### Worker overload

Symptoms:

- slow task start
- many retries

---

### DB issues

Symptoms:

- UI slow
- tasks delayed
- scheduler lag

---

## 5. Basic alerting setup

### Email alerts (built-in)

In DAG:

    default_args = {
        "email": ["your@email.com"],
        "email_on_failure": True,
        "email_on_retry": False,
    }

---

### Failure callback

    def on_failure(context):
        print("Task failed:", context["task_instance"].task_id)

---

### Good strategy

Alert only on:

- failures
- SLA miss

### Bad strategy

Alert on retries.

### Why bad is bad

- alert fatigue

---

## 6. Slack alert (basic production)

### Example webhook

    import requests

    def slack_alert(context):
        webhook = "https://hooks.slack.com/services/XXX"
        message = f"Task failed: {context['task_instance'].task_id}"

        requests.post(webhook, json={"text": message})

---

### Attach to DAG

    default_args = {
        "on_failure_callback": slack_alert
    }

---

### Good strategy

Send alerts to team channel.

### Bad strategy

Send alerts to individuals.

### Why bad is bad

- no ownership
- missed alerts

---

## 7. Minimal monitoring setup (must have)

- Airflow UI access
- logs enabled
- email or Slack alerts
- DAG validation tasks
- SLA checks

---

## 8. Real failure scenarios

### Case 1: Task stuck in queued

Cause:

- no free workers
- queue overloaded

---

### Case 2: No logs

Cause:

- worker crashed
- logging misconfigured

---

### Case 3: DAG green but data wrong

Cause:

- no validation
- logic bug

---

### Case 4: Tasks delayed

Cause:

- scheduler lag
- DB slow

---

## 9. Good vs bad monitoring

### Good

- check UI daily
- use CLI
- have alerts
- validate data

### Bad

- wait for complaints
- no alerts
- no logs
- no checks

---

## 10. Final checklist

- you know where to look in UI  
- you can read logs  
- you can debug with CLI  
- alerts are configured  
- validation exists  

--------------------------------------------------