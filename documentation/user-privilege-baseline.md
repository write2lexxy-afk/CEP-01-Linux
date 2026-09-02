# CEP-01 Linux — User & Privilege Baseline

## Purpose

This document records the initial user account and privilege configuration of the CEP-01 Linux system.

## Current User

| Item | Value |
|---|---|
| Username | lexxy |
| UID | 1000 |
| Primary Group | CEP |
| GID | 1000 |

## Group Membership

The current user belongs to the following groups:

- CEP
- adm
- cdrom
- sudo
- dip
- plugdev
- lxd

## Sudo Privileges

The `sudo -l` command confirms that the `lexxy` account has full sudo authorization:

```text
(ALL : ALL) ALL
