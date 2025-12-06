package com.sigc.backend.domain.service.usecase.auth;

/**
 * DTO: Solicitud de Registro.
 * Transporta datos desde la entrada (HTTP) hacia el use case de registro.
 */
public class RegisterRequest {
    private final String nombre;
    private final String email;
    private final String password;
    private final String dni;
    private final String telefono;
    private final String rol;

    public RegisterRequest(String nombre, String email, String password, String dni, String telefono, String rol) {
        this.nombre = nombre;
        this.email = email;
        this.password = password;
        this.dni = dni;
        this.telefono = telefono;
        this.rol = rol;
    }

    public String getNombre() {
        return nombre;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getDni() {
        return dni;
    }

    public String getTelefono() {
        return telefono;
    }

    public String getRol() {
        return rol;
    }
}