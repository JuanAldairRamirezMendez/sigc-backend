package com.sigc.backend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "doctores")
public class Doctor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idDoctor;

    @NotBlank(message = "El nombre del doctor es obligatorio")
    private String nombre;

    @NotBlank(message = "El apellido del doctor es obligatorio")
    private String apellido;

    @NotBlank(message = "El teléfono del doctor es obligatorio")
    private String telefono;

    @NotBlank(message = "El correo del doctor es obligatorio")
    @Email(message = "El correo debe tener un formato válido")
    private String correo;

    @NotNull(message = "La especialidad es obligatoria")
    private Long especialidadId;

    @NotBlank(message = "La especialidad es obligatoria")
    private String especialidad;

    @Min(value = 1, message = "El cupo mínimo es 1")
    @Max(value = 20, message = "El cupo máximo es 20 pacientes")
    private int cupoPacientes;

    // 🖼️ Nuevo campo para guardar la ruta o URL de la imagen del doctor
    private String imagen;
}
