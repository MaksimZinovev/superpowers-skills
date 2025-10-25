#!/bin/bash

# Set your API key
API_KEY="${ANTHROPIC_API_KEY}"

if [ -z "$API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY environment variable not set"
    exit 1
fi

echo "Available Skills:"

# List all skills
response=$(curl -s -X GET "https://api.anthropic.com/v1/skills" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $API_KEY" \
  -H "anthropic-beta: skills-2025-10-02")

# Parse and number the results
echo "$response" | jq -r '.data[] | "\(.id): \(.display_title) (source: \(.source))"' | nl

echo -e "\nCustom Skills only:"

# List only custom skills
custom_response=$(curl -s -X GET "https://api.anthropic.com/v1/skills?source=custom" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $API_KEY" \
  -H "anthropic-beta: skills-2025-10-02")

echo "$custom_response" | jq -r '.data[] | "\(.id): \(.display_title)"' | nl