-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         12.0.2-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para condor_airways
CREATE DATABASE IF NOT EXISTS `condor_airways` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `condor_airways`;

-- Volcando estructura para tabla condor_airways.aerolinea_checkin
CREATE TABLE IF NOT EXISTS `aerolinea_checkin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `asiento` varchar(5) NOT NULL,
  `pase_abordar` varchar(100) DEFAULT NULL,
  `compra_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_checkin_compra_id_0a66f7be_fk_aerolinea_compra_id` (`compra_id`),
  CONSTRAINT `aerolinea_checkin_compra_id_0a66f7be_fk_aerolinea_compra_id` FOREIGN KEY (`compra_id`) REFERENCES `aerolinea_compra` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_checkin: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_checkin` (`id`, `asiento`, `pase_abordar`, `compra_id`) VALUES
	(1, '22B', '', 1);

-- Volcando estructura para tabla condor_airways.aerolinea_comentario
CREATE TABLE IF NOT EXISTS `aerolinea_comentario` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `contenido` longtext NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `publicacion_id` bigint(20) NOT NULL,
  `usuario_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_comentario_publicacion_id_d2145a29_fk_aerolinea` (`publicacion_id`),
  KEY `aerolinea_comentario_usuario_id_d0c4a70c_fk_aerolinea_usuario_id` (`usuario_id`),
  CONSTRAINT `aerolinea_comentario_publicacion_id_d2145a29_fk_aerolinea` FOREIGN KEY (`publicacion_id`) REFERENCES `aerolinea_publicacion` (`id`),
  CONSTRAINT `aerolinea_comentario_usuario_id_d0c4a70c_fk_aerolinea_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `aerolinea_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_comentario: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.aerolinea_compra
CREATE TABLE IF NOT EXISTS `aerolinea_compra` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fecha_compra` datetime(6) NOT NULL,
  `estado` varchar(20) NOT NULL,
  `codigo_reserva` varchar(50) NOT NULL,
  `metodo_pago` varchar(50) NOT NULL,
  `usuario_id` bigint(20) NOT NULL,
  `vuelo_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_reserva` (`codigo_reserva`),
  KEY `aerolinea_compra_usuario_id_f151e2a2_fk_aerolinea_usuario_id` (`usuario_id`),
  KEY `aerolinea_compra_vuelo_id_4d4c2cad_fk_aerolinea_vuelo_id` (`vuelo_id`),
  CONSTRAINT `aerolinea_compra_usuario_id_f151e2a2_fk_aerolinea_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `aerolinea_usuario` (`id`),
  CONSTRAINT `aerolinea_compra_vuelo_id_4d4c2cad_fk_aerolinea_vuelo_id` FOREIGN KEY (`vuelo_id`) REFERENCES `aerolinea_vuelo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_compra: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_compra` (`id`, `fecha_compra`, `estado`, `codigo_reserva`, `metodo_pago`, `usuario_id`, `vuelo_id`) VALUES
	(1, '2025-09-17 00:53:36.383397', 'activa', 'RES64748', 'Tarjeta de Crédito', 1, 9);

-- Volcando estructura para tabla condor_airways.aerolinea_historialoperacion
CREATE TABLE IF NOT EXISTS `aerolinea_historialoperacion` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tipo` varchar(30) NOT NULL,
  `descripcion` longtext NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `usuario_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_historialo_usuario_id_c9edf4dc_fk_aerolinea` (`usuario_id`),
  CONSTRAINT `aerolinea_historialo_usuario_id_c9edf4dc_fk_aerolinea` FOREIGN KEY (`usuario_id`) REFERENCES `aerolinea_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_historialoperacion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.aerolinea_maleta
CREATE TABLE IF NOT EXISTS `aerolinea_maleta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `peso` decimal(5,2) NOT NULL,
  `costo` decimal(10,2) NOT NULL,
  `checkin_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_maleta_checkin_id_1b7526d2_fk_aerolinea_checkin_id` (`checkin_id`),
  CONSTRAINT `aerolinea_maleta_checkin_id_1b7526d2_fk_aerolinea_checkin_id` FOREIGN KEY (`checkin_id`) REFERENCES `aerolinea_checkin` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_maleta: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_maleta` (`id`, `peso`, `costo`, `checkin_id`) VALUES
	(1, 1.00, 20000.00, 1);

