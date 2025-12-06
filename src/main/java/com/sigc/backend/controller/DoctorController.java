package com.sigc.backend.controller;

import com.sigc.backend.application.service.EspecialidadApplicationService;
import com.sigc.backend.domain.model.Doctor;
import com.sigc.backend.dto.DoctorCreateRequest;
import com.sigc.backend.dto.DoctorUpdateRequest;
import com.sigc.backend.service.NotificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping("/doctores")
@CrossOrigin(origins = {"http://localhost:5173"})
@RequiredArgsConstructor
@Tag(name = "Doctores", description = "Gestión de doctores del sistema")
@SecurityRequirement(name = "JWT")
public class DoctorController {

    private final DoctorApplicationService doctorApplicationService;
    private final DoctorMapper doctorMapper;
    private final EspecialidadApplicationService especialidadApplicationService;
    private final NotificationService notificationService;

    @org.springframework.beans.factory.annotation.Value("${app.upload.dir:uploads/}")
    private String appUploadDir; // base upload dir configurable

    private final List<String> EXTENSIONES_PERMITIDAS = Arrays.asList("jpg", "jpeg", "png", "webp");
    private final long MAX_SIZE = 5 * 1024 * 1024;

    @GetMapping
    @Operation(summary = "Listar todos los doctores", description = "Obtiene la lista completa de doctores disponibles")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Lista de doctores obtenida exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    public List<com.sigc.backend.model.Doctor> listar() {
        try {
            List<Doctor> doctors = doctorApplicationService.getAllDoctors();
            return doctors.stream()
                    .map(doctorMapper::toJpaEntity)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            log.error("Error al listar doctores: {}", e.getMessage());
            return Collections.emptyList();
        }
    }

