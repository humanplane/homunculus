# Homunculus v2 Observation Capture (PowerShell)
# Append-only, non-blocking. Never fails (exit 0 always).

param(
    [string]$EventType = "unknown"
)

$OBS_FILE = ".claude/homunculus/observations.jsonl"

# Ensure directory exists
$obsDir = Split-Path -Parent $OBS_FILE
if (-not (Test-Path $obsDir)) {
    New-Item -ItemType Directory -Path $obsDir -Force | Out-Null
}

# Read input from stdin (hook data as JSON)
$InputData = $null
try {
    $InputData = [Console]::In.ReadToEnd()
} catch {
    $InputData = ""
}

# Get timestamp (UTC ISO 8601)
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

# Parse input JSON
$InputObj = $null
try {
    if ($InputData) {
        $InputObj = $InputData | ConvertFrom-Json -ErrorAction SilentlyContinue
    }
} catch {
    $InputObj = $null
}

# Build observation JSON based on event type
switch ($EventType) {
    "prompt" {
        $Prompt = ""
        if ($InputObj -and $InputObj.prompt) {
            $Prompt = $InputObj.prompt
        }
        if ($Prompt) {
            if ($Prompt.Length -gt 500) {
                $Prompt = $Prompt.Substring(0, 500)
            }
            $obs = @{
                timestamp = $Timestamp
                type = "prompt"
                prompt = $Prompt
            } | ConvertTo-Json -Compress
            Add-Content -Path $OBS_FILE -Value $obs -ErrorAction SilentlyContinue
        }
    }
    "tool" {
        $ToolName = ""
        $ToolInput = @{}
        $ToolResponse = ""

        if ($InputObj) {
            if ($InputObj.tool_name) { $ToolName = $InputObj.tool_name }
            if ($InputObj.tool_input) { $ToolInput = $InputObj.tool_input }
            if ($InputObj.tool_response) {
                $ToolResponse = $InputObj.tool_response | ConvertTo-Json -Compress -ErrorAction SilentlyContinue
                if (-not $ToolResponse) { $ToolResponse = "{}" }
            }
        }

        if ($ToolName) {
            if ($ToolResponse.Length -gt 1000) {
                $ToolResponse = $ToolResponse.Substring(0, 1000)
            }
            try {
                $obs = @{
                    timestamp = $Timestamp
                    type = "tool"
                    tool = $ToolName
                    input = $ToolInput
                    response = $ToolResponse
                } | ConvertTo-Json -Compress
                Add-Content -Path $OBS_FILE -Value $obs -ErrorAction SilentlyContinue
            } catch {
                $obs = @{
                    timestamp = $Timestamp
                    type = "tool"
                    tool = $ToolName
                } | ConvertTo-Json -Compress
                Add-Content -Path $OBS_FILE -Value $obs -ErrorAction SilentlyContinue
            }
        }
    }
    default {
        try {
            $obs = @{
                timestamp = $Timestamp
                type = $EventType
                raw = $InputData
            } | ConvertTo-Json -Compress
            Add-Content -Path $OBS_FILE -Value $obs -ErrorAction SilentlyContinue
        } catch {}
    }
}

exit 0
