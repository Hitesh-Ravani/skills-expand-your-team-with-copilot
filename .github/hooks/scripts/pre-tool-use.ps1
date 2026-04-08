$ErrorActionPreference = "Stop"

$logDir = Join-Path $PSScriptRoot "..\logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logFile = Join-Path $logDir "security-audit.jsonl"

$inputJson = [Console]::In.ReadToEnd() | ConvertFrom-Json

$toolName = $null
if ($inputJson.PSObject.Properties.Name -contains "toolName") {
    $toolName = $inputJson.toolName
} elseif ($inputJson.PSObject.Properties.Name -contains "tool_name") {
    $toolName = $inputJson.tool_name
} elseif ($inputJson.PSObject.Properties.Name -contains "tool") {
    $toolName = $inputJson.tool.name
} else {
    $toolName = "unknown"
}

$argsValue = @{}
if ($inputJson.PSObject.Properties.Name -contains "arguments") {
    $argsValue = $inputJson.arguments
} elseif ($inputJson.PSObject.Properties.Name -contains "args") {
    $argsValue = $inputJson.args
} elseif ($inputJson.PSObject.Properties.Name -contains "toolArguments") {
    $argsValue = $inputJson.toolArguments
}

$entry = [ordered]@{
    event     = "preToolUse"
    timestamp = $inputJson.timestamp
    toolName  = $toolName
    arguments = $argsValue
} | ConvertTo-Json -Compress -Depth 20

Add-Content -Path $logFile -Value $entry
exit 0