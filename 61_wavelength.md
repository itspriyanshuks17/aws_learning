# 📡 AWS Wavelength - Deep Dive

AWS Wavelength extends AWS infrastructure to the **edge of 5G networks**, embedding AWS **compute and storage inside telecommunication** providers' data centers.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Architecture &amp; Traffic Flow](#2-architecture--traffic-flow)
3. [Use Cases](#3-use-cases)
4. [Wavelength Zone vs Local Zone vs Outposts](#4-wavelength-zone-vs-local-zone-vs-outposts)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Core Concepts

- **Mobile Edge Computing (MEC)**: Puts AWS services (EC2, ECS, EKS) physically closer to mobile users (inside the Carrier's network).
- **Carrier Gateway**: A new resource type acting like an Internet Gateway (IGW) but for the Carrier network.
- **Wavelength Zone**: An isolated zone embedded in a carrier's data center (e.g., Verizon in NYC, Vodafone in London).

---

## 2.Architecture & Traffic Flow

Normally, mobile traffic has to go from:
`Phone -> Cell Tower -> Carrier Core -> Internet -> AWS Region and back.`

With Wavelength, traffic goes:
`Phone -> Cell Tower -> Wavelength Zone (AWS Compute).`

- Traffic **never leaves the Carrier network**.
- This removes the latency of hopping over the public internet.

```text
       [ 5G Mobile User ]
             |
             v
      [ Cell Tower ]
             |
             v
+-------------------------+
| Carrier Network (ISP)   |
|                         |
|  [ AWS Wavelength Zone ]| <---(Linked to Region)--- [ AWS Region ]
|  (EC2 / EKS Running)    |
|                         |
+-------------------------+
```

## 3. Use Cases

1. **Industrial Automation**: Smart factories using 5G robots.
2. **Autonomous Vehicles**: Real-time logic for self-driving cars.
3. **AR/VR**: Rendering high-fidelity graphics for mobile VR headsets.
4. **Live Video Streaming**: Real-time video analytics at the edge.

---

## 4. Wavelength Zone vs Local Zone vs Outposts

| Feature                | Wavelength Zone                               | Local Zone                                 | Outposts                               |
| :--------------------- | :-------------------------------------------- | :----------------------------------------- | :------------------------------------- |
| **Location**     | Inside**5G Carrier** DC (Verizon, etc.) | Specific**City** (LA, Houston, etc.) | **Your** On-Premise Data Center. |
| **Connectivity** | 5G Network.                                   | AWS Backbone / Internet.                   | Your Local Network.                    |
| **Use Case**     | **Mobile** Ultra-Low Latency.           | **General** Ultra-Low Latency.       | **Private** Data Residency.      |

---

## 5. Exam Cheat Sheet

- **5G / Mobile**: "Ultra-low latency application for 5G mobile users" -> **AWS Wavelength**.
- **Carrier Gateway**: "Component required to connect VPC to carrier network" -> **Carrier Gateway**.
- **Parent Region**: Wavelength Zones are tied to a parent AWS Region (e.g., us-east-1).
- **Not Global**: Available only with specific partners in specific cities.
