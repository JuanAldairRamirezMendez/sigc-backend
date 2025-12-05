# 📊 Arquitectura y Flujo de la Solución

## 🏗️ Diagrama General

```
┌─────────────────────────────────────────────────────────────────┐
│                    SISTEMA SIGC COMPLETO                        │
└─────────────────────────────────────────────────────────────────┘

    ┌────────────────────────────────────────────────────────────┐
    │                   NAVEGADOR WEB                             │
    ├────────────────────────────────────────────────────────────┤
    │                                                              │
    │   ┌──────────────────────────────────────────────────────┐  │
    │   │  database-dashboard.html                             │  │
    │   │  ✅ Gestión de Usuarios                              │  │
    │   │  ✅ Gestión de Doctores                              │  │
    │   │  ✅ Gestión de Citas                                 │  │
    │   │  ✅ Verificación de CRUD                             │  │
    │   │  ✅ Estadísticas en Vivo                             │  │
    │   └──────────────────────────────────────────────────────┘  │
    │                          ↓ (HTTP REST)                       │
    └────────────────────────────────────────────────────────────┘
                               │
                ┌──────────────┴──────────────┐
                │                             │
    ┌───────────▼──────────────┐   ┌─────────▼──────────────┐
    │   Backend Spring Boot    │   │  PowerShell Scripts    │
    │   http://localhost:8080  │   │  Testing & Automation  │
    ├──────────────────────────┤   ├────────────────────────┤
    │                          │   │                        │
    │  ✅ AuthController       │   │ ✅ test-crud-completo  │
    │  ✅ UsuarioController    │   │    (Menú interactivo)  │
    │  ✅ DoctorController     │   │                        │
    │  ✅ CitaController       │   │ ✅ iniciar-dashboard   │
    │  ✅ DebugController      │   │    (Automatización)    │
    │                          │   │                        │
    └────────────────┬─────────┘   └────────────────────────┘
                     │
                     └─────────────────────────┐
                                               │
                    ┌──────────────────────────▼────────────────┐
                    │         Base de Datos MySQL              │
                    ├─────────────────────────────────────────┤
                    │                                          │
                    │  📋 Tabla: usuarios                      │
                    │  ├─ id_usuario (PK)                     │
                    │  ├─ nombre                              │
                    │  ├─ email (UNIQUE)                      │
                    │  ├─ password                            │
                    │  ├─ dni                                 │
                    │  ├─ telefono                            │
                    │  ├─ rol (ADMIN/DOCTOR/PACIENTE)         │
                    │  └─ activo                              │
                    │                                          │
                    │  👨‍⚕️ Tabla: doctores                      │
                    │  ├─ id_doctor (PK)                      │
                    │  ├─ id_usuario (FK)                     │
                    │  ├─ especialidad_id (FK)                │
                    │  └─ activo                              │
                    │                                          │
                    │  📅 Tabla: citas                         │
                    │  ├─ id_cita (PK)                        │
                    │  ├─ id_paciente (FK)                    │
                    │  ├─ id_doctor (FK)                      │
                    │  ├─ fecha                               │
                    │  ├─ hora                                │
                    │  ├─ motivo                              │
                    │  └─ estado                              │
                    │                                          │
                    │  🏥 Tabla: especialidad                  │
                    │  ├─ id_especialidad (PK)                │
                    │  ├─ nombre                              │
                    │  └─ descripcion                         │
                    │                                          │
                    └──────────────────────────────────────────┘
```

---

## 🔄 Flujo de Operaciones CRUD

### 1️⃣ CREATE (Crear)

```
Usuario llena formulario en Dashboard
         ↓
JavaScript valida datos
         ↓
Envía POST request a Backend
         ↓
Spring Boot AuthController/UsuarioController recibe
         ↓
Valida datos nuevamente
         ↓
Guarda en Base de Datos
         ↓
Retorna response JSON (éxito/error)
         ↓
Dashboard muestra mensaje y recarga tabla
```

**Ejemplo:**
```json
POST /auth/register
{
  "nombre": "Juan Pérez",
  "email": "juan@example.com",
  "password": "Pass123",
  "dni": "12345678",
  "telefono": "987654321",
  "rol": "PACIENTE"
}

RESPONSE:
{
  "id": 5,
  "nombre": "Juan Pérez",
  "email": "juan@example.com",
  "rol": "PACIENTE",
  "activo": true
}
```

---

### 2️⃣ READ (Leer)

