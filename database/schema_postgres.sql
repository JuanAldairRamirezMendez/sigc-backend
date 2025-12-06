-- ============================================
-- SCRIPT DE BASE DE DATOS SIGC - VERSIÓN POSTGRESQL
-- Compatible con PostgreSQL en Render
-- ============================================

-- Eliminar base de datos si existe y recrearla (solo si tienes permisos, en Render probablemente no)
-- DROP DATABASE IF EXISTS sigc_postgres;
-- CREATE DATABASE sigc_postgres;

-- Usar la base de datos
-- \c sigc_postgres;

-- ============================================
-- TABLA: usuarios
-- ============================================
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    dni VARCHAR(8) NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    rol VARCHAR(50) NOT NULL DEFAULT 'PACIENTE',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios (email);
CREATE INDEX IF NOT EXISTS idx_usuarios_rol ON usuarios (rol);

-- ============================================
-- TABLA: especialidades
-- ============================================
CREATE TABLE IF NOT EXISTS especialidades (
    id_especialidad SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
    descripcion TEXT,
    imagen VARCHAR(255),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_especialidades_nombre ON especialidades (nombre);

-- ============================================
-- TABLA: doctores
-- ============================================
CREATE TABLE IF NOT EXISTS doctores (
    id_doctor SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    especialidad VARCHAR(255) NOT NULL,
    cupo_pacientes INTEGER DEFAULT 10,
    imagen VARCHAR(255),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_doctores_especialidad ON doctores (especialidad);
CREATE INDEX IF NOT EXISTS idx_doctores_nombre ON doctores (nombre);

-- ============================================
-- TABLA: horarios
-- ============================================
CREATE TABLE IF NOT EXISTS horarios (
    id_horario SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    turno VARCHAR(255) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    id_doctor INTEGER,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_doctor) REFERENCES doctores(id_doctor) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_horarios_fecha ON horarios (fecha);
CREATE INDEX IF NOT EXISTS idx_horarios_doctor_fecha ON horarios (id_doctor, fecha);
CREATE INDEX IF NOT EXISTS idx_horarios_disponible ON horarios (disponible);

-- ============================================
-- TABLA: citas
-- ============================================
CREATE TABLE IF NOT EXISTS citas (
    id_cita SERIAL PRIMARY KEY,
    fecha_cita DATE NOT NULL,
    hora_cita TIME NOT NULL,
    turno VARCHAR(255),
    estado VARCHAR(255) DEFAULT 'ACTIVA',
    id_usuario INTEGER,
    id_doctor INTEGER,
    id_horario INTEGER,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_doctor) REFERENCES doctores(id_doctor) ON DELETE CASCADE,
    FOREIGN KEY (id_horario) REFERENCES horarios(id_horario) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_citas_usuario ON citas (id_usuario);
CREATE INDEX IF NOT EXISTS idx_citas_doctor ON citas (id_doctor);
CREATE INDEX IF NOT EXISTS idx_citas_fecha ON citas (fecha_cita);
CREATE INDEX IF NOT EXISTS idx_citas_estado ON citas (estado);

-- ============================================
-- TABLA: servicios
-- ============================================
CREATE TABLE IF NOT EXISTS servicios (
    id_servicio SERIAL PRIMARY KEY,
    nombre_servicio VARCHAR(255),
    descripcion VARCHAR(255),
    duracion_minutos INTEGER NOT NULL,
    precio DOUBLE PRECISION NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_servicios_nombre ON servicios (nombre_servicio);

-- ============================================
-- DATOS INICIALES
-- ============================================

-- Usuario administrador (password: Admin123456 - BCrypt hash)
INSERT INTO usuarios (nombre, email, password, dni, telefono, rol, activo) VALUES
('Administrador', 'admin@sigc.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', '00000000', '999999999', 'ADMIN', TRUE)
ON CONFLICT (email) DO NOTHING;

-- Especialidades médicas
INSERT INTO especialidades (nombre, descripcion, imagen) VALUES
('Cardiología', 'Atención del corazón y sistema circulatorio', '/uploads/especialidades/cardiologia.jpg'),
('Pediatría', 'Atención médica de niños y adolescentes', '/uploads/especialidades/pediatria.jpg'),
('Odontología', 'Cuidado dental y salud bucal', '/uploads/especialidades/odontologia.jpg'),
('Dermatología', 'Tratamiento de enfermedades de la piel', '/uploads/especialidades/dermatologia.jpg'),
('Ginecología', 'Salud reproductiva y cuidado femenino', '/uploads/especialidades/ginecologia.jpg'),
('Neurología', 'Especialidad médica que trata los trastornos del sistema nervioso', '/uploads/especialidades/neurologia.jpg')
ON CONFLICT (nombre) DO NOTHING;

-- Doctores (usando los mismos de la BD actual)
INSERT INTO doctores (nombre, especialidad, cupo_pacientes, imagen) VALUES
('Dr. Ricardo López', 'Cardiología', 10, '/uploads/doctores/ricardo-lopez.jpg'),
('Dra. Sofía Torres', 'Pediatría', 15, '/uploads/doctores/sofia-torres.jpg'),
('Dr. Luis Ramos', 'Odontología', 8, '/uploads/doctores/luis-ramos.jpg'),
('Dra. Carmen Vega', 'Dermatología', 12, '/uploads/doctores/carmen-vega.jpg'),
('Dra. Ana Gutiérrez', 'Ginecología', 10, '/uploads/doctores/ana-gutierrez.jpg')
ON CONFLICT DO NOTHING;

-- Horarios de ejemplo (ajustar fechas futuras)
INSERT INTO horarios (fecha, turno, hora_inicio, hora_fin, disponible, id_doctor) VALUES
('2025-12-10', 'Mañana', '09:00:00', '12:00:00', TRUE, 1),
('2025-12-10', 'Tarde', '14:00:00', '17:00:00', TRUE, 2),
('2025-12-11', 'Mañana', '09:00:00', '12:00:00', TRUE, 3),
('2025-12-12', 'Tarde', '14:00:00', '17:00:00', TRUE, 4),
('2025-12-13', 'Mañana', '08:30:00', '11:30:00', TRUE, 5)
ON CONFLICT DO NOTHING;

-- Usuarios de prueba (pacientes)
INSERT INTO usuarios (nombre, email, password, dni, telefono, rol, activo) VALUES
('Juan Pérez', 'juan@cliente.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', '12345678', '987654321', 'PACIENTE', TRUE),
('María López', 'maria@cliente.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', '87654321', '912345678', 'PACIENTE', TRUE),
('Carlos Ramírez', 'carlos@cliente.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhCu', '65432198', '934567890', 'PACIENTE', TRUE)
ON CONFLICT (email) DO NOTHING;

-- Citas de ejemplo
INSERT INTO citas (fecha_cita, hora_cita, turno, estado, id_usuario, id_doctor, id_horario) VALUES
('2025-12-10', '09:00:00', 'Mañana', 'ACTIVA', 2, 1, 1),
('2025-12-10', '14:00:00', 'Tarde', 'ACTIVA', 3, 2, 2),
('2025-12-11', '09:00:00', 'Mañana', 'CANCELADA', 4, 3, 3),
('2025-12-12', '14:00:00', 'Tarde', 'ACTIVA', 2, 4, 4),
('2025-12-13', '08:30:00', 'Mañana', 'COMPLETADA', 3, 5, 5)
ON CONFLICT DO NOTHING;

-- ============================================
-- VERIFICACIÓN
-- ============================================
SELECT '✅ Base de datos creada exitosamente' AS resultado;

SELECT
    (SELECT COUNT(*) FROM usuarios) AS total_usuarios,
    (SELECT COUNT(*) FROM doctores) AS total_doctores,
    (SELECT COUNT(*) FROM especialidades) AS total_especialidades,
    (SELECT COUNT(*) FROM horarios) AS total_horarios,
    (SELECT COUNT(*) FROM citas) AS total_citas,
    (SELECT COUNT(*) FROM servicios) AS total_servicios;

-- Mostrar resumen de datos insertados
SELECT 'Usuarios creados:' AS info;
SELECT id_usuario, nombre, email, rol FROM usuarios;

SELECT 'Doctores creados:' AS info;
SELECT id_doctor, nombre, especialidad, cupo_pacientes FROM doctores;

SELECT 'Especialidades creadas:' AS info;
SELECT id_especialidad, nombre, descripcion FROM especialidades;

SELECT 'Horarios creados:' AS info;
SELECT id_horario, fecha, turno, hora_inicio, hora_fin, disponible, id_doctor FROM horarios;

SELECT 'Citas creadas:' AS info;
SELECT id_cita, fecha_cita, hora_cita, estado, id_usuario, id_doctor, id_horario FROM citas;