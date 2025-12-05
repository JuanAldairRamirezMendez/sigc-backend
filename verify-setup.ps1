# Script de Verificación Rápida - SIGC Backend

$ErrorActionPreference = "Continue"

Write-Host "`n" -NoNewline
Write-Host "═════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    🔍 VERIFICACIÓN DE CONFIGURACIÓN - SIGC BACKEND" -ForegroundColor Cyan
Write-Host "═════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "`n" -NoNewline

$backendPath = "C:\Users\LEONARDO\sigc-backend"
$frontendPath = "C:\Users\LEONARDO\sigc-frontend"

# 1. Verificar archivos .env
Write-Host "1️⃣  Verificando archivos de configuración..." -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────" -ForegroundColor Yellow

$backendEnv = Test-Path "$backendPath\.env"
$backendEnvEx = Test-Path "$backendPath\.env.example"

if ($backendEnv) {
    Write-Host "   ✅ Backend .env existe" -ForegroundColor Green
    $envContent = Get-Content "$backendPath\.env" | Select-Object -First 5
    Write-Host "   📋 Primeras líneas:" -ForegroundColor Gray
    $envContent | ForEach-Object { Write-Host "      $_" -ForegroundColor Gray }
} else {
    Write-Host "   ❌ Backend .env NO existe" -ForegroundColor Red
}

if ($backendEnvEx) {
    Write-Host "   ✅ Backend .env.example existe" -ForegroundColor Green
} else {
    Write-Host "   ❌ Backend .env.example NO existe" -ForegroundColor Red
}

$frontendEnv = Test-Path "$frontendPath\.env"
if ($frontendEnv) {
    Write-Host "   ✅ Frontend .env existe" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Frontend .env NO existe (necesita ser creado)" -ForegroundColor Yellow
}

# 2. Verificar backend corriendo
Write-Host "`n2️⃣  Verificando Backend en localhost:8080..." -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────" -ForegroundColor Yellow

Try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/especialidades" -Method GET -ErrorAction Stop
    Write-Host "   ✅ Backend OK - Status: $($response.StatusCode)" -ForegroundColor Green
    
    $data = $response.Content | ConvertFrom-Json
    Write-Host "   📊 Especialidades en BD: $($data.Length)" -ForegroundColor Gray
    
    if ($data.Length -gt 0) {
        Write-Host "   📋 Primeras especialidades:" -ForegroundColor Gray
        $data | Select-Object -First 2 | ForEach-Object {
            Write-Host "      • $($_.nombre)" -ForegroundColor Gray
        }
    }
} Catch {
    Write-Host "   ❌ Backend NO responde" -ForegroundColor Red
    Write-Host "   💡 Solución: Ejecuta 'java -jar target/backend-0.0.1-SNAPSHOT.jar'" -ForegroundColor Yellow
}

# 3. Verificar frontend
Write-Host "`n3️⃣  Verificando Frontend en localhost:5173..." -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────" -ForegroundColor Yellow

Try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method GET -ErrorAction Stop
    Write-Host "   ✅ Frontend OK - Status: $($response.StatusCode)" -ForegroundColor Green
} Catch {
    Write-Host "   ⚠️  Frontend NO responde" -ForegroundColor Yellow
    Write-Host "   💡 Normal si no está ejecutándose. Ejecuta 'npm run dev'" -ForegroundColor Gray
}

# 4. Verificar archivos de configuración
Write-Host "`n4️⃣  Verificando archivos de configuración..." -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────" -ForegroundColor Yellow

$appProps = Test-Path "$backendPath\src\main\resources\application.properties"
if ($appProps) {
    Write-Host "   ✅ application.properties existe" -ForegroundColor Green
    $content = Get-Content "$backendPath\src\main\resources\application.properties" | Select-String "VITE|SERVER_PORT"
    if ($content) {
        Write-Host "   📝 Contiene variables de entorno" -ForegroundColor Green
    }
} else {
    Write-Host "   ❌ application.properties NO existe" -ForegroundColor Red
}

# 5. Verificar .gitignore
Write-Host "`n5️⃣  Verificando .gitignore..." -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────" -ForegroundColor Yellow

$gitignore = Get-Content "$backendPath\.gitignore" | Select-String "\.env"
if ($gitignore) {
    Write-Host "   ✅ .gitignore excluye .env" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  .gitignore NO excluye .env" -ForegroundColor Yellow
}

# 6. Resumen
Write-Host "`n" -NoNewline
Write-Host "═════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                     📊 RESUMEN" -ForegroundColor Cyan
Write-Host "═════════════════════════════════════════════════════════" -ForegroundColor Cyan

$checks = @(
    @{name = "Backend .env"; status = $backendEnv},
    @{name = "Backend .env.example"; status = $backendEnvEx},
    @{name = "application.properties"; status = $appProps},
    @{name = ".gitignore OK"; status = $($gitignore -ne $null)}
)

$passed = 0
$checks | ForEach-Object {
    $emoji = if ($_.status) { "✅" } else { "❌" }
    Write-Host "$emoji $($_.name)" -ForegroundColor $(if ($_.status) { "Green" } else { "Red" })
    if ($_.status) { $passed++ }
}

Write-Host "`n📈 Configuración: $passed/$($checks.Count) items OK" -ForegroundColor Cyan

# 7. Próximos pasos
Write-Host "`n" -NoNewline
Write-Host "═════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "                   🚀 PRÓXIMOS PASOS" -ForegroundColor Green
Write-Host "═════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n1️⃣  FRONTEND - Crea/Actualiza archivos:" -ForegroundColor Yellow
Write-Host "   📄 Ver: $backendPath\COPIA_PEGA_FRONTEND.md" -ForegroundColor Gray
Write-Host "   • Crear .env en frontend" -ForegroundColor Gray
Write-Host "   • Actualizar src/services/api.js" -ForegroundColor Gray
Write-Host "   • Ejecutar: npm install && npm run dev" -ForegroundColor Gray

Write-Host "`n2️⃣  VERIFICACIÓN:" -ForegroundColor Yellow
Write-Host "   • Abre http://localhost:5173 en navegador" -ForegroundColor Gray
Write-Host "   • DevTools (F12) → Console" -ForegroundColor Gray
Write-Host "   • Busca: '🔗 API URL configurada: http://localhost:8080'" -ForegroundColor Gray

Write-Host "`n3️⃣  DOCUMENTACIÓN:" -ForegroundColor Yellow
Write-Host "   📚 Ver archivos en $backendPath" -ForegroundColor Gray
Write-Host "   • GUIA_VARIABLES_ENTORNO.md" -ForegroundColor Gray
Write-Host "   • SETUP_FRONTEND_INSTRUCCIONES.md" -ForegroundColor Gray
Write-Host "   • TODO_COMPLETADO.md" -ForegroundColor Gray

Write-Host "`n" -NoNewline
Write-Host "═════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "            ✅ VERIFICACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "═════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n" -NoNewline
