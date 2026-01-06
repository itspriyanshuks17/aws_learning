# 🧠 Amazon Comprehend - Deep Dive

Amazon Comprehend is a **Natural Language Processing (NLP)** service that uses **machine learning to find insights and relationships in text**. It's **fully managed**, so there are **no servers to provision**.

## 📋 Table of Contents

1. [Core Capabilities](#1-core-capabilities)
2. [Common Use Cases](#2-common-use-cases)
3. [Architecture Pattern](#3-architecture-pattern)
4. [Exam Cheat Sheet](#4-exam-cheat-sheet)

---

## 1. Core Capabilities

- **Sentiment Analysis**: Determines if text is Positive, Negative, Neutral, or Mixed.
- **Entity Recognition**: Detects people, places, brands, dates, etc. (e.g., "Jeff Bezos", "Seattle", "Amazon").
- **Key Phrase Extraction**: Identifies key talking points (e.g., "amazing customer service", "slow delivery").
- **Language Identification**: Detects the dominant language (100+ languages).
- **PII Detection**: Identifies Personally Identifiable Information (Name, Address, Credit Card) to help with compliance/redaction.
- **Topic Modeling**: Organizes a large collection of text documents into clusters of similar topics (uses unsupervised learning).

---

## 2. Common Use Cases

1. **Voice of Customer (VoC)**:
   - Analyze product reviews or social media mentions to track brand sentiment.
2. **Compliance & Redaction**:
   - Scan support tickets or emails for sensitive PII data before archiving.
3. **Document Classification**:
   - Automatically tag and route support tickets to the right team (e.g., "Billing" vs "Technical Support") using Custom Classification.

---

## 3. Architecture Pattern

Social Media Sentiment Analysis Pipeline.

```text
[ Social Media Feed ] --> [ Kinesis Data Firehose ] --> [ S3 Bucket (Raw) ]
                                                               |
                                                           (Trigger)
                                                               v
                                                       [ Lambda Function ] --(Call)--> [ Amazon Comprehend ]
                                                               |
                                                        (Save Results)
                                                               |
        [ QuickSight Dashboard ] <--(Visualize)-- [ Amazon Athena ] <--(Query)-- [ S3 Bucket (Enriched) ]
```

---

## 4. Exam Cheat Sheet

- **NLP**: "Extract insights from text" -> **Amazon Comprehend**.
- **PII**: "Redact SSN/Credit Card numbers from documents" -> **Comprehend PII Detection**.
- **Topic Modeling**: "Group a large set of documents by subject" -> **Comprehend Topic Modeling**.
- **Sentiment**: "Determine if customer reviews are positive or negative" -> **Comprehend Sentiment Analysis**.
