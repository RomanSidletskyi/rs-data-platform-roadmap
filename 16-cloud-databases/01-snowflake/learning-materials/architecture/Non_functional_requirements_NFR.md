# Non-Functional Requirements (NFR) — Data Platform (Senior Cheat Sheet)

## 1. What are NFR?

Non-Functional Requirements define how the system behaves, not what it does.

They cover:
- performance
- scalability
- reliability
- availability
- cost
- security
- observability
- maintainability

### Interview answer

> Functional requirements define what the system should do, while non-functional requirements define how well it should do it — including performance, reliability, scalability, and cost.

---

## 2. Key NFR Categories for Data Platforms

### 1. Latency

How fast data becomes available.

Examples:
- real-time: seconds
- near-real-time: minutes
- batch: hourly/daily

### 2. Throughput

How much data system can handle.

Examples:
- 1B events/day
- MB/s or GB/hour ingestion

### 3. Scalability

Ability to handle growth:
- more data
- more users
- more queries

### 4. Reliability

System correctness under failures:
- no data loss
- correct processing
- retry safety

### 5. Availability

System uptime:
- 99.9%
- 99.99%

### 6. Cost Efficiency

Cost per:
- query
- TB processed
- pipeline

### 7. Observability

Ability to detect and debug issues:
- logs
- metrics
- alerts

### 8. Data Quality

- accuracy
- completeness
- consistency

### 9. Security

- access control
- encryption
- data governance

### 10. Maintainability

- ease of changes
- onboarding new pipelines
- debugging

---

## 3. NFR in System Design Answer

Strong senior answer ALWAYS includes NFR.

Example:

> From a non-functional perspective, I would define SLAs for latency, design for replayability to ensure reliability, separate workloads to control cost, and build observability across ingestion and transformation layers.

---

## 4. Latency vs Cost Trade-off

### Key rule

    Lower latency = higher cost

### Example

- streaming →