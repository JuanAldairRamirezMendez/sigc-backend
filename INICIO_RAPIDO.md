# ⚡ INICIO RÁPIDO - Panel de Control SIGC

## 🚀 En 3 Pasos

### Paso 1: Compilar y Ejecutar Backend
```powershell
cd c:\Users\LEONARDO\sigc-backend
.\iniciar-dashboard.ps1
# Selecciona opción 1
# Espera a que diga "APPLICATION STARTED"
```

### Paso 2: Abrir Dashboard
```powershell
# En OTRA terminal
.\iniciar-dashboard.ps1
# Selecciona opción 3
# Se abre automáticamente en el navegador
```

### Paso 3: Conectar y Usar
```
En el navegador:
1. La URL ya está: http://localhost:8080
2. Click azul: "🔗 Conectar Backend"
3. Espera el mensaje verde "✅ Conectado"
4. ¡Ahora puedes ver y editar tu BD!
```

---

## 📝 Tareas Comunes

### Ver todos los usuarios
```
1. Dashboard → "👥 Gestión de Usuarios"
2. Tab "Listar"
3. Click "🔄 Recargar Usuarios"
```

### Crear un nuevo usuario
```
1. Dashboard → "👥 Gestión de Usuarios"
2. Tab "Crear"
3. Completa los campos
4. Click "✅ Crear Usuario"
```

### Crear un doctor
```
1. Dashboard → "👨‍⚕️ Gestión de Doctores"
2. Tab "Crear"
3. Ingresa datos
4. Click "✅ Crear Doctor"
```

### Crear una cita
```
1. Dashboard → "📅 Gestión de Citas"
2. Tab "Crear"
3. Selecciona paciente del dropdown
4. Selecciona doctor del dropdown
5. Elige fecha y hora
6. Click "✅ Crear Cita"
```

### Verificar que CRUD funciona
```
1. Dashboard → Baja hasta "✅ Verificación de CRUD"
2. Click en "📝 Verificar Usuarios"
3. Aparece un JSON con todos los datos
4. Verifica que los números coincidan
```

---

## 🔍 Hacer Pruebas desde PowerShell

```powershell
# En una terminal nueva:
cd c:\Users\LEONARDO\sigc-backend
.\test-crud-completo.ps1

# Selecciona opciones del menú:
# 1 = Login (obtener token)
# 5 = Ver estadísticas
# 9 = Listar usuarios
# 11 = Crear usuario
# 15 = Crear cita
# etc.
```

---

## ✅ Checklist de Verificación

- [ ] Backend compilado y corriendo
- [ ] Dashboard abierto en navegador
- [ ] Conectado al backend (mensaje verde)
- [ ] Estadísticas muestran números correctos
- [ ] Puedes listar usuarios
- [ ] Puedes crear un usuario
- [ ] El nuevo usuario aparece en la lista
- [ ] Los dropdowns muestran doctores y pacientes
- [ ] Puedes crear una cita
- [ ] La cita aparece en el listado
- [ ] "Verificar CRUD" muestra JSON válido

---

## 🆘 Si Algo Falla

### "No se puede conectar"
```
1. Verifica que el backend esté corriendo
2. En la terminal del backend debe decir:
   "APPLICATION STARTED in X seconds"
3. Intenta la URL en navegador: http://localhost:8080/auth/health
```

### "Error 401 - No autorizado"
```
1. El login automático falló
2. Solución: 
   - Para el backend (Ctrl+C)
   - Compila de nuevo
   - Ejecuta nuevamente
```

### "Los dropdowns están vacíos"
```
1. Click en "🔄 Recargar Usuarios"
2. Click en "🔄 Recargar Doctores"
3. Recarga la página (F5)
4. Intenta de nuevo
```

### "Cita no se crea"
```
1. Verifica que hayas seleccionado paciente Y doctor
2. Ingresa una fecha futura
3. Ingresa una hora válida (ej: 14:30)
4. Mira los errores en la consola (F12)
```

---

## 📚 Documentación

Para información completa, lee estos archivos:

| Archivo | Contenido |
|---------|----------|
| `DASHBOARD_GUIA_USO.md` | Guía completa del dashboard |
| `VERIFICACION_CRUD_PASO_A_PASO.md` | Pruebas detalladas |
| `SOLUCION_PANEL_CONTROL_BD.md` | Resumen de la solución |
| `ARQUITECTURA_SOLUCION.md` | Diagramas y flujos |

---

## 🎯 Próximos Pasos

1. **Verificar que todo funciona** → Sigue el checklist
2. **Crear datos de prueba** → Usa el dashboard
3. **Validar integridad** → Usa "Verificar CRUD"
4. **Si hay errores** → Anota exactamente qué pasó
5. **Reporta problemas** → Con screenshot y logs

---

**Solución creada:** 4 de diciembre de 2025  
**Última actualización:** 4 de diciembre de 2025
