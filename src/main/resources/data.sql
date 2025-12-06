-- Data inicial para H2 database (desarrollo)
-- Este archivo se ejecuta automáticamente al iniciar la aplicación

-- Limpiar datos anteriores (H2 no requiere reinicio de secuencias AUTO_INCREMENT)
DELETE FROM citas;
DELETE FROM horarios;
DELETE FROM doctores;  
DELETE FROM especialidades;
DELETE FROM usuarios;

-- Insertar especialidades iniciales
INSERT INTO especialidades (nombre) VALUES 
('Medicina General'),
('Cardiología'),
('Neurología'),
('Pediatría'),
('Ginecología'),
('Dermatología'),
('Oftalmología'),
('Traumatología');

-- Insertar usuarios de prueba (password: "admin123" hasheado con BCrypt)
INSERT INTO usuarios (nombre, email, password, dni, telefono, rol, activo) VALUES
('Admin Sistema', 'admin@sigc.com', '$2a$10$QKJyBGhJSrCqCJKyxXJp5eSjuS4k5zY7CfQvY0O3Y.KqDiQQk3wSy', '12345678', '987654321', 'ADMIN', true),
('Juan Pérez', 'juan.perez@paciente.com', '$2a$10$QKJyBGhJSrCqCJKyxXJp5eSjuS4k5zY7CfQvY0O3Y.KqDiQQk3wSy', '23456789', '987654322', 'PACIENTE', true);