```
Usuario hace click en "🔄 Recargar"
         ↓
Dashboard envía GET request
         ↓
Backend obtiene datos de BD
         ↓
Retorna lista JSON
         ↓
JavaScript renderiza tabla HTML
         ↓
Usuario ve los datos actualizados
```

**Ejemplo:**
```bash
GET /api/usuarios
Authorization: Bearer {token}

RESPONSE:
[
  {
    "id_usuario": 1,
    "nombre": "Admin",
    "email": "admin@sigc.com",
    "rol": "ADMIN",
    "activo": true
  },
  {
    "id_usuario": 5,
    "nombre": "Juan Pérez",
    "email": "juan@example.com",
    "rol": "PACIENTE",
    "activo": true
  }
]
```

---

### 3️⃣ UPDATE (Actualizar)

```
Usuario hace click en "✏️ Editar"
         ↓
Abre modal con datos actuales
         ↓
Usuario modifica campos
         ↓
Envía PUT request al Backend
         ↓
Backend valida y actualiza BD
         ↓
Retorna response
         ↓
Dashboard recarga datos
```

**Ejemplo:**
```bash
PUT /api/usuarios/{id}
{
  "nombre": "Juan Pérez Updated",
  "email": "juan.updated@example.com"
}
```

---

### 4️⃣ DELETE (Eliminar)

```
Usuario hace click en "🗑️ Eliminar"
         ↓
Confirma acción en popup
         ↓
Envía DELETE request al Backend
         ↓
Backend elimina de BD
         ↓
Retorna confirmación
         ↓
Dashboard recarga tabla sin registro
```

**Ejemplo:**
```bash
DELETE /api/usuarios/5
Authorization: Bearer {token}

RESPONSE:
{
  "status": "success",
  "message": "Usuario eliminado"
}
```

---

## 🔄 Sincronización de Datos

```
┌─────────────────────────────────────────────────────────────┐
│          SINCRONIZACIÓN: USUARIOS → DOCTORES → CITAS        │
└─────────────────────────────────────────────────────────────┘

Paso 1: Crear Usuario como DOCTOR
┌────────────────────────────────┐
│ POST /auth/register            │
│ {                              │
│   "nombre": "Dr. Luis",        │
│   "rol": "DOCTOR",             │
│   ...                          │
│ }                              │
└────────────┬───────────────────┘
             ↓
        Tabla usuarios
     (id=2, rol=DOCTOR)

Paso 2: Acceder al listado de Doctores
┌────────────────────────────────┐
│ GET /api/doctores              │
└────────────┬───────────────────┘
             ↓
        SQL: SELECT * FROM doctores
             WHERE rol='DOCTOR'
             ↓
        Tabla doctores
     (aparece Dr. Luis)

Paso 3: Seleccionar Doctor en Dropdown de Citas
┌────────────────────────────────┐
│ GET /api/doctores              │
│ (para llenar dropdown)         │
└────────────┬───────────────────┘
             ↓
        Dropdown muestra:
        "Dr. Luis"

Paso 4: Crear Cita
┌────────────────────────────────┐
│ POST /api/citas                │
│ {                              │
│   "id_doctor": 2,              │
│   "id_paciente": 1,            │
│   ...                          │
│ }                              │
└────────────┬───────────────────┘
             ↓
        Tabla citas
     (referencia al doctor 2)

✅ SINCRONIZACIÓN COMPLETA
```

---

## 🔐 Flujo de Autenticación

```
┌──────────────────────────────────────────────────┐
│         AUTENTICACIÓN JWT EN LA SOLUCIÓN          │
└──────────────────────────────────────────────────┘

1. Dashboard abre
         ↓
   Script detecta que no hay token
         ↓
   Intenta login automático como admin
         ↓

2. POST /auth/login
   {
     "email": "admin@sigc.com",
     "password": "Admin123456"
   }
         ↓
   Backend verifica credenciales
         ↓
   Genera JWT token
         ↓

3. Response:
   {
     "token": "eyJhbGciOiJIUzI1NiIs...",
     "email": "admin@sigc.com",
     "rol": "ADMIN"
   }
         ↓
   Dashboard almacena token
         ↓

4. Futuras requests incluyen:
   Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
         ↓
   Backend valida token
         ↓
   Procesa request autenticado
         ↓

✅ AUTENTICACIÓN COMPLETADA
```

---

## 🧪 Flujo de Verificación CRUD

