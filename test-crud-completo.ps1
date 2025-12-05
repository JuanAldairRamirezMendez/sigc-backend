# Script PowerShell para probar y verificar CRUD del backend SIGC
# Este script te permite testear todos los endpoints desde la terminal

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   🏥 SIGC - Script de Prueba de Endpoints" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:8080"
$adminEmail = "admin@sigc.com"
$adminPassword = "Admin123456"
$token = ""

# Función para mostrar respuestas formateadas
function Show-Response {
    param (
        [Parameter(Mandatory = $true)]
        [object]$response,
        
        [Parameter(Mandatory = $true)]
        [string]$title
    )
    
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host "  $title" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host ""
    Write-Host ($response | ConvertTo-Json -Depth 10) -ForegroundColor White
    Write-Host ""
}

# Función para hacer requests
function Invoke-ApiRequest {
    param (
        [Parameter(Mandatory = $true)]
        [string]$endpoint,
        
        [Parameter(Mandatory = $false)]
        [string]$method = "GET",
        
        [Parameter(Mandatory = $false)]
        [object]$body = $null,
        
        [Parameter(Mandatory = $false)]
        [switch]$requiresAuth
    )
    
    $headers = @{
        "Content-Type" = "application/json"
    }
    
    if ($requiresAuth -and $token) {
        $headers["Authorization"] = "Bearer $token"
    }
    
    try {
        $url = "$baseUrl$endpoint"
        
        if ($body) {
            $bodyJson = $body | ConvertTo-Json
            $response = Invoke-RestMethod -Uri $url -Method $method -Headers $headers -Body $bodyJson
        } else {
            $response = Invoke-RestMethod -Uri $url -Method $method -Headers $headers
        }
        
        return $response
    }
    catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
        return $null
    }
}

