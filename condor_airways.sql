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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_checkin: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_checkin` (`id`, `asiento`, `pase_abordar`, `compra_id`) VALUES
	(17, '12A', '', 19);

-- Volcando estructura para tabla condor_airways.aerolinea_comentario
CREATE TABLE IF NOT EXISTS `aerolinea_comentario` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `contenido` longtext NOT NULL,
  `fecha` datetime(6) NOT NULL,
  `usuario_id` bigint(20) NOT NULL,
  `publicacion_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aerolinea_comentario_usuario_id_d0c4a70c_fk_aerolinea_usuario_id` (`usuario_id`),
  KEY `aerolinea_comentario_publicacion_id_d2145a29_fk_aerolinea` (`publicacion_id`),
  CONSTRAINT `aerolinea_comentario_publicacion_id_d2145a29_fk_aerolinea` FOREIGN KEY (`publicacion_id`) REFERENCES `aerolinea_publicacion` (`id`),
  CONSTRAINT `aerolinea_comentario_usuario_id_d0c4a70c_fk_aerolinea_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `aerolinea_usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_compra: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_compra` (`id`, `fecha_compra`, `estado`, `codigo_reserva`, `metodo_pago`, `usuario_id`, `vuelo_id`) VALUES
	(19, '2025-09-10 02:50:07.862201', 'activa', 'RES16249', 'Efectivo', 1, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_maleta: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_maleta` (`id`, `peso`, `costo`, `checkin_id`) VALUES
	(17, 1.00, 20000.00, 17);

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_notificacion: ~10 rows (aproximadamente)
INSERT INTO `aerolinea_notificacion` (`id`, `mensaje`, `enviada`, `fecha`, `usuario_id`) VALUES
	(1, 'Rerum magnam quaerat ea nobis ratione possimus minima.', 0, '2025-09-04 23:21:03.782975', 20),
	(2, 'A praesentium sapiente veritatis voluptatum quod magni architecto ab ipsa.', 1, '2025-09-04 23:21:04.161920', 21),
	(3, 'Quibusdam quam voluptate rerum vel facere aliquam fugiat non aut.', 1, '2025-09-04 23:21:04.361154', 22),
	(4, 'Fugit saepe pariatur nesciunt hic modi necessitatibus deleniti voluptates voluptatum debitis.', 0, '2025-09-04 23:21:04.571771', 23),
	(5, 'Voluptate placeat suscipit voluptatibus ratione suscipit nulla deleniti.', 0, '2025-09-04 23:21:04.727127', 24),
	(6, 'Corrupti reprehenderit magni perferendis ab minus impedit iste.', 1, '2025-09-04 23:28:02.592323', 25),
	(7, 'Officia dolores mollitia laborum error. Quibusdam ratione amet ea sapiente harum harum.', 1, '2025-09-04 23:28:02.913757', 26),
	(8, 'Eos nostrum reprehenderit repellat blanditiis fuga ea.', 0, '2025-09-04 23:28:03.202351', 27),
	(9, 'Laudantium sunt est reiciendis molestiae. Placeat nisi eligendi dignissimos iste eligendi.', 0, '2025-09-04 23:28:03.696044', 28),
	(10, 'Fugiat culpa consequuntur exercitationem at est. Error quis expedita incidunt sit eos.', 1, '2025-09-04 23:28:04.223337', 29);

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_publicacion: ~10 rows (aproximadamente)
INSERT INTO `aerolinea_publicacion` (`id`, `titulo`, `contenido`, `fecha`, `usuario_id`) VALUES
	(1, 'Architecto ab quasi culpa minima quibusdam.', 'Nulla natus quod culpa perspiciatis dolore. Aliquid suscipit deleniti.\nConsequatur quibusdam eum natus consequuntur. Est enim officiis eaque quas illo. Libero corporis fuga velit qui sequi excepturi.', '2025-09-04 23:21:03.740410', 20),
	(2, 'Nihil rerum deleniti.', 'Molestias facilis quia ratione qui. Molestias error enim sapiente doloremque illo. Doloremque iste vitae quas voluptatem.', '2025-09-04 23:21:04.050626', 21),
	(3, 'Eius quas ipsum eaque illum.', 'Voluptas laborum esse ea quae eos consectetur. Velit ut non possimus maxime. Quisquam ullam possimus. Placeat eaque aliquam nesciunt dolorum ea soluta esse.', '2025-09-04 23:21:04.314775', 22),
	(4, 'Ab asperiores soluta.', 'Quas molestias sapiente fugiat. Veritatis quidem error laudantium.\nNisi magnam cum. Quasi ipsum praesentium at commodi in nobis.\nEsse sunt nihil officiis suscipit. Accusamus beatae laborum.', '2025-09-04 23:21:04.494709', 23),
	(5, 'Perspiciatis quis corporis dicta aut ipsam.', 'Pariatur reprehenderit quasi et aliquid. Atque a distinctio nam sunt.\nQuisquam repellendus voluptates velit cupiditate fugiat. Quod itaque ex. Aperiam consectetur itaque quibusdam incidunt nisi.', '2025-09-04 23:21:04.694337', 24),
	(6, 'Laboriosam hic nostrum eveniet expedita illo.', 'Aspernatur commodi ducimus reprehenderit aliquid quasi. Nemo voluptatum neque nemo omnis a. Rerum itaque tenetur perferendis facilis voluptatem rerum.\nExpedita tempore molestiae architecto.', '2025-09-04 23:28:02.559384', 25),
	(7, 'A fugiat laborum aspernatur animi dicta.', 'Sapiente error cum consequuntur veritatis nesciunt tempora. Ex porro sint placeat consectetur exercitationem.', '2025-09-04 23:28:02.814354', 26),
	(8, 'Quae ipsa dolore nemo quis sapiente autem.', 'Consequuntur quidem sint reprehenderit quisquam iusto unde. Vero quae beatae aperiam. Impedit numquam pariatur odit.\nVoluptates eum dolorum delectus atque. Dolorum occaecati non a placeat.', '2025-09-04 23:28:03.158487', 27),
	(9, 'Dolores facere voluptatem vitae suscipit quis.', 'Eaque autem perferendis commodi facere ullam. Labore cum ad. Minus eaque dolorum voluptates.\nVeniam quos dolores autem numquam est aspernatur vero. Non veniam perferendis officiis quisquam minus.', '2025-09-04 23:28:03.462614', 28),
	(10, 'Exercitationem odit ratione maiores.', 'Nemo officiis reprehenderit qui vel quae. Facere mollitia nesciunt.\nHarum nobis nesciunt magni. Possimus excepturi sit dolorum placeat ipsam. Eaque numquam fugiat exercitationem sunt ullam.', '2025-09-04 23:28:04.071689', 29);

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_reserva: ~1 rows (aproximadamente)
INSERT INTO `aerolinea_reserva` (`id`, `fecha_reserva`, `estado`, `num_tiquetes`, `usuario_id`, `vuelo_id`) VALUES
	(4, '2025-09-10 02:50:03.824605', 'confirmada', 3, 1, 1);

-- Volcando estructura para tabla condor_airways.aerolinea_rol
CREATE TABLE IF NOT EXISTS `aerolinea_rol` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_rol: ~3 rows (aproximadamente)
INSERT INTO `aerolinea_rol` (`id`, `nombre`) VALUES
	(1, 'Cliente'),
	(2, 'Administrador'),
	(3, 'Root');

-- Volcando estructura para tabla condor_airways.aerolinea_usuario
CREATE TABLE IF NOT EXISTS `aerolinea_usuario` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol_id` bigint(20) NOT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `aerolinea_usuario_rol_id_15a7aa42_fk_aerolinea_rol_id` (`rol_id`),
  CONSTRAINT `aerolinea_usuario_rol_id_15a7aa42_fk_aerolinea_rol_id` FOREIGN KEY (`rol_id`) REFERENCES `aerolinea_rol` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_usuario: ~27 rows (aproximadamente)
INSERT INTO `aerolinea_usuario` (`id`, `nombre`, `email`, `password`, `rol_id`, `direccion`, `telefono`) VALUES
	(1, 'Karen Cardona', 'karen@utp.edu.co', '1234', 1, NULL, NULL),
	(2, 'Admin Condor', 'admin@condor.com', 'admin123', 2, NULL, NULL),
	(3, 'Harold Juan Fonseca Daza', 'quinterohernan@example.com', '1234', 1, 'Ragonvalia', '(+57)3138520619'),
	(4, 'Silvia Sánchez', 'munozmiller@example.com', '1234', 1, 'Milán', '(+57)3074228777'),
	(5, 'Angélica Ortiz', 'munozeduardo@example.net', '1234', 1, 'Tibaná', '6609933'),
	(6, 'Andrés Julián Cardona', 'lizethibarra@example.net', '1234', 1, 'Motavita', '018009950654'),
	(7, 'Nidia Jennifer Pulido', 'hhoyos@example.com', '1234', 1, 'Topaipí', '(+57)3025554279'),
	(9, 'Leonardo Peña Ramírez', 'vargaslina@example.com', '1234', 1, 'Ginebra', '257 25 62'),
	(10, 'Johanna Sandra Arteaga Contreras', 'patriciaromero@example.com', '1234', 1, 'Armero', '57 300 663 80 24'),
	(11, 'René José Zapata', 'nury23@example.org', '1234', 1, 'Alpujarra', '318 063 15 82'),
	(12, 'María Dary Velásquez', 'marinaacosta@example.com', '1234', 1, 'Tubará', '57 305 093 71 91'),
	(13, 'Andrea Osorio', 'giovannygonzales@example.net', '1234', 1, 'San José del Guaviare', '573281787863'),
	(15, 'Ferney Castillo Ríos', 'romerosebastian@example.org', '1234', 1, 'Cuaspud Carlosama', '57 318 955 72 92'),
	(16, 'Alfonso Pérez', 'leonardocano@example.com', '1234', 1, 'Angostura', '(+57)3110341524'),
	(17, 'Isabel Martínez Hurtado', 'marcelarivera@example.com', '1234', 1, 'El Carmen de Viboral', '(+57)3195967598'),
	(18, 'Diego Gómez', 'sancheznayibe@example.net', '1234', 1, 'Boyacá', '6035915322'),
	(19, 'Rosa Bonilla', 'carlos36@example.net', '1234', 1, 'Páramo', '3228948120'),
	(20, 'Manuel Gutiérrez Daza', 'kcortes@example.net', '1234', 1, 'Páez', '+573094452609'),
	(21, 'Fernanda Arteaga', 'gonzaloguerra@example.org', '1234', 1, 'Taraira', '+576043240625'),
	(22, 'Tatiana Lina Cáceres Gómez', 'andres63@example.net', '1234', 1, 'La Estrella', '018003807336'),
	(23, 'Carmen Flórez', 'camachojuan@example.com', '1234', 1, 'Guadalupe', '480 44 56'),
	(24, 'Anderson Arley Lara', 'sotoliliana@example.net', '1234', 1, 'Villahermosa', '7900768'),
	(25, 'Wilson Gabriel Díaz Osorio', 'johana56@example.org', '1234', 1, 'Mistrató', '+573107073100'),
	(26, 'Jesús Luis Molina', 'patricia16@example.com', '1234', 1, 'Unguía', '(+57)3080587789'),
	(27, 'Erika Rodríguez López', 'josegomez@example.org', '1234', 1, 'San Pablo', '+576057586986'),
	(28, 'Rafael Pulido', 'rcastro@example.org', '1234', 1, 'San Jacinto del Cauca', '+576052242789'),
	(29, 'Andrés Restrepo', 'rinconmaria@example.com', '1234', 1, 'Salamina', '(+57) 603 480 82 67');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.aerolinea_vuelo: ~6 rows (aproximadamente)
INSERT INTO `aerolinea_vuelo` (`id`, `codigo`, `origen`, `destino`, `fecha_salida`, `fecha_llegada`, `capacidad`, `precio`) VALUES
	(1, 'CO100', 'Pereira', 'Bogotá', '2025-09-10 08:00:00.000000', '2025-09-10 09:30:00.000000', 120, 250000.00),
	(2, 'CO200', 'Bogotá', 'Medellín', '2025-09-12 14:00:00.000000', '2025-09-12 15:00:00.000000', 100, 180000.00),
	(3, 'CO101', 'Bogotá', 'Medellín', '2025-09-30 10:21:43.000000', '2025-09-30 13:21:43.000000', 92, 161936.00),
	(4, 'CO102', 'Medellín', 'Pereira', '2025-09-11 12:55:29.000000', '2025-09-11 15:55:29.000000', 135, 425809.00),
	(5, 'CO103', 'Medellín', 'Pereira', '2025-09-06 18:33:08.000000', '2025-09-06 20:33:08.000000', 109, 348772.00),
	(6, 'CO104', 'Cali', 'Medellín', '2025-09-26 13:06:40.000000', '2025-09-26 16:06:40.000000', 125, 298445.00);

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

-- Volcando datos para la tabla condor_airways.auth_user: ~1 rows (aproximadamente)
INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
	(1, 'pbkdf2_sha256$1000000$4UqAdQtYC27jR8HxOMlDWH$e3GeywsdGNvMUnrORejUQlMDGeGm1wr3pI61PBZlm5w=', '2025-09-04 22:41:40.606689', 1, 'Karen', '', '', 'karenmanuela.cardona@utp.edu.co', 1, 1, '2025-09-04 22:38:51.622000');

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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Volcando datos para la tabla condor_airways.django_migrations: ~21 rows (aproximadamente)
INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
	(1, 'contenttypes', '0001_initial', '2025-09-04 22:25:54.319964'),
	(2, 'auth', '0001_initial', '2025-09-04 22:26:05.759956'),
	(3, 'admin', '0001_initial', '2025-09-04 22:26:07.572287'),
	(4, 'admin', '0002_logentry_remove_auto_add', '2025-09-04 22:26:07.638751'),
	(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-09-04 22:26:08.191443'),
	(6, 'aerolinea', '0001_initial', '2025-09-04 22:26:09.685446'),
	(7, 'contenttypes', '0002_remove_content_type_name', '2025-09-04 22:26:11.006626'),
	(8, 'auth', '0002_alter_permission_name_max_length', '2025-09-04 22:26:12.221545'),
	(9, 'auth', '0003_alter_user_email_max_length', '2025-09-04 22:26:12.937395'),
	(10, 'auth', '0004_alter_user_username_opts', '2025-09-04 22:26:13.074639'),
	(11, 'auth', '0005_alter_user_last_login_null', '2025-09-04 22:26:14.241921'),
	(12, 'auth', '0006_require_contenttypes_0002', '2025-09-04 22:26:14.270158'),
	(13, 'auth', '0007_alter_validators_add_error_messages', '2025-09-04 22:26:14.444142'),
	(14, 'auth', '0008_alter_user_username_max_length', '2025-09-04 22:26:15.189292'),
	(15, 'auth', '0009_alter_user_last_name_max_length', '2025-09-04 22:26:15.895976'),
	(16, 'auth', '0010_alter_group_name_max_length', '2025-09-04 22:26:17.309974'),
	(17, 'auth', '0011_update_proxy_permissions', '2025-09-04 22:26:17.522287'),
	(18, 'auth', '0012_alter_user_first_name_max_length', '2025-09-04 22:26:18.163069'),
	(19, 'sessions', '0001_initial', '2025-09-04 22:26:19.367169'),
	(20, 'aerolinea', '0002_vuelo_usuario_direccion_usuario_telefono_compra_and_more', '2025-09-04 22:32:05.056974'),
	(21, 'aerolinea', '0003_historialoperacion_notificacion_publicacion_and_more', '2025-09-04 23:10:12.678054');

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
	('6bgqfo5kbgs7r67n8y4s0hs9onyglv21', '.eJxVjMsOwiAURP-FtSGUty7d9xvI5V6QqoGktCvjvytJF7qbzDkzLxZg30rYe1rDQuzCJnb67SLgI9UB6A711ji2uq1L5EPhB-18bpSe18P9OyjQy3ctXFZW6By11E5hisL7aElIFOgUnY20BBGVGjmLKZOxkEAq9DIZqdn7A9gfN78:1uuIeC:7T2RzOrI1m28DN-WDSzmmlWWm1y9gTJzUXRS8Bk-6mE', '2025-09-18 22:41:40.766119');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
