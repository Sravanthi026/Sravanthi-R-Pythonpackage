from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
from typing import List, Optional

app = FastAPI(title="Clinical Trial Data API", version="1.0.0")

# Load sample data
try:
    adae = pd.read_csv("question_5_api/data/adae.csv")
except:
    # Create sample ADAE data if file doesn't exist
    adae = pd.DataFrame({
        "USUBJID": ["01-701-1001", "01-701-1002", "01-701-1003"] * 10,
        "ACTARM": ["Placebo", "Treatment", "Treatment"] * 10,
        "AETERM": ["Headache", "Nausea", "Headache"] * 10,
        "AESEV": ["MILD", "MODERATE", "SEVERE"] * 10,
        "TRTEMFL": ["Y"] * 30
    })


class AEQuery(BaseModel):
    severity: Optional[List[str]] = None
    treatment_arm: Optional[str] = None


@app.get("/")
def root():
    """Welcome endpoint"""
    return {"message": "Clinical Trial Data API is running"}


@app.post("/ae-query")
def query_adverse_events(query: AEQuery):
    """
    Query adverse events with optional filtering by severity and treatment arm

    Args:
        query: AEQuery object with severity list and/or treatment_arm

    Returns:
        Dictionary with count and unique subject IDs matching criteria
    """
    filtered_ae = adae.copy()

    if query.severity:
        filtered_ae = filtered_ae[filtered_ae["AESEV"].isin(query.severity)]

    if query.treatment_arm:
        filtered_ae = filtered_ae[filtered_ae["ACTARM"] == query.treatment_arm]

    count = len(filtered_ae)
    subjects = filtered_ae["USUBJID"].unique().tolist()

    return {
        "query": query.dict(),
        "count": count,
        "unique_subjects": len(subjects),
        "subjects": subjects
    }


@app.get("/subject-risk/{subject_id}")
def get_subject_risk(subject_id: str):
    """
    Calculate patient safety risk score based on adverse events

    Scoring: MILD=1, MODERATE=3, SEVERE=5
    Risk category: Low (<5), Medium (5-14), High (>=15)

    Args:
        subject_id: Subject identifier

    Returns:
        Dictionary with risk score and category
    """
    subject_ae = adae[adae["USUBJID"] == subject_id]

    if len(subject_ae) == 0:
        raise HTTPException(status_code=404, detail=f"Subject {subject_id} not found")

    # Calculate risk score
    severity_map = {"MILD": 1, "MODERATE": 3, "SEVERE": 5}
    risk_score = subject_ae["AESEV"].map(severity_map).sum()

    # Determine risk category
    if risk_score < 5:
        risk_category = "Low"
    elif risk_score < 15:
        risk_category = "Medium"
    else:
        risk_category = "High"

    return {
        "subject_id": subject_id,
        "risk_score": int(risk_score),
        "risk_category": risk_category,
        "ae_count": len(subject_ae)
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
