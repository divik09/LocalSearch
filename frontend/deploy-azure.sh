#!/bin/bash

# Azure Deployment Script for Frontend
# This script builds and deploys the Angular frontend to Azure Static Web Apps

set -e  # Exit on error

echo "🚀 Starting Frontend Deployment to Azure..."

# Variables (update these with your values)
RESOURCE_GROUP="local-search-rg"
APP_NAME="local-search-frontend"
FRONTEND_DIR="."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"
cd "$FRONTEND_DIR"
npm install

# Step 2: Build the application
echo -e "${YELLOW}🔨 Building Angular application for production...${NC}"
npm run build -- --configuration production

if [ ! -d "dist/frontend/browser" ]; then
    echo "❌ Build failed! Output directory not found."
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${NC}"

# Step 3: Get deployment token
echo -e "${YELLOW}🔑 Getting deployment token...${NC}"
DEPLOYMENT_TOKEN=$(az staticwebapp secrets list \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "properties.apiKey" \
  --output tsv)

# Step 4: Deploy to Azure Static Web Apps
echo -e "${YELLOW}☁️ Deploying to Azure Static Web Apps...${NC}"
cd dist/frontend/browser
npx @azure/static-web-apps-cli deploy \
  --deployment-token "$DEPLOYMENT_TOKEN" \
  --app-location . \
  --no-use-keychain

# Step 5: Get the URL
APP_URL=$(az staticwebapp show \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "defaultHostname" \
  --output tsv)

echo -e "${GREEN}🎉 Frontend deployed successfully!${NC}"
echo -e "${GREEN}🔗 Frontend URL: https://${APP_URL}${NC}"

echo -e "${GREEN}✅ Deployment complete!${NC}"
