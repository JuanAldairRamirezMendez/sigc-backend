# 🚀 INSTRUCCIONES PARA EL FRONTEND

## Pasos a Realizar en el Repositorio Frontend

Sigue estos pasos para conectar el frontend (`https://github.com/Zahel-sys/sigc-frontend.git`) con el backend local.

---

## 1️⃣ Clonar el Frontend (si no lo tienes)

```bash
git clone https://github.com/Zahel-sys/sigc-frontend.git
cd sigc-frontend
```

---

## 2️⃣ Crear Archivo `.env`

En la **raíz del proyecto frontend**, crea un archivo llamado `.env`:

```bash
# PowerShell
New-Item -Path ".env" -ItemType File -Force
```

O crea el archivo manualmente con este contenido:

```env
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

## 3️⃣ Actualizar `src/services/api.js`

Reemplaza **TODO el contenido** del archivo `src/services/api.js` con esto:

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

## 4️⃣ Instalar Dependencias

```bash
npm install
```

---

## 5️⃣ Verificar que el Backend está Corriendo

Antes de ejecutar el frontend, asegúrate que el backend esté en `http://localhost:8080`:

```bash
# Prueba desde PowerShell
Invoke-WebRequest -Uri "http://localhost:8080/especialidades" -Method GET
```

Deberías recibir una respuesta JSON con las especialidades.

---

## 6️⃣ Ejecutar el Frontend

```bash
npm run dev
```

Deberías ver algo como:

```
  VITE v5.0.0  ready in 234 ms

  ➜  Local:   http://localhost:5173/
  ➜  press h to show help
```

---

## 7️⃣ Verificar que Todo Funciona

1. **Abre el navegador** en `http://localhost:5173`

2. **Abre DevTools** (F12) → pestaña **Console**
   - Deberías ver: `🔗 API URL configurada: http://localhost:8080`

3. **Prueba el Login:**
   - Ve a Login
   - Abre DevTools → pestaña **Network**
   - Intenta iniciar sesión
   - Verifica que las requests vayan a `http://localhost:8080/auth/login`

4. **Registra un Usuario Nuevo:**
   - Usa el formulario de registro
   - Verifica que vaya a `http://localhost:8080/auth/register`

5. **Ver Especialidades:**
   - Navega a Especialidades
   - Verifica que carguen desde `http://localhost:8080/especialidades`

---

## ✅ Checklist Final

- [ ] Archivo `.env` creado en la raíz con `VITE_API_URL=http://localhost:8080`
- [ ] Archivo `src/services/api.js` actualizado a leer `import.meta.env.VITE_API_URL`
- [ ] `npm install` ejecutado
- [ ] Backend corriendo en `http://localhost:8080`
- [ ] Frontend ejecutándose en `http://localhost:5173`
- [ ] Console muestra `🔗 API URL configurada: http://localhost:8080`
- [ ] Network tab muestra requests a `localhost:8080`
- [ ] Login funciona correctamente
- [ ] Datos se cargan desde el backend

---

## 🚀 Para Cambiar a Producción

Simplemente cambia el valor en `.env`:

```env
# Antes (desarrollo)
VITE_API_URL=http://localhost:8080

# Después (producción)
VITE_API_URL=https://sigc-backend.onrender.com
```

**No es necesario cambiar código.** Solo cambia la variable de entorno y redeploy.

---

## ❓ Errores Comunes

### Error: "Cannot GET /especialidades"
- **Causa:** Backend no está corriendo
- **Solución:** Ejecuta `java -jar target/backend-0.0.1-SNAPSHOT.jar` en la carpeta del backend

### Error: "CORS error"
- **Causa:** El backend no tiene CORS configurado para tu URL
- **Solución:** Verifica que `CORS_ALLOWED_ORIGINS` en `.env` del backend incluya `http://localhost:5173`

### Error: "API_URL is undefined"
- **Causa:** El archivo `.env` no está siendo leído
- **Solución:** Reinicia el servidor (`npm run dev`)

### Error: "401 Unauthorized"
- **Causa:** Token no enviado o inválido
- **Solución:** Verifica que el token se guarde en localStorage después del login

---

✅ **¡Listo! Tu frontend debería estar conectado correctamente con el backend local.**

Si tienes problemas, revisa los logs en:
- **Backend:** Consola de Maven
- **Frontend:** DevTools (F12) → Console y Network