-- Volcando estructura para tabla condor_airways.aerolinea_notificacion
CREATE TABLE IF NOT EXISTS `aerolinea_notificacion` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mensaje` longtext NOT NULL,
  `enviada` tinyint(1) NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `usuario_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_notificaci_usuario_id_8db648f0_fk_aerolinea` (`usuario_id`),
  CONSTRAINT `aerolinea_notificaci_usuario_id_8db648f0_fk_aerolinea` FOREIGN KEY (`usuario_id`) REFERENCES `aerolinea_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_notificacion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.aerolinea_publicacion
CREATE TABLE IF NOT EXISTS `aerolinea_publicacion` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(200) NOT NULL,
  `contenido` longtext NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `usuario_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_publicacio_usuario_id_eb27cb71_fk_aerolinea` (`usuario_id`),
  CONSTRAINT `aerolinea_publicacio_usuario_id_eb27cb71_fk_aerolinea` FOREIGN KEY (`usuario_id`) REFERENCES `aerolinea_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_publicacion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.aerolinea_reserva
CREATE TABLE IF NOT EXISTS `aerolinea_reserva` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fecha_reserva` datetime(6) NOT NULL,
  `estado` varchar(20) NOT NULL,
  `num_tiquetes` int(11) NOT NULL,
  `usuario_id` bigint(20) NOT NULL,
  `vuelo_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_reserva_usuario_id_b8f51962_fk_aerolinea_usuario_id` (`usuario_id`),
  KEY `aerolinea_reserva_vuelo_id_fe0e1074_fk_aerolinea_vuelo_id` (`vuelo_id`),
  CONSTRAINT `aerolinea_reserva_usuario_id_b8f51962_fk_aerolinea_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `aerolinea_usuario` (`id`),
  CONSTRAINT `aerolinea_reserva_vuelo_id_fe0e1074_fk_aerolinea_vuelo_id` FOREIGN KEY (`vuelo_id`) REFERENCES `aerolinea_vuelo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_reserva: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_reserva` (`id`, `fecha_reserva`, `estado`, `num_tiquetes`, `usuario_id`, `vuelo_id`) VALUES
	(1, '2025-09-17 00:53:32.514492', 'confirmada', 3, 1, 9);

-- Volcando estructura para tabla condor_airways.aerolinea_rol
CREATE TABLE IF NOT EXISTS `aerolinea_rol` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_rol: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.aerolinea_usuario
CREATE TABLE IF NOT EXISTS `aerolinea_usuario` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `password` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `rol_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `aerolinea_usuario_rol_id_15a7aa42_fk_aerolinea_rol_id` (`rol_id`),
  CONSTRAINT `aerolinea_usuario_rol_id_15a7aa42_fk_aerolinea_rol_id` FOREIGN KEY (`rol_id`) REFERENCES `aerolinea_rol` (`id`),
  CONSTRAINT `aerolinea_usuario_user_id_a42d0b57_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_usuario: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_usuario` (`id`, `nombre`, `email`, `password`, `telefono`, `direccion`, `rol_id`, `user_id`) VALUES
	(1, '', '', '', NULL, NULL, 1, 1);

-- Volcando estructura para tabla condor_airways.aerolinea_vuelo
CREATE TABLE IF NOT EXISTS `aerolinea_vuelo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) NOT NULL,
  `origen` varchar(50) NOT NULL,
  `destino` varchar(50) NOT NULL,
  `fecha_salida` datetime(6) NOT NULL,
  `fecha_llegada` datetime(6) NOT NULL,
  `capacidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_vuelo: ~55 rows (aproximadamente)
