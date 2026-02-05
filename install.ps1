# YYCLink AI Skills Installer
# Repository list defined directly in script

# ==================== ADD NEW SKILLS HERE ====================
$repos = @(
    @{
        name = "skill-miniprogram-ecosystem"
        url  = "https://github.com/wanddream/skill-miniprogram-ecosystem.git"
    },
    @{
        name = "skill-thesis-writer"
        url  = "https://github.com/wanddream/skill-thesis-writer.git"
    }
    # Add more skills by copying the block above:
    # ,@{
    #     name = "skill-your-name"
    #     url  = "https://github.com/username/skill-your-name.git"
    # }
)
# =============================================================

# Change to script directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
if ($scriptPath) {
    Set-Location $scriptPath
}

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Git not found in PATH" -ForegroundColor Red
    Write-Host "Please install Git: https://git-scm.com/download/win" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Display header
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   YYCLink AI Skills Installer" -ForegroundColor Cyan
Write-Host "   Location: $(Get-Location)" -ForegroundColor DarkGray
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Found $($repos.Count) skills:" -ForegroundColor Yellow
foreach ($repo in $repos) {
    Write-Host "   - $($repo.name)" -ForegroundColor Gray
}
Write-Host ""

$cloned = 0
$updated = 0
$failed = 0

foreach ($repo in $repos) {
    $name = $repo.name
    $url = $repo.url

    Write-Host "-----------------------------------------------" -ForegroundColor DarkGray

    if (Test-Path $name) {
        Write-Host "[$name] Updating..." -ForegroundColor Yellow

        Set-Location $name
        $pullOutput = git pull 2>&1
        $exitCode = $LASTEXITCODE
        Set-Location ..

        if ($exitCode -eq 0) {
            Write-Host "    Updated successfully" -ForegroundColor Green
            $updated++
        } else {
            Write-Host "    Update failed" -ForegroundColor Red
            Write-Host "    $pullOutput" -ForegroundColor DarkGray
            $failed++
        }
    } else {
        Write-Host "[$name] Downloading..." -ForegroundColor Cyan

        $cloneOutput = git clone $url $name 2>&1
        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0 -and (Test-Path $name)) {
            Write-Host "    Downloaded successfully" -ForegroundColor Green
            $cloned++
        } else {
            Write-Host "    Download failed" -ForegroundColor Red
            Write-Host "    Error: $cloneOutput" -ForegroundColor DarkGray
            $failed++
        }
    }
}

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   Summary" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   Downloaded: $cloned" -ForegroundColor Green
Write-Host "   Updated:    $updated" -ForegroundColor Yellow
Write-Host "   Failed:     $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Gray" })
Write-Host "===============================================" -ForegroundColor Cyan

Write-Host ""
Read-Host "Press Enter to exit"
