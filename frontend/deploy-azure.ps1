# Azure Deployment Script for Frontend (PowerShell)
# This script builds and deploys the Angular frontend to Azure Static Web Apps

# Variables (update these with your values)
$RESOURCE_GROUP = "local-search-rg"
$APP_NAME = "local-search-frontend"
$FRONTEND_DIR = "."

Write-Host "🚀 Starting Frontend Deployment to Azure..." -ForegroundColor Cyan

# Step 1: Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
Set-Location $FRONTEND_DIR
npm install

# Step 2: Build the application
Write-Host "🔨 Building Angular application for production..." -ForegroundColor Yellow
npm run build -- --configuration production

if (-not (Test-Path "dist\frontend\browser")) {
    Write-Host "❌ Build failed! Output directory not found." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Build successful!" -ForegroundColor Green

# Step 3: Get deployment token
Write-Host "🔑 Getting deployment token..." -ForegroundColor Yellow
$DEPLOYMENT_TOKEN = az staticwebapp secrets list `
  --name $APP_NAME `
  --resource-group $RESOURCE_GROUP `
  --query "properties.apiKey" `
  --output tsv

# Step 4: Deploy to Azure Static Web Apps
Write-Host "☁️ Deploying to Azure Static Web Apps..." -ForegroundColor Yellow
Set-Location dist\frontend\browser
npx @azure/static-web-apps-cli deploy `
  --deployment-token $DEPLOYMENT_TOKEN `
  --app-location . `
  --no-use-keychain

# Step 5: Get the URL
$APP_URL = az staticwebapp show `
  --name $APP_NAME `
  --resource-group $RESOURCE_GROUP `
  --query "defaultHostname" `
  --output tsv

Write-Host "🎉 Frontend deployed successfully!" -ForegroundColor Green
Write-Host "🔗 Frontend URL: https://$APP_URL" -ForegroundColor Green

Write-Host "✅ Deployment complete!" -ForegroundColor Green
