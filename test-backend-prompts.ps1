#Requires -Version 5.0
<#
    Script de pruebas para los prompts del documento BACKEND_FIX_PROMPTS.md
    Ejecuta las pruebas POST, PUT, GET para doctores
#>

$BASE_URL = "http://localhost:8080"

# Colores para la salida
function WriteHeader { param([string]$msg) Write-Host $msg -ForegroundColor Cyan -BackgroundColor DarkGray }
function WriteSuccess { param([string]$msg) Write-Host "✅ $msg" -ForegroundColor Green }
function WriteError { param([string]$msg) Write-Host "❌ $msg" -ForegroundColor Red }
function WriteInfo { param([string]$msg) Write-Host "ℹ️  $msg" -ForegroundColor Yellow }

WriteHeader "═══════════════════════════════════════════════════════════"
WriteHeader " 🧪 TEST BACKEND - SIGC Doctor Management Endpoints"
WriteHeader "═══════════════════════════════════════════════════════════"

# TEST 1: GET /doctores (verificar lectura)
WriteHeader "`n[TEST 1] GET /doctores - Listar todos los doctores"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/doctores" -Method GET -ErrorAction Stop
    WriteSuccess "GET /doctores funcionando"
    Write-Host "Doctores encontrados: $($response.Count)" -ForegroundColor Green
    if ($response.Count -gt 0) {
        Write-Host "Primero: $($response[0].nombre)" -ForegroundColor Green
        $firstId = $response[0].idDoctor
    }
} catch {
    WriteError "GET /doctores falló: $($_.Exception.Message)"
}

# TEST 2: POST /doctores/json (crear doctor)
WriteHeader "`n[TEST 2] POST /doctores/json - Crear doctor de prueba"
try {
    $body = @{
        nombre = "Dr. Test Creation"
        especialidad = "Test Specialty"
        cupoPacientes = 20
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$BASE_URL/doctores/json" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body $body `
        -ErrorAction Stop
    
    WriteSuccess "POST /doctores/json funcionando (Status 201 esperado)"
    Write-Host "Doctor creado: $($response.nombre) (ID: $($response.idDoctor))" -ForegroundColor Green
    $createdId = $response.idDoctor
} catch {
    WriteError "POST /doctores/json falló: $($_.Exception.Message)"
}

# TEST 3: PUT /doctores/{id} (actualizar doctor)
if ($null -ne $firstId) {
    WriteHeader "`n[TEST 3] PUT /doctores/{id} - Actualizar doctor"
    try {
        $body = @{
            nombre = "Dr. Test Updated"
            especialidad = "Updated Specialty"
            cupoPacientes = 25
        } | ConvertTo-Json

        $response = Invoke-RestMethod -Uri "$BASE_URL/doctores/$firstId/json" `
            -Method PUT `
            -Headers @{"Content-Type"="application/json"} `
            -Body $body `
            -ErrorAction Stop
        
        WriteSuccess "PUT /doctores/{id} funcionando (Status 200 esperado)"
        Write-Host "Doctor actualizado: $($response.nombre)" -ForegroundColor Green
    } catch {
        WriteError "PUT /doctores/{id} falló: $($_.Exception.Message)"
    }
} else {
    WriteError "PUT /doctores/{id} - No hay doctor con ID para actualizar"
}

WriteHeader "`n═══════════════════════════════════════════════════════════"
WriteInfo "Pruebas completadas. Revisa los resultados arriba."
WriteHeader "═══════════════════════════════════════════════════════════"
