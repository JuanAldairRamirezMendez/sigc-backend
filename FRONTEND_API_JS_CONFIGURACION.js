// ============================================================================
// INSTRUCCIONES PARA src/services/api.js DEL FRONTEND
// ============================================================================
// 
// Reemplaza TODO el contenido del archivo src/services/api.js con esto:
//
// ============================================================================

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

// ============================================================================
// FIN DEL ARCHIVO api.js
// ============================================================================
