# ✅ Verificación Completa de CRUD - Guía Paso a Paso

## 🎯 Objetivo

Verificar que todas tus operaciones CRUD (Create, Read, Update, Delete) funcionen correctamente y que los datos en el frontend coincidan con la base de datos.

---

## 📋 Checklist de Verificación

### Fase 1: Preparación

- [ ] Backend está compilado y corriendo en `http://localhost:8080`
- [ ] Base de datos `sigc_db` está creada y accesible
- [ ] Usuario admin (`admin@sigc.com`) existe en la BD
- [ ] Dashboard (`database-dashboard.html`) está abierto en navegador

### Fase 2: Conexión

- [ ] Ingresaste la URL del backend (`http://localhost:8080`)
- [ ] Hiciste click en "Conectar Backend"
- [ ] Aparece mensaje de "Conectado exitosamente"
- [ ] Se muestran estadísticas (usuarios totales, doctores, etc.)

---

## 🔍 Verificación por Módulo

### Módulo 1: USUARIOS

#### ✅ CREATE (Crear)
1. Ve a **Gestión de Usuarios** → Tab **Crear**
2. Completa los campos:
   - Nombre: `Juan Pérez Test`
   - Email: `juan.test@example.com`
   - Contraseña: `Password123`
   - DNI: `12345678`
   - Teléfono: `987654321`
   - Rol: `PACIENTE`
3. Click en "✅ Crear Usuario"
4. Debe aparecer: "✅ Usuario creado exitosamente"

#### Verificar en Base de Datos:
```bash
# En PowerShell:
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/debug/crud/usuarios"
$response.usuarios | Where-Object {$_.email -eq "juan.test@example.com"}
```

**Expected Output:**
```json
{
  "id": 5,
  "nombre": "Juan Pérez Test",
  "email": "juan.test@example.com",
  "rol": "PACIENTE",
  "activo": true
}
```

#### ✅ READ (Leer)
1. Ve a **Gestión de Usuarios** → Tab **Listar**
2. Click en "🔄 Recargar Usuarios"
3. Debe aparecer el usuario `juan.test@example.com` en la tabla
4. Verifica que todos los campos sean correctos

#### ✅ UPDATE (Actualizar)
1. En el listado de usuarios, busca el usuario creado
2. Click en el botón "✏️ Editar"
3. Cambiar algún dato (ejemplo: nombre a `Juan Pérez Actualizado`)
4. Guardar cambios
5. Recarga la tabla y verifica que el cambio se reflejó

#### ✅ DELETE (Eliminar)
1. En el listado de usuarios, encuentra el usuario test
2. Click en el botón "🗑️ Eliminar"
3. Confirma la acción
4. Recarga la tabla y verifica que desapareció

#### 🔐 VERIFICAR EN BD:
```bash
# Contar usuarios
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/debug/crud/usuarios"
$response.conteos
```

Expected:
```json
{
  "total": 4,
  "activos": 4,
  "inactivos": 0,
  "admin": 1,
  "doctores": 2,
  "pacientes": 1
}
```

---

### Módulo 2: DOCTORES

#### ✅ CREATE (Crear)
1. Ve a **Gestión de Doctores** → Tab **Crear**
2. Completa:
   - Nombre: `Dr. Carlos López`
   - Email: `carlos.lopez@hospital.com`
   - Contraseña: `DocPassword123`
   - Especialidad: `Cardiología`
3. Click en "✅ Crear Doctor"
4. Debe aparecer: "✅ Doctor creado exitosamente"

#### ✅ READ (Leer)
1. Ve a **Gestión de Doctores** → Tab **Listar**
2. Click en "🔄 Recargar Doctores"
3. Debe aparecer `Dr. Carlos López` en la tabla
4. La especialidad debe ser `Cardiología`

#### ✅ Verificar en Dropdown:
1. Ve a **Gestión de Citas** → Tab **Crear**
2. Abre el dropdown "Doctor:"
3. Debe aparecer `Dr. Carlos López`
4. **Esto confirma que los doctores se sincronizan correctamente**

#### ✅ VERIFICAR EN BD:
```bash
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/debug/crud/doctores"
$response.doctores | Where-Object {$_.email -eq "carlos.lopez@hospital.com"}
```

Expected:
```json
{
  "id": 3,
  "nombre": "Dr. Carlos López",
  "email": "carlos.lopez@hospital.com",
  "especialidad": "Cardiología",
  "activo": true
}
```

---

### Módulo 3: CITAS

#### ✅ CREATE (Crear)
1. Ve a **Gestión de Citas** → Tab **Crear**
2. Completa:
   - Paciente: Selecciona `Juan Pérez Test` del dropdown
   - Doctor: Selecciona `Dr. Carlos López` del dropdown
   - Fecha: `2025-12-15`
   - Hora: `14:30`
   - Motivo: `Consulta cardiológica`
3. Click en "✅ Crear Cita"
4. Debe aparecer: "✅ Cita creada exitosamente"

**⚠️ Importante:** Si los dropdowns están vacíos:
- Click en "🔄 Recargar Doctores" en el módulo de doctores
- Click en "🔄 Recargar Usuarios" en el módulo de usuarios
- Luego recarga la página

#### ✅ READ (Leer)
1. Ve a **Gestión de Citas** → Tab **Listar**
2. Click en "🔄 Recargar Citas"
3. Debe aparecer la cita con:
   - Paciente: `Juan Pérez Test`
   - Doctor: `Dr. Carlos López`
   - Fecha: `2025-12-15`
   - Hora: `14:30`

#### ✅ VERIFICAR EN BD:
```bash
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/debug/crud/citas"
$response.citas
```

