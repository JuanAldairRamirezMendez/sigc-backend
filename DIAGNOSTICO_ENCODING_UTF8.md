# 🔍 DIAGNÓSTICO: Error UTF-8 en Endpoints POST/PUT

## Problema Identificado

El backend está recibiendo **JSON con codificación UTF-8 incorrecta** desde el cliente, causando:

```
Invalid UTF-8 middle byte 0x61
JsonMappingException at [Source: line 3, column 22]
```

## Causas Posibles

### 1. **Frontend No Está Usando JSON.stringify() Correctamente**
   - Problema: Enviando strings sin serializar
   - Solución: Usar `JSON.stringify(objeto)`

### 2. **Content-Type Header Incorrecto**
   - Problema: No enviar `Content-Type: application/json`
   - Solución: Establecer header correctamente en fetch

### 3. **Encoding del Request Body**
   - Problema: La corporación no está en UTF-8
   - Solución: PowerShell convierte strings con codificación local

## Rutas Disponibles (CORRECTAS)

```
✅ POST   /doctores/json              → Crea doctor (JSON)
✅ PUT    /doctores/{id}/json         → Actualiza doctor (JSON)
✅ POST   /doctores/multipart         → Crea doctor (con imagen)
✅ PUT    /doctores/{id}/multipart    → Actualiza doctor (con imagen)
✅ GET    /doctores                   → Lista todos
✅ GET    /doctores/{id}              → Obtiene uno
✅ DELETE /doctores/{id}              → Elimina
```

## Cómo Debe Enviar el Frontend

### JavaScript/Fetch (CORRECTO)
```javascript
const payload = {
    nombre: "Juan",
    apellido: "Perez",
    telefono: "987654321",
    correo: "juan@test.com",
    especialidadId: 1
};

fetch('http://localhost:8080/doctores/json', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'  // ✅ IMPORTANTE
    },
    body: JSON.stringify(payload)  // ✅ IMPORTANTE
})
```

### JavaScript/Axios (CORRECTO)
```javascript
axios.post('http://localhost:8080/doctores/json', {
    nombre: "Juan",
    apellido: "Perez",
    telefono: "987654321",
    correo: "juan@test.com",
    especialidadId: 1
}, {
    headers: {
        'Content-Type': 'application/json'
    }
})
```

## Qué NO Hacer

❌ Enviar datos como `form-urlencoded` al endpoint `/json`
❌ Olvidar el header `Content-Type: application/json`
❌ No usar `JSON.stringify()` en el body
❌ Enviar caracteres con acentos sin UTF-8 correcto

## Validaciones Backend

```java
// En DoctorCreateRequest
@NotBlank  // nombre
@Pattern(regexp = "^[0-9]{9}$")  // telefono: 9 dígitos
@Email  // correo válido
@Positive  // especialidadId > 0
```

## Pruebas Recomendadas

1. **Abrir `test-doctores-json.html` en navegador**
   - Localización: `c:\Users\LEONARDO\sigc-backend\test-doctores-json.html`
   - Esto enviará JSON correctamente codificado

2. **Si funciona desde el HTML**, el problema está en el frontend
3. **Si falla desde el HTML**, el problema está en el backend

## Próximos Pasos

1. ✅ Prueba los endpoints desde el archivo HTML
2. ✅ Si funcionan, actualiza el frontend para usar fetch/axios correctamente
3. ✅ Si falla, revisar logs de Spring Boot para detalles

## Referencias

- **Validaciones**: `com.sigc.backend.dto.DoctorCreateRequest`
- **Controlador**: `com.sigc.backend.controller.DoctorController`
- **Logs**: Revisar errores de deserialisación en consola
