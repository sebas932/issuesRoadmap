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
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_download`
--

LOCK TABLES `msp_download` WRITE;
/*!40000 ALTER TABLE `msp_download` DISABLE KEYS */;
INSERT INTO `msp_download` VALUES (45,23,'CCAFS','Testing','2018-06-29 20:30:28',0),(46,23,'CCAFS','Testing','2018-06-29 20:30:29',0),(47,24,'MARLO','Testing','2018-06-29 20:30:29',0),(48,25,'DAPA','Testing','2018-06-29 19:43:12',0),(49,25,'DAPA','Testing','2018-06-29 19:43:52',0),(50,1,'','Testing','2018-06-29 20:30:29',0),(51,23,'CCAFS','Testing','2018-06-29 20:03:57',0),(52,23,'CCAFS','Testing','2018-06-29 20:39:44',0),(53,1,'','','2018-06-29 20:44:52',0),(54,23,'CCAFS','Testing GA','2018-06-29 21:32:08',0),(55,23,'CCAFS','Test','2018-07-01 18:14:57',0),(56,23,'CCAFS','Testing GA','2018-07-02 19:19:37',0),(57,1,'','','2018-07-04 15:38:06',0),(58,1,'','','2018-07-04 19:42:31',0),(59,1,'','','2018-07-05 15:42:29',0),(60,23,'CCAFS','test','2018-07-13 21:07:04',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_download_guidelines`
--

