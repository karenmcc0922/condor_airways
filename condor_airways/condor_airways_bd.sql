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

-- Volcando estructura para tabla condor_airways.aerolinea_capital
CREATE TABLE IF NOT EXISTS `aerolinea_capital` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `lat` double NOT NULL,
  `lon` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_capital: ~37 rows (aproximadamente)
INSERT INTO `aerolinea_capital` (`id`, `nombre`, `lat`, `lon`) VALUES
	(1, 'ARAUCA', 7.0847, -70.7591),
	(2, 'ARMENIA', 4.5339, -75.6811),
	(3, 'BARRANQUILLA', 10.9685, -74.7813),
	(4, 'BOGOTA', 4.711, -74.0721),
	(5, 'BUCARAMANGA', 7.1193, -73.1227),
	(6, 'CALI', 3.4516, -76.5319),
	(7, 'CARTAGENA', 10.391, -75.4794),
	(8, 'CUCUTA', 7.8939, -72.5078),
	(9, 'FLORENCIA', 1.6144, -75.6062),
	(10, 'IBAGUE', 4.4389, -75.2322),
	(11, 'INIRIDA', 3.8653, -67.9239),
	(12, 'LETICIA', -4.2153, -69.9406),
	(13, 'MANIZALES', 5.0703, -75.5138),
	(14, 'MEDELLIN', 6.2442, -75.5812),
	(15, 'MITU', 1.1983, -70.1733),
	(16, 'MOCOA', 1.1498, -76.6463),
	(17, 'MONTERIA', 8.748, -75.8814),
	(18, 'NEIVA', 2.9273, -75.2819),
	(19, 'PASTO', 1.2136, -77.2811),
	(20, 'PEREIRA', 4.8143, -75.6946),
	(21, 'POPAYAN', 2.4437, -76.6147),
	(22, 'PUERTO_CARREÑO', 6.187, -67.4859),
	(23, 'QUIBDO', 5.6947, -76.6612),
	(24, 'RIOHACHA', 11.5444, -72.9073),
	(25, 'SAN_ANDRES', 12.5847, -81.7006),
	(26, 'SAN_JOSE_DEL_GUAVIARE', 2.5658, -72.6396),
	(27, 'SANTA_MARTA', 11.2408, -74.199),
	(28, 'SINCELEJO', 9.3047, -75.3978),
	(29, 'TUNJA', 5.5353, -73.3678),
	(30, 'VALLEDUPAR', 10.4631, -73.2532),
	(31, 'VILLAVICENCIO', 4.142, -73.6266),
	(32, 'YOPAL', 5.3378, -72.3959),
	(33, 'MADRID', 40.4168, -3.7038),
	(34, 'LONDRES', 51.5074, -0.1278),
	(35, 'NUEVA_YORK', 40.7128, -74.006),
	(36, 'BUENOS_AIRES', -34.6037, -58.3816),
	(37, 'MIAMI', 25.7617, -80.1918);

-- Volcando estructura para tabla condor_airways.aerolinea_checkin
CREATE TABLE IF NOT EXISTS `aerolinea_checkin` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `asiento` varchar(5) NOT NULL,
  `pase_abordar` varchar(100) DEFAULT NULL,
  `compra_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_checkin_compra_id_0a66f7be_fk_aerolinea_compra_id` (`compra_id`),
  CONSTRAINT `aerolinea_checkin_compra_id_0a66f7be_fk_aerolinea_compra_id` FOREIGN KEY (`compra_id`) REFERENCES `aerolinea_compra` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_checkin: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_compra: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_maleta: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_reserva: ~0 rows (aproximadamente)

