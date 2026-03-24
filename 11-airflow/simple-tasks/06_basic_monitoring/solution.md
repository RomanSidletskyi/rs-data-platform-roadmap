# Solution - Basic Monitoring

This topic is about reading workflow state like an operator, not only like a code author.

## Operational Note Example

For a DAG with three tasks, monitor the following in the Airflow UI:

- DAG run state
- individual task states
- retry attempts
- task duration
- logs for failed tasks

## What To Look For

### Successful run

- DAG run marked successful
- all task instances finished successfully

### Failed run

- one or more task instances marked failed
- downstream tasks may be skipped or blocked depending on dependencies

### Retry behavior

- Airflow UI shows retry states and try numbers
- logs help explain whether the failure was transient or logic-related

## Where Logs Can Be Found

- task instance log view in the UI
- worker logs in the runtime environment when deeper debugging is needed

## Monitoring Concepts Worth Knowing Early

- retries do not mean the system is healthy by default
- a green DAG can still produce bad data if no validation exists
- queue delay and scheduling delay are also operational signals

## Extra Attention Areas

- execution timeout
- alerting hooks or email notification
- SLA or latency expectations for important workflows

## Definition Of Done

This topic is complete if you can:

- inspect task states and DAG run states confidently
- find the right logs for a failed task
- explain how retries appear operationally in the UI
- write a short operational diagnosis for one failed run