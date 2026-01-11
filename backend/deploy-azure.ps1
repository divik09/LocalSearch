# Azure Deployment Script for Backend (PowerShell)
# This script builds and deploys the Spring Boot backend to Azure App Service

# Variables (update these with your values)
$RESOURCE_GROUP = "local-search-rg"
$APP_NAME = "local-search-backend"
$BACKEND_DIR = "."

Write-Host "🚀 Starting Backend Deployment to Azure..." -ForegroundColor Cyan

# Step 1: Build the application
Write-Host "📦 Building Spring Boot application..." -ForegroundColor Yellow
Set-Location $BACKEND_DIR
mvn clean package -DskipTests

if (-not (Test-Path "target\backend-0.0.1-SNAPSHOT.jar")) {
    Write-Host "❌ Build failed! JAR file not found." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Build successful!" -ForegroundColor Green

# Step 2: Deploy to Azure
Write-Host "☁️ Deploying to Azure App Service..." -ForegroundColor Yellow
az webapp deploy `
  --resource-group $RESOURCE_GROUP `
  --name $APP_NAME `
  --src-path target\backend-0.0.1-SNAPSHOT.jar `
  --type jar

Write-Host "✅ Deployment successful!" -ForegroundColor Green

# Step 3: Restart the app service
Write-Host "♻️ Restarting App Service..." -ForegroundColor Yellow
az webapp restart `
  --resource-group $RESOURCE_GROUP `
  --name $APP_NAME

# Step 4: Get the URL
$APP_URL = az webapp show `
  --resource-group $RESOURCE_GROUP `
  --name $APP_NAME `
  --query defaultHostName `
  --output tsv

Write-Host "🎉 Backend deployed successfully!" -ForegroundColor Green
Write-Host "🔗 Backend URL: https://$APP_URL" -ForegroundColor Green
Write-Host "🏥 Health Check: https://$APP_URL/actuator/health" -ForegroundColor Green

# Step 5: Test health endpoint
Write-Host "🏥 Testing health endpoint..." -ForegroundColor Yellow
Start-Sleep -Seconds 10  # Wait for app to start
try {
    Invoke-WebRequest -Uri "https://$APP_URL/actuator/health" -UseBasicParsing | Out-Null
    Write-Host "✅ Health check passed!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Health check failed (app might still be starting)" -ForegroundColor Yellow
}

Write-Host "✅ Deployment complete!" -ForegroundColor Green
