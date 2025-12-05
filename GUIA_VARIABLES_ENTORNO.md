# 🔧 GUÍA DE CONFIGURACIÓN CON VARIABLES DE ENTORNO

## Conexión Backend-Frontend con .env

Este documento explica cómo conectar el backend y frontend usando variables de entorno profesionalmente.

---

## 📋 BACKEND - Configuración

### 1. Archivo `.env` ya creado

En la raíz de `sigc-backend` ya existe el archivo `.env` con todas las configuraciones:

```env
SERVER_PORT=8080
SPRING_DATASOURCE_URL=jdbc:h2:mem:sigcdb;...
JWT_SECRET=sigc-secret-key-2025-...
CORS_ALLOWED_ORIGINS=http://localhost:5173,...
APP_UPLOAD_DIR=uploads/
```

### 2. Cómo funciona

El archivo `src/main/resources/application.properties` ha sido actualizado para leer estas variables:

```properties
server.port=${SERVER_PORT:8080}
spring.datasource.url=${SPRING_DATASOURCE_URL:...}
jwt.secret=${JWT_SECRET:...}
app.upload.dir=${APP_UPLOAD_DIR:uploads/}
```

**Sintaxis:** `${NOMBRE_VARIABLE:valor_por_defecto}`

### 3. Para ejecutar el backend

**Opción A: Con las variables de .env automáticamente (requiere Maven plugin)**
```bash
mvn spring-boot:run
```

**Opción B: Pasar variables manualmente**
```bash
java -Dspring.config.import=optional:file:.env \
  -Dspring.profiles.active= \
  -jar target/backend-0.0.1-SNAPSHOT.jar
```

**Opción C: Usar directamente los valores de .env (recomendado en desarrollo)**
```bash
# Windows PowerShell
Get-Content .env | ForEach-Object {
  if ($_ -match '^\s*([^=]+)=(.*)$') {
    [Environment]::SetEnvironmentVariable($matches[1], $matches[2])
  }
}
java -jar target/backend-0.0.1-SNAPSHOT.jar
```

---

## 📋 FRONTEND - Configuración

### 1. Archivos a crear/actualizar

#### A. `.env` en la raíz del frontend

```env
# API Configuration
VITE_API_URL=http://localhost:8080

# Application Configuration
VITE_APP_NAME=SIGC Clínica
VITE_APP_VERSION=1.0.0
```

#### B. `.env.example` (referencia para otros desarrolladores)

```env
# Para desarrollo local
VITE_API_URL=http://localhost:8080

# Para producción
# VITE_API_URL=https://sigc-backend.onrender.com
```

### 2. Actualizar `src/services/api.js`

Reemplaza TODO el contenido con:

```javascript
import axios from "axios";

// Leer la URL base desde la variable de entorno
const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8080";

console.log("🔗 API URL configurada:", API_URL);

const api = axios.create({
  baseURL: API_URL,
  timeout: 10000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptor para agregar el token automáticamente
api.interceptors.request.use(
  (config) => {
    const usuario = localStorage.getItem("usuario");
    if (usuario) {
      try {
        const user = JSON.parse(usuario);
        if (user.token) {
          config.headers.Authorization = `Bearer ${user.token}`;
        }
      } catch (e) {
        console.error("Error al parsear usuario:", e);
      }
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Interceptor para manejar 401 (token expirado)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      const rutasPublicas = ['/login', '/registrar', '/especialidades', '/turnos'];
      const rutaActual = window.location.pathname;
      const esRutaPublica = rutasPublicas.some(ruta => rutaActual.startsWith(ruta));
      
      if (!esRutaPublica) {
        console.warn("⚠️ Token expirado. Redirigiendo al login...");
        localStorage.clear();
        window.location.href = "/login";
      }
    }
    return Promise.reject(error);
  }
);

export default api;
```

### 3. Ejecutar el frontend

```bash
cd sigc-frontend
npm install
npm run dev
```

El frontend accederá automáticamente a la URL definida en `VITE_API_URL`.

---

## ✅ Verificación

1. **Backend corriendo en puerto 8080:**
   ```bash
   # Desde PowerShell
   Invoke-WebRequest -Uri "http://localhost:8080/especialidades" -Method GET
   ```

2. **Frontend accediendo correctamente:**
   - Abre DevTools (F12) en el navegador
   - Ve a la pestaña **Network**
   - Intenta hacer login
   - Verifica que las requests vayan a `http://localhost:8080` (o la URL en .env)

3. **Ver la URL configurada en consola:**
   - Abre DevTools (F12)
   - Ve a la pestaña **Console**
   - Deberías ver: `🔗 API URL configurada: http://localhost:8080`

---

## 🚀 Para Cambiar a Producción

### Backend

Crea un archivo `.env.production`:

```env
SERVER_PORT=8080
SPRING_DATASOURCE_URL=jdbc:mysql://tu-host:3306/sigc_prod
SPRING_DATASOURCE_USERNAME=usuario_prod
SPRING_DATASOURCE_PASSWORD=password_prod
JWT_SECRET=tu-secret-key-seguro-produccion
CORS_ALLOWED_ORIGINS=https://tu-frontend-url.com
```

### Frontend

Crea un archivo `.env.production`:

```env
VITE_API_URL=https://tu-backend-produccion.com
VITE_LOG_LEVEL=warn
```

---

## 📝 Resumen

| Archivo | Ubicación | Propósito |
|---------|-----------|----------|
| `.env` | `sigc-backend/` | Variables de entorno del backend |
| `.env.example` | `sigc-backend/` | Plantilla para otros desarrolladores |
| `.env` | `sigc-frontend/` | Variables de entorno del frontend |
| `.env.example` | `sigc-frontend/` | Plantilla para otros desarrolladores |
| `application.properties` | `sigc-backend/src/main/resources/` | Lee variables de .env |
| `api.js` | `sigc-frontend/src/services/` | Lee VITE_API_URL |

---

## ❓ Preguntas Frecuentes

**P: ¿Debo hacer commit de .env?**
R: NO. Añade `.env` a `.gitignore`. Solo committe `.env.example`.

**P: ¿Qué pasa si no existe la variable en .env?**
R: Se usa el valor por defecto definido después del `:` (ej. `${PORT:8080}`)

**P: ¿Cómo cambiar a producción rápidamente?**
R: Solo cambia la variable `VITE_API_URL` en `.env` a la URL de producción, sin tocar código.

---

✅ **¡Listo! Ahora todo está configurado profesionalmente con variables de entorno.**
