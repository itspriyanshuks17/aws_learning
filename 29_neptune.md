# 🔱 Amazon Neptune - Deep Dive

Amazon Neptune is a **fast, reliable, fully managed** **graph database** service that makes it **easy to build and run applications** that work with highly connected datasets.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Query Languages (Gremlin vs SPARQL)](#2-query-languages-gremlin-vs-sparql)
3. [Architecture &amp; Availability](#3-architecture--availability)
4. [Use Cases](#4-use-cases)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Core Concepts

Unlike Relational (SQL) databases that **use tables, or Key-Value** (DynamoDB) stores, Neptune uses a **Graph** structure.

### Components

- **Nodes (Vertices)**: The entities (e.g., "Alice", "Bob", "Product X").
- **Edges**: The relationships between nodes (e.g., "Alice" -> _knows_ -> "Bob").
- **Properties**: Information about nodes or edges (e.g., Alice's age is 30).

### Visual Representation

```
   [ Alice ] ---- (knows) ----> [ Bob ]
      |                            |
   (purchased)                  (purchased)
      |                            |
      v                            v
 [ iPhone 15 ]                 [ iPad ]
```

- **Goal**: Find common purchases, friends of friends, etc. extremely fast.

![Neptune Graph](./images/neptune.png)

---

## 2. Query Languages (Gremlin vs SPARQL)

Neptune supports two open standards. You pick one based on your data model.

| Feature      | Gremlin (Apache TinkerPop)                     | SPARQL (RDF)                                                         |
| :----------- | :--------------------------------------------- | :------------------------------------------------------------------- |
| **Model**    | **Property Graph**                             | **Resource Description Framework (RDF)**                             |
| **Style**    | Imperative Traversal (Step-by-step navigation) | Declarative (SQL-like pattern matching)                              |
| **Use Case** | Social networks, Maps, Recommendation engines  | Knowledge graphs, Semantic web, Scientific data                      |
| **Example**  | `g.V('Alice').out('knows').values('name')`     | `SELECT ?name WHERE { :Alice :knows ?friend . ?friend :name ?name }` |

---

## 3. Architecture & Availability

Neptune is built on the shared storage layer similar to **Amazon Aurora**.

- **Storage**: 6 copies of data across 3 Availability Zones (AZs).
- **Self-Healing**: Automatically detects and repairs bad disk segments.
- **Replicas**: Supports up to 15 Read Replicas (Milliscond latency).
- **Multi-AZ**: Automatic failover to a Read Replica if the Primary fails.
- **Encryption**: Encryption at rest (KMS) and in-transit (TLS/SSL).

---

## 4. Use Cases

1. **Social Networking**: "Find friends of friends who live in NYC and like Jazz".
   - _Why_: SQL `JOIN` operations for this are slow and complex. Graph traversals are instant.
2. **Recommendation Engines**: "Customers who bought this also bought..."
3. **Fraud Detection**: "Is this credit card linked to a device that was used in a previous crime?" (Relationship analysis).
4. **Knowledge Graphs**: Storing complex, interlinked information (e.g., Wikipedia structure).

---

## 5. Exam Cheat Sheet

- **Highly Connected Data**: Keywords "Social Graph", "Knowledge Graph", "Relationships", "Highly Connected" -> **Neptune**.
- **Query Languages**: "Gremlin" or "SPARQL" -> **Neptune**.
- **Properties**: "Property Graph" -> **Neptune**.
- **Availability**: "Multi-AZ with up to 15 Read Replicas" -> Shared architecture with **Aurora**.
- **S3**: Using `Neptune Loader` to bulk load data from S3 is the fastest way to get data in.
