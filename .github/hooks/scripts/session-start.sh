#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
INPUT="$(cat)"

TS="$(echo "$INPUT" | jq -r '.timestamp // empty')"
SOURCE="$(echo "$INPUT" | jq -r '.source // "unknown"')"
CWD="$(echo "$INPUT" | jq -r '.cwd // "unknown"')"
PROMPT="$(echo "$INPUT" | jq -r '.initialPrompt // ""')"

echo "{\"event\":\"sessionStart\",\"timestamp\":\"$TS\",\"source\":\"$SOURCE\",\"cwd\":\"$CWD\",\"initialPrompt\":$(jq -Rn --arg v "$PROMPT" '$v')}" >> logs/security-audit.jsonl