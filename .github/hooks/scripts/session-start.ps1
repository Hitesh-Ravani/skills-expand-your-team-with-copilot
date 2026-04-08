$ErrorActionPreference = "Stop"

$logDir = Join-Path $PSScriptRoot "..\logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logFile = Join-Path $logDir "security-audit.jsonl"

$inputJson = [Console]::In.ReadToEnd() | ConvertFrom-Json

$entry = [ordered]@{
    event         = "sessionStart"
    timestamp     = $inputJson.timestamp
    source        = $inputJson.source
    cwd           = $inputJson.cwd
    initialPrompt = $inputJson.initialPrompt
} | ConvertTo-Json -Compress

Add-Content -Path $logFile -Value $entry