    @PostMapping(value = "/multipart", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Crear doctor con imagen", description = "Crea un nuevo doctor con upload de imagen")
    public ResponseEntity<?> crear(
            @RequestParam("nombre") String nombre,
            @RequestParam("apellido") String apellido,
            @RequestParam("telefono") String telefono,
            @RequestParam("correo") String correo,
            @RequestParam("especialidadId") Long especialidadId,
            @RequestParam(value = "imagen", required = false) MultipartFile imagen) {

        try {
            log.info("📥 POST /doctores - Crear doctor");
            log.info("  - nombre: {}, apellido: {}", nombre, apellido);
            log.info("  - correo: {}, telefono: {}", correo, telefono);
            log.info("  - especialidadId: {}", especialidadId);
            
            // 🔍 Obtener el nombre de la especialidad
            String nombreEspecialidad = null;
            try {
                var especialidad = especialidadApplicationService.getEspecialidadById(especialidadId);
                if (especialidad.isPresent()) {
                    nombreEspecialidad = especialidad.get().getNombre();
                    log.info("  - especialidad encontrada: {}", nombreEspecialidad);
                } else {
                    log.warn("  - especialidad con ID {} no encontrada", especialidadId);
                }
            } catch (Exception e) {
                log.warn("  - error obteniendo especialidad: {}", e.getMessage());
            }
            
            Doctor doctor = Doctor.builder()
                    .nombre(nombre)
                    .apellido(apellido)
                    .telefono(telefono)
                    .correo(correo)
                    .especialidadId(especialidadId)
                    .especialidad(nombreEspecialidad)
                    .cupoPacientes(10)
                    .build();

            if (imagen != null && !imagen.isEmpty()) {
                String rutaImagen = guardarImagen(imagen);
                doctor.setImagen(rutaImagen);
                log.info("  - imagen guardada: {}", rutaImagen);
            }

            Doctor saved = doctorApplicationService.createDoctor(doctor);
            log.info("✅ Doctor creado exitosamente con ID: {}", saved.getIdDoctor());
            
            // 🔔 Enviar notificación de nuevo doctor
            try {
                String mensaje = String.format("Nuevo doctor registrado: Dr. %s %s", 
                    saved.getNombre(), saved.getApellido());
                notificationService.notifyDoctorUpdate(
                    String.valueOf(saved.getIdDoctor()), 
                    mensaje, 
                    doctorMapper.toJpaEntity(saved)
                );
                log.info("✅ Notificación de nuevo doctor enviada");
            } catch (Exception notifEx) {
                log.warn("⚠️ Error enviando notificación de nuevo doctor: {}", notifEx.getMessage());
            }
            
            return ResponseEntity.status(HttpStatus.CREATED).body(doctorMapper.toJpaEntity(saved));

        } catch (IllegalArgumentException e) {
            log.warn("⚠️ Validación fallida al crear doctor: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            log.error("❌ Error al crear doctor: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al crear doctor: " + e.getMessage());
        }
    }

    // ================================================
    // ENDPOINTS JSON (SIN IMAGEN)
    // ================================================
    
    @PostMapping(value = "/json", consumes = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "Crear doctor (JSON)", description = "Crea un nuevo doctor sin imagen usando JSON")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Doctor creado exitosamente"),
        @ApiResponse(responseCode = "400", description = "Datos inválidos"),
        @ApiResponse(responseCode = "401", description = "No autorizado")
    })
    public ResponseEntity<?> crearConJson(@RequestBody DoctorCreateRequest request) {
        try {
            log.info("📥 POST /doctores (JSON) - Crear doctor");
            log.info("  - Datos recibidos: {}", request);
            
            // Usar apellido genérico si no viene especificado
            String apellido = request.getApellido() != null && !request.getApellido().isEmpty() 
                ? request.getApellido() 
                : "N/A";
            
            String telefono = request.getTelefono() != null && !request.getTelefono().isEmpty() 
                ? request.getTelefono() 
                : "0000000000";
            
            String correo = request.getCorreo() != null && !request.getCorreo().isEmpty() 
                ? request.getCorreo() 
                : "noasignado@sigc.local";
            
            // Determinar especialidadId - si viene especialidad (nombre), usar default
            Long especialidadId = request.getEspecialidadId() != null 
                ? request.getEspecialidadId() 
                : 1L; // Default a medicina general
            
            // 🔍 Obtener el nombre de la especialidad
            String nombreEspecialidad = null;
            try {
                var especialidad = especialidadApplicationService.getEspecialidadById(especialidadId);
                if (especialidad.isPresent()) {
                    nombreEspecialidad = especialidad.get().getNombre();
                    log.info("  - especialidad encontrada: {}", nombreEspecialidad);
                } else {
                    log.warn("  - especialidad con ID {} no encontrada", especialidadId);
                }
            } catch (Exception e) {
                log.warn("  - error obteniendo especialidad: {}", e.getMessage());
            }
            
            Doctor doctor = Doctor.builder()
                    .nombre(request.getNombre())
                    .apellido(apellido)
                    .telefono(telefono)
                    .correo(correo)
                    .especialidadId(especialidadId)
                    .especialidad(nombreEspecialidad)
                    .cupoPacientes(10)
                    .build();

            Doctor saved = doctorApplicationService.createDoctor(doctor);
            log.info("✅ Doctor creado exitosamente con ID: {}", saved.getIdDoctor());
            
            // Enviar notificación
            try {
                String mensaje = String.format("Nuevo doctor registrado: Dr. %s %s", 
                    saved.getNombre(), saved.getApellido());
                notificationService.notifyDoctorUpdate(
                    String.valueOf(saved.getIdDoctor()), 
                    mensaje, 
                    doctorMapper.toJpaEntity(saved)
                );
                log.info("✅ Notificación de nuevo doctor enviada");
            } catch (Exception notifEx) {
                log.warn("⚠️ Error enviando notificación: {}", notifEx.getMessage());
            }
            
            return ResponseEntity.status(HttpStatus.CREATED).body(doctorMapper.toJpaEntity(saved));

        } catch (IllegalArgumentException e) {
            log.warn("⚠️ Validación fallida al crear doctor: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            log.error("❌ Error al crear doctor: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al crear doctor: " + e.getMessage());
        }
    }

    @PutMapping(value = "/{id}/json", consumes = MediaType.APPLICATION_JSON_VALUE)
    @Operation(summary = "Actualizar doctor (JSON)", description = "Actualiza un doctor sin imagen usando JSON")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Doctor actualizado exitosamente"),
        @ApiResponse(responseCode = "400", description = "Datos inválidos"),
        @ApiResponse(responseCode = "404", description = "Doctor no encontrado"),
        @ApiResponse(responseCode = "401", description = "No autorizado")
    })
    public ResponseEntity<?> actualizarConJson(
            @PathVariable Long id, 
            @RequestBody DoctorUpdateRequest request) {
        try {
            log.info("📥 PUT /doctores/{} (JSON)", id);
            log.info("  - Datos recibidos: {}", request);
            
            Doctor existente = doctorApplicationService.getDoctorById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Doctor no encontrado"));

            // Actualizar campo nombre si viene en el request
            if (request.getNombre() != null && !request.getNombre().trim().isEmpty()) {
                existente.setNombre(request.getNombre().trim());
            }
            
            // Actualizar campo apellido si viene en el request (sino mantener el existente)
            if (request.getApellido() != null && !request.getApellido().trim().isEmpty()) {
                existente.setApellido(request.getApellido().trim());
            }
            
            // Actualizar campo telefono si viene en el request
            if (request.getTelefono() != null && !request.getTelefono().trim().isEmpty()) {
                existente.setTelefono(request.getTelefono().trim());
            }
            
            // Actualizar campo correo si viene en el request
            if (request.getCorreo() != null && !request.getCorreo().trim().isEmpty()) {
                existente.setCorreo(request.getCorreo().trim());
            }
            
            // Actualizar especialidadId si viene en el request (sino usar especialidad por nombre o mantener)
            if (request.getEspecialidadId() != null) {
                existente.setEspecialidadId(request.getEspecialidadId());
            }
            
            // Actualizar cupoPacientes si viene en el request
            if (request.getCupoPacientes() != null) {
                existente.setCupoPacientes(request.getCupoPacientes());
            }

            Doctor doctorGuardado = doctorApplicationService.updateDoctor(id, existente);
            log.info("✅ Doctor actualizado exitosamente: {}", id);
            
            // Enviar notificación
            try {
                String mensaje = String.format("Información actualizada: Dr. %s %s", 
                    doctorGuardado.getNombre(), doctorGuardado.getApellido());
                notificationService.notifyDoctorUpdate(
                    String.valueOf(id), 
                    mensaje, 
                    doctorMapper.toJpaEntity(doctorGuardado)
                );
                log.info("✅ Notificación enviada");
            } catch (Exception notifEx) {
                log.warn("⚠️ Error enviando notificación: {}", notifEx.getMessage());
            }
            
            return ResponseEntity.ok(doctorMapper.toJpaEntity(doctorGuardado));

        } catch (IllegalArgumentException e) {
            log.warn("⚠️ Error de validación: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            log.error("❌ Error al actualizar doctor: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al actualizar doctor: " + e.getMessage());
        }
    }

    // ================================================
    // ENDPOINTS MULTIPART (CON IMAGEN)
    // ================================================

    @PutMapping(value = "/{id}/multipart", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Actualizar doctor con imagen", description = "Actualiza un doctor con posibilidad de subir imagen")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Doctor actualizado exitosamente"),
        @ApiResponse(responseCode = "400", description = "Datos inválidos"),
        @ApiResponse(responseCode = "404", description = "Doctor no encontrado")
    })
    public ResponseEntity<?> actualizarConImagen(
            @PathVariable Long id,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String apellido,
            @RequestParam(required = false) String telefono,
            @RequestParam(required = false) String correo,
            @RequestParam(required = false) Long especialidadId,
            @RequestParam(value = "imagen", required = false) MultipartFile imagen) {

        try {
            log.info("📥 PUT /doctores/{}", id);
            log.info("  - nombre: {}, apellido: {}", nombre, apellido);
            log.info("  - correo: {}, telefono: {}", correo, telefono);
            log.info("  - especialidadId: {}", especialidadId);
            log.info("  - imagenFile: {}", imagen != null ? imagen.getOriginalFilename() : "null");
            
            Doctor existente = doctorApplicationService.getDoctorById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Doctor no encontrado"));

            // Actualizar solo los campos que vienen
            if (nombre != null && !nombre.trim().isEmpty()) {
                existente.setNombre(nombre.trim());
            }
            if (apellido != null && !apellido.trim().isEmpty()) {
                existente.setApellido(apellido.trim());
            }
            if (telefono != null && !telefono.trim().isEmpty()) {
                existente.setTelefono(telefono.trim());
            }
            if (correo != null && !correo.trim().isEmpty()) {
                existente.setCorreo(correo.trim());
            }
            if (especialidadId != null) {
                existente.setEspecialidadId(especialidadId);
            }

            // Guardar imagen si viene
            if (imagen != null && !imagen.isEmpty()) {
                String imagenGuardada = guardarImagen(imagen);
                if (imagenGuardada != null) {
                    existente.setImagen(imagenGuardada);
                    log.info("  - nueva imagen guardada: {}", imagenGuardada);
                }
            }

            Doctor doctorGuardado = doctorApplicationService.updateDoctor(id, existente);
            log.info("✅ Doctor actualizado exitosamente: {}", id);
            
            // 🔔 Enviar notificación de actualización de doctor
            try {
                String mensaje = String.format("Información actualizada: Dr. %s %s", 
                    doctorGuardado.getNombre(), doctorGuardado.getApellido());
                notificationService.notifyDoctorUpdate(
                    String.valueOf(id), 
                    mensaje, 
                    doctorMapper.toJpaEntity(doctorGuardado)
                );
                log.info("✅ Notificación de actualización de doctor enviada");
            } catch (Exception notifEx) {
                log.warn("⚠️ Error enviando notificación de actualización de doctor: {}", notifEx.getMessage());
            }
            
            return ResponseEntity.ok(doctorMapper.toJpaEntity(doctorGuardado));

        } catch (IllegalArgumentException e) {
            log.warn("⚠️ Error de validación al actualizar doctor: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (IOException e) {
            log.error("❌ Error al guardar imagen: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al guardar imagen: " + e.getMessage());
        } catch (Exception e) {
            log.error("❌ Error al actualizar doctor: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al actualizar doctor: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> eliminar(@PathVariable Long id) {
        try {
            doctorApplicationService.deleteDoctor(id);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            log.warn("Error al eliminar doctor: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            log.error("Error al eliminar doctor: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al eliminar doctor");
        }
    }

    private String guardarImagen(MultipartFile file) throws IOException {
        if (file.getSize() > MAX_SIZE) throw new IOException("El archivo excede los 5MB permitidos.");

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.trim().isEmpty()) {
            throw new IOException("El nombre del archivo es inválido");
        }
        String extension = "";
        if (originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();
        }
        if (!EXTENSIONES_PERMITIDAS.contains(extension)) {
            throw new IOException("Formato no permitido. Solo: " + EXTENSIONES_PERMITIDAS);
        }

        String base = appUploadDir == null ? "uploads/" : appUploadDir;
        if (!base.endsWith("/")) base = base + "/";
        File uploadDir = new File(base + "doctores/");
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String sanitized = originalFilename.replaceAll("[^a-zA-Z0-9.-]", "_");
        String fileName = System.currentTimeMillis() + "_" + sanitized;

        File destino = new File(uploadDir, fileName);
        file.transferTo(destino);
        
        // Retornar la ruta accesible desde el frontend
        String rutaAccesible = "/uploads/doctores/" + fileName;
        log.info("✅ Imagen de doctor guardada en: {}", destino.getAbsolutePath());
        log.info("📍 Ruta accesible: {}", rutaAccesible);
        return rutaAccesible;
    }

    @GetMapping("/imagen/{filename:.+}")
    public ResponseEntity<byte[]> servirImagen(@PathVariable String filename) {
        try {
            String base = appUploadDir == null ? "uploads/" : appUploadDir;
            if (!base.endsWith("/")) base = base + "/";
            File imgFile = new File(base + "doctores/" + filename);
            if (!imgFile.exists()) {
                return ResponseEntity.notFound().build();
            }
            byte[] bytes = java.nio.file.Files.readAllBytes(imgFile.toPath());
            MediaType mediaType = MediaType.APPLICATION_OCTET_STREAM;
            if (filename != null) {
                if (filename.endsWith(".png")) mediaType = MediaType.IMAGE_PNG;
                else if (filename.endsWith(".jpg") || filename.endsWith(".jpeg")) mediaType = MediaType.IMAGE_JPEG;
                else if (filename.endsWith(".webp")) {
                    MediaType webpType = MediaType.valueOf("image/webp");
                    if (webpType != null) mediaType = webpType;
                }
            }
            if (mediaType != null) {
                return ResponseEntity.ok().contentType(mediaType).body(bytes);
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