```
┌──────────────────────────────────────────────────┐
│       VERIFICACIÓN AUTOMÁTICA DE CRUD             │
└──────────────────────────────────────────────────┘

Usuario hace click: "Verificar Usuarios"
         ↓
         ├─ GET /api/debug/crud/usuarios
         ↓
         ├─ Backend ejecuta DebugController
         ├─ Consulta todas las filas de tabla usuarios
         ├─ Cuenta registros por rol
         ├─ Cuenta activos/inactivos
         ↓
Response JSON:
{
  "status": "OK",
  "conteos": {
    "total": 5,
    "activos": 5,
    "inactivos": 0,
    "admin": 1,
    "doctores": 2,
    "pacientes": 2
  },
  "usuarios": [
    {
      "id": 1,
      "nombre": "Admin",
      "email": "admin@sigc.com",
      "rol": "ADMIN",
      "activo": true
    },
    ...
  ]
}
         ↓
Dashboard parsea JSON y muestra:
- Tabla con todos los usuarios
- Números de verificación coinciden
- Estado "OK" en color verde

✅ VERIFICACIÓN COMPLETADA
```

---

## 📱 Interfaz del Dashboard

```
┌─────────────────────────────────────────────────────────┐
│  🏥 Panel de Control SIGC                              │
│  Visualización y verificación de BD en tiempo real      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ 📊 CONEXIÓN Y ESTADÍSTICAS                             │
├─────────────────────────────────────────────────────────┤
│ URL Backend: [http://localhost:8080    ]               │
│ [🔗 Conectar Backend]                                  │
│                                                          │
│ [Total Usuarios: 5] [Doctores: 2] [Pacientes: 3] [Admin: 1]│
└─────────────────────────────────────────────────────────┘

┌──────────────────────────┬──────────────────────────────┐
│   👥 GESTIÓN USUARIOS    │  👨‍⚕️ GESTIÓN DOCTORES       │
├──────────────────────────┼──────────────────────────────┤
│ [Crear] [Listar] [Buscar]│  [Listar] [Crear]            │
│                          │                              │
│ ID│Nombre│Email│Rol│Est │ ID│Nombre│Email│Esp│Est    │
├──────────────────────────┼──────────────────────────────┤
│ 1 │Admin │admin │ADMIN│✓ │ 1 │Dr. Luis│luis │Card│✓  │
│ 5 │Juan  │juan  │PACI │✓ │ 2 │Dr. Ana │ana  │Der │✓  │
└──────────────────────────┴──────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│   📅 GESTIÓN CITAS                                      │
├──────────────────────────────────────────────────────────┤
│ [Listar] [Crear]                                        │
│                                                          │
│ ID│Paciente│Doctor│Fecha│Hora │Estado                  │
├──────────────────────────────────────────────────────────┤
│ 1 │Juan    │Luis  │2025-12-15│14:30│PENDIENTE          │
│ 2 │Maria   │Ana   │2025-12-16│09:00│CONFIRMADA         │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│   ✅ VERIFICACIÓN DE CRUD                              │
├──────────────────────────────────────────────────────────┤
│ [Verificar Usuarios] [Verificar Doctores]              │
│ [Verificar Citas] [Verificar Especialidades]           │
└──────────────────────────────────────────────────────────┘
```

---

## 🔌 Endpoints REST Disponibles

```
┌─────────────────────────────────────────────────────────┐
│              ENDPOINTS DEL BACKEND                       │
└─────────────────────────────────────────────────────────┘

🔐 AUTENTICACIÓN
  POST   /auth/login                    → Login (obtener token)
  POST   /auth/register                 → Registrar usuario
  GET    /auth/health                   → Verificar conexión
  GET    /api/me                        → Info del usuario actual

👥 USUARIOS
  GET    /api/usuarios                  → Listar todos
  GET    /api/usuarios/{id}             → Obtener uno
  GET    /api/usuarios/email/{email}    → Buscar por email
  POST   /api/usuarios                  → Crear
  PUT    /api/usuarios/{id}             → Actualizar
  DELETE /api/usuarios/{id}             → Eliminar

👨‍⚕️ DOCTORES
  GET    /api/doctores                  → Listar todos
  GET    /api/doctores/{id}             → Obtener uno
  POST   /api/doctores                  → Crear
  PUT    /api/doctores/{id}             → Actualizar
  DELETE /api/doctores/{id}             → Eliminar

📅 CITAS
  GET    /api/citas                     → Listar todas
  GET    /api/citas/{id}                → Obtener una
  POST   /api/citas                     → Crear
  PUT    /api/citas/{id}                → Actualizar
  DELETE /api/citas/{id}                → Eliminar

🏥 ESPECIALIDADES
  GET    /api/especialidades            → Listar todas
  GET    /api/especialidades/{id}       → Obtener una
  POST   /api/especialidades            → Crear
  PUT    /api/especialidades/{id}       → Actualizar
  DELETE /api/especialidades/{id}       → Eliminar

🔧 DEBUG (NUEVO)
  GET    /api/debug/health              → Verificar backend
  GET    /api/debug/database-status     → Estadísticas de BD
  GET    /api/debug/crud/usuarios       → Verificar CRUD usuarios
  GET    /api/debug/crud/doctores       → Verificar CRUD doctores
  GET    /api/debug/crud/citas          → Verificar CRUD citas
  GET    /api/debug/crud/especializaciones → Verificar CRUD especialidades
  POST   /api/debug/reset               → Resetear BD (CUIDADO!)
```

