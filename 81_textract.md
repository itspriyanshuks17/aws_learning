# 📄 Amazon Textract - Deep Dive

Amazon Textract is a machine learning service that automatically **extracts text, handwriting, and data** (forms and tables) from scanned documents. It goes beyond simple OCR (**Optical Character Recognition**) by understanding the structure of the document.

## 📋 Table of Contents

1. [Core Capabilities](#1-core-capabilities)
2. [Use Cases &amp; Features](#2-use-cases--features)
3. [Architecture Pattern](#3-architecture-pattern)
4. [Exam Cheat Sheet](#4-exam-cheat-sheet)

---

## 1. Core Capabilities

- **Extract Text**: Detects lines and words from documents (standard OCR).
- **Extract Handwriting**: Can read handwritten text from medical notes, applications, etc.
- **Extract Forms**: Identifies key-value pairs (e.g., "Name: John Doe").
- **Extract Tables**: Preserves the structure of tables (rows and columns) for easy export to CSV/Excel.

---

## 2. Use Cases & Features

- **AnalyzeExpense**: API specialized for invoices and receipts (extracts vendor, date, total amount, taxes).
- **AnalyzeID**: API specialized for identity documents (Passports, Driver's Licenses) to extract Name, DOB, Expiry.
- **Queries**: You can ask questions about the document in natural language (e.g., "What is the patient's name?") and Textract will find the answer.

---

## 3. Architecture Pattern

Automated Expense Processing.

```text
[ User Uploads Receipt ] --> [ S3 Bucket ]
                                  |
                              (Trigger)
                                  v
                          [ Lambda Function ] --(Call)--> [ Amazon Textract (AnalyzeExpense) ]
                                  |
                           (Save Data)
                                  |
                                  v
                            [ DynamoDB ]
```

## 4. Exam Cheat Sheet

- **OCR + Structure**: "Extract text AND table structure/forms" -> **Amazon Textract**.
- **Receipts/Invoices**: "Process financial documents" -> **Textract AnalyzeExpense**.
- **Identity Verification**: "Extract info from Passports/IDs" -> **Textract AnalyzeID**.
- **V/s Rekognition**:
  - **Textract**: Documents, Forms, Tables, Dense text.
  - **Rekognition**: Text in natural scenes (e.g., street signs, license plates on cars).
