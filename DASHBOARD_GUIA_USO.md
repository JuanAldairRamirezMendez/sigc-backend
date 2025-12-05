# 🏥 Panel de Control SIGC - Guía de Uso

## 📋 Descripción

Este es un **panel de control interactivo** para visualizar y verificar tu base de datos SIGC en tiempo real. Te permite:

- ✅ Ver todos los usuarios, doctores y citas
- ✅ Crear, editar y eliminar registros
- ✅ Verificar que el CRUD funciona correctamente en cada módulo
- ✅ Asegurar que todo en el frontend esté acorde con la base de datos
- ✅ Validar integridad de datos con dropdowns dinámicos

---

## 🚀 Cómo Usar

### 1. Abrir el Dashboard

Abre el archivo `database-dashboard.html` en tu navegador:

```
file:///C:/Users/LEONARDO/sigc-backend/database-dashboard.html
```

O desde VS Code:
- Click derecho en `database-dashboard.html`
- Selecciona "Open with Live Server"

### 2. Conectar al Backend

1. Asegúrate que tu backend esté corriendo en `http://localhost:8080`
2. En el panel, ingresa la URL del backend (por defecto `http://localhost:8080`)
3. Haz clic en el botón **"🔗 Conectar Backend"**

El panel se conectará automáticamente y realizará login como admin.

### 3. Funcionalidades

#### 📊 Estadísticas
- Muestra total de usuarios, doctores, pacientes y administradores
- Se actualiza automáticamente al conectar

#### 👥 Gestión de Usuarios
- **Crear**: Agrega nuevos usuarios con roles (PACIENTE, DOCTOR, ADMIN)
- **Listar**: Ve todos los usuarios con sus detalles
- **Buscar**: Busca usuarios por email

#### 👨‍⚕️ Gestión de Doctores
- **Crear**: Agrega nuevos doctores
- **Listar**: Ve todos los doctores disponibles
- Los doctores aparecen automáticamente en el dropdown al crear citas

#### 📅 Gestión de Citas
- **Crear**: Crea citas asociando paciente, doctor, fecha y hora
- **Listar**: Ve todas las citas
- Los dropdowns se llenan automáticamente con datos de la BD

#### ✅ Verificación de CRUD
Hay botones para verificar que cada módulo funciona correctamente:

- **Verificar Usuarios**: Muestra todos los usuarios, conteos por rol, estado
- **Verificar Doctores**: Muestra doctores y especialidades
- **Verificar Citas**: Muestra citas con referencias cruzadas
- **Verificar Especialidades**: Muestra especialidades disponibles

---

## 🔧 Endpoints Disponibles

El backend ahora expone estos endpoints de debug:

### Health Check
```
GET /auth/health
```
Verifica que el backend esté corriendo.

### Ver Estadísticas de BD
```
GET /api/debug/database-status
```

Respuesta:
```json
{
  "status": "OK",
  "timestamp": "2025-12-04T23:15:10.000Z",
  "statistics": {
    "usuarios": 5,
    "doctores": 3,
    "citas": 10,
    "especialidades": 8
  }
}
```

### Verificar CRUD de Usuarios
```
GET /api/debug/crud/usuarios
```

### Verificar CRUD de Doctores
```
GET /api/debug/crud/doctores
```

### Verificar CRUD de Citas
```
GET /api/debug/crud/citas
```

### Verificar CRUD de Especialidades
```
GET /api/debug/crud/especializaciones
```

---

## 🗄️ Base de Datos

La herramienta se conecta a tu base de datos SIGC verificando:

### Tabla `usuarios`
- ID, Nombre, Email, Contraseña, DNI, Teléfono
- Rol (ADMIN, DOCTOR, PACIENTE)
- Estado (Activo/Inactivo)
- Fecha de Registro

### Tabla `doctores`
- ID, ID Usuario, Especialidad, Estado
- Se sincroniza automáticamente con usuarios

### Tabla `citas`
- ID, ID Paciente, ID Doctor, Fecha, Hora
- Estado (PENDIENTE, CONFIRMADA, CANCELADA)
- Motivo/Descripción

---

## 🔐 Credenciales

El dashboard usa automáticamente:
- **Email**: `admin@sigc.com`
- **Contraseña**: `Admin123456`

Para cambiar, edita estas líneas en el archivo:

```javascript
// Busca en database-dashboard.html la función loginAsAdmin()
email: 'admin@sigc.com',
password: 'Admin123456'
```

---

## 🐛 Solución de Problemas

### "No se pudo conectar"
- Verifica que el backend esté corriendo
- Comprueba que esté en `http://localhost:8080`
- Revisa la consola (F12) para ver errores

### "Error 401 - No autorizado"
- El login automático falló
- Verifica que `admin@sigc.com` existe en la BD
- Si la contraseña cambió, actualízala en el dashboard

### Los dropdowns están vacíos
- Haz clic en "🔄 Recargar" en cada sección
- Asegúrate de que haya doctores/pacientes en la BD

### No aparecen los datos después de crear
- Haz clic en "🔄 Recargar" después de crear
- Verifica que el backend devolvió 200 OK

---

## 📝 Validación de Integridad

Para verificar que todo está correcto:

1. **Crea un usuario** como DOCTOR
2. **Ve a Gestión de Doctores** → debe aparecer en el listado
3. **Ve a Crear Cita** → debe aparecer en el dropdown de doctores
4. **Verifica el CRUD de Citas** → la cita debe estar en la base de datos
5. **Busca el usuario** → todos sus datos deben ser correctos

---

## 🎯 Flujo Completo de Verificación

1. **Conectar** → Click en "Conectar Backend"
2. **Ver Estadísticas** → Verifica que los números sean correctos
3. **Crear un Usuario Test** → Ingresa datos y haz click en "Crear Usuario"
4. **Verificar en Listado** → Recarga y busca el nuevo usuario
5. **Verificar en Dropdown** → Crea una cita y verifica que aparezca
6. **Ejecutar Verificación CRUD** → Haz click en "Verificar Usuarios"
7. **Validar JSON** → Los datos deben coincidir con lo que ves en pantalla

---

## 💡 Tips

- **Auto-refresh**: Los datos no se auto-actualizan. Haz click en "🔄 Recargar" después de cambios
- **Timestamps**: Cada verificación CRUD muestra la marca de tiempo
- **Logs**: Abre F12 (DevTools) para ver los logs de las llamadas HTTP
- **Roles**: El dropdown de roles permite crear ADMIN, DOCTOR o PACIENTE
- **Búsqueda**: Busca usuarios por el email exacto

---

## 🔄 Actualizando el Dashboard

Si cambias algo en tu backend:

1. Cierra el navegador
2. Compila el backend: `mvn clean package`
3. Inicia el backend
4. Abre nuevamente el dashboard

---

## 📞 Soporte

Si algo no funciona:

1. Abre la **consola del navegador** (F12)
2. Revisa los errores
3. Verifica que el backend esté corriendo
4. Comprueba la URL del backend
5. Valida que el usuario admin exista

---

**Creado para**: Sistema Integral de Gestión de Citas (SIGC)  
**Versión**: 1.0  
**Última actualización**: 4 de diciembre de 2025
