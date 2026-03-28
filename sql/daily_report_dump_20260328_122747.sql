-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: localhost    Database: daily_report
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '3e6388e8-2a39-11f1-925c-da4ae2913039:1-437';

--
-- Table structure for table `app_settings`
--

DROP TABLE IF EXISTS `app_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_settings` (
  `setting_key` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_settings`
--

LOCK TABLES `app_settings` WRITE;
/*!40000 ALTER TABLE `app_settings` DISABLE KEYS */;
INSERT INTO `app_settings` VALUES ('viewLayout','[{\"key\":\"production\",\"name\":\"生产组织与趋势\",\"visible\":true,\"sort\":1,\"groups\":[\"采煤\"],\"fields\":[\"suggestedRings\",\"actualMiddle\",\"actualNight\",\"actualMorning\"]},{\"key\":\"custom_nengliang\",\"name\":\"能量事件\",\"visible\":true,\"sort\":2,\"groups\":[\"采煤\"],\"fields\":[\"dangrizongnengliang\",\"dangrisicifangyishang\"]},{\"key\":\"position\",\"name\":\"工作面位置\",\"visible\":true,\"sort\":3,\"groups\":[\"采煤\"],\"fields\":[\"jiaoyunLane\",\"huifengLane\"]},{\"key\":\"deformation\",\"name\":\"变形监测\",\"visible\":true,\"sort\":4,\"groups\":[\"共用\"],\"fields\":[\"deformationValue\",\"deformationNormalMin\",\"deformationNormalMax\"]},{\"key\":\"pressure\",\"name\":\"周期来压\",\"visible\":true,\"sort\":5,\"groups\":[\"采煤\"],\"fields\":[\"pressureCycle\",\"daysSincePressure\"]},{\"key\":\"hanging\",\"name\":\"悬顶情况\",\"visible\":true,\"sort\":6,\"groups\":[\"采煤\"],\"fields\":[\"hangingRoof\"]},{\"key\":\"settlement\",\"name\":\"地表沉降\",\"visible\":true,\"sort\":7,\"groups\":[\"采煤\"],\"fields\":[\"surfaceSettlement\"]},{\"key\":\"remark\",\"name\":\"备注\",\"visible\":true,\"sort\":8,\"groups\":[\"共用\"],\"fields\":[\"remark\"]},{\"key\":\"conclusion\",\"name\":\"综合结论\",\"visible\":true,\"sort\":9,\"groups\":[\"采煤\"],\"fields\":[\"conclusion\",\"dangrizongnengliang\",\"dangrisicifangyishang\"]}]');
/*!40000 ALTER TABLE `app_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily`
--

DROP TABLE IF EXISTS `daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date DEFAULT NULL,
  `workface` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `suggestedRings` double DEFAULT NULL,
  `suggestedBy` text COLLATE utf8mb4_unicode_ci,
  `actualNight` double DEFAULT NULL,
  `actualNightBy` text COLLATE utf8mb4_unicode_ci,
  `actualMorning` double DEFAULT NULL,
  `actualMorningBy` text COLLATE utf8mb4_unicode_ci,
  `actualMiddle` double DEFAULT NULL,
  `actualMiddleBy` text COLLATE utf8mb4_unicode_ci,
  `jiaoyunLane` text COLLATE utf8mb4_unicode_ci,
  `jiaoyunLaneBy` text COLLATE utf8mb4_unicode_ci,
  `huifengLane` text COLLATE utf8mb4_unicode_ci,
  `huifengLaneBy` text COLLATE utf8mb4_unicode_ci,
  `deformationValue` double DEFAULT NULL,
  `deformationValueBy` text COLLATE utf8mb4_unicode_ci,
  `deformationNormalMin` double DEFAULT NULL,
  `deformationNormalMax` double DEFAULT NULL,
  `pressureCycle` text COLLATE utf8mb4_unicode_ci,
  `pressureCycleBy` text COLLATE utf8mb4_unicode_ci,
  `daysSincePressure` int DEFAULT NULL,
  `hangingRoof` double DEFAULT NULL,
  `hangingRoofBy` text COLLATE utf8mb4_unicode_ci,
  `surfaceSettlement` double DEFAULT NULL,
  `surfaceSettlementBy` text COLLATE utf8mb4_unicode_ci,
  `conclusion` text COLLATE utf8mb4_unicode_ci,
  `conclusionBy` text COLLATE utf8mb4_unicode_ci,
  `remark` text COLLATE utf8mb4_unicode_ci,
  `filledBy` text COLLATE utf8mb4_unicode_ci,
  `createdAt` datetime DEFAULT NULL,
  `status` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT 'draft',
  `extraData` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_date_workface` (`date`,`workface`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily`
--

LOCK TABLES `daily` WRITE;
/*!40000 ALTER TABLE `daily` DISABLE KEYS */;
INSERT INTO `daily` VALUES ('1719de90-8abb-4419-a380-3e3c384c803f','2026-03-25','30102',10,'',3,'',2,'',4,'','1500','','1501','',5,'',0,0,'未来压','',0,20,'',2,'','测试数据','','','','2026-03-25 22:30:47','completed',NULL),('4dd74006-fb3c-428c-b601-8ddf70e3a324','2026-03-25','30210',8,'',4,'',1,'',3,'','','','','',NULL,'',NULL,NULL,'未 来压','',3,NULL,'',NULL,'','','','','jcy','2026-03-27 14:40:15','completed','{\"dangrizongnengliang\":\"70000\",\"dangrisicifangyishang\":\"5\"}'),('6924b8ce-0289-44ee-ad19-e1d17202584c','2026-03-22','30210',9,'',4,'',1,'',4,'','','','','',NULL,'',NULL,NULL,'来压强烈','',0,NULL,'',NULL,'','','','','jcy','2026-03-27 14:42:26','completed','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"1\"}'),('9f503e55-95b4-491d-a1a7-0a631caca9ae','2026-03-23','30210',9,'',2,'',1,'',3,'','','','','',NULL,'',NULL,NULL,'未 来压','',1,NULL,'',NULL,'','','','','jcy','2026-03-27 14:41:45','completed','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"2\"}'),('b33eed91-8a73-476e-af36-fd6200674c8a','2026-03-24','30210',9,'',3,'',0,'',4,'','','','','',NULL,'',NULL,NULL,'未 来压','',2,NULL,'',NULL,'','','','','jcy','2026-03-27 14:41:00','completed','{\"dangrizongnengliang\":\"80000\",\"dangrisicifangyishang\":\"6\"}'),('c3c5d838-5258-419c-a6f4-065164d24e86','2026-03-28','30210',9,'',3,'',2,'',3,'','','','','',NULL,'',NULL,NULL,'未 来压','',1,NULL,'',NULL,'','','','','jcy','2026-03-28 01:22:53','completed','{\"dangrizongnengliang\":\"50000\",\"dangrisicifangyishang\":\"5\"}'),('cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','2026-03-26','30210',9,'',3,'',2,'',2,'','','','','',NULL,'',NULL,NULL,'未 来压','',4,NULL,'',NULL,'','','','','jcy','2026-03-25 22:27:30','completed','{\"dangrizongnengliang\":\"40000\",\"dangrisicifangyishang\":\"3\"}'),('d2d4cd49-590b-404b-a178-cfb70e5f000a','2026-03-20','30210',0,'',4.11,'',0.63,'',2.53,'','2069','','2069','',0,'',0,0,'','',0,0,'',0,'','','','','jcy','2026-03-27 14:43:52','completed',NULL),('d47d3df7-a945-4741-9d31-adcbffbf795f','2026-03-27','30210',9,'',5,'',1,'',3,'','','','','',NULL,'',NULL,NULL,'来压强烈','',0,NULL,'',NULL,'','','','','jcy','2026-03-27 14:38:06','completed','{\"dangrizongnengliang\":\"630000\",\"dangrisicifangyishang\":\"4\"}'),('d7455829-e3af-4cfb-a681-ea8a144aaf98','2026-03-21','30210',9,'',1,'',1,'',3,'','','','','',NULL,'',NULL,NULL,'','',NULL,NULL,'',NULL,'','','','','jcy','2026-03-27 14:43:04','completed',NULL);
/*!40000 ALTER TABLE `daily` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields`
--

DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fields` (
  `field_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `group_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dept` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `sort_order` int DEFAULT '0',
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields`
--

LOCK TABLES `fields` WRITE;
/*!40000 ALTER TABLE `fields` DISABLE KEYS */;
INSERT INTO `fields` VALUES ('actualMiddle','中班刀数','采煤','',4),('actualMorning','早班刀数','采煤','',6),('actualNight','夜班刀数','采煤','',5),('conclusion','综合结论','共用','',13),('dangrisicifangyishang','当日四次方以上事件数','采煤','',15),('dangrizongnengliang','当日总能量','采煤','',14),('deformationValue','围岩变形监测','共用','',9),('hangingRoof','机尾悬顶情况','采煤','',11),('huifengLane','回风巷位置','采煤','',8),('jiaoyunLane','胶运巷位置','采煤','',7),('pressureCycle','周期来压','采煤','',10),('suggestedRings','建议刀数','采煤','',1),('surfaceSettlement','地表沉降情况','采煤','',12);
/*!40000 ALTER TABLE `fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `table_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `record_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field_name` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_value` text COLLATE utf8mb4_unicode_ci,
  `new_value` text COLLATE utf8mb4_unicode_ci,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=280 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,'jcy','insert','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','all','','New record created','2026-03-25 22:27:30'),(2,NULL,'insert','daily','1719de90-8abb-4419-a380-3e3c384c803f','all','','New record created','2026-03-25 22:30:47'),(3,'jcy','insert','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','all','','New record created','2026-03-27 14:38:06'),(4,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','jiaoyunLane','','2103','2026-03-27 14:38:21'),(5,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','huifengLane','','2103','2026-03-27 14:38:21'),(6,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualNight','6','4.68','2026-03-27 14:39:26'),(7,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMiddle','5','2.68','2026-03-27 14:39:26'),(8,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','jiaoyunLane','2100','2103','2026-03-27 14:39:26'),(9,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','huifengLane','2101','2103','2026-03-27 14:39:26'),(10,'jcy','insert','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','all','','New record created','2026-03-27 14:40:15'),(11,'jcy','insert','daily','b33eed91-8a73-476e-af36-fd6200674c8a','all','','New record created','2026-03-27 14:41:00'),(12,'jcy','insert','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','all','','New record created','2026-03-27 14:41:45'),(13,'jcy','insert','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','all','','New record created','2026-03-27 14:42:26'),(14,'jcy','insert','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','all','','New record created','2026-03-27 14:43:04'),(15,'jcy','insert','daily','d2d4cd49-590b-404b-a178-cfb70e5f000a','all','','New record created','2026-03-27 14:43:52'),(16,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','suggestedRings','0','9','2026-03-27 14:53:13'),(17,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','huifengLane','2103','','2026-03-27 14:53:13'),(18,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','filledBy','jcy','wxh','2026-03-27 14:53:13'),(19,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualNight','4.84','0','2026-03-27 14:53:13'),(20,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualMiddle','2.68','0','2026-03-27 14:53:13'),(21,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','jiaoyunLane','2103','','2026-03-27 14:53:13'),(22,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','suggestedRings','0','9','2026-03-27 14:53:19'),(23,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','jiaoyunLane','2103','','2026-03-27 14:53:19'),(24,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','huifengLane','2103','','2026-03-27 14:53:19'),(25,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','pressureCycle','未 来压','','2026-03-27 14:53:19'),(26,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','hangingRoof','30','0','2026-03-27 14:53:19'),(27,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','filledBy','jcy','wxh','2026-03-27 14:53:19'),(28,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMiddle','2.68','0','2026-03-27 14:53:19'),(29,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualNight','4.68','0','2026-03-27 14:53:19'),(30,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMorning','1','0','2026-03-27 14:53:19'),(31,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','suggestedRings','0','9','2026-03-27 14:53:23'),(32,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','jiaoyunLane','2097','','2026-03-27 14:53:23'),(33,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','huifengLane','2097','','2026-03-27 14:53:23'),(34,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','filledBy','jcy','wxh','2026-03-27 14:53:23'),(35,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualMorning','0.26','0','2026-03-27 14:53:23'),(36,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualMiddle','2.89','0','2026-03-27 14:53:23'),(37,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualNight','4.79','0','2026-03-27 14:53:23'),(38,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','suggestedRings','0','9','2026-03-27 14:53:28'),(39,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','jiaoyunLane','2091','','2026-03-27 14:53:28'),(40,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','huifengLane','2091','','2026-03-27 14:53:28'),(41,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','filledBy','jcy','wxh','2026-03-27 14:53:28'),(42,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualMorning','0.16','0','2026-03-27 14:53:28'),(43,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualMiddle','2.84','0','2026-03-27 14:53:28'),(44,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualNight','5.53','0','2026-03-27 14:53:28'),(45,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','suggestedRings','0','9','2026-03-27 14:53:33'),(46,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualNight','5.47','0','2026-03-27 14:53:33'),(47,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','huifengLane','2085','','2026-03-27 14:53:33'),(48,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','filledBy','jcy','wxh','2026-03-27 14:53:33'),(49,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualMorning','1','0','2026-03-27 14:53:33'),(50,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualMiddle','2','0','2026-03-27 14:53:33'),(51,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','jiaoyunLane','2085','','2026-03-27 14:53:33'),(52,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','suggestedRings','0','9','2026-03-27 14:53:37'),(53,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','huifengLane','2079','','2026-03-27 14:53:37'),(54,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','filledBy','jcy','wxh','2026-03-27 14:53:37'),(55,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualNight','4.84','0','2026-03-27 14:53:37'),(56,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualMiddle','2.63','0','2026-03-27 14:53:37'),(57,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','jiaoyunLane','2079','','2026-03-27 14:53:37'),(58,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','suggestedRings','0','9','2026-03-27 14:53:41'),(59,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','jiaoyunLane','2074','','2026-03-27 14:53:41'),(60,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','huifengLane','2074','','2026-03-27 14:53:41'),(61,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','filledBy','jcy','wxh','2026-03-27 14:53:41'),(62,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualMorning','0.16','0','2026-03-27 14:53:41'),(63,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualMiddle','2.58','0','2026-03-27 14:53:41'),(64,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualNight','4.53','0','2026-03-27 14:53:41'),(65,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','suggestedRings','9','null','2026-03-27 23:29:49'),(66,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','deformationNormalMin','0','null','2026-03-27 23:29:49'),(67,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualMiddle','0','2.68','2026-03-27 23:29:49'),(68,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','daysSincePressure','0','null','2026-03-27 23:29:49'),(69,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','hangingRoof','0','null','2026-03-27 23:29:49'),(70,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','surfaceSettlement','0','null','2026-03-27 23:29:49'),(71,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','filledBy','wxh','jcy','2026-03-27 23:29:49'),(72,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualNight','0','4.84','2026-03-27 23:29:49'),(73,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','deformationNormalMax','0','null','2026-03-27 23:29:49'),(74,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','deformationValue','0','null','2026-03-27 23:29:49'),(75,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','suggestedRings','9','null','2026-03-27 23:30:27'),(76,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','deformationValue','0','null','2026-03-27 23:30:27'),(77,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','deformationNormalMin','0','null','2026-03-27 23:30:27'),(78,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','deformationNormalMax','0','null','2026-03-27 23:30:27'),(79,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','daysSincePressure','0','null','2026-03-27 23:30:27'),(80,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','hangingRoof','0','null','2026-03-27 23:30:27'),(81,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','surfaceSettlement','0','null','2026-03-27 23:30:27'),(82,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','filledBy','wxh','jcy','2026-03-27 23:30:27'),(83,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMorning','0','1','2026-03-27 23:30:27'),(84,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMiddle','0','null','2026-03-27 23:30:27'),(85,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualNight','0','4.68','2026-03-27 23:30:27'),(86,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualMorning','0','null','2026-03-27 23:33:37'),(87,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualMiddle','2.68','2.684','2026-03-27 23:33:37'),(88,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualNight','4.68','4.684','2026-03-27 23:34:10'),(89,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','jiaoyunLane','','2103','2026-03-27 23:34:10'),(90,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','huifengLane','','2103','2026-03-27 23:34:10'),(91,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','suggestedRings','9','null','2026-03-27 23:34:59'),(92,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualNight','0','4.789','2026-03-27 23:34:59'),(93,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','huifengLane','','2097','2026-03-27 23:34:59'),(94,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','deformationValue','0','null','2026-03-27 23:34:59'),(95,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','deformationNormalMin','0','null','2026-03-27 23:34:59'),(96,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','deformationNormalMax','0','null','2026-03-27 23:34:59'),(97,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','daysSincePressure','0','null','2026-03-27 23:34:59'),(98,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','hangingRoof','0','null','2026-03-27 23:34:59'),(99,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','surfaceSettlement','0','null','2026-03-27 23:34:59'),(100,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','filledBy','wxh','jcy','2026-03-27 23:34:59'),(101,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualMiddle','0','2.895','2026-03-27 23:34:59'),(102,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','jiaoyunLane','','2097','2026-03-27 23:34:59'),(103,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualMorning','0','0.263','2026-03-27 23:34:59'),(104,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','suggestedRings','9','null','2026-03-27 23:35:38'),(105,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','jiaoyunLane','','2091','2026-03-27 23:35:38'),(106,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','huifengLane','','2091','2026-03-27 23:35:38'),(107,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','deformationValue','0','null','2026-03-27 23:35:38'),(108,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','deformationNormalMin','0','null','2026-03-27 23:35:38'),(109,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','deformationNormalMax','0','null','2026-03-27 23:35:38'),(110,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','daysSincePressure','0','null','2026-03-27 23:35:38'),(111,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','hangingRoof','0','null','2026-03-27 23:35:38'),(112,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','surfaceSettlement','0','null','2026-03-27 23:35:38'),(113,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','filledBy','wxh','jcy','2026-03-27 23:35:38'),(114,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualMiddle','0','2.842','2026-03-27 23:35:38'),(115,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualNight','0','5.526','2026-03-27 23:35:38'),(116,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualMorning','0','0.158','2026-03-27 23:35:38'),(117,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','suggestedRings','9','null','2026-03-27 23:36:13'),(118,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualNight','0','5.474','2026-03-27 23:36:13'),(119,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','huifengLane','','2085','2026-03-27 23:36:13'),(120,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','deformationValue','0','null','2026-03-27 23:36:13'),(121,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','deformationNormalMin','0','null','2026-03-27 23:36:13'),(122,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','deformationNormalMax','0','null','2026-03-27 23:36:13'),(123,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','daysSincePressure','0','null','2026-03-27 23:36:13'),(124,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','hangingRoof','0','null','2026-03-27 23:36:13'),(125,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','surfaceSettlement','0','null','2026-03-27 23:36:13'),(126,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','filledBy','wxh','jcy','2026-03-27 23:36:13'),(127,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualMiddle','0','2','2026-03-27 23:36:13'),(128,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','jiaoyunLane','','2085','2026-03-27 23:36:13'),(129,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualMorning','0','1','2026-03-27 23:36:13'),(130,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','suggestedRings','9','null','2026-03-27 23:36:58'),(131,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualNight','0','4.842','2026-03-27 23:36:58'),(132,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','deformationValue','0','null','2026-03-27 23:36:58'),(133,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','deformationNormalMin','0','null','2026-03-27 23:36:58'),(134,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','deformationNormalMax','0','null','2026-03-27 23:36:58'),(135,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','daysSincePressure','0','null','2026-03-27 23:36:58'),(136,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','hangingRoof','0','null','2026-03-27 23:36:58'),(137,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','surfaceSettlement','0','null','2026-03-27 23:36:58'),(138,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','filledBy','wxh','jcy','2026-03-27 23:36:58'),(139,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualMiddle','0','2.632','2026-03-27 23:36:58'),(140,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','jiaoyunLane','','2079','2026-03-27 23:36:58'),(141,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','huifengLane','','2079','2026-03-27 23:36:58'),(142,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','suggestedRings','9','null','2026-03-27 23:37:58'),(143,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualNight','0','4.526','2026-03-27 23:37:58'),(144,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','huifengLane','','2074','2026-03-27 23:37:58'),(145,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','deformationValue','0','null','2026-03-27 23:37:58'),(146,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','deformationNormalMin','0','null','2026-03-27 23:37:58'),(147,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','deformationNormalMax','0','null','2026-03-27 23:37:58'),(148,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','daysSincePressure','0','null','2026-03-27 23:37:58'),(149,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','hangingRoof','0','null','2026-03-27 23:37:58'),(150,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','surfaceSettlement','0','null','2026-03-27 23:37:58'),(151,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','filledBy','wxh','jcy','2026-03-27 23:37:58'),(152,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualMiddle','0','2.579','2026-03-27 23:37:58'),(153,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','jiaoyunLane','','2074','2026-03-27 23:37:58'),(154,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualMorning','0','0.158','2026-03-27 23:37:58'),(155,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMiddle','null','2.684','2026-03-27 23:38:55'),(156,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','suggestedRings','null','9','2026-03-27 23:39:58'),(157,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualMiddle','2.684','null','2026-03-27 23:39:58'),(158,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','filledBy','jcy','wxh','2026-03-27 23:39:58'),(159,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualNight','4.84','null','2026-03-27 23:39:58'),(160,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','suggestedRings','null','8.5','2026-03-27 23:40:04'),(161,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','jiaoyunLane','2103','','2026-03-27 23:40:04'),(162,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','huifengLane','2103','','2026-03-27 23:40:04'),(163,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','filledBy','jcy','wxh','2026-03-27 23:40:04'),(164,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMorning','1','null','2026-03-27 23:40:04'),(165,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMiddle','2.684','null','2026-03-27 23:40:04'),(166,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualNight','4.684','null','2026-03-27 23:40:04'),(167,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','suggestedRings','null','8','2026-03-27 23:40:09'),(168,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','jiaoyunLane','2097','','2026-03-27 23:40:09'),(169,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','huifengLane','2097','','2026-03-27 23:40:09'),(170,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','filledBy','jcy','wxh','2026-03-27 23:40:09'),(171,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualMorning','0.263','null','2026-03-27 23:40:09'),(172,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualMiddle','2.895','null','2026-03-27 23:40:09'),(173,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualNight','4.789','null','2026-03-27 23:40:09'),(174,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','suggestedRings','null','9','2026-03-27 23:40:14'),(175,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualNight','5.526','null','2026-03-27 23:40:14'),(176,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','huifengLane','2091','','2026-03-27 23:40:14'),(177,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','filledBy','jcy','wxh','2026-03-27 23:40:14'),(178,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualMorning','0.158','null','2026-03-27 23:40:14'),(179,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualMiddle','2.842','null','2026-03-27 23:40:14'),(180,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','jiaoyunLane','2091','','2026-03-27 23:40:14'),(181,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','suggestedRings','null','9','2026-03-27 23:40:19'),(182,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','jiaoyunLane','2085','','2026-03-27 23:40:19'),(183,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','huifengLane','2085','','2026-03-27 23:40:19'),(184,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','filledBy','jcy','wxh','2026-03-27 23:40:19'),(185,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualMorning','1','null','2026-03-27 23:40:19'),(186,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualMiddle','2','null','2026-03-27 23:40:19'),(187,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualNight','5.474','null','2026-03-27 23:40:19'),(188,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','suggestedRings','null','8','2026-03-27 23:40:24'),(189,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','jiaoyunLane','2079','','2026-03-27 23:40:24'),(190,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','huifengLane','2079','','2026-03-27 23:40:24'),(191,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','filledBy','jcy','wxh','2026-03-27 23:40:24'),(192,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualMorning','0','null','2026-03-27 23:40:24'),(193,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualMiddle','2.632','null','2026-03-27 23:40:24'),(194,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualNight','4.842','null','2026-03-27 23:40:24'),(195,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','suggestedRings','null','8.5','2026-03-27 23:40:30'),(196,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','jiaoyunLane','2074','','2026-03-27 23:40:30'),(197,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','huifengLane','2074','','2026-03-27 23:40:30'),(198,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','filledBy','jcy','wxh','2026-03-27 23:40:30'),(199,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualMorning','0.158','null','2026-03-27 23:40:30'),(200,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualMiddle','2.579','null','2026-03-27 23:40:30'),(201,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualNight','4.526','null','2026-03-27 23:40:30'),(202,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','suggestedRings','8.5','9','2026-03-27 23:48:49'),(203,'wxh','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','suggestedRings','8.5','9','2026-03-27 23:48:49'),(204,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','suggestedRings','8','9','2026-03-27 23:48:59'),(205,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualNight','null','5','2026-03-27 23:50:23'),(206,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','filledBy','wxh','jcy','2026-03-27 23:50:23'),(207,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualMorning','null','1','2026-03-27 23:50:23'),(208,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','actualMiddle','null','3','2026-03-27 23:50:23'),(209,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualNight','null','3','2026-03-27 23:50:23'),(210,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','filledBy','wxh','jcy','2026-03-27 23:50:23'),(211,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMorning','null','2','2026-03-27 23:50:23'),(212,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','actualMiddle','null','2','2026-03-27 23:50:23'),(213,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualNight','null','4','2026-03-27 23:50:23'),(214,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualMiddle','null','3','2026-03-27 23:50:23'),(215,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','filledBy','wxh','jcy','2026-03-27 23:50:23'),(216,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','actualMorning','null','1','2026-03-27 23:50:23'),(217,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualNight','null','3','2026-03-27 23:50:23'),(218,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualMiddle','null','4','2026-03-27 23:50:23'),(219,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','filledBy','wxh','jcy','2026-03-27 23:50:23'),(220,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','actualMorning','null','0','2026-03-27 23:50:23'),(221,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualNight','null','2','2026-03-27 23:50:23'),(222,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualMiddle','null','3','2026-03-27 23:50:23'),(223,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','filledBy','wxh','jcy','2026-03-27 23:50:23'),(224,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','actualMorning','null','1','2026-03-27 23:50:23'),(225,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualMiddle','null','3','2026-03-27 23:50:23'),(226,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualNight','null','4','2026-03-27 23:50:23'),(227,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualMorning','null','1','2026-03-27 23:50:23'),(228,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualMorning','null','1','2026-03-27 23:50:23'),(229,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','actualMiddle','null','4','2026-03-27 23:50:23'),(230,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','filledBy','wxh','jcy','2026-03-27 23:50:23'),(231,'jcy','update','daily','d7455829-e3af-4cfb-a681-ea8a144aaf98','actualNight','null','1','2026-03-27 23:50:23'),(232,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','filledBy','wxh','jcy','2026-03-27 23:50:23'),(233,'jcy','insert','daily','c3c5d838-5258-419c-a6f4-065164d24e86','all','','New record created','2026-03-28 01:22:53'),(234,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','filledBy','jcy','wxh','2026-03-28 03:49:05'),(235,'wxh','update','daily','c3c5d838-5258-419c-a6f4-065164d24e86','suggestedRings','null','9','2026-03-28 03:49:05'),(236,'wxh','update','daily','c3c5d838-5258-419c-a6f4-065164d24e86','filledBy','jcy','wxh','2026-03-28 03:49:05'),(237,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','filledBy','jcy','wxh','2026-03-28 03:49:05'),(238,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','filledBy','jcy','wxh','2026-03-28 03:49:05'),(239,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','filledBy','jcy','wxh','2026-03-28 03:49:05'),(240,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','filledBy','jcy','wxh','2026-03-28 03:49:05'),(241,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','filledBy','jcy','wxh','2026-03-28 03:49:05'),(242,'wxh','update','daily','c3c5d838-5258-419c-a6f4-065164d24e86','extraData','null','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"5\"}','2026-03-28 03:49:31'),(243,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','extraData','null','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"4\"}','2026-03-28 03:49:31'),(244,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','extraData','null','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"3\"}','2026-03-28 03:49:31'),(245,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','extraData','null','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"5\"}','2026-03-28 03:49:31'),(246,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','extraData','null','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"6\"}','2026-03-28 03:49:31'),(247,'wxh','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','extraData','null','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"2\"}','2026-03-28 03:49:31'),(248,'wxh','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','extraData','null','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"1\"}','2026-03-28 03:49:31'),(249,'wxh','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','extraData','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"6\"}','{\"dangrizongnengliang\":\"80000\",\"dangrisicifangyishang\":\"6\"}','2026-03-28 03:53:27'),(250,'wxh','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','extraData','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"4\"}','{\"dangrizongnengliang\":\"630000\",\"dangrisicifangyishang\":\"4\"}','2026-03-28 03:53:27'),(251,'wxh','update','daily','c3c5d838-5258-419c-a6f4-065164d24e86','extraData','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"5\"}','{\"dangrizongnengliang\":\"50000\",\"dangrisicifangyishang\":\"5\"}','2026-03-28 03:53:27'),(252,'wxh','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','extraData','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"3\"}','{\"dangrizongnengliang\":\"40000\",\"dangrisicifangyishang\":\"3\"}','2026-03-28 03:53:27'),(253,'wxh','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','extraData','{\"dangrizongnengliang\":\"\",\"dangrisicifangyishang\":\"5\"}','{\"dangrizongnengliang\":\"70000\",\"dangrisicifangyishang\":\"5\"}','2026-03-28 03:53:27'),(254,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','pressureCycle','','来压明显','2026-03-28 04:20:09'),(255,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','filledBy','wxh','jcy','2026-03-28 04:20:09'),(256,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','daysSincePressure','null','0','2026-03-28 04:20:09'),(257,'jcy','update','daily','c3c5d838-5258-419c-a6f4-065164d24e86','filledBy','wxh','jcy','2026-03-28 04:20:09'),(258,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','pressureCycle','','来压明显','2026-03-28 04:20:09'),(259,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','daysSincePressure','null','0','2026-03-28 04:20:09'),(260,'jcy','update','daily','c3c5d838-5258-419c-a6f4-065164d24e86','daysSincePressure','null','1','2026-03-28 04:20:09'),(261,'jcy','update','daily','c3c5d838-5258-419c-a6f4-065164d24e86','pressureCycle','','未 来压','2026-03-28 04:20:09'),(262,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','filledBy','wxh','jcy','2026-03-28 04:20:09'),(263,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','pressureCycle','','未 来压','2026-03-28 04:20:09'),(264,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','daysSincePressure','null','2','2026-03-28 04:20:09'),(265,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','filledBy','wxh','jcy','2026-03-28 04:20:09'),(266,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','pressureCycle','','未 来压','2026-03-28 04:20:09'),(267,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','daysSincePressure','null','1','2026-03-28 04:20:09'),(268,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','filledBy','wxh','jcy','2026-03-28 04:20:09'),(269,'jcy','update','daily','d47d3df7-a945-4741-9d31-adcbffbf795f','pressureCycle','来压明显','来压强烈','2026-03-28 04:21:08'),(270,'jcy','update','daily','cdb30bd0-5fd3-4ecf-b98b-5b9449c2e595','daysSincePressure','2','4','2026-03-28 04:21:08'),(271,'jcy','update','daily','4dd74006-fb3c-428c-b601-8ddf70e3a324','daysSincePressure','1','3','2026-03-28 04:21:08'),(272,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','pressureCycle','来压明显','未 来压','2026-03-28 04:21:08'),(273,'jcy','update','daily','b33eed91-8a73-476e-af36-fd6200674c8a','daysSincePressure','0','2','2026-03-28 04:21:08'),(274,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','pressureCycle','','来压强烈','2026-03-28 04:21:08'),(275,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','daysSincePressure','null','0','2026-03-28 04:21:08'),(276,'jcy','update','daily','6924b8ce-0289-44ee-ad19-e1d17202584c','filledBy','wxh','jcy','2026-03-28 04:21:08'),(277,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','pressureCycle','','未 来压','2026-03-28 04:21:08'),(278,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','daysSincePressure','null','1','2026-03-28 04:21:08'),(279,'jcy','update','daily','9f503e55-95b4-491d-a1a7-0a631caca9ae','filledBy','wxh','jcy','2026-03-28 04:21:08');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `workface` text COLLATE utf8mb4_unicode_ci,
  `fields` text COLLATE utf8mb4_unicode_ci,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('0f8128f8-156d-4944-a830-bee83f20c3f3','mxd','123456','viewer','30102,30206,30210','suggestedRings,actualMiddle,actualNight,actualMorning,jiaoyunLane,huifengLane,deformationValue,pressureCycle,hangingRoof,surfaceSettlement,conclusion','mxd'),('5ed45303-67d4-4c68-8ae5-027d6691630f','wxh','123456','user','30102,30206,30210','suggestedRings,conclusion,dangrizongnengliang,dangrisicifangyishang','wxh'),('bd8b01f8-a03a-4566-a940-038128e9e1f5','jcy','123456','user','30210','actualMiddle,actualNight,actualMorning,jiaoyunLane,huifengLane,deformationValue,pressureCycle,hangingRoof','jcy'),('bf6a50b4-1665-454f-8a66-87d3944f007b','admin','102184','admin','30210,30102','suggestedRings,actualNight,actualMorning,actualMiddle,jiaoyunLane,huifengLane,deformationValue,pressureCycle,hangingRoof,surfaceSettlement,conclusion','管理员');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workfaces`
--

DROP TABLE IF EXISTS `workfaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workfaces` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '采煤',
  `sort_order` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workfaces`
--

LOCK TABLES `workfaces` WRITE;
/*!40000 ALTER TABLE `workfaces` DISABLE KEYS */;
INSERT INTO `workfaces` VALUES ('30102','30102工作面','采煤',2),('30206','30206回风巷','掘进',3),('30210','30210工作面','采煤',1);
/*!40000 ALTER TABLE `workfaces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'daily_report'
--
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-28 12:28:55
