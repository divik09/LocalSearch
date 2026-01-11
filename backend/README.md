# Backend Setup Guide

## Environment Variables

The application requires certain environment variables to be set before running.

### OpenAI API Key

Set the `OPENAI_API_KEY` environment variable with your actual API key:

**Windows (PowerShell):**
```powershell
$env:OPENAI_API_KEY="your-actual-api-key-here"
```

**Windows (Command Prompt):**
```cmd
set OPENAI_API_KEY=your-actual-api-key-here
```

**Linux/Mac:**
```bash
export OPENAI_API_KEY=your-actual-api-key-here
```

### Running the Application

After setting the environment variable, run the Spring Boot application:

```bash
mvn spring-boot:run
```

Or if using an IDE, make sure to configure the environment variable in your run configuration.

## Security Best Practices

⚠️ **IMPORTANT**: Never commit API keys or secrets to version control!

- Always use environment variables for sensitive data
- Never hardcode API keys in `application.properties`
- Add sensitive files to `.gitignore`
- Rotate API keys if accidentally exposed
