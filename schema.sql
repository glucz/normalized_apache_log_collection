
-- MariaDB dump 10.19  Distrib 10.4.33-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: agentinfo
-- ------------------------------------------------------
-- Server version       10.4.33-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agent`
--

DROP TABLE IF EXISTS `agent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agent` (
  `a_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `a_name` varchar(255) DEFAULT NULL,
  `a_start` date DEFAULT NULL,
  `a_last` date DEFAULT NULL,
  `a_valuedays` int(11) DEFAULT NULL,
  `a_realvaluedays` int(11) DEFAULT NULL,
  `a_mediumvaluedays` int(11) DEFAULT NULL,
  `a_emediumvaluedays` int(11) DEFAULT NULL,
  `a_totalhit` int(11) DEFAULT NULL,
  UNIQUE KEY `a_1` (`a_name`),
  KEY `a_id` (`a_id`)
) ENGINE=TokuDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domain`
--

DROP TABLE IF EXISTS `domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain` (
  `d_id` int(11) NOT NULL AUTO_INCREMENT,
  `d_name` varchar(100) DEFAULT NULL,
  UNIQUE KEY `d_1` (`d_name`),
  KEY `d_id` (`d_id`)
) ENGINE=TokuDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exturl`
--

DROP TABLE IF EXISTS `exturl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exturl` (
  `e_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `e_name` varchar(255) DEFAULT NULL,
  UNIQUE KEY `e_1` (`e_name`),
  KEY `e_id` (`e_id`)
) ENGINE=TokuDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hits`
--

DROP TABLE IF EXISTS `hits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hits` (
  `h_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `h_a_id` bigint(20) DEFAULT NULL,
  `h_ccode` varchar(8) DEFAULT NULL,
  `h_prox` tinyint(4) DEFAULT NULL,
  `h_mode` varchar(8) DEFAULT NULL,
  `h_i_id` bigint(20) DEFAULT NULL,
  `h_d_id` int(11) DEFAULT NULL,
  `h_u_id` bigint(20) DEFAULT NULL,
  `h_e_id` bigint(20) DEFAULT NULL,
  `h_status` int(11) DEFAULT NULL,
  `h_ts` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  KEY `h_id` (`h_id`),
  KEY `h_1` (`h_a_id`,`h_ts`),
  KEY `h_2` (`h_u_id`,`h_status`,`h_ts`),
  KEY `h_3` (`h_mode`,`h_status`,`h_ts`),
  KEY `h_4` (`h_e_id`,`h_status`,`h_ts`)
) ENGINE=TokuDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip`
--

DROP TABLE IF EXISTS `ip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip` (
  `i_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `i_name` varchar(50) DEFAULT NULL,
  `i_agent` bigint(20) DEFAULT NULL,
  `i_year` smallint(6) DEFAULT NULL,
  `i_month` tinyint(4) DEFAULT NULL,
  `i_count` int(11) DEFAULT 0,
  `i_ccode` varchar(8) DEFAULT NULL,
  `i_proxy` tinyint(4) DEFAULT 0,
  UNIQUE KEY `i_1` (`i_name`,`i_agent`,`i_year`,`i_month`),
  KEY `i_id` (`i_id`)
) ENGINE=TokuDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `url`
--

DROP TABLE IF EXISTS `url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `url` (
  `u_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `u_name` varchar(255) DEFAULT NULL,
  `u_extension` varchar(16) DEFAULT NULL,
  UNIQUE KEY `u_1` (`u_name`),
  KEY `u_id` (`u_id`)
) ENGINE=TokuDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-07 22:10:57
