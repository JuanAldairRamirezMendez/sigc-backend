package com.sigc.backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigc.backend.repository.*;
import com.sigc.backend.model.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/debug")
@CrossOrigin(origins = "*")
public class DebugController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private CitaRepository citaRepository;

    @Autowired
    private EspecialidadRepository especialidadRepository;

    /**
     * Endpoint de salud básico
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", new Date().toString());
        return ResponseEntity.ok(response);
    }

    /**
     * Verificar CRUD de usuarios
     */
    @GetMapping("/crud/usuarios")
    public ResponseEntity<Map<String, Object>> verificarUsuarios() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<Usuario> usuarios = usuarioRepository.findAll();
            
            Map<String, Long> conteos = new HashMap<>();
            conteos.put("total", (long) usuarios.size());
            conteos.put("activos", usuarios.stream().filter(u -> u.getActivo()).count());
            conteos.put("inactivos", usuarios.stream().filter(u -> !u.getActivo()).count());
            conteos.put("admin", usuarios.stream().filter(u -> "ADMIN".equals(u.getRol())).count());
            conteos.put("doctores", usuarios.stream().filter(u -> "DOCTOR".equals(u.getRol())).count());
            conteos.put("pacientes", usuarios.stream().filter(u -> "PACIENTE".equals(u.getRol())).count());
            
            result.put("status", "OK");
            result.put("conteos", conteos);
            result.put("usuarios", usuarios.stream().map(u -> Map.of(
                "id", u.getIdUsuario(),
                "nombre", u.getNombre(),
                "email", u.getEmail(),
                "rol", u.getRol(),
                "activo", u.getActivo()
            )).collect(Collectors.toList()));
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }

    /**
     * Verificar CRUD de doctores
     */
    @GetMapping("/crud/doctores")
    public ResponseEntity<Map<String, Object>> verificarDoctores() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<Doctor> doctores = doctorRepository.findAll();
            
            Map<String, Object> conteos = new HashMap<>();
            conteos.put("total", doctores.size());
            conteos.put("activos", doctores.size()); // Todos los doctores son activos por ahora
            
            result.put("status", "OK");
            result.put("conteos", conteos);
            result.put("doctores", doctores.stream().map(d -> Map.of(
                "id", d.getIdDoctor(),
                "nombre", d.getNombre() + " " + (d.getApellido() != null ? d.getApellido() : ""),
                "email", d.getCorreo() != null ? d.getCorreo() : "N/A",
                "especialidad", d.getEspecialidad() != null ? d.getEspecialidad() : "N/A",
                "activo", true
            )).collect(Collectors.toList()));
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }

    /**
     * Verificar CRUD de citas
     */
    @GetMapping("/crud/citas")
    public ResponseEntity<Map<String, Object>> verificarCitas() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<Cita> citas = citaRepository.findAll();
            
            Map<String, Object> conteos = new HashMap<>();
            conteos.put("total", citas.size());
            conteos.put("pendientes", citas.stream().filter(c -> "PENDIENTE".equals(c.getEstado())).count());
            conteos.put("confirmadas", citas.stream().filter(c -> "CONFIRMADA".equals(c.getEstado())).count());
            conteos.put("canceladas", citas.stream().filter(c -> "CANCELADA".equals(c.getEstado())).count());
            
            result.put("status", "OK");
            result.put("conteos", conteos);
            result.put("citas", citas.stream().map(c -> Map.of(
                "id", c.getIdCita(),
                "paciente", c.getUsuario() != null ? c.getUsuario().getNombre() : "N/A",
                "doctor", c.getDoctor() != null ? c.getDoctor().getNombre() : "N/A",
                "fecha", c.getFechaCita(),
                "hora", c.getHoraCita(),
                "estado", c.getEstado()
            )).collect(Collectors.toList()));
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }

    /**
     * Verificar CRUD de especialidades
     */
    @GetMapping("/crud/especializaciones")
    public ResponseEntity<Map<String, Object>> verificarEspecializaciones() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<Especialidad> especialidades = especialidadRepository.findAll();
            
            Map<String, Object> conteos = new HashMap<>();
            conteos.put("total", especialidades.size());
            
            result.put("status", "OK");
            result.put("conteos", conteos);
            result.put("especialidades", especialidades.stream().map(e -> Map.of(
                "id", e.getIdEspecialidad(),
                "nombre", e.getNombre(),
                "descripcion", e.getDescripcion() != null ? e.getDescripcion() : "N/A"
            )).collect(Collectors.toList()));
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }

    /**
     * Obtener estado general de la BD
     */
    @GetMapping("/database-status")
    public ResponseEntity<Map<String, Object>> databaseStatus() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Map<String, Long> stats = new HashMap<>();
            stats.put("usuarios", (long) usuarioRepository.findAll().size());
            stats.put("doctores", (long) doctorRepository.findAll().size());
            stats.put("citas", (long) citaRepository.findAll().size());
            stats.put("especialidades", (long) especialidadRepository.findAll().size());
            
            result.put("status", "OK");
            result.put("timestamp", new Date());
            result.put("statistics", stats);
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }

    /**
     * Resetear datos de prueba
     */
    @PostMapping("/reset")
    public ResponseEntity<Map<String, String>> resetDatabase() {
        Map<String, String> result = new HashMap<>();
        
        try {
            citaRepository.deleteAll();
            doctorRepository.deleteAll();
            usuarioRepository.deleteAll();
            
            result.put("status", "SUCCESS");
            result.put("message", "Base de datos reseteada exitosamente");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("message", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }
}
