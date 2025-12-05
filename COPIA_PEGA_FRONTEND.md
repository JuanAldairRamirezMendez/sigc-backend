# 🎯 PROMPT LISTO PARA COPIAR Y PEGAR EN EL FRONTEND

## Para el Repositorio: https://github.com/Zahel-sys/sigc-frontend.git

---

## ✂️ PASO 1: Crear archivo `.env`

**Ubicación:** Raíz del proyecto frontend (donde está `package.json`)

**Contenido (copia y pega esto):**

```
# ================================
# SIGC Frontend Environment Variables
# ================================

# API Configuration
VITE_API_URL=http://localhost:8080

# Application Configuration
VITE_APP_NAME=SIGC Clínica
VITE_APP_VERSION=1.0.0

# CORS Configuration (if needed)
VITE_CORS_ENABLED=true

# Logging
VITE_LOG_LEVEL=debug
```

---

## ✂️ PASO 2: Crear archivo `.env.example`

**Ubicación:** Raíz del proyecto frontend

**Contenido (copia y pega esto):**

```
# ================================
# SIGC Frontend Environment Variables - EXAMPLE
# ================================
# Copy this file to .env and fill in your own values

# API Configuration - Change based on environment
# For Development: http://localhost:8080
# For Production: https://sigc-backend.onrender.com (or your production backend URL)
VITE_API_URL=http://localhost:8080

# Application Configuration
VITE_APP_NAME=SIGC Clínica
VITE_APP_VERSION=1.0.0

# CORS Configuration (if needed)
VITE_CORS_ENABLED=true

# Logging - debug, info, warn, error
VITE_LOG_LEVEL=debug
```

---

## ✂️ PASO 3: Reemplazar `src/services/api.js`

**Ubicación:** `src/services/api.js`

**Acción:** Reemplaza TODO el contenido con esto:

```javascript
import axios from "axios";

// Leer la URL base desde la variable de entorno
// Si no existe, usa http://localhost:8080 como fallback
const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8080";

console.log("🔗 API URL configurada:", API_URL);

const api = axios.create({
  baseURL: API_URL,
  timeout: 10000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptor para agregar el token automáticamente a todas las peticiones
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
        console.error("Error al parsear usuario del localStorage:", e);
      }
    }
    
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor para manejar errores 401 (token expirado/inválido)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Solo limpiar y redirigir si NO estamos en rutas públicas
      const rutasPublicas = ['/login', '/registrar', '/especialidades', '/turnos'];
      const rutaActual = window.location.pathname;
      
      const esRutaPublica = rutasPublicas.some(ruta => rutaActual.startsWith(ruta));
      
      if (!esRutaPublica) {
        console.warn("⚠️ Token expirado o inválido. Redirigiendo al login...");
        localStorage.clear();
        window.location.href = "/login";
      }
    }
    return Promise.reject(error);
  }
);

export default api;
```

---

## ✂️ PASO 4: Actualizar `.gitignore`

**Ubicación:** Raíz del proyecto frontend

**Acción:** Añade estas líneas al final de `.gitignore`:

```
# Environment Variables
.env
.env.local
.env.*.local

# Logs
*.log
npm-debug.log*

# OS
.DS_Store
Thumbs.db
```

---

## ✅ PASO 5: Instalar y Ejecutar

```bash
# 1. Navegar al proyecto
cd sigc-frontend

# 2. Instalar dependencias
npm install

# 3. Ejecutar en desarrollo
npm run dev
```

---

## 🔍 PASO 6: Verificar que Todo Funciona

1. **Abre el navegador** en `http://localhost:5173`

2. **Abre DevTools** (F12) → pestaña **Console**
   - Busca el mensaje: `🔗 API URL configurada: http://localhost:8080`

3. **Prueba el Login:**
   - Ve a Login
   - Abre DevTools → pestaña **Network**
   - Intenta iniciar sesión
   - Verifica que las requests vayan a `http://localhost:8080`

---

## 📊 Checklist

- [ ] Archivo `.env` creado en la raíz
- [ ] Archivo `.env.example` creado en la raíz
- [ ] `src/services/api.js` completamente reemplazado
- [ ] `.gitignore` actualizado con `.env`
- [ ] `npm install` ejecutado
- [ ] Backend está corriendo en `http://localhost:8080`
- [ ] Frontend ejecutándose con `npm run dev`
- [ ] Console muestra: `🔗 API URL configurada: http://localhost:8080`
- [ ] Network tab muestra requests a `localhost:8080`
- [ ] Login funciona sin errores

---

## 🚀 Para Cambiar a Producción (Después)

Solo necesitas cambiar el valor en `.env`:

```env
# Antes (desarrollo)
VITE_API_URL=http://localhost:8080

# Después (producción)
VITE_API_URL=https://sigc-backend.onrender.com
```

**¡Sin tocar código! Solo cambias la variable de entorno y redeploy.**

---

## ❓ Si Algo Sale Mal

**Error: Cannot find module 'axios'**
```bash
npm install axios
```

**Error: 404 en los endpoints**
- Verifica que el backend está corriendo: `http://localhost:8080`
- Comprueba que `VITE_API_URL` es correcto

**Error: CORS error**
- Verifica que el backend tiene `http://localhost:5173` en `CORS_ALLOWED_ORIGINS`

**Error: Token issue**
- Borra localStorage: `localStorage.clear()` en la consola
- Intenta login nuevamente

---

✅ **¡Listo! Tu frontend está configurado correctamente.**
