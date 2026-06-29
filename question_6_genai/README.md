# Question 6: GenAI Clinical Data Assistant (LLM & LangChain)

## Overview
Build an AI agent that translates natural language questions into Pandas queries on clinical adverse event data.

## Input Data
Uses `adae.csv` exported from Question 4 analysis (`pharmaverseadam::adae`)

## Objective
Demonstrate NLP-driven data access by parsing user intent and executing corresponding dataset filters.

## Components

### ClinicalTrialDataAgent Class
- **Schema Mapping**: Maps natural language terms to dataset columns
- **Query Parsing**: Extracts filter type and value from questions
- **Query Execution**: Applies Pandas filters and returns results

### Schema Mapping
```python
{
    "severity": "AESEV",
    "adverse_event": "AETERM",
    "soc": "AESOC",
    "system_organ_class": "AESOC",
    "treatment": "ACTARM",
    "subject": "USUBJID",
    "relationship": "AEREL"
}
```

## Example Queries

| User Question | Parsed Filter | Result |
|---|---|---|
| "Give me subjects with severe adverse events" | AESEV == "SEVERE" | List of subjects |
| "Show me patients with headaches" | AETERM == "Headache" | Subject count & IDs |
| "Which subjects had cardiac disorders" | AESOC == "Cardiac Disorders" | Matching subjects |
| "Find subjects in Placebo arm" | ACTARM == "Placebo" | Treatment arm filter |

## Usage

```python
from clinical_data_agent import ClinicalTrialDataAgent

# Initialize
agent = ClinicalTrialDataAgent("adae.csv")

# Process query
result = agent.process_query("Show me subjects with severe adverse events")
print(f"Found {result['unique_subjects']} subjects")
print(f"Subject IDs: {result['subjects']}")
```

## Testing

```bash
cd question_6_genai
python test_queries.py
```

## Features

Natural language query parsing
Intelligent schema mapping
Pattern-based intent detection
Multiple query type support
Structured JSON output

## Future Enhancements

- Integration with LangChain for more sophisticated NLP
- OpenAI API integration for complex query parsing
- Support for compound queries (AND, OR logic)
- Date range filtering