-- Volcando estructura para tabla condor_airways.aerolinea_rol
CREATE TABLE IF NOT EXISTS `aerolinea_rol` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_rol: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_rol` (`id`, `nombre`) VALUES
	(1, 'Cliente');

-- Volcando estructura para tabla condor_airways.aerolinea_usuario
CREATE TABLE IF NOT EXISTS `aerolinea_usuario` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol_id` bigint(20) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `es_admin` tinyint(1) NOT NULL,
  `direccion_facturacion` varchar(200) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `genero` varchar(20) NOT NULL,
  `imagen_usuario` varchar(100) DEFAULT NULL,
  `lugar_nacimiento` varchar(100) NOT NULL,
  `apellidos` varchar(150) DEFAULT NULL,
  `nombres` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `dni` (`dni`),
  KEY `aerolinea_usuario_rol_id_15a7aa42_fk_aerolinea_rol_id` (`rol_id`),
  CONSTRAINT `aerolinea_usuario_rol_id_15a7aa42_fk_aerolinea_rol_id` FOREIGN KEY (`rol_id`) REFERENCES `aerolinea_rol` (`id`),
  CONSTRAINT `aerolinea_usuario_user_id_a42d0b57_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_usuario: ~4 rows (aproximadamente)
INSERT INTO `aerolinea_usuario` (`id`, `email`, `password`, `rol_id`, `user_id`, `fecha_nacimiento`, `es_admin`, `direccion_facturacion`, `dni`, `genero`, `imagen_usuario`, `lugar_nacimiento`, `apellidos`, `nombres`) VALUES
	(1, 'karenmanuela.cardona@utp.edu.co', 'karencilla22', 1, 2, '2002-09-22', 0, 'Jardín II etapa Mz 10 Casa 15', '1004778917', 'F', '', 'Pereira', 'Cardona Castaño', 'Karen Manuela'),
	(2, 'jhoncito@gmail.com', 'jhoncito08', 1, 3, '1971-08-19', 0, 'Avenida Simón Bolivar', '10141297', 'M', '', 'Pereira', 'Cardona Rodas', 'Jhon Alexander'),
	(3, 'dani@gmail.com', 'danielita06', 1, 4, '1992-10-06', 0, 'Belén Fátima', '1088303011', 'F', '', 'Pereira', 'Cardona Castaño', 'Daniela Alexandra'),
	(4, 'niyica123@gmail.com', 'yineth25', 1, 5, '1971-02-25', 0, 'Jardín II etapa Mz 10 Casa 15', '42101192', 'F', '', 'Pereira', 'Castaño Muñoz', 'Nidia Yineth');

-- Volcando estructura para tabla condor_airways.aerolinea_vuelo
CREATE TABLE IF NOT EXISTS `aerolinea_vuelo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) NOT NULL,
  `origen` varchar(50) NOT NULL,
  `destino` varchar(50) NOT NULL,
  `fecha_salida` date NOT NULL,
  `fecha_llegada` date NOT NULL,
  `capacidad` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `hora_llegada` time(6) DEFAULT NULL,
  `hora_salida` time(6) DEFAULT NULL,
  `tiempo_vuelo` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_vuelo: ~8 rows (aproximadamente)
