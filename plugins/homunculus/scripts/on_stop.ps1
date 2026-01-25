# Homunculus v2 Stop Hook (PowerShell)
# Updates session count

$STATE = ".claude/homunculus/identity.json"
$PENDING_DIR = ".claude/homunculus/instincts/pending"

# Ensure directories exist
$stateDir = Split-Path -Parent $STATE
if (-not (Test-Path $stateDir)) {
    New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
}
if (-not (Test-Path $PENDING_DIR)) {
    New-Item -ItemType Directory -Path $PENDING_DIR -Force | Out-Null
}

# Update session count
if (Test-Path $STATE) {
    try {
        $stateObj = Get-Content $STATE -Raw | ConvertFrom-Json

        $count = 0
        if ($stateObj.journey -and $stateObj.journey.sessionCount) {
            $count = [int]$stateObj.journey.sessionCount
        }

        $Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

        if (-not $stateObj.journey) {
            $stateObj | Add-Member -NotePropertyName "journey" -NotePropertyValue @{} -Force
        }
        $stateObj.journey.sessionCount = $count + 1
        $stateObj.journey.lastSession = $Timestamp

        $stateObj | ConvertTo-Json -Depth 10 | Set-Content $STATE -ErrorAction SilentlyContinue
    } catch {
        # Silently fail
    }
}

exit 0
