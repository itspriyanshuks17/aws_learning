# 📒 Amazon QLDB (Quantum Ledger Database) - Deep Dive

Amazon QLDB is a fully managed **Ledger Database** that **provides a transparent, immutable**, and **cryptographically verifiable transaction log**.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [How it Works (The Journal)](#2-how-it-works-the-journal)
3. [QLDB vs Managed Blockchain](#3-qldb-vs-managed-blockchain)
4. [Use Cases](#4-use-cases)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Core Concepts

In normal databases (RDS/DynamoDB), if you update a record, the old value is overwritten. You might have an audit log, but that log _can_ be modified by an admin.

**QLDB is different:**

- **Immutable**: Data can **never** be deleted or modified. Updates create a new version, but the history is permanent.
- **Verifiable**: Uses cryptography (SHA-256) to prove that data hasn't been tampered with.
- **Centralized**: Unlike Blockchain, it is owned by a **single central authority** (AWS Account Owner).

---

## 2. How it Works (The Journal)

The core of QLDB is the **Journal**.

1. **Current State**: What the data looks like _now_.
2. **History**: Every previous version of the data.
3. **Journal**: An append-only log of every transaction.

### Workflow

```
[ Transaction ] --> [ Journal (Append Only) ] --> [ Current State (View) ]
                          |
                          +--> [ History (View) ]
```

- You query data using **PartiQL** (a SQL-compatible query language).

---

## 3. QLDB vs Managed Blockchain

This is a classic exam confusion point.

| Feature             | Amazon QLDB                          | Amazon Managed Blockchain                           |
| :------------------ | :----------------------------------- | :-------------------------------------------------- |
| **Authority** | **Centralized** (Owned by you) | **Decentralized** (Owned by multiple parties) |
| **Trust**     | You trust yourself (internal audit)  | You don't trust other members completely            |
| **Speed**     | Faster (2-3x blockchain)             | Slower (Consensus required)                         |
| **Use Case**  | DMV Records, Supply Chain (Internal) | Financial Consortium, Supply Chain (Multi-Org)      |

---

## 4. Use Cases

1. **Finance**: Banking transactions where you need a permanent, unchangeable history of every debit and credit.
2. **Supply Chain**: Tracking an item's movement from factory to warehouse. If "Status" changes to "Delivered", the "In-Transit" record is preserved forever.
3. **HR & Payroll**: Employee salary history. You cannot "accidentally" delete a raise history.
4. **DMV / Vehicle Registration**: A car's history of ownership.

---

## 5. Exam Cheat Sheet

- **Immutable / Verifiable**: Keywords "Immutable", "Cryptographically Verifiable", "Transparent history" -> **QLDB**.
- **Centralized Authority**: If the question says "Centralized" or "Trusted Authority" -> **QLDB**.
- **Decentralized**: If the question says "Multiple parties who do not trust each other" -> **Managed Blockchain**.
- **No Overwrites**: QLDB does not support in-place updates. It always appends a new version.
