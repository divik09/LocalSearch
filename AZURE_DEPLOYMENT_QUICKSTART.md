# Azure Deployment Quick Reference

## 🚀 Quick Start Deployment

### Prerequisites Checklist
- [ ] Azure account with active subscription
- [ ] Azure CLI installed and logged in (`az login`)
- [ ] Java 17+ installed
- [ ] Maven installed
- [ ] Node.js 18+ installed
- [ ] Git installed

---

## 📋 Step-by-Step Deployment

### 1️⃣ Create Azure Resources (5-10 minutes)

```bash
# Login to Azure
az login

# Create resource group
az group create --name local-search-rg --location eastus

# Create MySQL database
az mysql flexible-server create \
  --name local-search-mysql \
  --resource-group local-search-rg \
  --location eastus \
  --admin-user myadmin \
  --admin-password "YourPassword123!" \
  --sku-name Standard_B1ms \
  --tier Burstable

# Create database
az mysql flexible-server db create \
  --resource-group local-search-rg \
  --server-name local-search-mysql \
  --database-name local_search_db
```

### 2️⃣ Deploy Backend (5 minutes)

```bash
cd backend

# Build
mvn clean package -DskipTests

# Create App Service
az webapp create \
  --resource-group local-search-rg \
  --plan local-search-plan \
  --name local-search-backend \
  --runtime "JAVA:17-java17"

# Set environment variables
az webapp config appsettings set \
  --resource-group local-search-rg \
  --name local-search-backend \
  --settings \
    MYSQL_HOST="local-search-mysql.mysql.database.azure.com" \
    MYSQL_DATABASE="local_search_db" \
    MYSQL_USER="myadmin" \
    MYSQL_PASSWORD="YourPassword123!" \
    JWT_SECRET="$(openssl rand -base64 32)" \
    FRONTEND_URL="https://your-frontend.azurestaticapps.net" \
    SPRING_PROFILES_ACTIVE="prod"

# Deploy using script
./deploy-azure.ps1  # Windows
# OR
./deploy-azure.sh   # Linux/Mac
```

### 3️⃣ Deploy Frontend (5 minutes)

```bash
cd frontend

# Update environment.prod.ts with your backend URL
# apiUrl: 'https://local-search-backend.azurewebsites.net/api'

# Build
npm install
npm run build -- --configuration production

# Create Static Web App
az staticwebapp create \
  --name local-search-frontend \
  --resource-group local-search-rg \
  --location eastus2

# Deploy using script
./deploy-azure.ps1  # Windows
# OR
./deploy-azure.sh   # Linux/Mac
```

### 4️⃣ Update CORS (2 minutes)

```bash
# Get your frontend URL
az staticwebapp show \
  --name local-search-frontend \
  --resource-group local-search-rg \
  --query defaultHostname -o tsv

# Update backend CORS
az webapp config appsettings set \
  --resource-group local-search-rg \
  --name local-search-backend \
  --settings FRONTEND_URL="https://[YOUR-FRONTEND-URL]"

# Restart backend
az webapp restart \
  --resource-group local-search-rg \
  --name local-search-backend
```

---

## 🧪 Verification

```bash
# Check backend health
curl https://local-search-backend.azurewebsites.net/actuator/health

# Check backend API
curl https://local-search-backend.azurewebsites.net/api/businesses

# Open frontend
start https://local-search-frontend.azurestaticapps.net
```

---

## 💰 Cost Estimate

| Resource | Monthly Cost |
|----------|-------------|
| MySQL Flexible Server (B1ms) | ~$15 |
| App Service (B1) | ~$13 |
| Static Web Apps (Free tier) | $0 |
| **Total** | **~$28/month** |

---

## 🔧 Common Commands

### View Backend Logs
```bash
az webapp log tail --resource-group local-search-rg --name local-search-backend
```

### Restart Backend
```bash
az webapp restart --resource-group local-search-rg --name local-search-backend
```

### View Environment Variables
```bash
az webapp config appsettings list --resource-group local-search-rg --name local-search-backend
```

### Delete Everything
```bash
az group delete --name local-search-rg --yes --no-wait
```

---

## 📚 Files Reference

| File | Purpose |
|------|---------|
| [AZURE_DEPLOYMENT_GUIDE.md](AZURE_DEPLOYMENT_GUIDE.md) | Complete deployment guide |
| `backend/application-prod.properties` | Production config |
| `backend/deploy-azure.ps1` | Backend deployment script (Windows) |
| `backend/deploy-azure.sh` | Backend deployment script (Linux/Mac) |
| `frontend/environment.prod.ts` | Frontend production config |
| `frontend/deploy-azure.ps1` | Frontend deployment script (Windows) |
| `frontend/deploy-azure.sh` | Frontend deployment script (Linux/Mac) |

---

## ⚠️ Important Notes

1. **Change default passwords** - Don't use the example passwords in production!
2. **Secure JWT secret** - Generate with: `openssl rand -base64 32`
3. **Update CORS** - Make sure frontend URL is correct in backend settings
4. **Firewall rules** - Azure services need access to MySQL
5. **Environment variables** - Double-check all settings before deployment

---

## 🆘 Troubleshooting

**Backend won't start:**
- Check application logs: `az webapp log tail`
- Verify MySQL connection: Check firewall rules
- Verify environment variables: `az webapp config appsettings list`

**Frontend shows errors:**
- Check browser console for CORS errors
- Verify backend URL in `environment.prod.ts`
- Verify CORS settings in backend

**Database connection fails:**
- Check MySQL firewall rules
- Verify connection string in environment variables
- Check MySQL server status: `az mysql flexible-server show`

---

For detailed instructions, see **[AZURE_DEPLOYMENT_GUIDE.md](AZURE_DEPLOYMENT_GUIDE.md)**
