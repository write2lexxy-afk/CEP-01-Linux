
# CEP-01 — Linux Processes & Services

## 1. Overview

Linux services are implemented through processes. On Ubuntu, `systemd` is the primary service manager and runs as PID 1.

The relationship observed during this project is:

```text
systemd (PID 1)
    |
    +-- Service
          |
          +-- Process(es)
