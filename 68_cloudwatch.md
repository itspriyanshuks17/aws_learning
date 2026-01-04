# ⏲️ Amazon CloudWatch & EventBridge

Amazon CloudWatch is a **monitoring and observability service**. It provides **data and actionable insights to monitor** your **applications**, **respond to system-wide performance changes**, and **optimize resource utilization**.

## 📋 Table of Contents

1. [CloudWatch Metrics](#1-cloudwatch-metrics)
2. [CloudWatch Alarms](#2-cloudwatch-alarms)
3. [CloudWatch Logs](#3-cloudwatch-logs)
4. [Amazon EventBridge (formerly CloudWatch Events)](#4-amazon-eventbridge)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. CloudWatch Metrics

Metrics are the fundamental concept in CloudWatch. A metric represents a time-ordered set of data points.

- **Namespace**: A container for CloudWatch metrics (e.g., `AWS/EC2`).
- **Dimension**: A name/value pair that uniquely identifies a metric (e.g., `InstanceId`).
- **Resolution**:
  - **Standard**: 1 minute (default).
  - **High Resolution**: 1 second (extra cost).

---

## 2. CloudWatch Alarms

Alarms are used to trigger notifications for any metric.

- **States**:
  - `OK`: Metric is within defined threshold.
  - `ALARM`: Metric is outside defined threshold (e.g., CPU > 80%).
  - `INSUFFICIENT_DATA`: Not enough data to determine state.
- **Targets**:
  - **SNS**: Send email/SMS.
  - **Auto Scaling**: Scale out/in EC2 instances.
  - **EC2 Action**: Stop/Terminate/Reboot instance.

---

## 3. CloudWatch Logs

Store, monitor, and access log files from EC2 instances, CloudTrail, Route 53, etc.

- **Log Group**: A group of log streams (e.g., `MyApp/Production`).
- **Log Stream**: A sequence of log events from a specific source (e.g., `Instance-A`).
- **Metric Filter**: Can search logs for keywords (e.g., "Error") and turn them into a Metric (e.g., `ErrorCount`).
- **Agent**: You must install the **CloudWatch Agent** on EC2 to send OS-level logs (RAM usage, Disk space). By default, CloudWatch only sees "Hypervisor" metrics (CPU, Network, Disk I/O).

## 4. Amazon EventBridge

Formerly "CloudWatch Events". Serverless event bus to connect applications.

1. **Schedule (Cron)**: Trigger a Lambda function every hour.
2. **Pattern Matching**: Trigger when a specific event happens (e.g., "EC2 Instance State changes to Stopped").
   - **Target**: Lambda, SNS, SQS, Kinesis, Step Functions.

```text
[ EC2 Instance ] --(State Change)--> [ EventBridge ] --(Trigger Rule)--> [ Lambda Function ]
                                                                        (Fix Issue)
```

---

## 5. Exam Cheat Sheet

- **RAM/Disk Usage**: "Monitor memory usage on EC2" -> Install **CloudWatch Unified Agent** (Custom Metric).
- **High Resolution**: "Need sub-minute monitoring" -> **High Resolution Custom Metric** (1 sec).
- **Cron Job**: "Run a script every Monday at 8 AM" -> **EventBridge Schedule**.
- **Real-time Response**: "Trigger Lambda when Root user logs in" -> **EventBridge Rule** (via CloudTrail).
