# 💻 Virtualization & The AWS Nitro System

Virtualization is the core technology that allows Cloud Computing to exist. It enables multiple "Virtual Machines" (VMs) to run on a single physical server, sharing CPU, RAM, and storage.

## 📋 Table of Contents

1. [What is Virtualization?](#1-what-is-virtualization)
2. [Hypervisors (Type 1 vs Type 2)](#2-hypervisors)
3. [AWS Nitro System](#3-aws-nitro-system)
4. [Exam Cheat Sheet](#4-exam-cheat-sheet)

---

## 1. What is Virtualization?

It is the process of creating a software-based (virtual) representation of something, such as:

- **Server Virtualization**: Running multiple OS instances (Linux, Windows) on one physical server.
- **Network Virtualization**: VPCs, Subnets (Software Defined Networking).
- **Storage Virtualization**: EBS Volumes, S3 Buckets.

**Benefit**: Maximizes hardware utilization and isolates workloads.

---

## 2. Hypervisors

The **Hypervisor** (or VMM - Virtual Machine Monitor) is the software layer that sits between the hardware and the virtual machines.

| Type                    | Description                                | Performance                | Example                            |
| :---------------------- | :----------------------------------------- | :------------------------- | :--------------------------------- |
| **Type 1 (Bare Metal)** | Installs directly on hardware. No host OS. | **Highest** (Low overhead) | **AWS EC2 (Xen/KVM)**, VMware ESXi |
| **Type 2 (Hosted)**     | Installs as an app on an OS (Windows/Mac). | Lower (High overhead)      | VirtualBox, VMware Workstation     |

---

## 3. AWS Nitro System

Modern EC2 instances use the **AWS Nitro System**, which offloads virtualization functions to dedicated hardware.

### Key Components:

1.  **Nitro Card**: Dedicated hardware for **Networking** (VPC) and **Storage** (EBS).
2.  **Nitro Security Chip**: Integrated into the motherboard. Protects hardware resources and validates firmware.
3.  **Nitro Hypervisor**: A lightweight hypervisor that manages memory and CPU allocation with "bare metal" like performance.

**Outcome**: You get nearly 100% of the server's performance because the virtualization tax is handled by the Nitro Cards.

---

## 4. Exam Cheat Sheet

- **Bare Metal Performance**: "Need direct access to processor and memory" -> **EC2 Bare Metal** or **Nitro System**.
- **Isolation**: Virtual Machines (EC2) provide strong isolation via the Hypervisor compared to Containers (Docker).
- **Nitro System**: "Next generation EC2 underlying platform" -> Offloads Network/Storage/Security to dedicated hardware.
