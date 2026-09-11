# MariaDB Galera to Percona XtraDB Cluster — Data Validation

**Project:** DEV-815 — Data Validation
**Author:** Thanusha Bai
**Department:** DevOps
**Date:** 11 September 2026

---

## Overview

This repository contains the data validation plan and lab exercise for the
MariaDB Galera to Percona XtraDB Cluster (PXC) migration project. The goal
of this validation work is to prove that data migrated from the source
cluster to the target cluster is identical, with no rows lost and no values
changed.

Two complementary validation methods are used:

- **Row count validation** — a quick sanity check that catches missing or
  extra rows and entire tables that failed to migrate.
- **Checksum validation** — a deeper check that computes a fingerprint of
  the actual data and catches silent corruption that row counts cannot see.

---

## Repository Structure
Mariadb-to-pxc-data-validation/
│
├── docs/
│ └── DEV-815-Data_Validation_Report.pdf # Full validation report
│
├── evidence/
│ └── validation-output.txt # Raw terminal output from lab
│
├── screenshots/
│ ├── 01-containers-running.png
│ ├── 02-row-count-mismatch.png
│ ├── 03-checksum-mismatch.png
│ └── 04-checksum-match-after-fix.png
│
├── scripts/
│ ├── setup-lab.sh # Starts two MySQL containers
│ ├── row-count-validation.sh # Compares row counts
│ ├── checksum-validation.sh # Compares MD5 checksums
│ └── cleanup-lab.sh # Removes lab containers
│
└── README.md

text

---

## Prerequisites

- Linux VM with Docker installed
- `sudo` access (or user added to the `docker` group)
- Basic familiarity with the MySQL command line

---

## How to Reproduce the Lab

The lab uses two separate MySQL 8.0 containers — one acting as the source
(standing in for MariaDB Galera) and one as the target (standing in for PXC).

### Step 1 — Start the lab

```bash
bash scripts/setup-lab.sh
This starts both containers, waits for MySQL to initialize, and creates a
sample users table. The source is given 2 rows and the target is
deliberately given 3 rows to simulate a migration mismatch.

Step 2 — Run row count validation
bash
bash scripts/row-count-validation.sh
Expected output: source shows 2 rows, target shows 3 rows — a mismatch.

Step 3 — Run checksum validation
bash
bash scripts/checksum-validation.sh
Expected output: source and target produce different MD5 hashes, confirming
the data content differs.

Step 4 — Correct the data and re-validate
Insert the missing row into the source, then re-run the checksum script.
The two hashes should now be identical.

Step 5 — Clean up
bash
bash scripts/cleanup-lab.sh
Validation Results Summary
Stage	Row Count (Source vs Target)	Checksum Match
Initial	2 vs 3 — mismatch	No
After fix	3 vs 3 — match	Yes
The full analysis, reasoning, and production recommendations are in the
report at docs/DEV-815-Data_Validation_Report.pdf.

Key Learnings
Row counts answer "is everything here?" — checksums answer "is everything correct?"

A matching hash is a mathematical guarantee that the underlying bytes are identical.

Tables without primary keys cannot be checksummed by pt-table-checksum
and require a manual validation plan.

In production, pt-table-checksum replaces manual MD5 checksums because
it chunks tables, respects load limits, and is cluster-aware.

The source cluster must stay alive until the target passes validation, so
there is always a way back.

Evidence
Screenshots in screenshots/ capture each validation step from the terminal.
Raw output is stored in evidence/validation-output.txt as an audit trail.

References
Percona Toolkit — pt-table-checksum

Percona XtraDB Cluster documentation

MySQL 8.0 reference manual

End of README