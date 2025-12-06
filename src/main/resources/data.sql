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

-- Insertar doctores de prueba
INSERT INTO doctores (nombre, especialidad, cupo_pacientes, imagen) VALUES
('María González', 'Medicina General', 15, '/uploads/doctores/default_doctor.png'),
('Carlos Rodríguez', 'Cardiología', 12, '/uploads/doctores/default_doctor.png'),
('Ana Martínez', 'Neurología', 8, '/uploads/doctores/default_doctor.png');

-- Insertar horarios de prueba (con la estructura correcta)
INSERT INTO horarios (fecha, turno, hora_inicio, hora_fin, disponible, id_doctor) VALUES
('2025-12-06', 'Mañana', '08:00:00', '12:00:00', true, 1),
('2025-12-06', 'Tarde', '14:00:00', '18:00:00', true, 1),
('2025-12-07', 'Mañana', '08:00:00', '12:00:00', true, 1),
('2025-12-06', 'Mañana', '09:00:00', '13:00:00', true, 2),
('2025-12-08', 'Tarde', '15:00:00', '19:00:00', true, 2),
('2025-12-07', 'Mañana', '08:00:00', '12:00:00', true, 3),
('2025-12-09', 'Tarde', '14:00:00', '18:00:00', true, 3);