# CEP-01 — Linux Service Troubleshooting

## Overview

When a Linux service fails or behaves unexpectedly, logs provide important information about what happened.

For systemd-managed services, `journalctl` can be used to inspect service logs.

---

## Viewing Service Logs

```bash
journalctl -u apache2
