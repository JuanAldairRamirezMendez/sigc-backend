package com.sigc.backend.security;

import com.sigc.backend.application.service.UserApplicationService;
import com.sigc.backend.model.Usuario;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

/**
 * Servicio de detalles de usuario para Spring Security
 * Implementa UserDetailsService para cargar usuarios desde la base de datos
 */
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserApplicationService userApplicationService;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        try {
            // Buscar usuario por email usando el application service
            Usuario usuario = userApplicationService.getUserByEmail(email);

            // Crear UserDetails con la información del usuario
            return User.builder()
                    .username(usuario.getEmail())
                    .password(usuario.getPassword()) // Ya está encriptada con BCrypt
                    .authorities(Collections.singletonList(
                        new SimpleGrantedAuthority("ROLE_" + usuario.getRole())
                    ))
                    .accountExpired(false)
                    .accountLocked(false)
                    .credentialsExpired(false)
                    .disabled(false)
                    .build();

        } catch (Exception e) {
            throw new UsernameNotFoundException("Usuario no encontrado: " + email, e);
        }
    }
}