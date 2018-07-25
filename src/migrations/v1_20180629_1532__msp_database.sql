-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 52.45.180.6    Database: msp_db
-- ------------------------------------------------------
-- Server version	5.5.52-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `msp_categories`
--

DROP TABLE IF EXISTS `msp_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_categories`
--

LOCK TABLES `msp_categories` WRITE;
/*!40000 ALTER TABLE `msp_categories` DISABLE KEYS */;
INSERT INTO `msp_categories` VALUES (0,'Research Protocols'),(1,'Policy Documents'),(2,'Data Ownership and Authorship'),(3,'Planning'),(4,'Data & Document Store'),(5,'Fieldwork'),(6,'Managing Data'),(7,'Metadata'),(8,' Archiving & Sharing');
/*!40000 ALTER TABLE `msp_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_download`
--

DROP TABLE IF EXISTS `msp_download`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_download` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `institute` longtext NOT NULL,
  `intended_use` longtext NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `filter_type` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_msp_download_msp_person1_idx1` (`user_id`),
  CONSTRAINT `fk_download_person` FOREIGN KEY (`user_id`) REFERENCES `msp_person` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_download`
--

LOCK TABLES `msp_download` WRITE;
/*!40000 ALTER TABLE `msp_download` DISABLE KEYS */;
INSERT INTO `msp_download` VALUES (45,23,'CCAFS','Testing','2018-06-29 20:30:28',0),(46,23,'CCAFS','Testing','2018-06-29 20:30:29',0),(47,24,'MARLO','Testing','2018-06-29 20:30:29',0),(48,25,'DAPA','Testing','2018-06-29 19:43:12',0),(49,25,'DAPA','Testing','2018-06-29 19:43:52',0),(50,1,'','Testing','2018-06-29 20:30:29',0),(51,23,'CCAFS','Testing','2018-06-29 20:03:57',0);
/*!40000 ALTER TABLE `msp_download` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_download_guidelines`
--

DROP TABLE IF EXISTS `msp_download_guidelines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_download_guidelines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `download_id` int(11) NOT NULL,
  `guideline_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_msp_guidelines_downloaded_msp_download1_idx` (`download_id`),
  KEY `fk_msp_guidelines_downloaded_msp_guidelines1_idx1` (`guideline_id`),
  CONSTRAINT `fk_download` FOREIGN KEY (`download_id`) REFERENCES `msp_download` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_guideline` FOREIGN KEY (`guideline_id`) REFERENCES `msp_guidelines` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_download_guidelines`
--

LOCK TABLES `msp_download_guidelines` WRITE;
/*!40000 ALTER TABLE `msp_download_guidelines` DISABLE KEYS */;
INSERT INTO `msp_download_guidelines` VALUES (37,45,8),(38,45,9),(39,46,8),(40,46,9),(41,47,29),(42,47,30),(43,47,31),(44,48,23),(45,48,24),(46,48,25),(47,49,29),(48,49,30),(49,49,31),(50,50,29),(51,50,30),(52,50,31),(53,51,21);
/*!40000 ALTER TABLE `msp_download_guidelines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_download_regions`
--

DROP TABLE IF EXISTS `msp_download_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_download_regions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `download_id` int(11) NOT NULL,
  `region_id` int(11) NOT NULL,
  `region_scope` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_download_idx` (`download_id`),
  KEY `fk_download_regions_region_id_idx` (`region_id`),
  CONSTRAINT `fk_download_regions_download_id` FOREIGN KEY (`download_id`) REFERENCES `msp_download` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_download_regions_region_id` FOREIGN KEY (`region_id`) REFERENCES `msp_regions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_download_regions`
--

LOCK TABLES `msp_download_regions` WRITE;
/*!40000 ALTER TABLE `msp_download_regions` DISABLE KEYS */;
INSERT INTO `msp_download_regions` VALUES (5,45,7,'instituteRegion'),(6,45,8,'instituteRegion'),(7,45,1,'researchRegion'),(8,45,2,'researchRegion'),(9,46,7,'instituteRegion'),(10,46,8,'instituteRegion'),(11,46,1,'researchRegion'),(12,46,2,'researchRegion'),(13,46,5,'researchRegion'),(14,47,8,'instituteRegion'),(15,47,1,'researchRegion'),(16,47,2,'researchRegion'),(17,47,6,'researchRegion'),(18,48,7,'instituteRegion'),(19,48,8,'instituteRegion'),(20,48,1,'researchRegion'),(21,48,2,'researchRegion'),(22,49,7,'instituteRegion'),(23,49,8,'instituteRegion'),(24,49,1,'researchRegion'),(25,49,2,'researchRegion'),(26,51,4,'instituteRegion'),(27,51,1,'researchRegion'),(28,51,2,'researchRegion'),(29,51,5,'researchRegion'),(30,51,6,'researchRegion');
/*!40000 ALTER TABLE `msp_download_regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_guidelines`
--

DROP TABLE IF EXISTS `msp_guidelines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_guidelines` (
  `id` int(11) NOT NULL,
  `code` varchar(45) NOT NULL,
  `name` varchar(200) NOT NULL,
  `type` int(11) DEFAULT NULL,
  `source` varchar(300) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_guidelines`
--

LOCK TABLES `msp_guidelines` WRITE;
/*!40000 ALTER TABLE `msp_guidelines` DISABLE KEYS */;
INSERT INTO `msp_guidelines` VALUES (1,'1.1.','CGIAR Open Access & Data Management Policy',0,'1_Policy_Documents\\2013-10 CGIAR Open Access & Data Management Policy.pdf',1),(2,'1.2.','CGIAR Open Access & Data Management Implementation Guidelines',0,'1_Policy_Documents\\2014-07 CGIAR Open Access & Data Management Implementation Guidelines.pdf',0),(3,'1.3.','CGIAR Open Access-Open Data Implementation Plan Template',0,'1_Policy_Documents\\2015-05 CGIAR Open Access-Open Data Implementation Plan - Template.docx',0),(4,'1.4.','CCAFS Data Management Strategy',0,'1_Policy_Documents\\2015-06 CCAFS Data Management Strategy.pdf',1),(5,'0.1.','Writing Research Protocols - a statistical perspective',0,'https://resources.stats4sd.org/resource/writing-research-protocols---a-statistical-perspective',1),(6,'0.2.','What is a research protocol and how to use one (Video)',1,'https://www.youtube.com/watch?v=_KVHxHYM9DQ&index=1&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(7,'0.3.','What a Protocol Should Contain (Video)',1,'https://www.youtube.com/watch?v=IhmliEn_ejw&index=2&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(8,'2.1.','Data Ownership & Authorship',0,'2_Data_Ownership_Authorship\\2018-03-07 Data Ownership & Authorship.pdf',1),(9,'2.2.','Data Ownership (Video)',1,'https://www.youtube.com/watch?v=aDQWTuAMKTQ&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj&index=5',1),(10,'2.3.','Data Ownership Agreement - Template',0,'2_Data_Ownership_Authorship\\2018-03-07 Data Ownership Agreement - Template.pdf',1),(11,'2.4.','CGIAR Author Guidance',0,'2_Data_Ownership_Authorship\\2015-03 CGIAR Author Guidance.pdf',1),(12,'2.5.','Data Ownership Agreement - Example',0,'2_Data_Ownership_Authorship\\2018-03-07 Data Ownership Agreement - Example.pdf',1),(13,'2.6.','CCAFS Publications Policy',0,'2_Data_Ownership_Authorship\\2012-08 CCAFS Publications Policy.pdf',1),(14,'3.1.','Budgeting and Planning for Data Management',0,'3_Budgeting_Planning\\2018-03-07_Budgeting_and_Planning_for_Data_Management.pdf',1),(15,'3.2.','Planning and Budgeting for Data Management (Video)',1,'https://www.youtube.com/watch?v=O0vpXLJPB5o&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj&index=4',1),(16,'3.3.','ILRI Data Management Process (flowcharts)',0,'3_Budgeting_Planning\\2014 ILRI Data Management Process (flowcharts).pdf',0),(17,'3.4.','Data Management Process - Narrative',0,'3_Budgeting_Planning\\2018-03-07 Data Management Process - Narative.pdf',1),(18,'3.5.','Creating a Data Management Plan',0,'3_Budgeting_Planning\\2018-03-07_Creating_a_Data_Management_Plan.pdf',1),(19,'3.6.','Data Management Plan (Video)',1,'https://www.youtube.com/watch?v=Q8jX_cH0C60&index=3&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(20,'3.7.','ToR Data Management Roles - General',0,'3_Budgeting_Planning\\2018-03-07 ToRs Data Management Roles.docx',1),(21,'3.8.','Example Data Management Activity Plan',0,'3_Budgeting_Planning\\2013-10 Example Data Management Activity Plan (CCAFS).pdf',1),(22,'3.9.','Tools for Research Projects',0,'3_Budgeting_Planning\\2018-03-07 Tools for Research Projects.pdf',1),(23,'4.1.','Creating and Using a Data and Document Storage Facility',0,'4_Data_Document_Store\\2018-03-14 Creating and Using a Data and Document Storage Facility.pdf',1),(24,'4.2.','Introduction to Data and Document Storage (Video)',1,'https://www.youtube.com/watch?v=4CQtJbg_Qms&index=6&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(25,'4.3.','Ownership Issues with Data and Document Stores (Video)',1,'https://www.youtube.com/watch?v=ML3UXLzaqRw&index=8&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(26,'4.4.','Data and Document Store Organisation (Video)',1,'https://www.youtube.com/watch?v=MMagU_77rdI&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj&index=7',1),(27,'4.5.','Introduction to Dropbox',0,'4_Data_Document_Store\\2018-03-07 Introduction to Dropbox.pdf',1),(28,'4.6.','Introduction to Dropbox (Video)',1,'https://www.youtube.com/watch?v=kvMkh4slKCU&index=9&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(29,'5.1.','Documents needed for Survey Fieldwork and Training',0,'5_Fieldwork\\2018-03-08 Documents for Survey Fieldwork and Training.pdf',1),(30,'5.2.','CCAFS Training Manual for Field Supervisors',0,'5_Fieldwork\\2010-11 CCAFS Training Manual for Field Supervisors.pdf',1),(31,'5.3.','CCAFS HBS Code Book',0,'5_Fieldwork\\2013-06 CCAFS HBS Code Book.pdf',1),(32,'5.4.','CCAFS HBS Questionnaire',0,'5_Fieldwork\\2011-08 CCAFS HBS Questionnaire.pdf',1),(33,'5.5.','Example Consent Form',0,'5_Fieldwork\\2013-10 Example Consent form.pdf',1),(34,'5.6.','Example Training Manual when using ODK',0,'5_Fieldwork\\2018-03-09_Training_Manual_Example_using_ODK.pdf',1),(35,'6.1.','Data Quality Assurance',0,'6_Managing_Data\\2018-03-09_Data_Quality_Assurance.pdf',1),(36,'6.2.','Data Quality Checking (Video)',1,'https://www.youtube.com/watch?v=vbxvtIbqkPA&index=15&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(37,'6.3.','Transition from Raw to Primary Data',0,'6_Managing_Data\\2018-03-09_Transition_from_Raw_to_Primary_Data.pdf',1),(38,'6.4.','Transition from Raw to Primary Data (Video)',1,'https://www.youtube.com/watch?v=IR0hbPIn_Yk&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj&index=17',1),(39,'6.5.','Guidance for Handling Different Types of Data',0,'6_Managing_Data\\2018-03-09_Guidance_for_handling_different_types_of_data.pdf',1),(40,'6.6.','Guidance for Handling Different Types of Data (Video)',1,'https://www.youtube.com/watch?v=SrRN2eHOVxk&index=16&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(41,'7.1.','Introduction to Metadata',0,'7_Metadata\\2018-03-09 Introduction to Metadata.pdf',1),(42,'7.2.','Metadata (Video)',1,'https://www.youtube.com/watch?v=AdX5OUJY9P0&index=11&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(43,'7.3.','CG Core Metadata Schema',0,'7_Metadata\\2016-11-23 CG Core Metadata Schema.pdf',1),(44,'7.4.','CG Core Basic for Researchers (Excel)',0,'7_Metadata\\2016-02-14 CG Core Basic for Researchers.xlsx',1),(45,'7.5.','CG Core Basic for Researchers  ',0,'7_Metadata\\2018-03-11 CG Core Metadata for Researchers.pdf',1),(46,'7.6.','ILRI Datasets Metadata Template (Excel)',0,'7_Metadata\\2014-04 ILRI Datasets Metadata Template.xlsx',0),(47,'8.1.','Principles for Archiving and Sharing',0,'8_Archiving_Sharing/2018-03-11_Principles_for_Archiving_and_Sharing.pdf',1),(48,'8.2.','Archiving & Sharing Data (Video)',1,'https://www.youtube.com/watch?v=H8sO21P5RBc&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj&index=10',1),(49,'8.3.','Data and Documents to Submit for Archiving - a checklist',0,'8_Archiving_Sharing/2018-03-11 Data and Documents to Submit for Archiving - Checklist.pdf',1),(50,'8.4.','Portals for Archiving & Sharing',0,'8_Archiving_Sharing/2018-03-11_Portals_for_Archiving_and_Sharing.pdf',1),(51,'8.5.','Introduction to Dataverse',0,'8_Archiving_Sharing/2018-03-11 Introduction to Dataverse.pdf',1),(52,'8.6.','Introduction to Dataverse (Video)',1,'https://www.youtube.com/watch?v=EGYuj1JM1Qc&index=12&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj',1),(53,'8.7.','Creating a Dataverse (Video)',1,'https://www.youtube.com/watch?v=9dMtCvCpZNM&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj&index=13',1),(54,'8.8.','CCAFS Dataverse (Video)',1,'https://www.youtube.com/watch?v=tr33h7TzFeY&list=PLK5PktXR1tmNRaUPsFiYlyhg2lui0xgpj&index=14',1),(55,'8.9.','Introduction to Dspace (Coming soon)',0,'',1),(56,'8.10.','Introduction to AgTrials (Coming soon)',0,'',1),(57,'8.11.','Introduction to CCAFS-Climate (Coming soon)',0,'',1);
/*!40000 ALTER TABLE `msp_guidelines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_guidelines_spheres`
--

DROP TABLE IF EXISTS `msp_guidelines_spheres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_guidelines_spheres` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sphere_id` int(11) NOT NULL,
  `guideline_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sphere_relationship_idx` (`sphere_id`),
  KEY `fk_guideline_relationship_idx` (`guideline_id`),
  CONSTRAINT `fk_guideline_relationship` FOREIGN KEY (`guideline_id`) REFERENCES `msp_guidelines` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sphere_relationship` FOREIGN KEY (`sphere_id`) REFERENCES `msp_sphere` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_guidelines_spheres`
--

LOCK TABLES `msp_guidelines_spheres` WRITE;
/*!40000 ALTER TABLE `msp_guidelines_spheres` DISABLE KEYS */;
INSERT INTO `msp_guidelines_spheres` VALUES (1,1,1),(2,2,1),(3,1,2),(4,3,2),(5,6,2),(6,1,3),(7,2,3),(8,3,3),(9,5,3),(10,1,4),(11,2,4),(12,1,8),(13,2,8),(14,4,8),(15,1,10),(16,2,10),(17,7,10),(18,2,11),(19,4,11),(20,7,11),(21,2,12),(22,4,13),(23,1,14),(24,3,14),(25,3,16),(26,5,16),(27,6,16),(28,7,16),(29,3,17),(30,5,17),(31,6,17),(32,7,17),(33,1,18),(34,1,20),(35,3,20),(36,5,20),(37,6,21),(38,5,22),(39,6,22),(40,7,22),(41,4,23),(42,6,23),(43,7,23),(44,6,27),(45,7,27),(46,4,29),(47,6,29),(48,7,29),(49,4,30),(50,6,30),(51,7,30),(52,6,31),(53,7,31),(54,6,32),(55,7,32),(56,7,33),(57,4,34),(58,6,34),(59,7,34),(60,3,35),(61,6,35),(62,6,37),(63,3,39),(64,5,39),(65,6,39),(66,6,41),(67,7,41),(68,4,43),(69,6,43),(70,7,43),(71,4,44),(72,6,44),(73,7,44),(74,4,45),(75,6,45),(76,7,45),(77,6,46),(78,7,46),(79,1,47),(80,2,47),(81,6,47),(82,7,47),(83,6,49),(84,5,50),(85,6,50),(86,7,50),(87,2,51),(88,4,51),(89,5,51),(90,6,51),(91,7,51),(92,4,55),(93,6,55),(94,7,55),(95,6,56),(96,7,56),(97,5,57),(98,6,57);
/*!40000 ALTER TABLE `msp_guidelines_spheres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_importance_levels`
--

DROP TABLE IF EXISTS `msp_importance_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_importance_levels` (
  `id` int(11) NOT NULL,
  `importance_level` enum('Very important','Important','Useful','Optional') DEFAULT NULL,
  `guideline_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `stage_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_msp_importance_levels_msp_roles1_idx1` (`role_id`),
  KEY `fk_msp_importance_levels_msp_guidelines1_idx1` (`guideline_id`),
  KEY `fk_msp_importance_levels_msp_stages1_idx1` (`stage_id`),
  KEY `fk_msp_importance_levels_msp_categories1_idx1` (`category_id`),
  CONSTRAINT `fk_category` FOREIGN KEY (`category_id`) REFERENCES `msp_categories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_guidelines` FOREIGN KEY (`guideline_id`) REFERENCES `msp_guidelines` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_rol_id` FOREIGN KEY (`role_id`) REFERENCES `msp_roles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_stage` FOREIGN KEY (`stage_id`) REFERENCES `msp_stages` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_importance_levels`
--

LOCK TABLES `msp_importance_levels` WRITE;
/*!40000 ALTER TABLE `msp_importance_levels` DISABLE KEYS */;
INSERT INTO `msp_importance_levels` VALUES (1,'Very important',1,1,1,1),(2,'Very important',1,1,1,2),(3,'Important',1,1,1,3),(4,'Very important',1,1,2,1),(5,'Very important',1,1,2,2),(6,'Important',1,1,2,3),(7,'Important',1,1,3,1),(8,'Important',1,1,3,2),(9,'Important',1,1,3,3),(10,'Important',1,1,4,1),(11,'Optional',1,1,4,2),(12,'Important',1,1,4,3),(13,'Very important',1,1,5,1),(14,'Optional',1,1,5,2),(15,'Very important',1,1,5,3),(16,'Important',2,1,1,1),(17,'Useful',2,1,1,2),(18,'Important',2,1,1,3),(19,'Important',2,1,2,1),(20,'Useful',2,1,2,2),(21,'Important',2,1,2,3),(22,'Optional',2,1,3,1),(23,'Optional',2,1,3,2),(24,'Optional',2,1,3,3),(25,'Optional',2,1,4,1),(26,'Optional',2,1,4,2),(27,'Optional',2,1,4,3),(28,'Optional',2,1,5,1),(29,'Optional',2,1,5,2),(30,'Useful',2,1,5,3),(31,'Useful',3,1,1,1),(32,'Optional',3,1,1,2),(33,'Optional',3,1,1,3),(34,'Useful',3,1,2,1),(35,'Optional',3,1,2,2),(36,'Optional',3,1,2,3),(37,'Optional',3,1,3,1),(38,'Optional',3,1,3,2),(39,'Optional',3,1,3,3),(40,'Optional',3,1,4,1),(41,'Optional',3,1,4,2),(42,'Optional',3,1,4,3),(43,'Useful',3,1,5,1),(44,'Optional',3,1,5,2),(45,'Useful',3,1,5,3),(46,'Very important',4,1,1,1),(47,'Important',4,1,1,2),(48,'Very important',4,1,1,3),(49,'Very important',4,1,2,1),(50,'Important',4,1,2,2),(51,'Very important',4,1,2,3),(52,'Optional',4,1,3,1),(53,'Optional',4,1,3,2),(54,'Optional',4,1,3,3),(55,'Optional',4,1,4,1),(56,'Optional',4,1,4,2),(57,'Optional',4,1,4,3),(58,'Very important',4,1,5,1),(59,'Optional',4,1,5,2),(60,'Optional',4,1,5,3),(61,'Very important',5,0,1,1),(62,'Very important',5,0,1,2),(63,'Very important',5,0,1,3),(64,'Useful',5,0,2,1),(65,'Useful',5,0,2,2),(66,'Useful',5,0,2,3),(67,'Optional',5,0,3,1),(68,'Optional',5,0,3,2),(69,'Optional',5,0,3,3),(70,'Optional',5,0,4,1),(71,'Optional',5,0,4,2),(72,'Optional',5,0,4,3),(73,'Optional',5,0,5,1),(74,'Optional',5,0,5,2),(75,'Optional',5,0,5,3),(76,'Important',6,0,1,1),(77,'Very important',6,0,1,2),(78,'Useful',6,0,1,3),(79,'Useful',6,0,2,1),(80,'Useful',6,0,2,2),(81,'Useful',6,0,2,3),(82,'Optional',6,0,3,1),(83,'Optional',6,0,3,2),(84,'Optional',6,0,3,3),(85,'Optional',6,0,4,1),(86,'Useful',6,0,4,2),(87,'Useful',6,0,4,3),(88,'Optional',6,0,5,1),(89,'Useful',6,0,5,2),(90,'Useful',6,0,5,3),(91,'Important',7,0,1,1),(92,'Important',7,0,1,2),(93,'Useful',7,0,1,3),(94,'Useful',7,0,2,1),(95,'Useful',7,0,2,2),(96,'Useful',7,0,2,3),(97,'Optional',7,0,3,1),(98,'Optional',7,0,3,2),(99,'Optional',7,0,3,3),(100,'Optional',7,0,4,1),(101,'Useful',7,0,4,2),(102,'Useful',7,0,4,3),(103,'Optional',7,0,5,1),(104,'Useful',7,0,5,2),(105,'Useful',7,0,5,3),(106,'Very important',8,2,1,1),(107,'Very important',8,2,1,2),(108,'Very important',8,2,1,3),(109,'Very important',8,2,2,1),(110,'Very important',8,2,2,2),(111,'Very important',8,2,2,3),(112,'Useful',8,2,3,1),(113,'Useful',8,2,3,2),(114,'Useful',8,2,3,3),(115,'Useful',8,2,4,1),(116,'Useful',8,2,4,2),(117,'Useful',8,2,4,3),(118,'Useful',8,2,5,1),(119,'Useful',8,2,5,2),(120,'Useful',8,2,5,3),(121,'Important',9,2,1,1),(122,'Important',9,2,1,2),(123,'Very important',9,2,1,3),(124,'Very important',9,2,2,1),(125,'Very important',9,2,2,2),(126,'Very important',9,2,2,3),(127,'Useful',9,2,3,1),(128,'Useful',9,2,3,2),(129,'Useful',9,2,3,3),(130,'Useful',9,2,4,1),(131,'Useful',9,2,4,2),(132,'Useful',9,2,4,3),(133,'Useful',9,2,5,1),(134,'Useful',9,2,5,2),(135,'Useful',9,2,5,3),(136,'Useful',10,2,1,1),(137,'Useful',10,2,1,2),(138,'Important',10,2,1,3),(139,'Very important',10,2,2,1),(140,'Very important',10,2,2,2),(141,'Very important',10,2,2,3),(142,'Useful',10,2,3,1),(143,'Useful',10,2,3,2),(144,'Important',10,2,3,3),(145,'Useful',10,2,4,1),(146,'Useful',10,2,4,2),(147,'Useful',10,2,4,3),(148,'Useful',10,2,5,1),(149,'Useful',10,2,5,2),(150,'Useful',10,2,5,3),(151,'Useful',11,2,1,1),(152,'Useful',11,2,1,2),(153,'Optional',11,2,1,3),(154,'Important',11,2,2,1),(155,'Important',11,2,2,2),(156,'Optional',11,2,2,3),(157,'Optional',11,2,3,1),(158,'Optional',11,2,3,2),(159,'Optional',11,2,3,3),(160,'Very important',11,2,4,1),(161,'Very important',11,2,4,2),(162,'Useful',11,2,4,3),(163,'Useful',11,2,5,1),(164,'Useful',11,2,5,2),(165,'Optional',11,2,5,3),(166,'Useful',12,2,1,1),(167,'Useful',12,2,1,2),(168,'Very important',12,2,1,3),(169,'Very important',12,2,2,1),(170,'Very important',12,2,2,2),(171,'Very important',12,2,2,3),(172,'Useful',12,2,3,1),(173,'Useful',12,2,3,2),(174,'Important',12,2,3,3),(175,'Useful',12,2,4,1),(176,'Useful',12,2,4,2),(177,'Very important',12,2,4,3),(178,'Useful',12,2,5,1),(179,'Useful',12,2,5,2),(180,'Very important',12,2,5,3),(181,'Important',13,2,1,1),(182,'Important',13,2,1,2),(183,'Optional',13,2,1,3),(184,'Useful',13,2,2,1),(185,'Useful',13,2,2,2),(186,'Optional',13,2,2,3),(187,'Optional',13,2,3,1),(188,'Optional',13,2,3,2),(189,'Optional',13,2,3,3),(190,'Important',13,2,4,1),(191,'Important',13,2,4,2),(192,'Optional',13,2,4,3),(193,'Useful',13,2,5,1),(194,'Useful',13,2,5,2),(195,'Optional',13,2,5,3),(196,'Very important',14,3,1,1),(197,'Very important',14,3,1,2),(198,'Very important',14,3,1,3),(199,'Very important',14,3,2,1),(200,'Very important',14,3,2,2),(201,'Very important',14,3,2,3),(202,'Important',14,3,3,1),(203,'Useful',14,3,3,2),(204,'Useful',14,3,3,3),(205,'Useful',14,3,4,1),(206,'Useful',14,3,4,2),(207,'Useful',14,3,4,3),(208,'Optional',14,3,5,1),(209,'Optional',14,3,5,2),(210,'Optional',14,3,5,3),(211,'Very important',15,3,1,1),(212,'Very important',15,3,1,2),(213,'Very important',15,3,1,3),(214,'Very important',15,3,2,1),(215,'Very important',15,3,2,2),(216,'Very important',15,3,2,3),(217,'Useful',15,3,3,1),(218,'Useful',15,3,3,2),(219,'Useful',15,3,3,3),(220,'Useful',15,3,4,1),(221,'Useful',15,3,4,2),(222,'Useful',15,3,4,3),(223,'Optional',15,3,5,1),(224,'Optional',15,3,5,2),(225,'Optional',15,3,5,3),(226,'Optional',16,3,1,1),(227,'Optional',16,3,1,2),(228,'Optional',16,3,1,3),(229,'Optional',16,3,2,1),(230,'Optional',16,3,2,2),(231,'Optional',16,3,2,3),(232,'Optional',16,3,3,1),(233,'Optional',16,3,3,2),(234,'Optional',16,3,3,3),(235,'Optional',16,3,4,1),(236,'Optional',16,3,4,2),(237,'Useful',16,3,4,3),(238,'Optional',16,3,5,1),(239,'Optional',16,3,5,2),(240,'Optional',16,3,5,3),(241,'Optional',17,3,1,1),(242,'Optional',17,3,1,2),(243,'Optional',17,3,1,3),(244,'Optional',17,3,2,1),(245,'Optional',17,3,2,2),(246,'Optional',17,3,2,3),(247,'Optional',17,3,3,1),(248,'Optional',17,3,3,2),(249,'Optional',17,3,3,3),(250,'Optional',17,3,4,1),(251,'Optional',17,3,4,2),(252,'Useful',17,3,4,3),(253,'Optional',17,3,5,1),(254,'Optional',17,3,5,2),(255,'Optional',17,3,5,3),(256,'Very important',18,3,1,1),(257,'Very important',18,3,1,2),(258,'Very important',18,3,1,3),(259,'Very important',18,3,2,1),(260,'Very important',18,3,2,2),(261,'Very important',18,3,2,3),(262,'Important',18,3,3,1),(263,'Useful',18,3,3,2),(264,'Very important',18,3,3,3),(265,'Useful',18,3,4,1),(266,'Useful',18,3,4,2),(267,'Useful',18,3,4,3),(268,'Optional',18,3,5,1),(269,'Useful',18,3,5,2),(270,'Useful',18,3,5,3),(271,'Useful',19,3,1,1),(272,'Useful',19,3,1,2),(273,'Very important',19,3,1,3),(274,'Useful',19,3,2,1),(275,'Important',19,3,2,2),(276,'Useful',19,3,2,3),(277,'Useful',19,3,3,1),(278,'Optional',19,3,3,2),(279,'Very important',19,3,3,3),(280,'Optional',19,3,4,1),(281,'Useful',19,3,4,2),(282,'Useful',19,3,4,3),(283,'Optional',19,3,5,1),(284,'Useful',19,3,5,2),(285,'Useful',19,3,5,3),(286,'Very important',20,3,1,1),(287,'Very important',20,3,1,2),(288,'Very important',20,3,1,3),(289,'Very important',20,3,2,1),(290,'Very important',20,3,2,2),(291,'Very important',20,3,2,3),(292,'Important',20,3,3,1),(293,'Optional',20,3,3,2),(294,'Important',20,3,3,3),(295,'Useful',20,3,4,1),(296,'Useful',20,3,4,2),(297,'Useful',20,3,4,3),(298,'Optional',20,3,5,1),(299,'Optional',20,3,5,2),(300,'Optional',20,3,5,3),(301,'Useful',21,3,1,1),(302,'Useful',21,3,1,2),(303,'Important',21,3,1,3),(304,'Useful',21,3,2,1),(305,'Very important',21,3,2,2),(306,'Important',21,3,2,3),(307,'Optional',21,3,3,1),(308,'Optional',21,3,3,2),(309,'Important',21,3,3,3),(310,'Optional',21,3,4,1),(311,'Useful',21,3,4,2),(312,'Useful',21,3,4,3),(313,'Optional',21,3,5,1),(314,'Useful',21,3,5,2),(315,'Useful',21,3,5,3),(316,'Optional',22,3,1,1),(317,'Useful',22,3,1,2),(318,'Important',22,3,1,3),(319,'Optional',22,3,2,1),(320,'Useful',22,3,2,2),(321,'Useful',22,3,2,3),(322,'Useful',22,3,3,1),(323,'Useful',22,3,3,2),(324,'Useful',22,3,3,3),(325,'Useful',22,3,4,1),(326,'Useful',22,3,4,2),(327,'Useful',22,3,4,3),(328,'Useful',22,3,5,1),(329,'Useful',22,3,5,2),(330,'Useful',22,3,5,3),(331,'Important',23,4,1,1),(332,'Important',23,4,1,2),(333,'Important',23,4,1,3),(334,'Very important',23,4,2,1),(335,'Very important',23,4,2,2),(336,'Very important',23,4,2,3),(337,'Useful',23,4,3,1),(338,'Important',23,4,3,2),(339,'Very important',23,4,3,3),(340,'Useful',23,4,4,1),(341,'Important',23,4,4,2),(342,'Very important',23,4,4,3),(343,'Optional',23,4,5,1),(344,'Optional',23,4,5,2),(345,'Very important',23,4,5,3),(346,'Important',24,4,1,1),(347,'Important',24,4,1,2),(348,'Important',24,4,1,3),(349,'Very important',24,4,2,1),(350,'Very important',24,4,2,2),(351,'Very important',24,4,2,3),(352,'Useful',24,4,3,1),(353,'Important',24,4,3,2),(354,'Very important',24,4,3,3),(355,'Useful',24,4,4,1),(356,'Important',24,4,4,2),(357,'Very important',24,4,4,3),(358,'Optional',24,4,5,1),(359,'Optional',24,4,5,2),(360,'Very important',24,4,5,3),(361,'Useful',25,4,1,1),(362,'Useful',25,4,1,2),(363,'Important',25,4,1,3),(364,'Useful',25,4,2,1),(365,'Useful',25,4,2,2),(366,'Very important',25,4,2,3),(367,'Useful',25,4,3,1),(368,'Important',25,4,3,2),(369,'Very important',25,4,3,3),(370,'Useful',25,4,4,1),(371,'Important',25,4,4,2),(372,'Very important',25,4,4,3),(373,'Optional',25,4,5,1),(374,'Optional',25,4,5,2),(375,'Very important',25,4,5,3),(376,'Useful',26,4,1,1),(377,'Useful',26,4,1,2),(378,'Important',26,4,1,3),(379,'Useful',26,4,2,1),(380,'Useful',26,4,2,2),(381,'Very important',26,4,2,3),(382,'Useful',26,4,3,1),(383,'Important',26,4,3,2),(384,'Very important',26,4,3,3),(385,'Useful',26,4,4,1),(386,'Important',26,4,4,2),(387,'Very important',26,4,4,3),(388,'Optional',26,4,5,1),(389,'Optional',26,4,5,2),(390,'Very important',26,4,5,3),(391,'Optional',27,4,1,1),(392,'Useful',27,4,1,2),(393,'Useful',27,4,1,3),(394,'Optional',27,4,2,1),(395,'Useful',27,4,2,2),(396,'Useful',27,4,2,3),(397,'Useful',27,4,3,1),(398,'Useful',27,4,3,2),(399,'Useful',27,4,3,3),(400,'Useful',27,4,4,1),(401,'Useful',27,4,4,2),(402,'Useful',27,4,4,3),(403,'Optional',27,4,5,1),(404,'Optional',27,4,5,2),(405,'Useful',27,4,5,3),(406,'Optional',28,4,1,1),(407,'Useful',28,4,1,2),(408,'Useful',28,4,1,3),(409,'Optional',28,4,2,1),(410,'Useful',28,4,2,2),(411,'Useful',28,4,2,3),(412,'Useful',28,4,3,1),(413,'Useful',28,4,3,2),(414,'Useful',28,4,3,3),(415,'Useful',28,4,4,1),(416,'Useful',28,4,4,2),(417,'Useful',28,4,4,3),(418,'Optional',28,4,5,1),(419,'Optional',28,4,5,2),(420,'Useful',28,4,5,3),(421,'Important',29,5,1,1),(422,'Important',29,5,1,2),(423,'Important',29,5,1,3),(424,'Very important',29,5,2,1),(425,'Very important',29,5,2,2),(426,'Very important',29,5,2,3),(427,'Very important',29,5,3,1),(428,'Very important',29,5,3,2),(429,'Very important',29,5,3,3),(430,'Important',29,5,4,1),(431,'Important',29,5,4,2),(432,'Useful',29,5,4,3),(433,'Useful',29,5,5,1),(434,'Useful',29,5,5,2),(435,'Important',29,5,5,3),(436,'Useful',30,5,1,1),(437,'Useful',30,5,1,2),(438,'Useful',30,5,1,3),(439,'Useful',30,5,2,1),(440,'Useful',30,5,2,2),(441,'Useful',30,5,2,3),(442,'Useful',30,5,3,1),(443,'Useful',30,5,3,2),(444,'Useful',30,5,3,3),(445,'Useful',30,5,4,1),(446,'Useful',30,5,4,2),(447,'Useful',30,5,4,3),(448,'Useful',30,5,5,1),(449,'Useful',30,5,5,2),(450,'Useful',30,5,5,3),(451,'Useful',31,5,1,1),(452,'Useful',31,5,1,2),(453,'Useful',31,5,1,3),(454,'Useful',31,5,2,1),(455,'Useful',31,5,2,2),(456,'Useful',31,5,2,3),(457,'Useful',31,5,3,1),(458,'Useful',31,5,3,2),(459,'Useful',31,5,3,3),(460,'Useful',31,5,4,1),(461,'Useful',31,5,4,2),(462,'Useful',31,5,4,3),(463,'Useful',31,5,5,1),(464,'Useful',31,5,5,2),(465,'Useful',31,5,5,3),(466,'Useful',32,5,1,1),(467,'Useful',32,5,1,2),(468,'Useful',32,5,1,3),(469,'Useful',32,5,2,1),(470,'Useful',32,5,2,2),(471,'Useful',32,5,2,3),(472,'Useful',32,5,3,1),(473,'Useful',32,5,3,2),(474,'Useful',32,5,3,3),(475,'Useful',32,5,4,1),(476,'Useful',32,5,4,2),(477,'Useful',32,5,4,3),(478,'Useful',32,5,5,1),(479,'Useful',32,5,5,2),(480,'Useful',32,5,5,3),(481,'Very important',33,5,1,1),(482,'Very important',33,5,1,2),(483,'Useful',33,5,1,3),(484,'Very important',33,5,2,1),(485,'Very important',33,5,2,2),(486,'Useful',33,5,2,3),(487,'Very important',33,5,3,1),(488,'Very important',33,5,3,2),(489,'Very important',33,5,3,3),(490,'Optional',33,5,4,1),(491,'Very important',33,5,4,2),(492,'Useful',33,5,4,3),(493,'Optional',33,5,5,1),(494,'Useful',33,5,5,2),(495,'Useful',33,5,5,3),(496,'Useful',34,5,1,1),(497,'Useful',34,5,1,2),(498,'Useful',34,5,1,3),(499,'Useful',34,5,2,1),(500,'Useful',34,5,2,2),(501,'Useful',34,5,2,3),(502,'Useful',34,5,3,1),(503,'Useful',34,5,3,2),(504,'Useful',34,5,3,3),(505,'Useful',34,5,4,1),(506,'Useful',34,5,4,2),(507,'Useful',34,5,4,3),(508,'Useful',34,5,5,1),(509,'Useful',34,5,5,2),(510,'Useful',34,5,5,3),(511,'Important',35,6,1,1),(512,'Important',35,6,1,2),(513,'Important',35,6,1,3),(514,'Very important',35,6,2,1),(515,'Very important',35,6,2,2),(516,'Very important',35,6,2,3),(517,'Very important',35,6,3,1),(518,'Very important',35,6,3,2),(519,'Very important',35,6,3,3),(520,'Important',35,6,4,1),(521,'Important',35,6,4,2),(522,'Very important',35,6,4,3),(523,'Very important',35,6,5,1),(524,'Very important',35,6,5,2),(525,'Very important',35,6,5,3),(526,'Important',36,6,1,1),(527,'Important',36,6,1,2),(528,'Important',36,6,1,3),(529,'Very important',36,6,2,1),(530,'Very important',36,6,2,2),(531,'Very important',36,6,2,3),(532,'Important',36,6,3,1),(533,'Important',36,6,3,2),(534,'Very important',36,6,3,3),(535,'Important',36,6,4,1),(536,'Important',36,6,4,2),(537,'Very important',36,6,4,3),(538,'Very important',36,6,5,1),(539,'Very important',36,6,5,2),(540,'Very important',36,6,5,3),(541,'Useful',37,6,1,1),(542,'Useful',37,6,1,2),(543,'Useful',37,6,1,3),(544,'Useful',37,6,2,1),(545,'Useful',37,6,2,2),(546,'Important',37,6,2,3),(547,'Useful',37,6,3,1),(548,'Important',37,6,3,2),(549,'Very important',37,6,3,3),(550,'Useful',37,6,4,1),(551,'Useful',37,6,4,2),(552,'Important',37,6,4,3),(553,'Useful',37,6,5,1),(554,'Useful',37,6,5,2),(555,'Important',37,6,5,3),(556,'Useful',38,6,1,1),(557,'Useful',38,6,1,2),(558,'Useful',38,6,1,3),(559,'Useful',38,6,2,1),(560,'Useful',38,6,2,2),(561,'Important',38,6,2,3),(562,'Useful',38,6,3,1),(563,'Useful',38,6,3,2),(564,'Important',38,6,3,3),(565,'Useful',38,6,4,1),(566,'Useful',38,6,4,2),(567,'Important',38,6,4,3),(568,'Useful',38,6,5,1),(569,'Useful',38,6,5,2),(570,'Important',38,6,5,3),(571,'Useful',39,6,1,1),(572,'Useful',39,6,1,2),(573,'Useful',39,6,1,3),(574,'Useful',39,6,2,1),(575,'Useful',39,6,2,2),(576,'Important',39,6,2,3),(577,'Useful',39,6,3,1),(578,'Useful',39,6,3,2),(579,'Very important',39,6,3,3),(580,'Useful',39,6,4,1),(581,'Useful',39,6,4,2),(582,'Important',39,6,4,3),(583,'Useful',39,6,5,1),(584,'Useful',39,6,5,2),(585,'Important',39,6,5,3),(586,'Useful',40,6,1,1),(587,'Useful',40,6,1,2),(588,'Useful',40,6,1,3),(589,'Useful',40,6,2,1),(590,'Useful',40,6,2,2),(591,'Important',40,6,2,3),(592,'Useful',40,6,3,1),(593,'Useful',40,6,3,2),(594,'Important',40,6,3,3),(595,'Useful',40,6,4,1),(596,'Useful',40,6,4,2),(597,'Important',40,6,4,3),(598,'Useful',40,6,5,1),(599,'Useful',40,6,5,2),(600,'Important',40,6,5,3),(601,'Important',41,7,1,1),(602,'Important',41,7,1,2),(603,'Important',41,7,1,3),(604,'Very important',41,7,2,1),(605,'Very important',41,7,2,2),(606,'Very important',41,7,2,3),(607,'Very important',41,7,3,1),(608,'Important',41,7,3,2),(609,'Important',41,7,3,3),(610,'Very important',41,7,4,1),(611,'Very important',41,7,4,2),(612,'Very important',41,7,4,3),(613,'Very important',41,7,5,1),(614,'Very important',41,7,5,2),(615,'Very important',41,7,5,3),(616,'Useful',42,7,1,1),(617,'Useful',42,7,1,2),(618,'Useful',42,7,1,3),(619,'Useful',42,7,2,1),(620,'Useful',42,7,2,2),(621,'Useful',42,7,2,3),(622,'Useful',42,7,3,1),(623,'Useful',42,7,3,2),(624,'Useful',42,7,3,3),(625,'Useful',42,7,4,1),(626,'Useful',42,7,4,2),(627,'Useful',42,7,4,3),(628,'Very important',42,7,5,1),(629,'Useful',42,7,5,2),(630,'Very important',42,7,5,3),(631,'Useful',43,7,1,1),(632,'Useful',43,7,1,2),(633,'Useful',43,7,1,3),(634,'Useful',43,7,2,1),(635,'Useful',43,7,2,2),(636,'Useful',43,7,2,3),(637,'Useful',43,7,3,1),(638,'Useful',43,7,3,2),(639,'Useful',43,7,3,3),(640,'Important',43,7,4,1),(641,'Useful',43,7,4,2),(642,'Important',43,7,4,3),(643,'Very important',43,7,5,1),(644,'Very important',43,7,5,2),(645,'Very important',43,7,5,3),(646,'Useful',44,7,1,1),(647,'Useful',44,7,1,2),(648,'Useful',44,7,1,3),(649,'Useful',44,7,2,1),(650,'Useful',44,7,2,2),(651,'Useful',44,7,2,3),(652,'Useful',44,7,3,1),(653,'Useful',44,7,3,2),(654,'Useful',44,7,3,3),(655,'Useful',44,7,4,1),(656,'Useful',44,7,4,2),(657,'Useful',44,7,4,3),(658,'Important',44,7,5,1),(659,'Important',44,7,5,2),(660,'Important',44,7,5,3),(661,'Useful',45,7,1,1),(662,'Useful',45,7,1,2),(663,'Useful',45,7,1,3),(664,'Useful',45,7,2,1),(665,'Useful',45,7,2,2),(666,'Useful',45,7,2,3),(667,'Useful',45,7,3,1),(668,'Useful',45,7,3,2),(669,'Useful',45,7,3,3),(670,'Useful',45,7,4,1),(671,'Useful',45,7,4,2),(672,'Useful',45,7,4,3),(673,'Important',45,7,5,1),(674,'Important',45,7,5,2),(675,'Important',45,7,5,3),(676,'Optional',46,7,1,1),(677,'Optional',46,7,1,2),(678,'Optional',46,7,1,3),(679,'Optional',46,7,2,1),(680,'Optional',46,7,2,2),(681,'Optional',46,7,2,3),(682,'Optional',46,7,3,1),(683,'Optional',46,7,3,2),(684,'Optional',46,7,3,3),(685,'Optional',46,7,4,1),(686,'Optional',46,7,4,2),(687,'Optional',46,7,4,3),(688,'Optional',46,7,5,1),(689,'Optional',46,7,5,2),(690,'Optional',46,7,5,3),(691,'Very important',47,8,1,1),(692,'Useful',47,8,1,2),(693,'Very important',47,8,1,3),(694,'Very important',47,8,2,1),(695,'Useful',47,8,2,2),(696,'Very important',47,8,2,3),(697,'Important',47,8,3,1),(698,'Useful',47,8,3,2),(699,'Useful',47,8,3,3),(700,'Optional',47,8,4,1),(701,'Important',47,8,4,2),(702,'Important',47,8,4,3),(703,'Very important',47,8,5,1),(704,'Very important',47,8,5,2),(705,'Very important',47,8,5,3),(706,'Useful',48,8,1,1),(707,'Useful',48,8,1,2),(708,'Important',48,8,1,3),(709,'Useful',48,8,2,1),(710,'Useful',48,8,2,2),(711,'Useful',48,8,2,3),(712,'Useful',48,8,3,1),(713,'Useful',48,8,3,2),(714,'Useful',48,8,3,3),(715,'Useful',48,8,4,1),(716,'Useful',48,8,4,2),(717,'Useful',48,8,4,3),(718,'Very important',48,8,5,1),(719,'Useful',48,8,5,2),(720,'Very important',48,8,5,3),(721,'Useful',49,8,1,1),(722,'Optional',49,8,1,2),(723,'Optional',49,8,1,3),(724,'Useful',49,8,2,1),(725,'Useful',49,8,2,2),(726,'Useful',49,8,2,3),(727,'Useful',49,8,3,1),(728,'Optional',49,8,3,2),(729,'Optional',49,8,3,3),(730,'Useful',49,8,4,1),(731,'Useful',49,8,4,2),(732,'Important',49,8,4,3),(733,'Very important',49,8,5,1),(734,'Very important',49,8,5,2),(735,'Very important',49,8,5,3),(736,'Useful',50,8,1,1),(737,'Optional',50,8,1,2),(738,'Useful',50,8,1,3),(739,'Useful',50,8,2,1),(740,'Useful',50,8,2,2),(741,'Useful',50,8,2,3),(742,'Useful',50,8,3,1),(743,'Optional',50,8,3,2),(744,'Useful',50,8,3,3),(745,'Useful',50,8,4,1),(746,'Useful',50,8,4,2),(747,'Useful',50,8,4,3),(748,'Useful',50,8,5,1),(749,'Useful',50,8,5,2),(750,'Very important',50,8,5,3),(751,'Useful',51,8,1,1),(752,'Useful',51,8,1,2),(753,'Useful',51,8,1,3),(754,'Useful',51,8,2,1),(755,'Useful',51,8,2,2),(756,'Useful',51,8,2,3),(757,'Useful',51,8,3,1),(758,'Optional',51,8,3,2),(759,'Optional',51,8,3,3),(760,'Useful',51,8,4,1),(761,'Useful',51,8,4,2),(762,'Useful',51,8,4,3),(763,'Useful',51,8,5,1),(764,'Useful',51,8,5,2),(765,'Very important',51,8,5,3),(766,'Optional',52,8,1,1),(767,'Optional',52,8,1,2),(768,'Optional',52,8,1,3),(769,'Useful',52,8,2,1),(770,'Useful',52,8,2,2),(771,'Useful',52,8,2,3),(772,'Optional',52,8,3,1),(773,'Optional',52,8,3,2),(774,'Optional',52,8,3,3),(775,'Useful',52,8,4,1),(776,'Useful',52,8,4,2),(777,'Useful',52,8,4,3),(778,'Useful',52,8,5,1),(779,'Useful',52,8,5,2),(780,'Very important',52,8,5,3),(781,'Optional',53,8,1,1),(782,'Optional',53,8,1,2),(783,'Optional',53,8,1,3),(784,'Useful',53,8,2,1),(785,'Useful',53,8,2,2),(786,'Useful',53,8,2,3),(787,'Optional',53,8,3,1),(788,'Optional',53,8,3,2),(789,'Optional',53,8,3,3),(790,'Useful',53,8,4,1),(791,'Useful',53,8,4,2),(792,'Useful',53,8,4,3),(793,'Useful',53,8,5,1),(794,'Useful',53,8,5,2),(795,'Very important',53,8,5,3),(796,'Optional',54,8,1,1),(797,'Optional',54,8,1,2),(798,'Optional',54,8,1,3),(799,'Useful',54,8,2,1),(800,'Useful',54,8,2,2),(801,'Useful',54,8,2,3),(802,'Optional',54,8,3,1),(803,'Optional',54,8,3,2),(804,'Optional',54,8,3,3),(805,'Useful',54,8,4,1),(806,'Useful',54,8,4,2),(807,'Useful',54,8,4,3),(808,'Useful',54,8,5,1),(809,'Useful',54,8,5,2),(810,'Very important',54,8,5,3),(811,'Useful',55,8,1,1),(812,'Useful',55,8,1,2),(813,'Optional',55,8,1,3),(814,'Useful',55,8,2,1),(815,'Useful',55,8,2,2),(816,'Useful',55,8,2,3),(817,'Useful',55,8,3,1),(818,'Optional',55,8,3,2),(819,'Optional',55,8,3,3),(820,'Useful',55,8,4,1),(821,'Useful',55,8,4,2),(822,'Useful',55,8,4,3),(823,'Useful',55,8,5,1),(824,'Useful',55,8,5,2),(825,'Very important',55,8,5,3),(826,'Optional',56,8,1,1),(827,'Optional',56,8,1,2),(828,'Optional',56,8,1,3),(829,'Useful',56,8,2,1),(830,'Useful',56,8,2,2),(831,'Useful',56,8,2,3),(832,'Optional',56,8,3,1),(833,'Optional',56,8,3,2),(834,'Optional',56,8,3,3),(835,'Useful',56,8,4,1),(836,'Useful',56,8,4,2),(837,'Useful',56,8,4,3),(838,'Useful',56,8,5,1),(839,'Useful',56,8,5,2),(840,'Very important',56,8,5,3),(841,'Optional',57,8,1,1),(842,'Optional',57,8,1,2),(843,'Optional',57,8,1,3),(844,'Useful',57,8,2,1),(845,'Useful',57,8,2,2),(846,'Useful',57,8,2,3),(847,'Optional',57,8,3,1),(848,'Optional',57,8,3,2),(849,'Optional',57,8,3,3),(850,'Useful',57,8,4,1),(851,'Useful',57,8,4,2),(852,'Useful',57,8,4,3),(853,'Useful',57,8,5,1),(854,'Useful',57,8,5,2),(855,'Very important',57,8,5,3);
/*!40000 ALTER TABLE `msp_importance_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_person`
--

DROP TABLE IF EXISTS `msp_person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_person` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(250) NOT NULL,
  `last_name` varchar(250) NOT NULL,
  `registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `email` varchar(75) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_person`
--

LOCK TABLES `msp_person` WRITE;
/*!40000 ALTER TABLE `msp_person` DISABLE KEYS */;
INSERT INTO `msp_person` VALUES (1,'Anonymous','  ','2018-06-29 19:48:00','s.amariles+dmsp@cgair.org'),(23,'Sebastian','Amariles','2018-06-29 19:12:15','sebas932@gmail.com'),(24,'Andrés','Valencia','2018-06-29 20:12:25','a.valencia@cgiar.org'),(25,'Daniel ','Amariles','2018-06-29 19:43:12','d.amariles@cgiar.org');
/*!40000 ALTER TABLE `msp_person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_regions`
--

DROP TABLE IF EXISTS `msp_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_regions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(90) DEFAULT NULL,
  `name` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_regions`
--

LOCK TABLES `msp_regions` WRITE;
/*!40000 ALTER TABLE `msp_regions` DISABLE KEYS */;
INSERT INTO `msp_regions` VALUES (1,'africa','Africa'),(2,'asia','Asia'),(3,'oceania','Australia and Oceania'),(4,'central_america_caribbean','Central America and the Caribbean'),(5,'middle_east_north_africa','Middle East and North Africa'),(6,'north_america','North America'),(7,'south_america','South America'),(8,'europe','Europe');
/*!40000 ALTER TABLE `msp_regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_roles`
--

DROP TABLE IF EXISTS `msp_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_roles` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_roles`
--

LOCK TABLES `msp_roles` WRITE;
/*!40000 ALTER TABLE `msp_roles` DISABLE KEYS */;
INSERT INTO `msp_roles` VALUES (1,'Principal Investigator'),(2,'Researcher'),(3,'Data Manager');
/*!40000 ALTER TABLE `msp_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_sphere`
--

DROP TABLE IF EXISTS `msp_sphere`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_sphere` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_sphere`
--

LOCK TABLES `msp_sphere` WRITE;
/*!40000 ALTER TABLE `msp_sphere` DISABLE KEYS */;
INSERT INTO `msp_sphere` VALUES (1,'Strategic Planning'),(2,'Legal'),(3,'Managerial'),(4,'Communications'),(5,'Technical'),(6,'Data Management'),(7,'Using the Data');
/*!40000 ALTER TABLE `msp_sphere` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msp_stages`
--

DROP TABLE IF EXISTS `msp_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msp_stages` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_stages`
--

LOCK TABLES `msp_stages` WRITE;
/*!40000 ALTER TABLE `msp_stages` DISABLE KEYS */;
INSERT INTO `msp_stages` VALUES (1,'Proposal Stage','You are writing a project concept note or proposal for funding consideration'),(2,'Grant Opening','Your project has been funded and you are starting research activities'),(3,'Project Research','You are carrying out activities that will achieve project objectives'),(4,'Publishing','You are sharing the results of your project'),(5,'Grant Close out','The project is coming to an end and you are housekeeping');
/*!40000 ALTER TABLE `msp_stages` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-29 15:32:49