INSERT INTO `aerolinea_vuelo` (`id`, `codigo`, `origen`, `destino`, `fecha_salida`, `fecha_llegada`, `capacidad`, `precio`) VALUES
	(1, 'CONDOR001', 'Bogotá', 'Medellín', '2025-09-26 20:55:52.522218', '2025-09-26 23:55:52.522218', 87, 445175.00),
	(2, 'CONDOR002', 'Bogotá', 'Cali', '2025-10-03 20:55:52.597273', '2025-10-03 21:55:52.597273', 198, 233660.00),
	(3, 'CONDOR003', 'Medellín', 'Cartagena', '2025-09-24 20:55:52.619821', '2025-09-24 21:55:52.619821', 183, 296651.00),
	(4, 'CONDOR004', 'Cali', 'Barranquilla', '2025-10-15 20:55:52.664393', '2025-10-15 21:55:52.664393', 57, 233116.00),
	(5, 'CONDOR005', 'Bogotá', 'San Andrés', '2025-10-02 20:55:52.686812', '2025-10-02 21:55:52.686812', 166, 438947.00),
	(6, 'V001', 'Bogotá', 'Bucaramanga', '2025-10-07 23:33:34.232937', '2025-10-08 02:33:34.232937', 164, 588173.00),
	(7, 'V002', 'Cali', 'Pereira', '2025-10-15 23:33:34.403343', '2025-10-16 00:33:34.403343', 51, 172277.00),
	(8, 'V003', 'Medellín', 'Barranquilla', '2025-09-22 23:33:34.466627', '2025-09-23 01:33:34.466627', 68, 404549.00),
	(9, 'V004', 'Pereira', 'Cartagena', '2025-10-07 23:33:34.539635', '2025-10-08 00:33:34.539635', 123, 434999.00),
	(10, 'V005', 'Santa Marta', 'Cali', '2025-10-10 23:33:34.577172', '2025-10-11 00:33:34.577172', 72, 124604.00),
	(11, 'V006', 'Bogotá', 'Barranquilla', '2025-09-25 23:33:34.599373', '2025-09-26 02:33:34.599373', 139, 466529.00),
	(12, 'V007', 'Bogotá', 'Cartagena', '2025-09-28 23:33:34.654747', '2025-09-29 00:33:34.654747', 121, 483465.00),
	(13, 'V008', 'Medellín', 'Pereira', '2025-10-08 23:33:34.676996', '2025-10-09 00:33:34.676996', 86, 494530.00),
	(14, 'V009', 'Bucaramanga', 'Pereira', '2025-09-18 23:33:34.699202', '2025-09-19 00:33:34.699202', 163, 420708.00),
	(15, 'V010', 'Barranquilla', 'Pereira', '2025-10-02 23:33:34.721374', '2025-10-03 02:33:34.721374', 132, 250774.00),
	(16, 'V011', 'San Andrés', 'Bucaramanga', '2025-09-27 23:33:34.743588', '2025-09-28 01:33:34.743588', 72, 356889.00),
	(17, 'V012', 'Barranquilla', 'San Andrés', '2025-09-26 23:33:34.765701', '2025-09-27 00:33:34.765701', 56, 192418.00),
	(18, 'V013', 'Manizales', 'Medellín', '2025-10-16 23:33:34.802541', '2025-10-17 02:33:34.802541', 51, 301834.00),
	(19, 'V014', 'Cali', 'Bucaramanga', '2025-09-25 23:33:34.832326', '2025-09-26 01:33:34.832326', 53, 337351.00),
	(20, 'V015', 'Manizales', 'Santa Marta', '2025-09-28 23:33:34.854542', '2025-09-29 01:33:34.854542', 78, 292324.00),
	(21, 'V016', 'Medellín', 'Santa Marta', '2025-10-03 23:33:34.876748', '2025-10-04 02:33:34.876748', 101, 278401.00),
	(22, 'V017', 'San Andrés', 'Bogotá', '2025-10-04 23:33:34.898974', '2025-10-05 01:33:34.898974', 75, 317656.00),
	(23, 'V018', 'Cartagena', 'Bogotá', '2025-10-06 23:33:34.921188', '2025-10-07 01:33:34.921188', 146, 159038.00),
	(24, 'V019', 'San Andrés', 'Bogotá', '2025-09-24 23:33:34.943389', '2025-09-25 00:33:34.943389', 108, 367191.00),
	(25, 'V020', 'Pereira', 'Cali', '2025-10-07 23:33:35.000118', '2025-10-08 02:33:35.000118', 100, 490822.00),
	(26, 'V021', 'Pereira', 'Bucaramanga', '2025-10-12 23:33:35.020877', '2025-10-13 00:33:35.020877', 137, 250508.00),
	(27, 'V022', 'Medellín', 'San Andrés', '2025-10-15 23:33:35.043785', '2025-10-16 01:33:35.043785', 176, 107823.00),
	(28, 'V023', 'Cartagena', 'Bogotá', '2025-09-22 23:33:35.875832', '2025-09-23 01:33:35.875832', 62, 342007.00),
	(29, 'V024', 'Barranquilla', 'Bogotá', '2025-09-25 23:33:36.568082', '2025-09-26 02:33:36.568082', 195, 378511.00),
	(30, 'V025', 'San Andrés', 'Pereira', '2025-10-03 23:33:36.786073', '2025-10-04 02:33:36.786073', 101, 328737.00),
	(31, 'V026', 'Pereira', 'San Andrés', '2025-09-30 23:33:36.838435', '2025-10-01 02:33:36.838435', 177, 571770.00),
	(32, 'V027', 'Cartagena', 'Barranquilla', '2025-10-05 23:33:36.858952', '2025-10-06 00:33:36.858952', 137, 482835.00),
	(33, 'V028', 'Barranquilla', 'Medellín', '2025-09-25 23:33:37.025251', '2025-09-26 00:33:37.025251', 79, 512645.00),
	(34, 'V029', 'Bogotá', 'Medellín', '2025-09-20 23:33:37.117986', '2025-09-21 00:33:37.117986', 133, 365578.00),
	(35, 'V030', 'Santa Marta', 'Cali', '2025-10-06 23:33:37.128826', '2025-10-07 02:33:37.128826', 97, 145707.00),
	(36, 'V031', 'Bogotá', 'San Andrés', '2025-09-23 23:33:37.140138', '2025-09-24 02:33:37.140138', 174, 286081.00),
	(37, 'V032', 'Bucaramanga', 'Barranquilla', '2025-09-26 23:33:37.165364', '2025-09-27 02:33:37.165364', 70, 481445.00),
	(38, 'V033', 'Bucaramanga', 'Cali', '2025-10-12 23:33:37.196222', '2025-10-13 02:33:37.196222', 149, 398392.00),
	(39, 'V034', 'Cartagena', 'Bucaramanga', '2025-09-22 23:33:37.218034', '2025-09-23 01:33:37.218034', 194, 572979.00),
	(40, 'V035', 'Medellín', 'Cartagena', '2025-10-11 23:33:37.240739', '2025-10-12 01:33:37.240739', 84, 493950.00),
	(41, 'V036', 'Pereira', 'Barranquilla', '2025-09-27 23:33:37.262683', '2025-09-28 01:33:37.262683', 78, 161739.00),
	(42, 'V037', 'Bogotá', 'Bucaramanga', '2025-09-25 23:33:37.313930', '2025-09-26 02:33:37.313930', 135, 160552.00),
	(43, 'V038', 'San Andrés', 'Bogotá', '2025-09-23 23:33:37.381904', '2025-09-24 01:33:37.381904', 79, 495739.00),
	(44, 'V039', 'Santa Marta', 'Pereira', '2025-10-13 23:33:37.439337', '2025-10-14 00:33:37.439337', 119, 221809.00),
	(45, 'V040', 'Santa Marta', 'Pereira', '2025-09-26 23:33:37.506971', '2025-09-27 00:33:37.506971', 152, 297982.00),
	(46, 'V041', 'Manizales', 'Medellín', '2025-09-29 23:33:37.621822', '2025-09-30 02:33:37.621822', 162, 571705.00),
	(47, 'V042', 'Bucaramanga', 'Manizales', '2025-09-21 23:33:37.756746', '2025-09-22 02:33:37.756746', 117, 251966.00),
	(48, 'V043', 'Medellín', 'Bogotá', '2025-10-05 23:33:37.846001', '2025-10-06 02:33:37.846001', 92, 346293.00),
	(49, 'V044', 'Pereira', 'San Andrés', '2025-09-29 23:33:37.982902', '2025-09-30 00:33:37.982902', 93, 387153.00),
	(50, 'V045', 'Cartagena', 'Bucaramanga', '2025-09-18 23:33:38.030206', '2025-09-19 00:33:38.030206', 100, 202974.00),
	(51, 'V046', 'San Andrés', 'Cartagena', '2025-10-10 23:33:38.173254', '2025-10-11 00:33:38.173254', 200, 595807.00),
	(52, 'V047', 'Medellín', 'Cali', '2025-09-27 23:33:38.195450', '2025-09-28 02:33:38.195450', 197, 202670.00),
	(53, 'V048', 'Cali', 'San Andrés', '2025-10-10 23:33:38.217920', '2025-10-11 00:33:38.217920', 159, 138083.00),
	(54, 'V049', 'Manizales', 'Barranquilla', '2025-10-03 23:33:38.239479', '2025-10-04 01:33:38.239479', 178, 339511.00),
	(55, 'V050', 'Bogotá', 'Bucaramanga', '2025-10-06 23:33:38.262010', '2025-10-07 01:33:38.262010', 77, 445535.00);

