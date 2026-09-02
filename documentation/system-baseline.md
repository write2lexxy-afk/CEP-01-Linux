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

The following commands were used to collect the initial system information:

```bash
hostnamectl
uname -a
lsb_release -a


## CPU and Memory

### CPU

The system is equipped with an Intel Core i5-6300U processor with two physical cores and four logical CPUs.

CPU virtualization support is provided through Intel VT-x.

### Memory

The system has approximately 7.6 GiB of RAM and 4.0 GiB of swap space.

At the time of baseline collection, approximately 7.0 GiB of RAM was available and swap usage was 0 B.

## Storage

The root filesystem is provided through an LVM logical volume.

| Filesystem | Size | Used | Available | Usage |
|---|---:|---:|---:|---:|
| Root (`/`) | 98 GB | 16 GB | 78 GB | 17% |

Additional boot filesystems are present for `/boot` and `/boot/efi`.

## Network Configuration

The system has three primary network interfaces:

| Interface | Type | Status |
|---|---|---|
| `lo` | Loopback | UP |
| `enp0s31f6` | Ethernet | DOWN / no carrier |
| `wlp2s0` | Wi-Fi | UP |

The active network connection uses the Wi-Fi interface.

The system receives its network configuration through DHCP and uses a default gateway on the local network.

## Routing

The routing table contains:

- A default route through the local gateway using `wlp2s0`.
- A directly connected `/24` route for the local network.

## Baseline Commands

The following commands were used to collect the system resource and network information:

```bash
lscpu
free -h
df -h
ip addr
ip route
