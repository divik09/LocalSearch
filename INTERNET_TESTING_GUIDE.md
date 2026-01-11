# Internet Exposure Guide for Local Testing

This guide explains how to expose your locally running Local Search Platform to the internet for testing using ngrok.

## Quick Start

### Prerequisites
- Your application is running locally (Angular on port 4200, Spring Boot on port 8080)
- Windows PowerShell

### Steps

1. **Run the exposure script:**
   ```powershell
   cd local-search-platform
   .\expose-to-internet.ps1
   ```

2. **Follow the prompts:**
   - Script will install ngrok if needed (requires Chocolatey)
   - You'll be prompted to authenticate ngrok (free account required)

3. **Get your URLs:**
   - The script will display public URLs for your app
   - Share these URLs with anyone for testing

## Usage Options

### Expose Both Frontend and Backend
```powershell
.\expose-to-internet.ps1
```
**Note:** Free ngrok tier only allows 1 tunnel. Use flags below for free tier.

### Expose Frontend Only
```powershell
.\expose-to-internet.ps1 -FrontendOnly
```

### Expose Backend Only
```powershell
.\expose-to-internet.ps1 -BackendOnly
```

### Install ngrok Automatically
```powershell
.\expose-to-internet.ps1 -InstallNgrok
```

## Setting Up ngrok (First Time)

### 1. Install ngrok

**Option A: Using the script**
```powershell
.\expose-to-internet.ps1 -InstallNgrok
```

**Option B: Manual installation**
```powershell
# Using Chocolatey
choco install ngrok

# OR download from https://ngrok.com/download
```

### 2. Create Free ngrok Account

1. Go to https://dashboard.ngrok.com/signup
2. Sign up (free account)
3. Get your authtoken from https://dashboard.ngrok.com/get-started/your-authtoken

### 3. Authenticate ngrok

```powershell
ngrok authtoken YOUR_TOKEN_HERE
```

## What Gets Exposed

| Component | Local Port | Example Public URL |
|-----------|------------|-------------------|
| Angular Frontend | 4200 | `https://abc123.ngrok.io` |
| Spring Boot Backend | 8080 | `https://xyz789.ngrok.io` |

## CORS Configuration

✅ **Already configured!** The backend now automatically accepts requests from:
- `localhost` (any port)
- `*.ngrok.io` and `*.ngrok-free.app`
- `*.loca.lt` (LocalTunnel)
- `*.cloudflare.com` (Cloudflare Tunnel)
- `*.azurestaticapps.net` (Azure deployment)

No manual CORS configuration needed! 🎉

## Testing Flow

### Scenario 1: Test Frontend Only (Backend Running Locally)

```powershell
# Expose only frontend
.\expose-to-internet.ps1 -FrontendOnly

# Your backend still runs on localhost:8080
# Frontend at https://abc123.ngrok.io connects to backend on your machine
```

Use this when:
- Testing UI/UX with remote users
- Mobile device testing
- Cross-browser testing with cloud services

### Scenario 2: Test Backend API (Frontend Local)

```powershell
# Expose only backend
.\expose-to-internet.ps1 -BackendOnly

# Your frontend still runs on localhost:4200
# Backend API accessible at https://xyz789.ngrok.io/api
```

Use this when:
- Testing API with external tools (Postman, mobile apps)
- Integrating with third-party webhooks
- Backend development demos

### Scenario 3: Full Stack Testing (Paid ngrok)

```powershell
# Expose both (requires paid ngrok plan)
.\expose-to-internet.ps1
```

Use this when:
- Complete end-to-end testing
- Client demos
- Beta testing with users

## Important Notes

> [!WARNING]
> **Security Considerations**
> - URLs are temporary and change each time you restart ngrok
> - Anyone with the URL can access your app
> - Don't share sensitive data through these tunnels
> - Not suitable for production use

> [!TIP]
> **Free Tier Limitations**
> - ngrok free tier: 1 active tunnel at a time
> - URLs change on restart (use paid plan for static URLs)
> - Bandwidth limits apply
> - Session timeout after 2 hours

> [!IMPORTANT]
> **Before Testing**
> - Ensure your local app is running
> - Test locally first to verify everything works
> - Backend must be accessible on http://localhost:8080
> - Frontend must be accessible on http://localhost:4200

## Troubleshooting

### ngrok Installation Issues

**Problem:** Chocolatey not installed
```powershell
# Install Chocolatey first
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### ngrok Authentication Issues

**Problem:** "You must sign up" error
- Sign up at https://dashboard.ngrok.com/signup
- Get authtoken and run: `ngrok authtoken YOUR_TOKEN`

### CORS Errors

**Problem:** Browser shows CORS errors
- ✅ **Already fixed!** The backend now accepts ngrok URLs
- If still having issues, restart your Spring Boot backend

### Connection Refused

**Problem:** ngrok URL shows "connection refused"
- Verify your local app is running:
  - Frontend: http://localhost:4200
  - Backend: http://localhost:8080
- Check Windows Firewall isn't blocking connections

### Multiple Tunnels Error

**Problem:** "You've hit your account limit"
- Free tier allows 1 tunnel at a time
- Use `-FrontendOnly` or `-BackendOnly` flags
- Or upgrade to paid ngrok plan

## Alternative Tools

If ngrok doesn't work for you, try these alternatives:

### LocalTunnel (No account needed)
```powershell
npm install -g localtunnel
lt --port 4200
```

### Cloudflare Tunnel (Free, secure)
```powershell
winget install cloudflare.cloudflared
cloudflared tunnel --url http://localhost:4200
```

### VS Code Port Forward (If using VS Code)
1. Press `Ctrl+Shift+P`
2. Type "Forward a Port"
3. Enter `4200`
4. Right-click → Make Public

## ngrok Dashboard

While tunnels are running, access the ngrok dashboard at:
- **Local Dashboard:** http://localhost:4040
- **Web Dashboard:** https://dashboard.ngrok.com

The local dashboard shows:
- Request/response details
- Traffic logs
- Tunnel status
- Performance metrics

## Stopping Tunnels

Press `Ctrl+C` in the PowerShell window where the script is running.

## Advanced: Environment-Specific Backend URLs

If you need to switch backend URLs for testing:

**Update frontend environment:**
```typescript
// frontend/src/environments/environment.ts
export const environment = {
  production: false,
  apiUrl: 'https://your-backend-ngrok-url.ngrok.io/api'
};
```

Then restart your Angular dev server:
```powershell
cd frontend
npm start
```

## Tips for Effective Testing

1. **Mobile Testing:**
   - Open ngrok URL on your phone
   - Test touch interactions
   - Check responsive design

2. **Cross-Browser Testing:**
   - Use cloud browser testing services
   - Test on different devices simultaneously

3. **Share with Team:**
   - Share URL on Slack/Teams
   - Get instant feedback
   - Collaborative debugging

4. **API Testing:**
   - Use Postman with ngrok backend URL
   - Test webhooks and callbacks
   - Simulate external integrations

## FAQ

**Q: How long do ngrok URLs last?**
A: Free tier URLs last until you stop ngrok. Paid plans offer permanent URLs.

**Q: Can I use a custom domain?**
A: Yes, but requires a paid ngrok plan.

**Q: Is ngrok secure?**
A: Yes, all traffic is encrypted over HTTPS. However, anyone with the URL can access your app.

**Q: Can I see who's accessing my tunnel?**
A: Yes, check http://localhost:4040 for request logs.

**Q: Do I need to modify my code?**
A: No! The backend CORS config is already updated to accept ngrok URLs.

---

**Ready to test?** Run `.\expose-to-internet.ps1` and share your app with the world! 🚀