-- Volcando estructura para tabla condor_airways.auth_group
CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.auth_group: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.auth_group_permissions
CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.auth_group_permissions: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.auth_permission
CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.auth_permission: ~68 rows (aproximadamente)
INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
	(1, 'Can add log entry', 1, 'add_logentry'),
	(2, 'Can change log entry', 1, 'change_logentry'),
	(3, 'Can delete log entry', 1, 'delete_logentry'),
	(4, 'Can view log entry', 1, 'view_logentry'),
	(5, 'Can add permission', 2, 'add_permission'),
	(6, 'Can change permission', 2, 'change_permission'),
	(7, 'Can delete permission', 2, 'delete_permission'),
	(8, 'Can view permission', 2, 'view_permission'),
	(9, 'Can add group', 3, 'add_group'),
	(10, 'Can change group', 3, 'change_group'),
	(11, 'Can delete group', 3, 'delete_group'),
	(12, 'Can view group', 3, 'view_group'),
	(13, 'Can add user', 4, 'add_user'),
	(14, 'Can change user', 4, 'change_user'),
	(15, 'Can delete user', 4, 'delete_user'),
	(16, 'Can view user', 4, 'view_user'),
	(17, 'Can add content type', 5, 'add_contenttype'),
	(18, 'Can change content type', 5, 'change_contenttype'),
	(19, 'Can delete content type', 5, 'delete_contenttype'),
	(20, 'Can view content type', 5, 'view_contenttype'),
	(21, 'Can add session', 6, 'add_session'),
	(22, 'Can change session', 6, 'change_session'),
	(23, 'Can delete session', 6, 'delete_session'),
	(24, 'Can view session', 6, 'view_session'),
	(25, 'Can add rol', 7, 'add_rol'),
	(26, 'Can change rol', 7, 'change_rol'),
	(27, 'Can delete rol', 7, 'delete_rol'),
	(28, 'Can view rol', 7, 'view_rol'),
	(29, 'Can add usuario', 8, 'add_usuario'),
	(30, 'Can change usuario', 8, 'change_usuario'),
	(31, 'Can delete usuario', 8, 'delete_usuario'),
	(32, 'Can view usuario', 8, 'view_usuario'),
	(33, 'Can add vuelo', 9, 'add_vuelo'),
	(34, 'Can change vuelo', 9, 'change_vuelo'),
	(35, 'Can delete vuelo', 9, 'delete_vuelo'),
	(36, 'Can view vuelo', 9, 'view_vuelo'),
	(37, 'Can add compra', 10, 'add_compra'),
	(38, 'Can change compra', 10, 'change_compra'),
	(39, 'Can delete compra', 10, 'delete_compra'),
	(40, 'Can view compra', 10, 'view_compra'),
	(41, 'Can add check in', 11, 'add_checkin'),
	(42, 'Can change check in', 11, 'change_checkin'),
	(43, 'Can delete check in', 11, 'delete_checkin'),
	(44, 'Can view check in', 11, 'view_checkin'),
	(45, 'Can add maleta', 12, 'add_maleta'),
	(46, 'Can change maleta', 12, 'change_maleta'),
	(47, 'Can delete maleta', 12, 'delete_maleta'),
	(48, 'Can view maleta', 12, 'view_maleta'),
	(49, 'Can add reserva', 13, 'add_reserva'),
	(50, 'Can change reserva', 13, 'change_reserva'),
	(51, 'Can delete reserva', 13, 'delete_reserva'),
	(52, 'Can view reserva', 13, 'view_reserva'),
	(53, 'Can add historial operacion', 14, 'add_historialoperacion'),
	(54, 'Can change historial operacion', 14, 'change_historialoperacion'),
	(55, 'Can delete historial operacion', 14, 'delete_historialoperacion'),
	(56, 'Can view historial operacion', 14, 'view_historialoperacion'),
	(57, 'Can add comentario', 15, 'add_comentario'),
	(58, 'Can change comentario', 15, 'change_comentario'),
	(59, 'Can delete comentario', 15, 'delete_comentario'),
	(60, 'Can view comentario', 15, 'view_comentario'),
	(61, 'Can add notificacion', 16, 'add_notificacion'),
	(62, 'Can change notificacion', 16, 'change_notificacion'),
	(63, 'Can delete notificacion', 16, 'delete_notificacion'),
	(64, 'Can view notificacion', 16, 'view_notificacion'),
	(65, 'Can add publicacion', 17, 'add_publicacion'),
	(66, 'Can change publicacion', 17, 'change_publicacion'),
	(67, 'Can delete publicacion', 17, 'delete_publicacion'),
	(68, 'Can view publicacion', 17, 'view_publicacion');

