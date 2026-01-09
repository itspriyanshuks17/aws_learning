# ⚖️ Load Balancers (ELB)

Elastic Load Balancing (ELB) automatically **distributes incoming application traffic across multiple targets**, such as EC2 instances, containers, and IP addresses.

## 📋 Table of Contents

1. [Types of Load Balancers](#1-types-of-load-balancers)
2. [Application Load Balancer (ALB)](#2-application-load-balancer-alb)
3. [Network Load Balancer (NLB)](#3-network-load-balancer-nlb)
4. [Gateway Load Balancer (GWLB)](#4-gateway-load-balancer-gwlb)
5. [Key Concepts](#5-key-concepts)
6. [Exam Cheat Sheet](#6-exam-cheat-sheet)

---

## 1. Types of Load Balancers

AWS offers 4 types of load balancers:

| Feature      | **ALB** (Application)        | **NLB** (Network)                            | **GWLB** (Gateway)             | **CLB** (Classic) |
| :----------- | :--------------------------- | :------------------------------------------- | :----------------------------- | :---------------- |
| **Layer**    | Layer 7 (HTTP/HTTPS)         | Layer 4 (TCP/UDP)                            | Layer 3 (IP)                   | Layer 4 & 7       |
| **Speed**    | Slow (Application awareness) | **Ultra High Performance** (Millions of RPS) | High                           | Slower            |
| **IP Type**  | Dynamic IPs                  | **Static IPs** (Elastic IP)                  | Private                        | Dynamic           |
| **Use Case** | Web Apps, Microservices      | Gaming, High Frequency Trading               | Firewalls, Intrusion Detection | Legacy Apps       |

---

## 2. Application Load Balancer (ALB)

- **Layer 7**: Understands HTTP/HTTPS.
- **Routing Rules**:
  - **Path-based**: `/images` -> ImageService, `/api` -> ApiService.
  - **Host-based**: `api.example.com` -> ApiService, `web.example.com` -> WebService.
  - **Query String**: `?id=123` -> Specific Target Group.
- **Container Support**: Integrates perfectly with **ECS** (Dynamic Port Mapping).

### Architecture Diagram (ALB)

Layer 7 Routing based on content.

```text
       [ User ]
           |
      ( HTTPS )
           v
+-----------------------+
| Application Load Balancer |  <-- Listeners (Port 80/443)
+-----------+-----------+
            | /api
            v
   [ Target Group: API ]
      |           |
   [ EC2 ]     [ EC2 ]
```

---

## 3. Network Load Balancer (NLB)

- **Layer 4**: Understands TCP / UDP.
- **Performance**: Capable of handling **millions of requests per second** with ultra-low latency.
- **Static IP**: Has 1 static IP per AZ (useful for whitelisting).
- **Health Checks**: Supports TCP, HTTP, HTTPS health checks.

### Architecture Diagram (NLB)

Layer 4 Pass-through for High Performance.

```text
      [ Gamer ]
          |
       ( TCP )
          v
+-----------------------+
| Network Load Balancer |  <-- Static IP per AZ
+-----------+-----------+
            |
            v
   [ Target Group: Game ]
      |           |
   [ EC2 ]     [ EC2 ]
```

---

## 4. Gateway Load Balancer (GWLB)

- **Layer 3**: Operates at the Network Layer.
- **Purpose**: Deploy, scale, and manage 3rd party virtual appliances (Firewalls, IDS/IPS, Deep Packet Inspection).
- **GENEVE Protocol**: Uses port 6081 to encapsulate traffic.

---

## 5. Key Concepts

### Sticky Sessions (Session Affinity)

- **ALB**: Uses a cookie (`AWSALB`) to lock a client to a specific backend instance.
- **Use Case**: Valid for Stateful apps, but discouraged for modern stateless apps.

### Cross-Zone Load Balancing

- **Enabled (ALB Default)**: Traffic is distributed evenly across ALL instances in ALL AZs.
- **Disabled (NLB Default)**: Traffic is distributed only to instances in the _same_ AZ as the Load Balancer node. (If AZ-A has 10 instances and AZ-B has 1, disabled means AZ-B gets overloaded).

### Connection Draining (Deregistration Delay)

- Time to wait for in-flight requests to complete before terminating an instance (e.g., during scaling down). Usually 300 seconds.

---

## 6. Exam Cheat Sheet

- **High Performance / Static IP**: "Need a load balancer with a static IP and millions of requests per second" -> **NLB**.
- **Path Routing / Usage Microservices**: "Route traffic based on URL path" -> **ALB**.
- **Firewalls / Inspection**: "Deploy a fleet of firewalls" -> **GWLB**.
- **Legacy**: "EC2-Classic" -> **CLB** (Rarely the answer unless specifically "Classic").
- **X-Forwarded-For**: "Need the client's original IP address in the backend logs" -> Look at the **X-Forwarded-For** header.
