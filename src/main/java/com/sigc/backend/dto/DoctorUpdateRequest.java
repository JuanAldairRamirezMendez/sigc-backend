package com.sigc.backend.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para actualizar doctores mediante JSON
 * Acepta ambos formatos: con apellido/telefono/correo/especialidadId o solo nombre/especialidad/cupoPacientes
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DoctorUpdateRequest {

    @NotBlank(message = "El nombre es obligatorio")
    @Size(min = 2, max = 100, message = "El nombre debe tener entre 2 y 100 caracteres")
    private String nombre;

    // Estos campos son opcionales
    @Size(min = 2, max = 100, message = "El apellido debe tener entre 2 y 100 caracteres")
    private String apellido;

    // Validación solo si no es vacío
    @Pattern(regexp = "^(\\d{9})?$", message = "El teléfono debe tener exactamente 9 dígitos o estar vacío")
    private String telefono;

    // Validación solo si no es vacío
    @Email(message = "Debe ingresar un correo válido")
    @Size(max = 100, message = "El correo no puede exceder 100 caracteres")
    private String correo;

    // Acepta especialidadId (número) o especialidad (nombre)
    private Long especialidadId;
    private String especialidad;

    // Campo adicional del frontend
    private Integer cupoPacientes;
}