INSERT INTO `aerolinea_vuelo` (`id`, `codigo`, `origen`, `destino`, `fecha_salida`, `fecha_llegada`, `capacidad`, `precio`, `tipo`, `hora_llegada`, `hora_salida`, `tiempo_vuelo`) VALUES
	(1, 'VN0001', 'ARAUCA', 'YOPAL', '2025-10-03', '2025-10-03', 150, 110000.00, 'NACIONAL', '09:20:00.000000', '08:30:00.000000', 50000000),
	(2, 'VN0002', 'ARMENIA', 'VILLAVICENCIO', '2025-10-04', '2025-10-04', 150, 110000.00, 'NACIONAL', '12:27:00.000000', '11:40:00.000000', 47000000),
	(3, 'VN0003', 'BARRANQUILLA', 'VALLEDUPAR', '2025-10-05', '2025-10-05', 150, 110000.00, 'NACIONAL', '15:26:00.000000', '14:45:00.000000', 41000000),
	(4, 'VN0004', 'BOGOTA', 'SANTA_MARTA', '2025-10-06', '2025-10-06', 150, 200000.00, 'NACIONAL', '09:16:00.000000', '07:40:00.000000', 96000000),
	(5, 'VI0001', 'PEREIRA', 'MADRID', '2025-10-07', '2025-10-08', 250, 1200000.00, 'INTERNACIONAL', '05:55:00.000000', '11:40:00.000000', 675000000),
	(6, 'VI0002', 'BOGOTA', 'LONDRES', '2025-10-11', '2025-10-12', 250, 1200000.00, 'INTERNACIONAL', '00:23:00.000000', '06:40:00.000000', 703000000),
	(7, 'VI0003', 'MEDELLIN', 'NUEVA_YORK', '2025-10-12', '2025-10-12', 250, 800000.00, 'INTERNACIONAL', '10:15:00.000000', '03:45:00.000000', 330000000),
	(8, 'VI0004', 'CALI', 'BUENOS_AIRES', '2025-10-17', '2025-10-17', 250, 750000.00, 'INTERNACIONAL', '09:05:00.000000', '00:30:00.000000', 395000000);

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
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.auth_permission: ~72 rows (aproximadamente)
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
	(25, 'Can add Capital', 7, 'add_capital'),
	(26, 'Can change Capital', 7, 'change_capital'),
	(27, 'Can delete Capital', 7, 'delete_capital'),
	(28, 'Can view Capital', 7, 'view_capital'),
	(29, 'Can add rol', 8, 'add_rol'),
	(30, 'Can change rol', 8, 'change_rol'),
	(31, 'Can delete rol', 8, 'delete_rol'),
	(32, 'Can view rol', 8, 'view_rol'),
	(33, 'Can add usuario', 9, 'add_usuario'),
	(34, 'Can change usuario', 9, 'change_usuario'),
	(35, 'Can delete usuario', 9, 'delete_usuario'),
	(36, 'Can view usuario', 9, 'view_usuario'),
	(37, 'Can add vuelo', 10, 'add_vuelo'),
	(38, 'Can change vuelo', 10, 'change_vuelo'),
	(39, 'Can delete vuelo', 10, 'delete_vuelo'),
	(40, 'Can view vuelo', 10, 'view_vuelo'),
	(41, 'Can add reserva', 11, 'add_reserva'),
	(42, 'Can change reserva', 11, 'change_reserva'),
	(43, 'Can delete reserva', 11, 'delete_reserva'),
	(44, 'Can view reserva', 11, 'view_reserva'),
	(45, 'Can add compra', 12, 'add_compra'),
	(46, 'Can change compra', 12, 'change_compra'),
	(47, 'Can delete compra', 12, 'delete_compra'),
	(48, 'Can view compra', 12, 'view_compra'),
	(49, 'Can add check in', 13, 'add_checkin'),
	(50, 'Can change check in', 13, 'change_checkin'),
	(51, 'Can delete check in', 13, 'delete_checkin'),
	(52, 'Can view check in', 13, 'view_checkin'),
	(53, 'Can add maleta', 14, 'add_maleta'),
	(54, 'Can change maleta', 14, 'change_maleta'),
	(55, 'Can delete maleta', 14, 'delete_maleta'),
	(56, 'Can view maleta', 14, 'view_maleta'),
	(57, 'Can add historial operacion', 15, 'add_historialoperacion'),
	(58, 'Can change historial operacion', 15, 'change_historialoperacion'),
	(59, 'Can delete historial operacion', 15, 'delete_historialoperacion'),
	(60, 'Can view historial operacion', 15, 'view_historialoperacion'),
	(61, 'Can add publicacion', 16, 'add_publicacion'),
	(62, 'Can change publicacion', 16, 'change_publicacion'),
	(63, 'Can delete publicacion', 16, 'delete_publicacion'),
	(64, 'Can view publicacion', 16, 'view_publicacion'),
	(65, 'Can add comentario', 17, 'add_comentario'),
	(66, 'Can change comentario', 17, 'change_comentario'),
	(67, 'Can delete comentario', 17, 'delete_comentario'),
	(68, 'Can view comentario', 17, 'view_comentario'),
	(69, 'Can add notificacion', 18, 'add_notificacion'),
	(70, 'Can change notificacion', 18, 'change_notificacion'),
	(71, 'Can delete notificacion', 18, 'delete_notificacion'),
	(72, 'Can view notificacion', 18, 'view_notificacion');

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.auth_user: ~5 rows (aproximadamente)
INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
	(1, 'pbkdf2_sha256$1000000$jCkOGLG5V3jlG60yZ4dszI$jx2fvy/YETxDDzTb1CYJSfcuFJWENcZS2ES3fe2SMHQ=', '2025-10-03 02:37:56.629609', 1, 'KMCC', '', '', 'karencarcas@gmail.com', 1, 1, '2025-10-03 02:36:53.879821'),
	(2, 'pbkdf2_sha256$1000000$ofJnXU4VR2aTrJQH4Jebrq$L969OdhsZC+gsqfoBhY0/cCVXMWRtAvTXdsJx2ntumc=', NULL, 0, 'karencita22', '', '', 'karenmanuela.cardona@utp.edu.co', 0, 1, '2025-10-03 02:43:52.021891'),
	(3, 'pbkdf2_sha256$1000000$qLDydzRPzxVlvedOvlTs8H$YXZJTY5DFX1Y5TSMEAOPSVic7neb3vYmbp2Odji3pZA=', NULL, 0, 'jhoncito08', '', '', 'jhoncito@gmail.com', 0, 1, '2025-10-03 02:44:39.591774'),
	(4, 'pbkdf2_sha256$1000000$lWofykLFvNmHundrgwfnUf$uwDbmGZsDuh6poNzoORCo2fCqEoTZeDVLDZBdRgtuw4=', NULL, 0, 'danielita06', '', '', 'dani@gmail.com', 0, 1, '2025-10-03 02:45:42.856295'),
	(5, 'pbkdf2_sha256$1000000$YHfwoBL3eNWUBVwVeeRdty$rNYYMLvg2X2EUpnrgwkM3iTthZ9aJmv47PcVyWC19FY=', NULL, 0, 'yineth25', '', '', 'niyica123@gmail.com', 0, 1, '2025-10-03 02:46:51.501137');

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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_admin_log: ~11 rows (aproximadamente)
INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
	(1, '2025-10-03 02:32:18.577308', '1', 'VN0001 - ARAUCA → CUCUTA (NACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(2, '2025-10-03 02:32:47.189729', '2', 'VN0002 - ARAUCA → CUCUTA (NACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(3, '2025-10-03 02:33:25.851564', '3', 'VI0001 - PEREIRA → LONDRES (INTERNACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(4, '2025-10-03 02:38:41.492080', '1', 'VN0001 - ARAUCA → YOPAL (NACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(5, '2025-10-03 02:39:11.178228', '2', 'VN0002 - ARMENIA → VILLAVICENCIO (NACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(6, '2025-10-03 02:39:50.825667', '3', 'VN0003 - BARRANQUILLA → VALLEDUPAR (NACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(7, '2025-10-03 02:40:19.618306', '4', 'VN0004 - BOGOTA → SANTA_MARTA (NACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(8, '2025-10-03 02:40:48.012500', '5', 'VI0001 - PEREIRA → MADRID (INTERNACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(9, '2025-10-03 02:41:15.722711', '6', 'VI0002 - BOGOTA → LONDRES (INTERNACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(10, '2025-10-03 02:41:52.469471', '7', 'VI0003 - MEDELLIN → NUEVA_YORK (INTERNACIONAL)', 1, '[{"added": {}}]', 10, 1),
	(11, '2025-10-03 02:42:35.603135', '8', 'VI0004 - CALI → BUENOS_AIRES (INTERNACIONAL)', 1, '[{"added": {}}]', 10, 1);

-- Volcando estructura para tabla condor_airways.django_content_type
CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_content_type: ~18 rows (aproximadamente)
INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
	(1, 'admin', 'logentry'),
	(2, 'auth', 'permission'),
	(3, 'auth', 'group'),
	(4, 'auth', 'user'),
	(5, 'contenttypes', 'contenttype'),
	(6, 'sessions', 'session'),
	(7, 'aerolinea', 'capital'),
	(8, 'aerolinea', 'rol'),
	(9, 'aerolinea', 'usuario'),
	(10, 'aerolinea', 'vuelo'),
	(11, 'aerolinea', 'reserva'),
	(12, 'aerolinea', 'compra'),
	(13, 'aerolinea', 'checkin'),
	(14, 'aerolinea', 'maleta'),
	(15, 'aerolinea', 'historialoperacion'),
	(16, 'aerolinea', 'publicacion'),
	(17, 'aerolinea', 'comentario'),
	(18, 'aerolinea', 'notificacion');

-- Volcando estructura para tabla condor_airways.django_migrations
CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_migrations: ~29 rows (aproximadamente)
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
	(22, 'aerolinea', '0001_initial', '2025-09-16 20:46:04.181214'),
	(23, 'aerolinea', '0002_usuario_fecha_nacimiento_alter_usuario_rol', '2025-09-17 02:37:23.283008'),
	(24, 'aerolinea', '0003_usuario_es_admin', '2025-09-19 00:01:39.125052'),
	(25, 'aerolinea', '0004_vuelo_tipo', '2025-09-25 00:19:51.697836'),
	(26, 'aerolinea', '0005_remove_usuario_direccion_remove_usuario_telefono_and_more', '2025-09-27 01:33:08.634992'),
	(27, 'aerolinea', '0006_add_capital_model', '2025-09-30 21:00:40.539670'),
	(28, 'aerolinea', '0007_add_vuelo_time_fields', '2025-09-30 21:00:51.346123'),
	(29, 'aerolinea', '0008_alter_vuelo_precio', '2025-09-30 21:00:51.435827'),
	(30, 'aerolinea', '0009_alter_vuelo_fecha_llegada_alter_vuelo_fecha_salida', '2025-09-30 21:16:40.444769'),
	(31, 'aerolinea', '0002_remove_usuario_nombre_remove_usuario_nombre_completo_and_more', '2025-10-01 03:59:09.076856'),
	(32, 'aerolinea', '0003_fix_fecha_nacimiento', '2025-10-01 04:40:37.308586');

-- Volcando estructura para tabla condor_airways.django_session
CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_session: ~0 rows (aproximadamente)

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
