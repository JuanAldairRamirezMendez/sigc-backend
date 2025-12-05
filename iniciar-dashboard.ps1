# Script para iniciar el Dashboard SIGC

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   🏥 SIGC - Panel de Control de Base de Datos" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Maven está disponible
Write-Host "🔍 Verificando disponibilidad de Maven..." -ForegroundColor Yellow
$mavenCheck = mvn --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Maven no está en el PATH. Usando mvnw..." -ForegroundColor Yellow
    $mvnCommand = ".\mvnw"
} else {
    Write-Host "✅ Maven encontrado" -ForegroundColor Green
    $mvnCommand = "mvn"
}

Write-Host ""
Write-Host "📋 Menú de opciones:" -ForegroundColor Cyan
Write-Host "1. Compilar y ejecutar el backend"
Write-Host "2. Solo ejecutar el backend (sin compilar)"
Write-Host "3. Abrir el dashboard en el navegador"
Write-Host "4. Compilar sin ejecutar"
Write-Host "5. Ver estado de la base de datos"
Write-Host "6. Abrir consola SQL"
Write-Host "0. Salir"
Write-Host ""

$option = Read-Host "Selecciona una opción (0-6)"

switch ($option) {
    "1" {
        Write-Host ""
        Write-Host "🔨 Compilando el backend..." -ForegroundColor Yellow
        & $mvnCommand clean package -DskipTests
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Compilación exitosa" -ForegroundColor Green
            Write-Host ""
            Write-Host "🚀 Iniciando el backend..." -ForegroundColor Yellow
            & $mvnCommand spring-boot:run
        } else {
            Write-Host "❌ Error en la compilación" -ForegroundColor Red
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "🚀 Ejecutando el backend..." -ForegroundColor Yellow
        & $mvnCommand spring-boot:run
    }
    
    "3" {
        Write-Host ""
        $dashboardPath = Join-Path (Get-Location) "database-dashboard.html"
        
        if (Test-Path $dashboardPath) {
            Write-Host "📱 Abriendo el dashboard en el navegador..." -ForegroundColor Green
            Start-Process $dashboardPath
            Write-Host "✅ Dashboard abierto" -ForegroundColor Green
            Write-Host ""
            Write-Host "📝 Asegúrate de que el backend esté corriendo en http://localhost:8080" -ForegroundColor Cyan
        } else {
            Write-Host "❌ El archivo database-dashboard.html no existe" -ForegroundColor Red
            Write-Host "Ubicación esperada: $dashboardPath" -ForegroundColor Yellow
        }
    }
    
    "4" {
        Write-Host ""
        Write-Host "🔨 Compilando el backend (sin ejecutar)..." -ForegroundColor Yellow
        & $mvnCommand clean package -DskipTests
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Compilación exitosa" -ForegroundColor Green
            Write-Host "Para ejecutar, elige la opción 2" -ForegroundColor Cyan
        } else {
            Write-Host "❌ Error en la compilación" -ForegroundColor Red
        }
    }
    
    "5" {
        Write-Host ""
        Write-Host "📊 Verificando estado de la base de datos..." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "URL: http://localhost:8080/api/debug/database-status" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Ejecuta este comando en otra terminal (con PowerShell):" -ForegroundColor Yellow
        Write-Host '$response = Invoke-RestMethod -Uri "http://localhost:8080/api/debug/database-status"' -ForegroundColor Green
        Write-Host '$response | ConvertTo-Json' -ForegroundColor Green
    }
    
    "6" {
        Write-Host ""
        Write-Host "🗄️  Abriendo consola SQL..." -ForegroundColor Yellow
        Write-Host "Base de datos: sigc_db" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Usuario: root (por defecto)" -ForegroundColor Cyan
        Write-Host ""
        
        $sqlCommand = @"
USE sigc_db;
SELECT 'USUARIOS' as Tabla, COUNT(*) as Total FROM usuarios
UNION ALL
SELECT 'DOCTORES', COUNT(*) FROM doctores
UNION ALL
SELECT 'CITAS', COUNT(*) FROM citas
UNION ALL
SELECT 'ESPECIALIDADES', COUNT(*) FROM especialidad;
"@
        
        Write-Host "Comandos SQL útiles:" -ForegroundColor Yellow
        Write-Host "  SELECT * FROM usuarios;" -ForegroundColor Cyan
        Write-Host "  SELECT * FROM doctores;" -ForegroundColor Cyan
        Write-Host "  SELECT * FROM citas;" -ForegroundColor Cyan
        Write-Host "  SELECT * FROM especialidad;" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Para conectar a MySQL desde PowerShell:" -ForegroundColor Yellow
        Write-Host "mysql -u root -p -D sigc_db" -ForegroundColor Green
    }
    
    "0" {
        Write-Host ""
        Write-Host "👋 ¡Hasta luego!" -ForegroundColor Cyan
        exit
    }
    
    default {
        Write-Host "❌ Opción no válida" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Para más información, lee: DASHBOARD_GUIA_USO.md" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
