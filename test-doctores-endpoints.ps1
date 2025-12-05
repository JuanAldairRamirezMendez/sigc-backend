#!/usr/bin/env powershell

# Test de endpoints de doctores arreglados
Write-Host "🔧 TESTING ENDPOINTS DOCTORES ARREGLADOS 🔧" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Yellow

$baseUrl = "http://localhost:8080"
$frontendHeaders = @{
    "Content-Type" = "application/json"
    "Accept" = "application/json"
    "Origin" = "http://localhost:5173"
}

# Test 1: POST /doctores/json (JSON) - Este es el endpoint que el frontend debería usar
Write-Host "`n1. Testing POST /doctores/json (JSON) - NUEVO ENDPOINT" -ForegroundColor Cyan
$doctorData = @{
    nombre = "Juan Carlos"
    apellido = "Rodríguez"
    telefono = "987654321"
    correo = "juan.rodriguez@test.com"
    especialidadId = 1
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/doctores/json" -Method POST -Body $doctorData -Headers $frontendHeaders
    Write-Host "✅ POST /doctores/json - SUCCESS" -ForegroundColor Green
    Write-Host "Doctor creado: $($response.nombre) $($response.apellido)" -ForegroundColor White
    $doctorId = $response.idDoctor
} catch {
    Write-Host "❌ POST /doctores/json - ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Response: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
}

# Test 2: GET /doctores - Verificar que se listó correctamente
Write-Host "`n2. Testing GET /doctores - Verificar listado" -ForegroundColor Cyan
try {
    $doctores = Invoke-RestMethod -Uri "$baseUrl/doctores" -Method GET -Headers $frontendHeaders
    Write-Host "✅ GET /doctores - SUCCESS. Doctores encontrados: $($doctores.Length)" -ForegroundColor Green
} catch {
    Write-Host "❌ GET /doctores - ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: PUT /doctores/{id}/json (JSON) - Actualización sin imagen
if ($doctorId) {
    Write-Host "`n3. Testing PUT /doctores/$doctorId/json (JSON) - NUEVO ENDPOINT" -ForegroundColor Cyan
    $updateData = @{
        nombre = "Juan Carlos ACTUALIZADO"
        apellido = "Rodríguez García"
        telefono = "987654322"
        correo = "juan.rodriguez.actualizado@test.com"
        especialidadId = 2
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/doctores/$doctorId/json" -Method PUT -Body $updateData -Headers $frontendHeaders
        Write-Host "✅ PUT /doctores/$doctorId/json - SUCCESS" -ForegroundColor Green
        Write-Host "Doctor actualizado: $($response.nombre) $($response.apellido)" -ForegroundColor White
    } catch {
        Write-Host "❌ PUT /doctores/$doctorId/json - ERROR: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Response: $($_.ErrorDetails.Message)" -ForegroundColor Yellow
    }
}

# Test 4: Verificar specialidades disponibles
Write-Host "`n4. Testing GET /especialidades - Verificar especialidades disponibles" -ForegroundColor Cyan
try {
    $especialidades = Invoke-RestMethod -Uri "$baseUrl/especialidades" -Method GET -Headers $frontendHeaders
    Write-Host "✅ GET /especialidades - SUCCESS" -ForegroundColor Green
    $especialidades | ForEach-Object {
        Write-Host "  - ID: $($_.idEspecialidad), Nombre: $($_.nombre)" -ForegroundColor White
    }
} catch {
    Write-Host "❌ GET /especialidades - ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=============================================" -ForegroundColor Yellow
Write-Host "🏁 TESTS COMPLETADOS - RUTAS CORREGIDAS 🏁" -ForegroundColor Green
Write-Host "`n📝 RUTAS PARA EL FRONTEND:" -ForegroundColor Cyan
Write-Host "  - POST /doctores/json    (para crear doctor sin imagen)" -ForegroundColor White
Write-Host "  - PUT /doctores/{id}/json (para actualizar doctor sin imagen)" -ForegroundColor White
Write-Host "  - POST /doctores/multipart (para crear doctor con imagen)" -ForegroundColor White
Write-Host "  - PUT /doctores/{id}/multipart (para actualizar doctor con imagen)" -ForegroundColor White