-- Volcando estructura para tabla condor_airways.auth_user
CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.auth_user: ~0 rows (aproximadamente)
INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
	(1, 'pbkdf2_sha256$1000000$0jwMjWKAdCeHQdTIbt5YGk$zyKSg88FMvwcss3qjDZ0BIFOAIK9fN0tzCDkAGTwIqE=', '2025-09-17 00:53:21.992497', 1, 'karen', '', '', 'karenmanuela.cardona@utp.edu.co', 1, 1, '2025-09-14 22:38:00.721976');

-- Volcando estructura para tabla condor_airways.auth_user_groups
CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.auth_user_groups: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.auth_user_user_permissions
CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.auth_user_user_permissions: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.checkin
CREATE TABLE IF NOT EXISTS `checkin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `compra_id` int(11) NOT NULL,
  `asiento` varchar(5) NOT NULL,
  `pase_abordar` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `compra_id` (`compra_id`),
  CONSTRAINT `checkin_ibfk_1` FOREIGN KEY (`compra_id`) REFERENCES `compra` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.checkin: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.compra
CREATE TABLE IF NOT EXISTS `compra` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `vuelo_id` int(11) NOT NULL,
  `fecha_compra` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('activa','cancelada') DEFAULT 'activa',
  `codigo_reserva` varchar(50) NOT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_reserva` (`codigo_reserva`),
  KEY `usuario_id` (`usuario_id`),
  KEY `vuelo_id` (`vuelo_id`),
  CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`),
  CONSTRAINT `compra_ibfk_2` FOREIGN KEY (`vuelo_id`) REFERENCES `vuelo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.compra: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.django_admin_log
CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_admin_log: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.django_content_type
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_content_type: ~17 rows (aproximadamente)
INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(1, 'admin', 'logentry'),
	(2, 'auth', 'permission'),
	(3, 'auth', 'group'),
	(4, 'auth', 'user'),
	(5, 'contenttypes', 'contenttype'),
	(6, 'sessions', 'session'),
	(7, 'aerolinea', 'rol'),
	(8, 'aerolinea', 'usuario'),
	(9, 'aerolinea', 'vuelo'),
	(10, 'aerolinea', 'compra'),
	(11, 'aerolinea', 'checkin'),
	(12, 'aerolinea', 'maleta'),
	(13, 'aerolinea', 'reserva'),
	(14, 'aerolinea', 'historialoperacion'),
	(15, 'aerolinea', 'comentario'),
	(16, 'aerolinea', 'notificacion'),
	(17, 'aerolinea', 'publicacion');

-- Volcando estructura para tabla condor_airways.django_migrations
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_migrations: ~19 rows (aproximadamente)
INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2025-09-14 22:31:04.500826'),
	(2, 'auth', '0001_initial', '2025-09-14 22:31:13.015985'),
	(3, 'admin', '0001_initial', '2025-09-14 22:31:14.725590'),
	(4, 'admin', '0002_logentry_remove_auto_add', '2025-09-14 22:31:14.805700'),
	(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-09-14 22:31:15.098814'),
	(7, 'contenttypes', '0002_remove_content_type_name', '2025-09-14 22:31:18.418831'),
	(8, 'auth', '0002_alter_permission_name_max_length', '2025-09-14 22:31:19.240020'),
	(9, 'auth', '0003_alter_user_email_max_length', '2025-09-14 22:31:19.858553'),
	(10, 'auth', '0004_alter_user_username_opts', '2025-09-14 22:31:19.925124'),
	(11, 'auth', '0005_alter_user_last_login_null', '2025-09-14 22:31:21.015931'),
	(12, 'auth', '0006_require_contenttypes_0002', '2025-09-14 22:31:21.038286'),
	(13, 'auth', '0007_alter_validators_add_error_messages', '2025-09-14 22:31:21.093178'),
	(14, 'auth', '0008_alter_user_username_max_length', '2025-09-14 22:31:22.147553'),
	(15, 'auth', '0009_alter_user_last_name_max_length', '2025-09-14 22:31:22.924424'),
	(16, 'auth', '0010_alter_group_name_max_length', '2025-09-14 22:31:23.811661'),
	(17, 'auth', '0011_update_proxy_permissions', '2025-09-14 22:31:23.945929'),
	(18, 'auth', '0012_alter_user_first_name_max_length', '2025-09-14 22:31:24.943582'),
	(19, 'sessions', '0001_initial', '2025-09-14 22:31:25.975019'),
	(22, 'aerolinea', '0001_initial', '2025-09-16 20:46:04.181214');

-- Volcando estructura para tabla condor_airways.django_session
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_session: ~1 rows (aproximadamente)
INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
	('xve2j9n14ildmc4mhw5o5frb35e26mj0', '.eJxVjEEOwiAQRe_C2hAQKIxL9z0DGZhBqoYmpV0Z765NutDtf-_9l4i4rTVunZc4kbgILU6_W8L84LYDumO7zTLPbV2mJHdFHrTLcSZ-Xg_376Bir986WAODTdlg5mQAKJCBAqTQQihnZ5Rnn9g51DqgK0PIxNoilaCyd068P-glOB0:1uygQE:7avZRUDYEyOT94HxScNazuMNv_r9a-SQlbUYvjOipM0', '2025-10-01 00:53:22.075555');

-- Volcando estructura para tabla condor_airways.maleta
CREATE TABLE IF NOT EXISTS `maleta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `checkin_id` int(11) NOT NULL,
  `peso` decimal(5,2) DEFAULT 0.00,
  `costo` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `checkin_id` (`checkin_id`),
  CONSTRAINT `maleta_ibfk_1` FOREIGN KEY (`checkin_id`) REFERENCES `checkin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.maleta: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.reserva
CREATE TABLE IF NOT EXISTS `reserva` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `vuelo_id` int(11) NOT NULL,
  `fecha_reserva` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` enum('activa','cancelada','vencida') DEFAULT 'activa',
  `num_tiquetes` int(11) DEFAULT NULL CHECK (`num_tiquetes` between 1 and 5),
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `vuelo_id` (`vuelo_id`),
  CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`),
  CONSTRAINT `reserva_ibfk_2` FOREIGN KEY (`vuelo_id`) REFERENCES `vuelo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.reserva: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.rol
CREATE TABLE IF NOT EXISTS `rol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.rol: ~4 rows (aproximadamente)
INSERT INTO `rol` (`id`, `nombre`) VALUES
	(1, 'Cliente'),
	(2, 'Administrador'),
	(3, 'Root');

-- Volcando estructura para tabla condor_airways.usuario
CREATE TABLE IF NOT EXISTS `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `rol_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `rol_id` (`rol_id`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `rol` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.usuario: ~0 rows (aproximadamente)
INSERT INTO `usuario` (`id`, `nombre`, `email`, `password`, `telefono`, `direccion`, `rol_id`) VALUES
	(1, 'Karen', 'karen@utp.edu.co', '1234', NULL, NULL, 1);

-- Volcando estructura para tabla condor_airways.vuelo
CREATE TABLE IF NOT EXISTS `vuelo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) NOT NULL,
  `origen` varchar(50) NOT NULL,
  `destino` varchar(50) NOT NULL,
  `fecha_salida` datetime NOT NULL,
  `fecha_llegada` datetime NOT NULL,
  `capacidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.vuelo: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
