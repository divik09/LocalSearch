# Expose Local Search Platform to Internet
# This script uses ngrok to create public URLs for your locally running app

param(
    [switch]$FrontendOnly,
    [switch]$BackendOnly,
    [switch]$InstallNgrok
)

$ErrorActionPreference = "Stop"

# Colors
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Info { Write-Host $args -ForegroundColor Cyan }
function Write-Warning { Write-Host $args -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host $msg -ForegroundColor Red }

Write-Info "🌐 Local Search Platform - Internet Exposure Tool"
Write-Info "================================================`n"

# Check if ngrok is installed
function Test-NgrokInstalled {
    try {
        $null = Get-Command ngrok -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Install ngrok if needed
if ($InstallNgrok -or -not (Test-NgrokInstalled)) {
    Write-Warning "ngrok is not installed. Installing via Chocolatey..."
    
    # Check if Chocolatey is installed
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Error "Chocolatey is not installed. Please install ngrok manually from https://ngrok.com/download"
        Write-Info "`nAlternatively, install Chocolatey first: https://chocolatey.org/install"
        exit 1
    }
    
    choco install ngrok -y
    
    if (-not (Test-NgrokInstalled)) {
        Write-Error "Failed to install ngrok. Please install manually from https://ngrok.com/download"
        exit 1
    }
    
    Write-Success "✅ ngrok installed successfully!`n"
}

# Verify ngrok is installed
if (-not (Test-NgrokInstalled)) {
    Write-Error "❌ ngrok is not installed!"
    Write-Info "Please install it using one of these methods:"
    Write-Info "  1. Run this script with -InstallNgrok flag"
    Write-Info "  2. Install via Chocolatey: choco install ngrok"
    Write-Info "  3. Download from: https://ngrok.com/download`n"
    exit 1
}

Write-Success "✅ ngrok is installed`n"

# Check if ngrok account is set up
Write-Info "📝 Checking ngrok authentication..."
$ngrokConfig = "$env:USERPROFILE\.ngrok2\ngrok.yml"
if (-not (Test-Path $ngrokConfig)) {
    Write-Warning "⚠️  ngrok is not authenticated!"
    Write-Info "To use ngrok, you need a free account:"
    Write-Info "  1. Sign up at https://dashboard.ngrok.com/signup"
    Write-Info "  2. Get your authtoken from https://dashboard.ngrok.com/get-started/your-authtoken"
    Write-Info "  3. Run: ngrok authtoken YOUR_TOKEN`n"
    
    $continue = Read-Host "Do you want to continue anyway? (y/n)"
    if ($continue -ne 'y') {
        exit 0
    }
}

# Function to start ngrok tunnel
function Start-NgrokTunnel {
    param(
        [int]$Port,
        [string]$Name,
        [string]$LogFile
    )
    
    Write-Info "🚀 Starting ngrok tunnel for $Name on port $Port..."
    
    # Start ngrok in background
    $process = Start-Process ngrok -ArgumentList "http", $Port, "--log=stdout" -NoNewWindow -PassThru -RedirectStandardOutput $LogFile
    
    # Wait for ngrok to start
    Start-Sleep -Seconds 3
    
    # Get the public URL from ngrok API
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -ErrorAction Stop
        $publicUrl = $response.tunnels[0].public_url
        
        Write-Success "✅ $Name is now accessible at: $publicUrl"
        return @{
            Url = $publicUrl
            Process = $process
        }
    } catch {
        Write-Warning "⚠️  Could not get ngrok URL. Please check the ngrok dashboard."
        return @{
            Url = $null
            Process = $process
        }
    }
}

# Determine what to expose
$exposeFrontend = -not $BackendOnly
$exposeBackend = -not $FrontendOnly

$tunnels = @()

# Start backend tunnel
if ($exposeBackend) {
    Write-Info "`n--- Backend (Spring Boot) ---"
    $backendTunnel = Start-NgrokTunnel -Port 8080 -Name "Backend API" -LogFile "ngrok-backend.log"
    $tunnels += $backendTunnel
    
    if ($backendTunnel.Url) {
        $backendUrl = $backendTunnel.Url
        Write-Info "`n📋 Copy this backend URL:"
        Write-Success "   $backendUrl"
        Write-Info "`nUpdate your frontend environment.ts with:"
        Write-Success "   apiUrl: '$backendUrl/api'"
    }
}

# Start frontend tunnel (on different ngrok instance)
if ($exposeFrontend) {
    Write-Info "`n--- Frontend (Angular) ---"
    
    if ($exposeBackend) {
        Write-Warning "⚠️  Note: Running multiple ngrok tunnels requires a paid plan."
        Write-Warning "For free tier, expose one at a time using -FrontendOnly or -BackendOnly flags.`n"
        $continue = Read-Host "Continue with frontend tunnel? (y/n)"
        if ($continue -ne 'y') {
            Write-Info "Skipping frontend tunnel. Backend is exposed."
            Write-Info "Press Ctrl+C to stop ngrok."
            Wait-Process -Id $tunnels[0].Process.Id
            exit 0
        }
    }
    
    $frontendTunnel = Start-NgrokTunnel -Port 4200 -Name "Frontend App" -LogFile "ngrok-frontend.log"
    $tunnels += $frontendTunnel
    
    if ($frontendTunnel.Url) {
        $frontendUrl = $frontendTunnel.Url
        Write-Info "`n📋 Your app is now accessible at:"
        Write-Success "   $frontendUrl"
        Write-Info "`nShare this URL with anyone for testing!"
    }
}

# Display summary
Write-Info "`n================================================"
Write-Success "🎉 Your app is now on the internet!"
Write-Info "================================================"

if ($backendTunnel.Url) {
    Write-Info "Backend API:  $($backendTunnel.Url)"
}
if ($frontendTunnel.Url) {
    Write-Info "Frontend App: $($frontendTunnel.Url)"
}

Write-Info "`n📊 ngrok Dashboard: http://localhost:4040"
Write-Warning "`n⚠️  Important Notes:"
Write-Info "  - These URLs are temporary and change when you restart ngrok"
Write-Info "  - Make sure your backend allows CORS from the frontend URL"
Write-Info "  - Free ngrok tier allows 1 tunnel at a time"
Write-Info "  - Press Ctrl+C to stop all tunnels`n"

# Keep script running
Write-Info "Tunnels are running. Press Ctrl+C to stop...`n"
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    Write-Info "`nStopping ngrok tunnels..."
    foreach ($tunnel in $tunnels) {
        if ($tunnel.Process -and -not $tunnel.Process.HasExited) {
            Stop-Process -Id $tunnel.Process.Id -Force
        }
    }
    Write-Success "✅ Tunnels stopped."
}
