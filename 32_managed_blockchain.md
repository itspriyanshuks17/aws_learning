# ⛓️ Amazon Managed Blockchain - Deep Dive

Amazon Managed Blockchain is a ***fully managed service*** that makes it easy ***to create and manage scalable blockchain networks*** using popular ***open-source frameworks***.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Supported Frameworks](#2-supported-frameworks)
3. [Architecture Components](#3-architecture-components)
4. [Use Cases](#4-use-cases)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Core Concepts

Unlike QLDB (Centralized), Managed Blockchain is **Decentralized**.

- **Decentralized Trust**: *Allows multiple parties* (who do not trust each other) to *execute transactions* *without a central authority*.
- **Distributed Ledger**: Every member in the network has a copy of the ledger.
- **Consensus**: All nodes must agree on the validity of a transaction before it is added.

---

## 2. Supported Frameworks

Amazon Managed Blockchain supports two major frameworks:

### A. Hyperledger Fabric

- **Type**: **Private** / Permissioned Network.
- **Access**: Known members only. You invite specific companies (e.g., a banking consortium).
- **Features**: Fine-grained permissions, high privacy.
- **Use Case**: Supply Chain among specific partners, Banking settlements.

### B. Ethereum

- **Type**: **Public** (or Private) Network.
- **Access**: Anyone can join (Public Mainnet) or restricted (Private).
- **Features**: Smart Contracts (Solidity), Crypto-currency friendly (ETH).
- **Use Case**: NFT Marketplaces, Decentralized Finance (DeFi).

---

## 3. Architecture Components

When you create a network (specifically Hyperledger Fabric), you deal with these components:

1. **Network**: The overall blockchain infrastructure.
2. **Member**: Make up the network. Each "Member" is a unique AWS account (organization).
3. **Peer Node**: The servers that run the code and store the ledger copy for a Member.
4. **Ordering Service**: Ensures transactions are ordered correctly before being committed.

### Workflow

```
[ Member A (Bank) ]      [ Member B (Retailer) ]
      |                          |
 [ Peer Node 1 ]          [ Peer Node 2 ]
      |                          |
      +----------+---------------+
                 | (Hyp. Fabric)
         [ Ordering Service ]
                 |
        [ Shared Blockchain ]
```

---

## 4. Use Cases

1. **Trading Consortium**: A group of banks want to settle trades instantly without a clearing house (middleman).
2. **Supply Chain**: Tracking a diamond from mine to store. Multiple companies (Mine, Shipper, Cutter, Store) all write to the same chain.
3. **Retail Rewards**: A decentralized loyalty program shared across different airlines and hotels.

---

## 5. Exam Cheat Sheet

- **Decentralized**: Keywords "Decentralized", "No central authority", "Multiple parties" -> **Managed Blockchain**.
- **Hyperledger Fabric**: "Private network", "Known members", "Permissioned" -> **Hyperledger Fabric**.
- **Ethereum**: "Public network", "Smart Contracts", "Solidty" -> **Ethereum**.
- **Vs QLDB**:
  - **QLDB**: I own it, I trust myself, I want a history.
  - **Blockchain**: We (group) own it, We don't trust each other, We need consensus.
