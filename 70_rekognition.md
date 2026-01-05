# 👁️ Amazon Rekognition - Deep Dive

Amazon Rekognition is a fully managed **machine learning service** that automates image and video analysis. You don't need to know anything about machine learning to use it.

## 📋 Table of Contents

1. [Core Capabilities](#1-core-capabilities)
2. [Common Use Cases](#2-common-use-cases)
3. [Architecture Pattern](#3-architecture-pattern)
4. [Exam Cheat Sheet](#4-exam-cheat-sheet)

---

## 1. Core Capabilities

Rekognition can identify objects, people, text, scenes, and activities in images and videos.

- **Object & Scene Detection**: "This image contains a generic 'Dog', 'Beach', and 'Ball'".
- **Facial Analysis**: Detects faces and attributes (Smile, Eyes Open, Age Range, Emotion). _Does not identify WHO it is, just features._
- **Face Comparison**: Compares a face in an input image with a face in a target image (Verification).
- **Facial Recognition**: Searches a face against a collection of stored faces (Identification).
- **Content Moderation**: Detects unsafe, offensive, or inappropriate content (Nudity, Violence).
- **Text in Image (OCR)**: Detects and reads text in images (e.g., license plates, street signs).

---

## 2. Common Use Cases

1.  **Identity Verification (KYC)**:
    - Compare a user's "Selfie" with their "Government ID" photo to verify identity during signup.
2.  **Content Moderation**:
    - Automatically flag or blur offensive user-uploaded photos in a social media app.
3.  **Media Analysis**:
    - Search a video archive for "files containing Jeff Bezos" or "scenes with a Ferrari".

---

## 3. Architecture Pattern

A common pattern is automatically analyzing images uploaded to S3.

```text
[ User ] --(Upload Image)--> [ S3 Bucket ]
                                  |
                             (Trigger)
                                  v
                          [ Lambda Function ] --(API Call)--> [ Amazon Rekognition ]
                                  |                                   |
                          (Update Metadata)                      (JSON Result)
                                  v                                   |
                            [ DynamoDB ] <----------------------------+
```

1.  User uploads photo to **S3**.
2.  S3 triggers a **Lambda** function.
3.  Lambda sends the image to **Rekognition** API.
4.  Rekognition returns tags (e.g., "Cat: 99%").
5.  Lambda saves these tags to **DynamoDB** so the image becomes searchable.

---

## 4. Exam Cheat Sheet

- **Content Moderation**: "Need to block inappropriate content from user uploads" -> **Rekognition Content Moderation**.
- **Text Detection**: "Read license plates from car images" -> **Rekognition Text in Image**.
- **Video Analysis**: "Real-time analysis of streaming video" -> **Rekognition Video** (can use Kinesis Video Streams).
- **Not for OCR Documents**: If you need to read Scanned Documents (Invoices, PDFs) with tables/forms, use **Amazon Textract**, NOT Rekognition.
