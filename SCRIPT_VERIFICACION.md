# 🧪 SCRIPT DE PRUEBA RÁPIDA

## Verificar Backend

```powershell
# 1. Verificar que el backend está corriendo en puerto 8080
$response = Invoke-WebRequest -Uri "http://localhost:8080/especialidades" -Method GET
$response.Content | ConvertFrom-Json | Format-Table

# 2. Ver especialidades
Invoke-WebRequest -Uri "http://localhost:8080/especialidades" -Method GET | Select-Object -ExpandProperty Content

# 3. Ver health check
Invoke-WebRequest -Uri "http://localhost:8080/auth/health" -Method GET | Select-Object -ExpandProperty Content
```

## Verificar Variables de Entorno

### Backend

```powershell
# Verificar que .env existe
Test-Path "C:\Users\LEONARDO\sigc-backend\.env"

# Ver contenido
Get-Content "C:\Users\LEONARDO\sigc-backend\.env"
```

### Frontend

```powershell
# Verificar que .env existe
Test-Path "C:\Users\LEONARDO\sigc-frontend\.env"

# Ver contenido
Get-Content "C:\Users\LEONARDO\sigc-frontend\.env"
```

## Verificar Archivos Creados

```powershell
# En el backend
Get-ChildItem "C:\Users\LEONARDO\sigc-backend" -Filter ".env*"

# Archivos de documentación
Get-ChildItem "C:\Users\LEONARDO\sigc-backend" -Filter "*.md" | 
  Where-Object {$_.Name -match "(GUIA|SETUP|RESUMEN|VARIABLES)"}
```

## Ejecutar Backend con Variables de Entorno

```powershell
# Navegar al backend
cd "C:\Users\LEONARDO\sigc-backend"

# Opción 1: Maven
mvn spring-boot:run

# Opción 2: JAR con variables
java -jar target/backend-0.0.1-SNAPSHOT.jar

# Opción 3: JAR con variables específicas
java -DSERVER_PORT=8080 -DJWT_SECRET=sigc-secret-key-2025 `
  -jar target/backend-0.0.1-SNAPSHOT.jar
```

## Ejecutar Frontend

```powershell
# Navegar al frontend
cd "C:\Users\LEONARDO\sigc-frontend"

# Instalar dependencias
npm install

# Ejecutar en desarrollo
npm run dev

# En la consola del navegador (F12), deberías ver:
# 🔗 API URL configurada: http://localhost:8080
```

## Pruebas de Conectividad

```powershell
# 1. Backend responde
$backend = Invoke-WebRequest -Uri "http://localhost:8080/especialidades" -Method GET
Write-Host "✅ Backend OK: $($backend.StatusCode)"

# 2. Frontend está corriendo (si lo está)
Try {
  $frontend = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET
  Write-Host "✅ Frontend OK: $($frontend.StatusCode)"
} Catch {
  Write-Host "⚠️ Frontend no responde (normal si no está ejecutándose)"
}

# 3. Ver especialidades en el backend
$especialidades = (Invoke-WebRequest -Uri "http://localhost:8080/especialidades" -Method GET).Content | ConvertFrom-Json
Write-Host "✅ Especialidades encontradas: $($especialidades.Length)"
```

## Script Automático de Pruebas

```powershell
# Guardar como "test-setup.ps1" y ejecutar

$ErrorActionPreference = "Stop"

Write-Host "=== VERIFICANDO CONFIGURACIÓN ===" -ForegroundColor Cyan

# 1. Verificar archivos .env
Write-Host "`n1️⃣ Verificando archivos .env..." -ForegroundColor Yellow
if (Test-Path "C:\Users\LEONARDO\sigc-backend\.env") {
  Write-Host "   ✅ Backend .env existe"
} else {
  Write-Host "   ❌ Backend .env NO existe"
}

if (Test-Path "C:\Users\LEONARDO\sigc-frontend\.env") {
  Write-Host "   ✅ Frontend .env existe"
} else {
  Write-Host "   ⚠️  Frontend .env NO existe (necesita ser creado)"
}

# 2. Verificar backend corriendo
Write-Host "`n2️⃣ Verificando backend en localhost:8080..." -ForegroundColor Yellow
Try {
  $response = Invoke-WebRequest -Uri "http://localhost:8080/especialidades" -Method GET
  Write-Host "   ✅ Backend OK - Status: $($response.StatusCode)"
  $count = ($response.Content | ConvertFrom-Json).Length
  Write-Host "   ℹ️  Especialidades encontradas: $count"
} Catch {
  Write-Host "   ❌ Backend NO responde - $($_.Exception.Message)"
}

# 3. Verificar frontend corriendo
Write-Host "`n3️⃣ Verificando frontend en localhost:5173..." -ForegroundColor Yellow
Try {
  $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET
  Write-Host "   ✅ Frontend OK - Status: $($response.StatusCode)"
} Catch {
  Write-Host "   ⚠️  Frontend NO responde (normal si no está ejecutándose)"
}

Write-Host "`n=== VERIFICACIÓN COMPLETADA ===" -ForegroundColor Green
```

## Guardar y Ejecutar

```powershell
# Guardar el script
@"
# Script de pruebas aquí...
"@ | Out-File "C:\Users\LEONARDO\sigc-backend\test-setup.ps1"

# Ejecutar
. "C:\Users\LEONARDO\sigc-backend\test-setup.ps1"
```
