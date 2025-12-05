package com.sigc.backend.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Modelo de dominio para Doctor
 * Representa un doctor en el sistema sin dependencias de infraestructura
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Doctor {
    
    private Long idDoctor;
    private String nombre;
    private String apellido;
    private String telefono;
    private String correo;
    private Long especialidadId;
    private String especialidad;
    private int cupoPacientes;
    private String imagen;
    
    /**
     * Valida que el doctor tenga datos mínimos requeridos
     */
    public boolean isValid() {
        return nombre != null && !nombre.trim().isEmpty() 
            && apellido != null && !apellido.trim().isEmpty()
            && correo != null && !correo.trim().isEmpty()
            && telefono != null && !telefono.trim().isEmpty()
            && especialidadId != null
            && cupoPacientes >= 1 && cupoPacientes <= 20;
    }
    
    /**
     * Verifica si el doctor tiene cupo disponible
     */
    public boolean tieneCupoDisponible() {
        return cupoPacientes > 0;
    }
}
