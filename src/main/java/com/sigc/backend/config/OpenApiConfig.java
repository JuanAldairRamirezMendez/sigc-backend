package com.sigc.backend.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.servers.Server;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "SIGC - Sistema Integral de Gestión de Citas",
        description = "API REST para gestión de citas médicas con autenticación JWT",
        version = "1.0.0",
        contact = @Contact(
            name = "Equipo SIGC",
            email = "sigc@example.com"
        )
    ),
    servers = {
        @Server(url = "http://localhost:8080", description = "Servidor de Desarrollo"),
        @Server(url = "https://sigc-backend.onrender.com", description = "Servidor de Producción")
    }
)
@SecurityScheme(
    name = "JWT",
    type = SecuritySchemeType.HTTP,
    scheme = "bearer",
    bearerFormat = "JWT"
)
public class OpenApiConfig {
}