# Menu principal
while ($true) {
    Write-Host ""
    Write-Host "📋 MENÚ DE OPCIONES:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🔐 AUTENTICACIÓN" -ForegroundColor Yellow
    Write-Host "  1. Login como Admin"
    Write-Host "  2. Mostrar Token Actual"
    Write-Host ""
    Write-Host "📊 DEBUG Y ESTADÍSTICAS" -ForegroundColor Yellow
    Write-Host "  3. Health Check (verificar conexión)"
    Write-Host "  4. Estado de Base de Datos"
    Write-Host "  5. Verificar CRUD Usuarios"
    Write-Host "  6. Verificar CRUD Doctores"
    Write-Host "  7. Verificar CRUD Citas"
    Write-Host "  8. Verificar CRUD Especialidades"
    Write-Host ""
    Write-Host "👥 USUARIOS" -ForegroundColor Yellow
    Write-Host "  9. Listar Todos los Usuarios"
    Write-Host "  10. Buscar Usuario por Email"
    Write-Host "  11. Crear Nuevo Usuario"
    Write-Host ""
    Write-Host "👨‍⚕️ DOCTORES" -ForegroundColor Yellow
    Write-Host "  12. Listar Todos los Doctores"
    Write-Host "  13. Crear Nuevo Doctor"
    Write-Host ""
    Write-Host "📅 CITAS" -ForegroundColor Yellow
    Write-Host "  14. Listar Todas las Citas"
    Write-Host "  15. Crear Nueva Cita"
    Write-Host ""
    Write-Host "🏥 ESPECIALIDADES" -ForegroundColor Yellow
    Write-Host "  16. Listar Especialidades"
    Write-Host ""
    Write-Host "0. Salir"
    Write-Host ""
    
    $option = Read-Host "Selecciona una opción"
    
    switch ($option) {
        "1" {
            Write-Host ""
            Write-Host "🔐 Intentando login como admin..." -ForegroundColor Yellow
            
            $loginData = @{
                email    = $adminEmail
                password = $adminPassword
            }
            
            $response = Invoke-ApiRequest -endpoint "/auth/login" -method "POST" -body $loginData
            
            if ($response -and $response.token) {
                $token = $response.token
                Show-Response -response $response -title "✅ Login Exitoso"
                Write-Host "✅ Token guardado. Puedes usar endpoints autenticados." -ForegroundColor Green
            } elseif ($response -and $response.access_token) {
                $token = $response.access_token
                Show-Response -response $response -title "✅ Login Exitoso"
                Write-Host "✅ Token guardado." -ForegroundColor Green
            } else {
                Write-Host "❌ Error en el login. Verifica las credenciales." -ForegroundColor Red
            }
        }
        
        "2" {
            if ($token) {
                Write-Host ""
                Write-Host "🔐 Token Actual:" -ForegroundColor Green
                Write-Host ""
                Write-Host "Token (primeros 50 caracteres): $($token.Substring(0, [Math]::Min(50, $token.Length)))..." -ForegroundColor Cyan
                Write-Host "Longitud total: $($token.Length) caracteres" -ForegroundColor Cyan
            } else {
                Write-Host ""
                Write-Host "❌ No hay token. Haz login primero." -ForegroundColor Red
            }
        }
        
        "3" {
            Write-Host ""
            Write-Host "🔍 Verificando conexión..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/auth/health" -method "GET"
            
            if ($response) {
                Show-Response -response $response -title "✅ Conexión OK"
                Write-Host "✅ Backend está activo y responde correctamente." -ForegroundColor Green
            } else {
                Write-Host "❌ No se pudo conectar al backend." -ForegroundColor Red
                Write-Host "Verifica que esté corriendo en $baseUrl" -ForegroundColor Yellow
            }
        }
        
        "4" {
            Write-Host ""
            Write-Host "📊 Obteniendo estado de BD..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/debug/database-status" -requiresAuth
            
            if ($response) {
                Show-Response -response $response -title "📊 Estado de Base de Datos"
            }
        }
        
        "5" {
            Write-Host ""
            Write-Host "👥 Verificando CRUD Usuarios..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/debug/crud/usuarios" -requiresAuth
            
            if ($response) {
                Show-Response -response $response -title "👥 Verificación CRUD Usuarios"
            }
        }
        
        "6" {
            Write-Host ""
            Write-Host "👨‍⚕️ Verificando CRUD Doctores..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/debug/crud/doctores" -requiresAuth
            
            if ($response) {
                Show-Response -response $response -title "👨‍⚕️ Verificación CRUD Doctores"
            }
        }
        
        "7" {
            Write-Host ""
            Write-Host "📅 Verificando CRUD Citas..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/debug/crud/citas" -requiresAuth
            
            if ($response) {
                Show-Response -response $response -title "📅 Verificación CRUD Citas"
            }
        }
        
        "8" {
            Write-Host ""
            Write-Host "🏥 Verificando CRUD Especialidades..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/debug/crud/especializaciones" -requiresAuth
            
            if ($response) {
                Show-Response -response $response -title "🏥 Verificación CRUD Especialidades"
            }
        }
        
        "9" {
            Write-Host ""
            Write-Host "👥 Listando usuarios..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/usuarios" -requiresAuth
            
            if ($response) {
                Write-Host ""
                Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
                Write-Host "  👥 Usuarios" -ForegroundColor Green
                Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
                Write-Host ""
                
                foreach ($usuario in $response) {
                    Write-Host "ID: $($usuario.id_usuario) | Nombre: $($usuario.nombre) | Email: $($usuario.email) | Rol: $($usuario.rol)" -ForegroundColor White
                }
                
                Write-Host ""
            }
        }
        
        "10" {
            Write-Host ""
            $email = Read-Host "Ingresa el email a buscar"
            
            Write-Host ""
            Write-Host "🔍 Buscando usuario: $email..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/usuarios/email/$email" -requiresAuth
            
            if ($response) {
                Show-Response -response $response -title "🔍 Usuario Encontrado"
            }
        }
        
        "11" {
            Write-Host ""
            Write-Host "➕ Crear Nuevo Usuario" -ForegroundColor Yellow
            Write-Host ""
            
            $nombre = Read-Host "Nombre"
            $email = Read-Host "Email"
            $password = Read-Host "Contraseña" -AsSecureString
            $passwordPlain = [System.Net.NetworkCredential]::new('', $password).Password
            $dni = Read-Host "DNI"
            $telefono = Read-Host "Teléfono"
            
            Write-Host ""
            Write-Host "Selecciona el rol:" -ForegroundColor Cyan
            Write-Host "1. PACIENTE"
            Write-Host "2. DOCTOR"
            Write-Host "3. ADMIN"
            $rolOption = Read-Host "Opción"
            
            $rol = switch ($rolOption) {
                "1" { "PACIENTE" }
                "2" { "DOCTOR" }
                "3" { "ADMIN" }
                default { "PACIENTE" }
            }
            
            $userData = @{
                nombre   = $nombre
                email    = $email
                password = $passwordPlain
                dni      = $dni
                telefono = $telefono
                rol      = $rol
            }
            
            Write-Host ""
            Write-Host "✏️ Creando usuario..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/auth/register" -method "POST" -body $userData
            
            if ($response) {
                Show-Response -response $response -title "✅ Usuario Creado"
            }
        }
        
        "12" {
            Write-Host ""
            Write-Host "👨‍⚕️ Listando doctores..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/doctores" -requiresAuth
            
            if ($response) {
                Write-Host ""
                Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
                Write-Host "  👨‍⚕️ Doctores" -ForegroundColor Green
                Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
                Write-Host ""
                
                foreach ($doctor in $response) {
                    Write-Host "ID: $($doctor.id_doctor) | Nombre: $($doctor.nombre) | Email: $($doctor.email)" -ForegroundColor White
                }
                
                Write-Host ""
            }
        }
        
        "13" {
            Write-Host ""
            Write-Host "➕ Crear Nuevo Doctor" -ForegroundColor Yellow
            Write-Host ""
            
            $nombre = Read-Host "Nombre"
            $email = Read-Host "Email"
            $password = Read-Host "Contraseña" -AsSecureString
            $passwordPlain = [System.Net.NetworkCredential]::new('', $password).Password
            
            $userData = @{
                nombre    = $nombre
                email     = $email
                password  = $passwordPlain
                dni       = "00000000"
                telefono  = "000000000"
                rol       = "DOCTOR"
            }
            
            Write-Host ""
            Write-Host "✏️ Creando doctor..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/auth/register" -method "POST" -body $userData
            
            if ($response) {
                Show-Response -response $response -title "✅ Doctor Creado"
            }
        }
        
        "14" {
            Write-Host ""
            Write-Host "📅 Listando citas..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/citas" -requiresAuth
            
            if ($response) {
                Write-Host ""
                Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
                Write-Host "  📅 Citas" -ForegroundColor Green
                Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
                Write-Host ""
                
                foreach ($cita in $response) {
                    $paciente = $cita.paciente.nombre ?? "N/A"
                    $doctor = $cita.doctor.nombre ?? "N/A"
                    Write-Host "ID: $($cita.id_cita) | Paciente: $paciente | Doctor: $doctor | $($cita.fecha) $($cita.hora)" -ForegroundColor White
                }
                
                Write-Host ""
            }
        }
        
        "15" {
            Write-Host ""
            Write-Host "➕ Crear Nueva Cita" -ForegroundColor Yellow
            Write-Host ""
            
            # Obtener pacientes y doctores
            $usuarios = Invoke-ApiRequest -endpoint "/api/usuarios" -requiresAuth
            $doctores = Invoke-ApiRequest -endpoint "/api/doctores" -requiresAuth
            
            if ($usuarios -and $doctores) {
                Write-Host ""
                Write-Host "Pacientes disponibles:" -ForegroundColor Cyan
                $pacientes = $usuarios | Where-Object { $_.rol -eq "PACIENTE" }
                for ($i = 0; $i -lt $pacientes.Count; $i++) {
                    Write-Host "$($i+1). $($pacientes[$i].nombre)"
                }
                $pacienteIdx = (Read-Host "Selecciona paciente (número)") - 1
                
                Write-Host ""
                Write-Host "Doctores disponibles:" -ForegroundColor Cyan
                for ($i = 0; $i -lt $doctores.Count; $i++) {
                    Write-Host "$($i+1). $($doctores[$i].nombre)"
                }
                $doctorIdx = (Read-Host "Selecciona doctor (número)") - 1
                
                Write-Host ""
                $fecha = Read-Host "Fecha (YYYY-MM-DD)"
                $hora = Read-Host "Hora (HH:MM)"
                $motivo = Read-Host "Motivo"
                
                $citaData = @{
                    id_paciente = $pacientes[$pacienteIdx].id_usuario
                    id_doctor   = $doctores[$doctorIdx].id_doctor
                    fecha       = $fecha
                    hora        = $hora
                    motivo      = $motivo
                    estado      = "PENDIENTE"
                }
                
                Write-Host ""
                Write-Host "✏️ Creando cita..." -ForegroundColor Yellow
                
                $response = Invoke-ApiRequest -endpoint "/api/citas" -method "POST" -body $citaData -requiresAuth
                
                if ($response) {
                    Show-Response -response $response -title "✅ Cita Creada"
                }
            }
        }
        
        "16" {
            Write-Host ""
            Write-Host "🏥 Listando especialidades..." -ForegroundColor Yellow
            
            $response = Invoke-ApiRequest -endpoint "/api/especialidades" -requiresAuth
            
            if ($response) {
                Show-Response -response $response -title "🏥 Especialidades"
            }
        }
        
        "0" {
            Write-Host ""
            Write-Host "👋 ¡Hasta luego!" -ForegroundColor Cyan
            break
        }
        
        default {
            Write-Host ""
            Write-Host "❌ Opción no válida" -ForegroundColor Red
        }
    }
}
