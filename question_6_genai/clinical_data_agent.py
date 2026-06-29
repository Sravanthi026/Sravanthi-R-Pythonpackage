import pandas as pd
import json
from typing import Dict, List

class ClinicalTrialDataAgent:
    """
    GenAI Clinical Data Assistant
    Translates natural language queries to Pandas operations
    """

    def __init__(self, data_path: str):
        """Initialize agent with clinical data"""
        self.adae = pd.read_csv(data_path)
        self.schema = {
            "severity": "AESEV",
            "adverse_event": "AETERM",
            "soc": "AESOC",
            "system_organ_class": "AESOC",
            "treatment": "ACTARM",
            "subject": "USUBJID",
            "relationship": "AEREL"
        }

    def parse_query(self, question: str) -> Dict:
        """
        Parse natural language query to structured format
        Uses pattern matching for common query types
        """
        question_lower = question.lower()

        # Detect filter type and value
        filter_type = None
        filter_value = None

        # Severity queries
        if "severe" in question_lower or "severity" in question_lower:
            filter_type = "severity"
            if "mild" in question_lower:
                filter_value = "MILD"
            elif "moderate" in question_lower:
                filter_value = "MODERATE"
            elif "severe" in question_lower:
                filter_value = "SEVERE"

        # Adverse event queries
        elif "headache" in question_lower:
            filter_type = "adverse_event"
            filter_value = "Headache"
        elif "nausea" in question_lower:
            filter_type = "adverse_event"
            filter_value = "Nausea"
        elif "rash" in question_lower:
            filter_type = "adverse_event"
            filter_value = "Rash"

        # Cardiac queries
        elif "cardiac" in question_lower or "heart" in question_lower:
            filter_type = "soc"
            filter_value = "Cardiac Disorders"

        # Treatment queries
        elif "placebo" in question_lower:
            filter_type = "treatment"
            filter_value = "Placebo"
        elif "treatment" in question_lower and "arm" in question_lower:
            filter_type = "treatment"
            filter_value = "Treatment"

        return {
            "question": question,
            "filter_type": filter_type,
            "filter_value": filter_value,
            "column": self.schema.get(filter_type) if filter_type else None
        }

    def execute_query(self, parsed: Dict) -> Dict:
        """Execute parsed query on dataset"""
        filtered_data = self.adae.copy()

        if parsed["column"] and parsed["filter_value"]:
            filtered_data = filtered_data[
                filtered_data[parsed["column"]] == parsed["filter_value"]
            ]

        unique_subjects = filtered_data["USUBJID"].unique().tolist()
        count = len(filtered_data)

        return {
            "count": count,
            "unique_subjects": len(unique_subjects),
            "subjects": unique_subjects,
            "query": parsed["question"]
        }

    def process_query(self, question: str) -> Dict:
        """End-to-end: parse and execute query"""
        parsed = self.parse_query(question)
        result = self.execute_query(parsed)
        return result
