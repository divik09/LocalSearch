#!/bin/bash

# Azure Deployment Script for Backend
# This script builds and deploys the Spring Boot backend to Azure App Service

set -e  # Exit on error

echo "🚀 Starting Backend Deployment to Azure..."

# Variables (update these with your values)
RESOURCE_GROUP="local-search-rg"
APP_NAME="local-search-backend"
BACKEND_DIR="."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Build the application
echo -e "${YELLOW}📦 Building Spring Boot application...${NC}"
cd "$BACKEND_DIR"
mvn clean package -DskipTests

if [ ! -f "target/backend-0.0.1-SNAPSHOT.jar" ]; then
    echo "❌ Build failed! JAR file not found."
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${NC}"

# Step 2: Deploy to Azure
echo -e "${YELLOW}☁️ Deploying to Azure App Service...${NC}"
az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --src-path target/backend-0.0.1-SNAPSHOT.jar \
  --type jar

echo -e "${GREEN}✅ Deployment successful!${NC}"

# Step 3: Restart the app service
echo -e "${YELLOW}♻️ Restarting App Service...${NC}"
az webapp restart \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME"

# Step 4: Get the URL
APP_URL=$(az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --query defaultHostName \
  --output tsv)

echo -e "${GREEN}🎉 Backend deployed successfully!${NC}"
echo -e "${GREEN}🔗 Backend URL: https://${APP_URL}${NC}"
echo -e "${GREEN}🏥 Health Check: https://${APP_URL}/actuator/health${NC}"

# Step 5: Test health endpoint
echo -e "${YELLOW}🏥 Testing health endpoint...${NC}"
sleep 10  # Wait for app to start
curl -f "https://${APP_URL}/actuator/health" || echo "⚠️  Health check failed (app might still be starting)"

echo -e "${GREEN}✅ Deployment complete!${NC}"