LOCK TABLES `msp_download_guidelines` WRITE;
/*!40000 ALTER TABLE `msp_download_guidelines` DISABLE KEYS */;
INSERT INTO `msp_download_guidelines` VALUES (37,45,8),(38,45,9),(39,46,8),(40,46,9),(41,47,29),(42,47,30),(43,47,31),(44,48,23),(45,48,24),(46,48,25),(47,49,29),(48,49,30),(49,49,31),(50,50,29),(51,50,30),(52,50,31),(53,51,21),(54,52,15),(55,53,6),(56,54,29),(57,55,29),(58,56,8),(59,56,9),(60,57,8),(61,58,10),(62,59,17),(63,60,14),(64,60,15);
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
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_download_regions`
--

LOCK TABLES `msp_download_regions` WRITE;
/*!40000 ALTER TABLE `msp_download_regions` DISABLE KEYS */;
INSERT INTO `msp_download_regions` VALUES (5,45,7,'instituteRegion'),(6,45,8,'instituteRegion'),(7,45,1,'researchRegion'),(8,45,2,'researchRegion'),(9,46,7,'instituteRegion'),(10,46,8,'instituteRegion'),(11,46,1,'researchRegion'),(12,46,2,'researchRegion'),(13,46,5,'researchRegion'),(14,47,8,'instituteRegion'),(15,47,1,'researchRegion'),(16,47,2,'researchRegion'),(17,47,6,'researchRegion'),(18,48,7,'instituteRegion'),(19,48,8,'instituteRegion'),(20,48,1,'researchRegion'),(21,48,2,'researchRegion'),(22,49,7,'instituteRegion'),(23,49,8,'instituteRegion'),(24,49,1,'researchRegion'),(25,49,2,'researchRegion'),(26,51,4,'instituteRegion'),(27,51,1,'researchRegion'),(28,51,2,'researchRegion'),(29,51,5,'researchRegion'),(30,51,6,'researchRegion'),(31,52,8,'instituteRegion'),(32,52,1,'researchRegion'),(33,54,8,'instituteRegion'),(34,54,1,'researchRegion'),(35,55,7,'instituteRegion'),(36,55,8,'instituteRegion'),(37,55,1,'researchRegion'),(38,55,3,'researchRegion'),(39,56,7,'instituteRegion'),(40,56,8,'instituteRegion'),(41,56,1,'researchRegion'),(42,56,2,'researchRegion'),(43,60,4,'instituteRegion'),(44,60,5,'instituteRegion'),(45,60,1,'researchRegion'),(46,60,2,'researchRegion');
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
  `guideline_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `stage_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `importance_level` enum('Very important','Important','Useful','Optional') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_msp_importance_levels_msp_categories1_idx1` (`category_id`),
  KEY `fk_msp_importance_levels_msp_roles1_idx1` (`role_id`) USING BTREE,
  KEY `fk_msp_importance_levels_msp_guidelines1_idx1` (`guideline_id`) USING BTREE,
  KEY `fk_msp_importance_levels_msp_stages1_idx1` (`stage_id`) USING BTREE,
  KEY `fk_msp_importance_levels_performance` (`role_id`,`stage_id`,`guideline_id`) USING BTREE,
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
INSERT INTO `msp_importance_levels` VALUES (1,1,1,1,1,'Very important'),(2,1,1,1,2,'Very important'),(3,1,1,1,3,'Important'),(4,1,1,2,1,'Very important'),(5,1,1,2,2,'Very important'),(6,1,1,2,3,'Important'),(7,1,1,3,1,'Important'),(8,1,1,3,2,'Important'),(9,1,1,3,3,'Important'),(10,1,1,4,1,'Important'),(11,1,1,4,2,'Optional'),(12,1,1,4,3,'Important'),(13,1,1,5,1,'Very important'),(14,1,1,5,2,'Optional'),(15,1,1,5,3,'Very important'),(16,2,1,1,1,'Important'),(17,2,1,1,2,'Useful'),(18,2,1,1,3,'Important'),(19,2,1,2,1,'Important'),(20,2,1,2,2,'Useful'),(21,2,1,2,3,'Important'),(22,2,1,3,1,'Optional'),(23,2,1,3,2,'Optional'),(24,2,1,3,3,'Optional'),(25,2,1,4,1,'Optional'),(26,2,1,4,2,'Optional'),(27,2,1,4,3,'Optional'),(28,2,1,5,1,'Optional'),(29,2,1,5,2,'Optional'),(30,2,1,5,3,'Useful'),(31,3,1,1,1,'Useful'),(32,3,1,1,2,'Optional'),(33,3,1,1,3,'Optional'),(34,3,1,2,1,'Useful'),(35,3,1,2,2,'Optional'),(36,3,1,2,3,'Optional'),(37,3,1,3,1,'Optional'),(38,3,1,3,2,'Optional'),(39,3,1,3,3,'Optional'),(40,3,1,4,1,'Optional'),(41,3,1,4,2,'Optional'),(42,3,1,4,3,'Optional'),(43,3,1,5,1,'Useful'),(44,3,1,5,2,'Optional'),(45,3,1,5,3,'Useful'),(46,4,1,1,1,'Very important'),(47,4,1,1,2,'Important'),(48,4,1,1,3,'Very important'),(49,4,1,2,1,'Very important'),(50,4,1,2,2,'Important'),(51,4,1,2,3,'Very important'),(52,4,1,3,1,'Optional'),(53,4,1,3,2,'Optional'),(54,4,1,3,3,'Optional'),(55,4,1,4,1,'Optional'),(56,4,1,4,2,'Optional'),(57,4,1,4,3,'Optional'),(58,4,1,5,1,'Very important'),(59,4,1,5,2,'Optional'),(60,4,1,5,3,'Optional'),(61,5,0,1,1,'Very important'),(62,5,0,1,2,'Very important'),(63,5,0,1,3,'Very important'),(64,5,0,2,1,'Useful'),(65,5,0,2,2,'Useful'),(66,5,0,2,3,'Useful'),(67,5,0,3,1,'Optional'),(68,5,0,3,2,'Optional'),(69,5,0,3,3,'Optional'),(70,5,0,4,1,'Optional'),(71,5,0,4,2,'Optional'),(72,5,0,4,3,'Optional'),(73,5,0,5,1,'Optional'),(74,5,0,5,2,'Optional'),(75,5,0,5,3,'Optional'),(76,6,0,1,1,'Important'),(77,6,0,1,2,'Very important'),(78,6,0,1,3,'Useful'),(79,6,0,2,1,'Useful'),(80,6,0,2,2,'Useful'),(81,6,0,2,3,'Useful'),(82,6,0,3,1,'Optional'),(83,6,0,3,2,'Optional'),(84,6,0,3,3,'Optional'),(85,6,0,4,1,'Optional'),(86,6,0,4,2,'Useful'),(87,6,0,4,3,'Useful'),(88,6,0,5,1,'Optional'),(89,6,0,5,2,'Useful'),(90,6,0,5,3,'Useful'),(91,7,0,1,1,'Important'),(92,7,0,1,2,'Important'),(93,7,0,1,3,'Useful'),(94,7,0,2,1,'Useful'),(95,7,0,2,2,'Useful'),(96,7,0,2,3,'Useful'),(97,7,0,3,1,'Optional'),(98,7,0,3,2,'Optional'),(99,7,0,3,3,'Optional'),(100,7,0,4,1,'Optional'),(101,7,0,4,2,'Useful'),(102,7,0,4,3,'Useful'),(103,7,0,5,1,'Optional'),(104,7,0,5,2,'Useful'),(105,7,0,5,3,'Useful'),(106,8,2,1,1,'Very important'),(107,8,2,1,2,'Very important'),(108,8,2,1,3,'Very important'),(109,8,2,2,1,'Very important'),(110,8,2,2,2,'Very important'),(111,8,2,2,3,'Very important'),(112,8,2,3,1,'Useful'),(113,8,2,3,2,'Useful'),(114,8,2,3,3,'Useful'),(115,8,2,4,1,'Useful'),(116,8,2,4,2,'Useful'),(117,8,2,4,3,'Useful'),(118,8,2,5,1,'Useful'),(119,8,2,5,2,'Useful'),(120,8,2,5,3,'Useful'),(121,9,2,1,1,'Important'),(122,9,2,1,2,'Important'),(123,9,2,1,3,'Very important'),(124,9,2,2,1,'Very important'),(125,9,2,2,2,'Very important'),(126,9,2,2,3,'Very important'),(127,9,2,3,1,'Useful'),(128,9,2,3,2,'Useful'),(129,9,2,3,3,'Useful'),(130,9,2,4,1,'Useful'),(131,9,2,4,2,'Useful'),(132,9,2,4,3,'Useful'),(133,9,2,5,1,'Useful'),(134,9,2,5,2,'Useful'),(135,9,2,5,3,'Useful'),(136,10,2,1,1,'Useful'),(137,10,2,1,2,'Useful'),(138,10,2,1,3,'Important'),(139,10,2,2,1,'Very important'),(140,10,2,2,2,'Very important'),(141,10,2,2,3,'Very important'),(142,10,2,3,1,'Useful'),(143,10,2,3,2,'Useful'),(144,10,2,3,3,'Important'),(145,10,2,4,1,'Useful'),(146,10,2,4,2,'Useful'),(147,10,2,4,3,'Useful'),(148,10,2,5,1,'Useful'),(149,10,2,5,2,'Useful'),(150,10,2,5,3,'Useful'),(151,11,2,1,1,'Useful'),(152,11,2,1,2,'Useful'),(153,11,2,1,3,'Optional'),(154,11,2,2,1,'Important'),(155,11,2,2,2,'Important'),(156,11,2,2,3,'Optional'),(157,11,2,3,1,'Optional'),(158,11,2,3,2,'Optional'),(159,11,2,3,3,'Optional'),(160,11,2,4,1,'Very important'),(161,11,2,4,2,'Very important'),(162,11,2,4,3,'Useful'),(163,11,2,5,1,'Useful'),(164,11,2,5,2,'Useful'),(165,11,2,5,3,'Optional'),(166,12,2,1,1,'Useful'),(167,12,2,1,2,'Useful'),(168,12,2,1,3,'Very important'),(169,12,2,2,1,'Very important'),(170,12,2,2,2,'Very important'),(171,12,2,2,3,'Very important'),(172,12,2,3,1,'Useful'),(173,12,2,3,2,'Useful'),(174,12,2,3,3,'Important'),(175,12,2,4,1,'Useful'),(176,12,2,4,2,'Useful'),(177,12,2,4,3,'Very important'),(178,12,2,5,1,'Useful'),(179,12,2,5,2,'Useful'),(180,12,2,5,3,'Very important'),(181,13,2,1,1,'Important'),(182,13,2,1,2,'Important'),(183,13,2,1,3,'Optional'),(184,13,2,2,1,'Useful'),(185,13,2,2,2,'Useful'),(186,13,2,2,3,'Optional'),(187,13,2,3,1,'Optional'),(188,13,2,3,2,'Optional'),(189,13,2,3,3,'Optional'),(190,13,2,4,1,'Important'),(191,13,2,4,2,'Important'),(192,13,2,4,3,'Optional'),(193,13,2,5,1,'Useful'),(194,13,2,5,2,'Useful'),(195,13,2,5,3,'Optional'),(196,14,3,1,1,'Very important'),(197,14,3,1,2,'Very important'),(198,14,3,1,3,'Very important'),(199,14,3,2,1,'Very important'),(200,14,3,2,2,'Very important'),(201,14,3,2,3,'Very important'),(202,14,3,3,1,'Important'),(203,14,3,3,2,'Useful'),(204,14,3,3,3,'Useful'),(205,14,3,4,1,'Useful'),(206,14,3,4,2,'Useful'),(207,14,3,4,3,'Useful'),(208,14,3,5,1,'Optional'),(209,14,3,5,2,'Optional'),(210,14,3,5,3,'Optional'),(211,15,3,1,1,'Very important'),(212,15,3,1,2,'Very important'),(213,15,3,1,3,'Very important'),(214,15,3,2,1,'Very important'),(215,15,3,2,2,'Very important'),(216,15,3,2,3,'Very important'),(217,15,3,3,1,'Useful'),(218,15,3,3,2,'Useful'),(219,15,3,3,3,'Useful'),(220,15,3,4,1,'Useful'),(221,15,3,4,2,'Useful'),(222,15,3,4,3,'Useful'),(223,15,3,5,1,'Optional'),(224,15,3,5,2,'Optional'),(225,15,3,5,3,'Optional'),(226,16,3,1,1,'Optional'),(227,16,3,1,2,'Optional'),(228,16,3,1,3,'Optional'),(229,16,3,2,1,'Optional'),(230,16,3,2,2,'Optional'),(231,16,3,2,3,'Optional'),(232,16,3,3,1,'Optional'),(233,16,3,3,2,'Optional'),(234,16,3,3,3,'Optional'),(235,16,3,4,1,'Optional'),(236,16,3,4,2,'Optional'),(237,16,3,4,3,'Useful'),(238,16,3,5,1,'Optional'),(239,16,3,5,2,'Optional'),(240,16,3,5,3,'Optional'),(241,17,3,1,1,'Optional'),(242,17,3,1,2,'Optional'),(243,17,3,1,3,'Optional'),(244,17,3,2,1,'Optional'),(245,17,3,2,2,'Optional'),(246,17,3,2,3,'Optional'),(247,17,3,3,1,'Optional'),(248,17,3,3,2,'Optional'),(249,17,3,3,3,'Optional'),(250,17,3,4,1,'Optional'),(251,17,3,4,2,'Optional'),(252,17,3,4,3,'Useful'),(253,17,3,5,1,'Optional'),(254,17,3,5,2,'Optional'),(255,17,3,5,3,'Optional'),(256,18,3,1,1,'Very important'),(257,18,3,1,2,'Very important'),(258,18,3,1,3,'Very important'),(259,18,3,2,1,'Very important'),(260,18,3,2,2,'Very important'),(261,18,3,2,3,'Very important'),(262,18,3,3,1,'Important'),(263,18,3,3,2,'Useful'),(264,18,3,3,3,'Very important'),(265,18,3,4,1,'Useful'),(266,18,3,4,2,'Useful'),(267,18,3,4,3,'Useful'),(268,18,3,5,1,'Optional'),(269,18,3,5,2,'Useful'),(270,18,3,5,3,'Useful'),(271,19,3,1,1,'Useful'),(272,19,3,1,2,'Useful'),(273,19,3,1,3,'Very important'),(274,19,3,2,1,'Useful'),(275,19,3,2,2,'Important'),(276,19,3,2,3,'Useful'),(277,19,3,3,1,'Useful'),(278,19,3,3,2,'Optional'),(279,19,3,3,3,'Very important'),(280,19,3,4,1,'Optional'),(281,19,3,4,2,'Useful'),(282,19,3,4,3,'Useful'),(283,19,3,5,1,'Optional'),(284,19,3,5,2,'Useful'),(285,19,3,5,3,'Useful'),(286,20,3,1,1,'Very important'),(287,20,3,1,2,'Very important'),(288,20,3,1,3,'Very important'),(289,20,3,2,1,'Very important'),(290,20,3,2,2,'Very important'),(291,20,3,2,3,'Very important'),(292,20,3,3,1,'Important'),(293,20,3,3,2,'Optional'),(294,20,3,3,3,'Important'),(295,20,3,4,1,'Useful'),(296,20,3,4,2,'Useful'),(297,20,3,4,3,'Useful'),(298,20,3,5,1,'Optional'),(299,20,3,5,2,'Optional'),(300,20,3,5,3,'Optional'),(301,21,3,1,1,'Useful'),(302,21,3,1,2,'Useful'),(303,21,3,1,3,'Important'),(304,21,3,2,1,'Useful'),(305,21,3,2,2,'Very important'),(306,21,3,2,3,'Important'),(307,21,3,3,1,'Optional'),(308,21,3,3,2,'Optional'),(309,21,3,3,3,'Important'),(310,21,3,4,1,'Optional'),(311,21,3,4,2,'Useful'),(312,21,3,4,3,'Useful'),(313,21,3,5,1,'Optional'),(314,21,3,5,2,'Useful'),(315,21,3,5,3,'Useful'),(316,22,3,1,1,'Optional'),(317,22,3,1,2,'Useful'),(318,22,3,1,3,'Important'),(319,22,3,2,1,'Optional'),(320,22,3,2,2,'Useful'),(321,22,3,2,3,'Useful'),(322,22,3,3,1,'Useful'),(323,22,3,3,2,'Useful'),(324,22,3,3,3,'Useful'),(325,22,3,4,1,'Useful'),(326,22,3,4,2,'Useful'),(327,22,3,4,3,'Useful'),(328,22,3,5,1,'Useful'),(329,22,3,5,2,'Useful'),(330,22,3,5,3,'Useful'),(331,23,4,1,1,'Important'),(332,23,4,1,2,'Important'),(333,23,4,1,3,'Important'),(334,23,4,2,1,'Very important'),(335,23,4,2,2,'Very important'),(336,23,4,2,3,'Very important'),(337,23,4,3,1,'Useful'),(338,23,4,3,2,'Important'),(339,23,4,3,3,'Very important'),(340,23,4,4,1,'Useful'),(341,23,4,4,2,'Important'),(342,23,4,4,3,'Very important'),(343,23,4,5,1,'Optional'),(344,23,4,5,2,'Optional'),(345,23,4,5,3,'Very important'),(346,24,4,1,1,'Important'),(347,24,4,1,2,'Important'),(348,24,4,1,3,'Important'),(349,24,4,2,1,'Very important'),(350,24,4,2,2,'Very important'),(351,24,4,2,3,'Very important'),(352,24,4,3,1,'Useful'),(353,24,4,3,2,'Important'),(354,24,4,3,3,'Very important'),(355,24,4,4,1,'Useful'),(356,24,4,4,2,'Important'),(357,24,4,4,3,'Very important'),(358,24,4,5,1,'Optional'),(359,24,4,5,2,'Optional'),(360,24,4,5,3,'Very important'),(361,25,4,1,1,'Useful'),(362,25,4,1,2,'Useful'),(363,25,4,1,3,'Important'),(364,25,4,2,1,'Useful'),(365,25,4,2,2,'Useful'),(366,25,4,2,3,'Very important'),(367,25,4,3,1,'Useful'),(368,25,4,3,2,'Important'),(369,25,4,3,3,'Very important'),(370,25,4,4,1,'Useful'),(371,25,4,4,2,'Important'),(372,25,4,4,3,'Very important'),(373,25,4,5,1,'Optional'),(374,25,4,5,2,'Optional'),(375,25,4,5,3,'Very important'),(376,26,4,1,1,'Useful'),(377,26,4,1,2,'Useful'),(378,26,4,1,3,'Important'),(379,26,4,2,1,'Useful'),(380,26,4,2,2,'Useful'),(381,26,4,2,3,'Very important'),(382,26,4,3,1,'Useful'),(383,26,4,3,2,'Important'),(384,26,4,3,3,'Very important'),(385,26,4,4,1,'Useful'),(386,26,4,4,2,'Important'),(387,26,4,4,3,'Very important'),(388,26,4,5,1,'Optional'),(389,26,4,5,2,'Optional'),(390,26,4,5,3,'Very important'),(391,27,4,1,1,'Optional'),(392,27,4,1,2,'Useful'),(393,27,4,1,3,'Useful'),(394,27,4,2,1,'Optional'),(395,27,4,2,2,'Useful'),(396,27,4,2,3,'Useful'),(397,27,4,3,1,'Useful'),(398,27,4,3,2,'Useful'),(399,27,4,3,3,'Useful'),(400,27,4,4,1,'Useful'),(401,27,4,4,2,'Useful'),(402,27,4,4,3,'Useful'),(403,27,4,5,1,'Optional'),(404,27,4,5,2,'Optional'),(405,27,4,5,3,'Useful'),(406,28,4,1,1,'Optional'),(407,28,4,1,2,'Useful'),(408,28,4,1,3,'Useful'),(409,28,4,2,1,'Optional'),(410,28,4,2,2,'Useful'),(411,28,4,2,3,'Useful'),(412,28,4,3,1,'Useful'),(413,28,4,3,2,'Useful'),(414,28,4,3,3,'Useful'),(415,28,4,4,1,'Useful'),(416,28,4,4,2,'Useful'),(417,28,4,4,3,'Useful'),(418,28,4,5,1,'Optional'),(419,28,4,5,2,'Optional'),(420,28,4,5,3,'Useful'),(421,29,5,1,1,'Important'),(422,29,5,1,2,'Important'),(423,29,5,1,3,'Important'),(424,29,5,2,1,'Very important'),(425,29,5,2,2,'Very important'),(426,29,5,2,3,'Very important'),(427,29,5,3,1,'Very important'),(428,29,5,3,2,'Very important'),(429,29,5,3,3,'Very important'),(430,29,5,4,1,'Important'),(431,29,5,4,2,'Important'),(432,29,5,4,3,'Useful'),(433,29,5,5,1,'Useful'),(434,29,5,5,2,'Useful'),(435,29,5,5,3,'Important'),(436,30,5,1,1,'Useful'),(437,30,5,1,2,'Useful'),(438,30,5,1,3,'Useful'),(439,30,5,2,1,'Useful'),(440,30,5,2,2,'Useful'),(441,30,5,2,3,'Useful'),(442,30,5,3,1,'Useful'),(443,30,5,3,2,'Useful'),(444,30,5,3,3,'Useful'),(445,30,5,4,1,'Useful'),(446,30,5,4,2,'Useful'),(447,30,5,4,3,'Useful'),(448,30,5,5,1,'Useful'),(449,30,5,5,2,'Useful'),(450,30,5,5,3,'Useful'),(451,31,5,1,1,'Useful'),(452,31,5,1,2,'Useful'),(453,31,5,1,3,'Useful'),(454,31,5,2,1,'Useful'),(455,31,5,2,2,'Useful'),(456,31,5,2,3,'Useful'),(457,31,5,3,1,'Useful'),(458,31,5,3,2,'Useful'),(459,31,5,3,3,'Useful'),(460,31,5,4,1,'Useful'),(461,31,5,4,2,'Useful'),(462,31,5,4,3,'Useful'),(463,31,5,5,1,'Useful'),(464,31,5,5,2,'Useful'),(465,31,5,5,3,'Useful'),(466,32,5,1,1,'Useful'),(467,32,5,1,2,'Useful'),(468,32,5,1,3,'Useful'),(469,32,5,2,1,'Useful'),(470,32,5,2,2,'Useful'),(471,32,5,2,3,'Useful'),(472,32,5,3,1,'Useful'),(473,32,5,3,2,'Useful'),(474,32,5,3,3,'Useful'),(475,32,5,4,1,'Useful'),(476,32,5,4,2,'Useful'),(477,32,5,4,3,'Useful'),(478,32,5,5,1,'Useful'),(479,32,5,5,2,'Useful'),(480,32,5,5,3,'Useful'),(481,33,5,1,1,'Very important'),(482,33,5,1,2,'Very important'),(483,33,5,1,3,'Useful'),(484,33,5,2,1,'Very important'),(485,33,5,2,2,'Very important'),(486,33,5,2,3,'Useful'),(487,33,5,3,1,'Very important'),(488,33,5,3,2,'Very important'),(489,33,5,3,3,'Very important'),(490,33,5,4,1,'Optional'),(491,33,5,4,2,'Very important'),(492,33,5,4,3,'Useful'),(493,33,5,5,1,'Optional'),(494,33,5,5,2,'Useful'),(495,33,5,5,3,'Useful'),(496,34,5,1,1,'Useful'),(497,34,5,1,2,'Useful'),(498,34,5,1,3,'Useful'),(499,34,5,2,1,'Useful'),(500,34,5,2,2,'Useful'),(501,34,5,2,3,'Useful'),(502,34,5,3,1,'Useful'),(503,34,5,3,2,'Useful'),(504,34,5,3,3,'Useful'),(505,34,5,4,1,'Useful'),(506,34,5,4,2,'Useful'),(507,34,5,4,3,'Useful'),(508,34,5,5,1,'Useful'),(509,34,5,5,2,'Useful'),(510,34,5,5,3,'Useful'),(511,35,6,1,1,'Important'),(512,35,6,1,2,'Important'),(513,35,6,1,3,'Important'),(514,35,6,2,1,'Very important'),(515,35,6,2,2,'Very important'),(516,35,6,2,3,'Very important'),(517,35,6,3,1,'Very important'),(518,35,6,3,2,'Very important'),(519,35,6,3,3,'Very important'),(520,35,6,4,1,'Important'),(521,35,6,4,2,'Important'),(522,35,6,4,3,'Very important'),(523,35,6,5,1,'Very important'),(524,35,6,5,2,'Very important'),(525,35,6,5,3,'Very important'),(526,36,6,1,1,'Important'),(527,36,6,1,2,'Important'),(528,36,6,1,3,'Important'),(529,36,6,2,1,'Very important'),(530,36,6,2,2,'Very important'),(531,36,6,2,3,'Very important'),(532,36,6,3,1,'Important'),(533,36,6,3,2,'Important'),(534,36,6,3,3,'Very important'),(535,36,6,4,1,'Important'),(536,36,6,4,2,'Important'),(537,36,6,4,3,'Very important'),(538,36,6,5,1,'Very important'),(539,36,6,5,2,'Very important'),(540,36,6,5,3,'Very important'),(541,37,6,1,1,'Useful'),(542,37,6,1,2,'Useful'),(543,37,6,1,3,'Useful'),(544,37,6,2,1,'Useful'),(545,37,6,2,2,'Useful'),(546,37,6,2,3,'Important'),(547,37,6,3,1,'Useful'),(548,37,6,3,2,'Important'),(549,37,6,3,3,'Very important'),(550,37,6,4,1,'Useful'),(551,37,6,4,2,'Useful'),(552,37,6,4,3,'Important'),(553,37,6,5,1,'Useful'),(554,37,6,5,2,'Useful'),(555,37,6,5,3,'Important'),(556,38,6,1,1,'Useful'),(557,38,6,1,2,'Useful'),(558,38,6,1,3,'Useful'),(559,38,6,2,1,'Useful'),(560,38,6,2,2,'Useful'),(561,38,6,2,3,'Important'),(562,38,6,3,1,'Useful'),(563,38,6,3,2,'Useful'),(564,38,6,3,3,'Important'),(565,38,6,4,1,'Useful'),(566,38,6,4,2,'Useful'),(567,38,6,4,3,'Important'),(568,38,6,5,1,'Useful'),(569,38,6,5,2,'Useful'),(570,38,6,5,3,'Important'),(571,39,6,1,1,'Useful'),(572,39,6,1,2,'Useful'),(573,39,6,1,3,'Useful'),(574,39,6,2,1,'Useful'),(575,39,6,2,2,'Useful'),(576,39,6,2,3,'Important'),(577,39,6,3,1,'Useful'),(578,39,6,3,2,'Useful'),(579,39,6,3,3,'Very important'),(580,39,6,4,1,'Useful'),(581,39,6,4,2,'Useful'),(582,39,6,4,3,'Important'),(583,39,6,5,1,'Useful'),(584,39,6,5,2,'Useful'),(585,39,6,5,3,'Important'),(586,40,6,1,1,'Useful'),(587,40,6,1,2,'Useful'),(588,40,6,1,3,'Useful'),(589,40,6,2,1,'Useful'),(590,40,6,2,2,'Useful'),(591,40,6,2,3,'Important'),(592,40,6,3,1,'Useful'),(593,40,6,3,2,'Useful'),(594,40,6,3,3,'Important'),(595,40,6,4,1,'Useful'),(596,40,6,4,2,'Useful'),(597,40,6,4,3,'Important'),(598,40,6,5,1,'Useful'),(599,40,6,5,2,'Useful'),(600,40,6,5,3,'Important'),(601,41,7,1,1,'Important'),(602,41,7,1,2,'Important'),(603,41,7,1,3,'Important'),(604,41,7,2,1,'Very important'),(605,41,7,2,2,'Very important'),(606,41,7,2,3,'Very important'),(607,41,7,3,1,'Very important'),(608,41,7,3,2,'Important'),(609,41,7,3,3,'Important'),(610,41,7,4,1,'Very important'),(611,41,7,4,2,'Very important'),(612,41,7,4,3,'Very important'),(613,41,7,5,1,'Very important'),(614,41,7,5,2,'Very important'),(615,41,7,5,3,'Very important'),(616,42,7,1,1,'Useful'),(617,42,7,1,2,'Useful'),(618,42,7,1,3,'Useful'),(619,42,7,2,1,'Useful'),(620,42,7,2,2,'Useful'),(621,42,7,2,3,'Useful'),(622,42,7,3,1,'Useful'),(623,42,7,3,2,'Useful'),(624,42,7,3,3,'Useful'),(625,42,7,4,1,'Useful'),(626,42,7,4,2,'Useful'),(627,42,7,4,3,'Useful'),(628,42,7,5,1,'Very important'),(629,42,7,5,2,'Useful'),(630,42,7,5,3,'Very important'),(631,43,7,1,1,'Useful'),(632,43,7,1,2,'Useful'),(633,43,7,1,3,'Useful'),(634,43,7,2,1,'Useful'),(635,43,7,2,2,'Useful'),(636,43,7,2,3,'Useful'),(637,43,7,3,1,'Useful'),(638,43,7,3,2,'Useful'),(639,43,7,3,3,'Useful'),(640,43,7,4,1,'Important'),(641,43,7,4,2,'Useful'),(642,43,7,4,3,'Important'),(643,43,7,5,1,'Very important'),(644,43,7,5,2,'Very important'),(645,43,7,5,3,'Very important'),(646,44,7,1,1,'Useful'),(647,44,7,1,2,'Useful'),(648,44,7,1,3,'Useful'),(649,44,7,2,1,'Useful'),(650,44,7,2,2,'Useful'),(651,44,7,2,3,'Useful'),(652,44,7,3,1,'Useful'),(653,44,7,3,2,'Useful'),(654,44,7,3,3,'Useful'),(655,44,7,4,1,'Useful'),(656,44,7,4,2,'Useful'),(657,44,7,4,3,'Useful'),(658,44,7,5,1,'Important'),(659,44,7,5,2,'Important'),(660,44,7,5,3,'Important'),(661,45,7,1,1,'Useful'),(662,45,7,1,2,'Useful'),(663,45,7,1,3,'Useful'),(664,45,7,2,1,'Useful'),(665,45,7,2,2,'Useful'),(666,45,7,2,3,'Useful'),(667,45,7,3,1,'Useful'),(668,45,7,3,2,'Useful'),(669,45,7,3,3,'Useful'),(670,45,7,4,1,'Useful'),(671,45,7,4,2,'Useful'),(672,45,7,4,3,'Useful'),(673,45,7,5,1,'Important'),(674,45,7,5,2,'Important'),(675,45,7,5,3,'Important'),(676,46,7,1,1,'Optional'),(677,46,7,1,2,'Optional'),(678,46,7,1,3,'Optional'),(679,46,7,2,1,'Optional'),(680,46,7,2,2,'Optional'),(681,46,7,2,3,'Optional'),(682,46,7,3,1,'Optional'),(683,46,7,3,2,'Optional'),(684,46,7,3,3,'Optional'),(685,46,7,4,1,'Optional'),(686,46,7,4,2,'Optional'),(687,46,7,4,3,'Optional'),(688,46,7,5,1,'Optional'),(689,46,7,5,2,'Optional'),(690,46,7,5,3,'Optional'),(691,47,8,1,1,'Very important'),(692,47,8,1,2,'Useful'),(693,47,8,1,3,'Very important'),(694,47,8,2,1,'Very important'),(695,47,8,2,2,'Useful'),(696,47,8,2,3,'Very important'),(697,47,8,3,1,'Important'),(698,47,8,3,2,'Useful'),(699,47,8,3,3,'Useful'),(700,47,8,4,1,'Optional'),(701,47,8,4,2,'Important'),(702,47,8,4,3,'Important'),(703,47,8,5,1,'Very important'),(704,47,8,5,2,'Very important'),(705,47,8,5,3,'Very important'),(706,48,8,1,1,'Useful'),(707,48,8,1,2,'Useful'),(708,48,8,1,3,'Important'),(709,48,8,2,1,'Useful'),(710,48,8,2,2,'Useful'),(711,48,8,2,3,'Useful'),(712,48,8,3,1,'Useful'),(713,48,8,3,2,'Useful'),(714,48,8,3,3,'Useful'),(715,48,8,4,1,'Useful'),(716,48,8,4,2,'Useful'),(717,48,8,4,3,'Useful'),(718,48,8,5,1,'Very important'),(719,48,8,5,2,'Useful'),(720,48,8,5,3,'Very important'),(721,49,8,1,1,'Useful'),(722,49,8,1,2,'Optional'),(723,49,8,1,3,'Optional'),(724,49,8,2,1,'Useful'),(725,49,8,2,2,'Useful'),(726,49,8,2,3,'Useful'),(727,49,8,3,1,'Useful'),(728,49,8,3,2,'Optional'),(729,49,8,3,3,'Optional'),(730,49,8,4,1,'Useful'),(731,49,8,4,2,'Useful'),(732,49,8,4,3,'Important'),(733,49,8,5,1,'Very important'),(734,49,8,5,2,'Very important'),(735,49,8,5,3,'Very important'),(736,50,8,1,1,'Useful'),(737,50,8,1,2,'Optional'),(738,50,8,1,3,'Useful'),(739,50,8,2,1,'Useful'),(740,50,8,2,2,'Useful'),(741,50,8,2,3,'Useful'),(742,50,8,3,1,'Useful'),(743,50,8,3,2,'Optional'),(744,50,8,3,3,'Useful'),(745,50,8,4,1,'Useful'),(746,50,8,4,2,'Useful'),(747,50,8,4,3,'Useful'),(748,50,8,5,1,'Useful'),(749,50,8,5,2,'Useful'),(750,50,8,5,3,'Very important'),(751,51,8,1,1,'Useful'),(752,51,8,1,2,'Useful'),(753,51,8,1,3,'Useful'),(754,51,8,2,1,'Useful'),(755,51,8,2,2,'Useful'),(756,51,8,2,3,'Useful'),(757,51,8,3,1,'Useful'),(758,51,8,3,2,'Optional'),(759,51,8,3,3,'Optional'),(760,51,8,4,1,'Useful'),(761,51,8,4,2,'Useful'),(762,51,8,4,3,'Useful'),(763,51,8,5,1,'Useful'),(764,51,8,5,2,'Useful'),(765,51,8,5,3,'Very important'),(766,52,8,1,1,'Optional'),(767,52,8,1,2,'Optional'),(768,52,8,1,3,'Optional'),(769,52,8,2,1,'Useful'),(770,52,8,2,2,'Useful'),(771,52,8,2,3,'Useful'),(772,52,8,3,1,'Optional'),(773,52,8,3,2,'Optional'),(774,52,8,3,3,'Optional'),(775,52,8,4,1,'Useful'),(776,52,8,4,2,'Useful'),(777,52,8,4,3,'Useful'),(778,52,8,5,1,'Useful'),(779,52,8,5,2,'Useful'),(780,52,8,5,3,'Very important'),(781,53,8,1,1,'Optional'),(782,53,8,1,2,'Optional'),(783,53,8,1,3,'Optional'),(784,53,8,2,1,'Useful'),(785,53,8,2,2,'Useful'),(786,53,8,2,3,'Useful'),(787,53,8,3,1,'Optional'),(788,53,8,3,2,'Optional'),(789,53,8,3,3,'Optional'),(790,53,8,4,1,'Useful'),(791,53,8,4,2,'Useful'),(792,53,8,4,3,'Useful'),(793,53,8,5,1,'Useful'),(794,53,8,5,2,'Useful'),(795,53,8,5,3,'Very important'),(796,54,8,1,1,'Optional'),(797,54,8,1,2,'Optional'),(798,54,8,1,3,'Optional'),(799,54,8,2,1,'Useful'),(800,54,8,2,2,'Useful'),(801,54,8,2,3,'Useful'),(802,54,8,3,1,'Optional'),(803,54,8,3,2,'Optional'),(804,54,8,3,3,'Optional'),(805,54,8,4,1,'Useful'),(806,54,8,4,2,'Useful'),(807,54,8,4,3,'Useful'),(808,54,8,5,1,'Useful'),(809,54,8,5,2,'Useful'),(810,54,8,5,3,'Very important'),(811,55,8,1,1,'Useful'),(812,55,8,1,2,'Useful'),(813,55,8,1,3,'Optional'),(814,55,8,2,1,'Useful'),(815,55,8,2,2,'Useful'),(816,55,8,2,3,'Useful'),(817,55,8,3,1,'Useful'),(818,55,8,3,2,'Optional'),(819,55,8,3,3,'Optional'),(820,55,8,4,1,'Useful'),(821,55,8,4,2,'Useful'),(822,55,8,4,3,'Useful'),(823,55,8,5,1,'Useful'),(824,55,8,5,2,'Useful'),(825,55,8,5,3,'Very important'),(826,56,8,1,1,'Optional'),(827,56,8,1,2,'Optional'),(828,56,8,1,3,'Optional'),(829,56,8,2,1,'Useful'),(830,56,8,2,2,'Useful'),(831,56,8,2,3,'Useful'),(832,56,8,3,1,'Optional'),(833,56,8,3,2,'Optional'),(834,56,8,3,3,'Optional'),(835,56,8,4,1,'Useful'),(836,56,8,4,2,'Useful'),(837,56,8,4,3,'Useful'),(838,56,8,5,1,'Useful'),(839,56,8,5,2,'Useful'),(840,56,8,5,3,'Very important'),(841,57,8,1,1,'Optional'),(842,57,8,1,2,'Optional'),(843,57,8,1,3,'Optional'),(844,57,8,2,1,'Useful'),(845,57,8,2,2,'Useful'),(846,57,8,2,3,'Useful'),(847,57,8,3,1,'Optional'),(848,57,8,3,2,'Optional'),(849,57,8,3,3,'Optional'),(850,57,8,4,1,'Useful'),(851,57,8,4,2,'Useful'),(852,57,8,4,3,'Useful'),(853,57,8,5,1,'Useful'),(854,57,8,5,2,'Useful'),(855,57,8,5,3,'Very important');
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
  `acronym` varchar(45) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msp_roles`
--

LOCK TABLES `msp_roles` WRITE;
/*!40000 ALTER TABLE `msp_roles` DISABLE KEYS */;
INSERT INTO `msp_roles` VALUES (1,'PI','Principal Investigator'),(2,'R','Researcher'),(3,'DM','Data Manager');
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

-- Dump completed on 2018-07-13 16:21:16