Expected:
```json
[
  {
    "id": 1,
    "paciente": "Juan Pérez Test",
    "doctor": "Dr. Carlos López",
    "fecha": "2025-12-15",
    "hora": "14:30",
    "estado": "PENDIENTE"
  }
]
```

---

### Módulo 4: ESPECIALIDADES

#### ✅ READ (Leer)
1. Ve al panel y busca especialidades
2. Click en "Verificar Especialidades"
3. Debe mostrar todas las especialidades disponibles

#### ✅ VERIFICAR EN BD:
```bash
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/debug/crud/especializaciones"
$response.especialidades
```

Expected:
```json
[
  {
    "id": 1,
    "nombre": "Cardiología",
    "descripcion": "Especialidad del corazón"
  },
  {
    "id": 2,
    "nombre": "Dermatología",
    "descripcion": "Especialidad de la piel"
  }
]
```

---

## 🔄 Verificación de Integridad de Datos

### Sincronización de Usuarios a Doctores

| Paso | Acción | Resultado Esperado |
|------|--------|-------------------|
| 1 | Crear usuario como DOCTOR | Usuario aparece en tabla |
| 2 | Recargar Doctores | Doctor aparece en listado |
| 3 | Ir a crear Cita | Doctor aparece en dropdown |
| ✅ | Si llegó aquí | SYNC CORRECTO |

### Sincronización de Pacientes a Citas

| Paso | Acción | Resultado Esperado |
|------|--------|-------------------|
| 1 | Crear usuario como PACIENTE | Usuario aparece en tabla |
| 2 | Ir a crear Cita | Paciente aparece en dropdown |
| 3 | Crear cita con ese paciente | Cita se crea exitosamente |
| ✅ | Si llegó aquí | SYNC CORRECTO |

---

## 📊 Verificación de Estadísticas

Después de crear usuarios, doctores y citas:

```bash
# En PowerShell
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/debug/database-status"
$response | ConvertTo-Json
```

Expected output:
```json
{
  "status": "OK",
  "timestamp": "2025-12-04T23:30:00.000Z",
  "statistics": {
    "usuarios": 5,
    "doctores": 3,
    "citas": 5,
    "especialidades": 8
  }
}
```

Los números deben coincidir con lo que ves en el dashboard.

---

## 🐛 Checklist de Debugging

Si algo no funciona, verifica:

### ❌ "No se puede conectar al backend"
- [ ] Backend está corriendo en `http://localhost:8080`
- [ ] Verificar con `curl` o navegador:
  ```bash
  curl http://localhost:8080/auth/health
  ```
- [ ] Ver si hay errores en la consola (F12 en navegador)

### ❌ "Login automático falla"
- [ ] Usuario `admin@sigc.com` existe en la BD
- [ ] Contraseña es `Admin123456`
- [ ] Base de datos está conectada

### ❌ "Los datos no aparecen después de crear"
- [ ] Haz click en "🔄 Recargar"
- [ ] Abre consola (F12) y revisa errores HTTP
- [ ] Verifica que recibiste respuesta 200 OK

### ❌ "Los dropdowns están vacíos"
- [ ] Haz click en "🔄 Recargar" en cada sección
- [ ] Verifica que haya doctores/pacientes en la BD
- [ ] Recarga la página (F5)

### ❌ "Error 500 en el backend"
- [ ] Revisa logs del backend
- [ ] Verifica que la BD esté disponible
- [ ] Comprueba que las tablas existan

---

## 🎯 Prueba Final Completa

Sigue este flujo para verificar TODO:

```bash
# 1. Conectar
✅ Click "Conectar Backend"

# 2. Ver estadísticas iniciales
✅ Anota los números: Total = X, Doctores = Y

# 3. Crear usuario PACIENTE
✅ Nombre: "Test Paciente", Email: "test@paciente.com"

# 4. Crear usuario DOCTOR
✅ Nombre: "Dr. Test", Email: "test@doctor.com"

# 5. Buscar usuario
✅ Busca "test@paciente.com" y verifica datos

# 6. Listar usuarios
✅ Debe estar el usuario test

# 7. Crear cita
✅ Selecciona test paciente + test doctor + fecha/hora

# 8. Listar citas
✅ Debe estar la cita con referencias correctas

# 9. Verificar CRUD
✅ Botón "Verificar Usuarios" → Debe incluir tests
✅ Botón "Verificar Doctores" → Debe incluir tests
✅ Botón "Verificar Citas" → Debe incluir tests

# 10. Final
✅ Estadísticas actualizadas: Total = X+1, Doctores = Y+1

✅✅✅ SI COMPLETÓ TODO → CRUD FUNCIONA CORRECTAMENTE
```

---

## 📝 Reporte de Problemas

Si encuentras un problema:

1. **Anota exactamente qué hiciste**
2. **Copia el error de la consola (F12)**
3. **Toma screenshot del resultado esperado vs actual**
4. **Ejecuta este comando:**

```bash
# Ver logs del backend
Get-Content backend-log.txt -Tail 50

# O en tiempo real
Get-Content backend-log.txt -Wait
```

---

## ✅ Estado Final

Cuando todo esté verificado, deberías tener:

- ✅ **Usuarios CRUD funcionando** (Create, Read, Update, Delete)
- ✅ **Doctores CRUD funcionando**
- ✅ **Citas CRUD funcionando**
- ✅ **Dropdowns sincronizados con BD**
- ✅ **Frontend y Backend en sincronía**
- ✅ **Estadísticas correctas**

---

**Documento creado**: 4 de diciembre de 2025  
**Para**: Sistema SIGC Backend Testing
