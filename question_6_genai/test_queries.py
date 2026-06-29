import pandas as pd
from clinical_data_agent import ClinicalTrialDataAgent

# Initialize agent
agent = ClinicalTrialDataAgent("question_6_genai/data/adae.csv")

# Test queries
test_queries = [
    "Give me subjects with severe adverse events",
    "Show me patients with headaches",
    "Which subjects had moderate severity AEs",
    "List patients with cardiac disorders",
    "Find subjects in the Placebo treatment arm",
    "Show me subjects with nausea"
]

print("=" * 80)
print("CLINICAL TRIAL DATA ASSISTANT - TEST QUERIES")
print("=" * 80)

for query in test_queries:
    print(f"\n📋 Query: {query}")
    print("-" * 80)

    result = agent.process_query(query)

    print(f"✓ Records found: {result['count']}")
    print(f"✓ Unique subjects: {result['unique_subjects']}")
    if result['subjects']:
        print(f"✓ Subjects: {', '.join(result['subjects'][:5])}")
        if len(result['subjects']) > 5:
            print(f"  ... and {len(result['subjects']) - 5} more")
    else:
        print("✗ No subjects found matching criteria")

print("\n" + "=" * 80)
print("Test completed successfully")
print("=" * 80)
