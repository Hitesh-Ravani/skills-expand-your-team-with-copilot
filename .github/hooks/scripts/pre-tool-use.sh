#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
INPUT="$(cat)"

TS="$(echo "$INPUT" | jq -r '.timestamp // empty')"
TOOL_NAME="$(echo "$INPUT" | jq -r '.toolName // .tool_name // .tool.name // "unknown"')"
ARGS="$(echo "$INPUT" | jq -c '.arguments // .args // .toolArguments // {}')"

echo "{\"event\":\"preToolUse\",\"timestamp\":\"$TS\",\"toolName\":\"$TOOL_NAME\",\"arguments\":$ARGS}" >> logs/security-audit.jsonl

# Explicitly allow the tool call to continue.
# For command hooks, output is ignored unless your policy script is designed to block.
exit 0