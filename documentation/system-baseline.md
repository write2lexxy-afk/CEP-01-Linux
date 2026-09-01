# CEP-01 Linux — System Baseline

## Purpose

This document records the initial system baseline for CEP-01-Linux before configuration and security changes are performed.

## System Information

| Item | Value |
|---|---|
| Hostname | dualnet |
| Operating System | Ubuntu 24.04.4 LTS |
| Release | 24.04 |
| Codename | noble |
| Kernel | 6.8.0-137-generic |
| Architecture | x86_64 |
| Hardware Vendor | HP |
| Hardware Model | HP EliteBook 840 G3 |

## Baseline Commands

The following commands were used to collect the baseline information:

```bash
hostnamectl
uname -a
lsb_release -a
