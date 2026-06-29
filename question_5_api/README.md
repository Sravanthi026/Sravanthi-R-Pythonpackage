# Question 5: Clinical Data API (FastAPI)

## Overview
Build a RESTful API for clinical trial adverse event data with dynamic filtering and patient risk assessment.

## Input Data
Uses `adae.csv` exported from Question 4 analysis (`pharmaverseadam::adae`)

## Endpoints

### 1. GET /
Welcome endpoint
- Response: `{"message": "Clinical Trial Data API is running"}`

### 2. POST /ae-query
Query adverse events with optional filters
- **Input**: 
  ```json
  {
    "severity": ["MILD", "MODERATE"],
    "treatment_arm": "Placebo"
  }
  ```
- **Output**:
  ```json
  {
    "query": {...},
    "count": 42,
    "unique_subjects": 15,
    "subjects": ["01-701-1001", "01-701-1002", ...]
  }
  ```

### 3. GET /subject-risk/{subject_id}
Calculate patient safety risk score
- **Scoring**: MILD=1, MODERATE=3, SEVERE=5
- **Risk Categories**: Low (<5), Medium (5-14), High (≥15)
- **Output**:
  ```json
  {
    "subject_id": "01-701-1015",
    "risk_score": 8,
    "risk_category": "Medium",
    "ae_count": 3
  }
  ```

## Setup & Usage

```bash
cd question_5_api
pip install -r requirements.txt
uvicorn main:app --reload
```

## Testing

```bash
# Welcome
curl http://localhost:8000/

# Query AEs
curl -X POST http://localhost:8000/ae-query \
  -H "Content-Type: application/json" \
  -d '{"severity": ["MILD", "MODERATE"]}'

# Subject Risk
curl http://localhost:8000/subject-risk/01-701-1015
```

## Features

FastAPI with type hints and validation
Dynamic filtering with optional parameters
Comprehensive error handling (404 for missing subjects)
Risk scoring algorithm
Auto-generated API documentation (/docs)