---

## 🚀 Cómo Comienza la Ejecución

```
1. Usuario ejecuta PowerShell
   ↓
   .\iniciar-dashboard.ps1
   ↓
   Selecciona opción 1: "Compilar y ejecutar backend"
   ↓

2. Maven compila el proyecto
   ↓
   Incluye DebugController.java
   ↓
   spring-boot:run inicia la aplicación
   ↓

3. Backend inicia en http://localhost:8080
   ↓
   DataInitializer crea admin@sigc.com
   ↓
   Backend lista en puerto 8080
   ↓

4. Usuario abre database-dashboard.html en navegador
   ↓
   Dashboard.html carga en el navegador
   ↓
   JavaScript espera acción del usuario
   ↓

5. Usuario hace click "Conectar Backend"
   ↓
   Dashboard intenta login automático
   ↓
   Obtiene JWT token
   ↓
   Carga datos iniciales (usuarios, doctores, citas)
   ↓
   Muestra estadísticas en vivo
   ↓

6. Usuario ahora puede:
   ✅ Ver datos en tiempo real
   ✅ Crear/Editar/Eliminar registros
   ✅ Verificar que CRUD funciona
   ✅ Validar sincronización con BD
```

---

## 📊 Comparativa: Frontend vs Backend vs BD

```
┌────────────────────────────────────────────────────────┐
│         VALIDACIÓN DE INTEGRIDAD                       │
└────────────────────────────────────────────────────────┘

ESCENARIO: Crear un doctor

FRONTEND (Dashboard)
  ↓
  Usuario ingresa:
  - Nombre: "Dr. Carlos López"
  - Email: "carlos@hospital.com"
  - Especialidad: "Cardiología"
  ↓
  Click "Crear Doctor"
  ↓

BACKEND (Spring Boot)
  ↓
  Recibe POST /auth/register
  ↓
  Valida datos
  ↓
  Guarda en BD:
  - usuarios table: nuevo registro
  - doctores table: referencia a usuario
  ↓
  Retorna confirmación
  ↓

BASE DE DATOS (MySQL)
  ↓
  INSERT INTO usuarios...
  INSERT INTO doctores...
  ↓
  Datos persistidos
  ↓

VERIFICACIÓN (Dashboard)
  ↓
  Click "Recargar Doctores"
  ↓
  GET /api/doctores
  ↓
  Tabla muestra:
  "Dr. Carlos López | carlos@hospital.com | Cardiología | Activo"
  ↓

VALIDACIÓN FINAL
  ↓
  Click "Verificar Doctores"
  ↓
  GET /api/debug/crud/doctores
  ↓
  JSON muestra:
  {
    "status": "OK",
    "conteos": { "total": 3, "activos": 3 },
    "doctores": [
      {
        "id": 3,
        "nombre": "Dr. Carlos López",
        "email": "carlos@hospital.com",
        "especialidad": "Cardiología",
        "activo": true
      }
    ]
  }
  ↓
  ✅ TODO COINCIDE: Frontend = Backend = BD
```

---

## 🎯 Conclusión

Esta solución proporciona:

✅ **Visualización completa** de la BD en tiempo real  
✅ **CRUD completo** para todos los módulos  
✅ **Verificación automática** de integridad  
✅ **Sincronización de datos** validada  
✅ **Debugging facilitado** con endpoints específicos  
✅ **Interface amigable** sin necesidad de SQL  
✅ **Scripts automáticos** para testing  

---

**Arquitectura creada:** 4 de diciembre de 2025  
**Para:** Sistema SIGC  
**Versión:** 1.0
