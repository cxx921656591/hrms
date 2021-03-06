use hrms;

create table if not exists employee (
	eid int not null auto_increment,
	name varchar (30) not null,
	address varchar (50) not null,
	age int not null check (age < 60 and age > 0),
	gender char(1) not null,
	aadhar char(12),
	primary key(eid)
);

create table if not exists employee_login(
	eid int not null,
	user int not null,
	primary key(eid, user),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(user) references auth_user(id) on delete cascade on update cascade
);

create table if not exists employee_phone (
	eid int not null,
	phone char(10) not null,
	primary key(eid, phone),
	foreign key(eid) references employee(eid) on delete cascade on update cascade
);

create table if not exists ulb (
	uid int not null auto_increment,
	ulb_name varchar(40),
	ulb_type varchar(11),
	primary key(uid)
);

create table if not exists post (
	pid int not null,
	uid int not null,
	post_name varchar(30),
	class char(7),
	number int not null,
	primary key(pid, uid),
	foreign key(uid) references ulb(uid) on delete cascade on update cascade
);

create table if not exists regularisation (
	eid int not null,
	date date not null,
	pid int,
	uid int,
	primary key(eid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(pid, uid) references post(pid, uid) on delete set null on update cascade
);

create table if not exists employee_post (
	eid int not null,
	pid int not null,
	uid int not null,
	primary key(eid, pid, uid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(pid, uid) references post(pid, uid) on delete restrict on update cascade
);

create table if not exists retirement(
	eid int not null,
	date date,
	pension int,
	primary key(eid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade
);

create table if not exists employee_account(
	eid int not null,
	account_no varchar(11) not null,
	ifsc char(11) not null,
	primary key(account_no, ifsc),
	foreign key(eid) references employee(eid) on delete set null on update cascade
);


create table if not exists salary(
	sid int not null auto_increment,
	basic_pay int not null,
	grade_pay int not null,
	primary key(sid)
);

create table if not exists loan(
	lid int not null auto_increment,
	amount int not null,
	date date not null,
	duration int not null,
	type varchar(10),
	paid int default 0,
	status char(1) default 'n',
	months int default 0,
	primary key(lid)
);

/* insert into loan values(0, 0, '0001-01-01', 1, 'misc', 'y');*/

create table if not exists employee_loan(
	eid int not null,
	lid int not null,
	primary key(eid, lid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(lid) references loan(lid) on delete cascade on update cascade
);


create table if not exists payment(
	account_no varchar(11) not null,
    ifsc char(11) not null,
	sid int not null,
	date date not null,
	deductions int default 0,
	primary key(account_no, ifsc, date),
	foreign key(account_no, ifsc) references employee_account(account_no, ifsc) on delete restrict on update cascade,
	foreign key(sid) references salary(sid) on delete restrict on update restrict
);

create table if not exists payment_loan(
	account_no varchar(11) not null,
	ifsc char(11) not null,
	date date not null,
	lid int not null,
	primary key(account_no, ifsc, date, lid),
	foreign key(account_no, ifsc, date) references payment(account_no, ifsc, date) on delete cascade on update cascade,
	foreign key(lid) references loan(lid) on delete cascade on update cascade
);

create table if not exists pay_scale(
	eid int not null,
	sid int not null,
	primary key(eid, sid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(sid) references salary(sid) on delete cascade on update cascade
);

create table if not exists dependents(
	aadhar char(12) not null,
	eid int not null,
	name varchar(30) not null,
	address varchar(50) not null,
	age int not null check (age > 0 and age < 100),
	gender char(1) not null,
	relation varchar(10) not null,
	primary key(aadhar),
	foreign key(eid) references employee(eid) on delete cascade on update cascade
);

create table if not exists resignation(
	eid int not null,
	date date not null,
	reason varchar(100) default 'nil',
	w_e_f date,
	primary key(eid, date),
	foreign key(eid) references employee(eid) on delete cascade on update cascade
);

create table if not exists contracts(
	cid int not null auto_increment,
	contract varchar(100) not null,
	salary int not null,
	date_started date,
	end_date date,
	primary key(cid)
);

create table if not exists contract_based(
	eid int not null,
	cid int not null,
	primary key(eid, cid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(cid) references contracts(cid) on delete cascade on update cascade
);

create table if not exists leave_record(
	eid int not null,
	date date not null,
	type varchar(10),
	approved char(1) default 'n',
	primary key(eid, date),
	foreign key(eid) references employee(eid) on delete cascade on update cascade
);

create table if not exists charge_sheet(
	iid int not null auto_increment,
	decision varchar(100),
	appeal varchar(100),
	charges varchar(100),
	primary key(iid)
);

create table if not exists employee_charges(
	eid int not null,
	iid int not null,
	primary key(eid, iid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(iid) references charge_sheet(iid) on delete cascade on update cascade
);

create table if not exists orders(
	oid int not null auto_increment,
	quantity int not null check (quantity > 0),
	item varchar(20),
	date date,
	approved char(1) default 'n',
	primary key(oid)
);

create table if not exists orders_placed(
	eid int not null,
	oid int not null,
	primary key(eid, oid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(oid) references orders(oid) on delete cascade on update cascade
);

create table if not exists promotion(
	eid int not null,
	lower_pid int not null,
	lower_uid int not null,
	higher_pid int not null,
	higher_uid int not null,
	relieving_date date,
	joining_date date,
	primary key(eid, lower_pid, lower_uid, higher_pid, higher_uid),
	foreign key(eid) references employee(eid) on delete cascade on update cascade,
	foreign key(lower_pid, lower_uid) references post(pid, uid) on delete restrict on update cascade,
	foreign key(higher_pid, higher_uid) references post(pid, uid) on delete restrict on update cascade
);

create table if not exists demotion(
	iid int not null,
	higher_pid int not null,
	higher_uid int not null,
	lower_pid int not null,
	lower_uid int not null,
	relieving_date date,
	joining_date date,
	primary key(iid, higher_pid, higher_uid, lower_pid, lower_uid),
	foreign key(iid) references charge_sheet(iid) on delete restrict on update cascade,
	foreign key(lower_pid, lower_uid) references post(pid, uid) on delete restrict on update cascade,
	foreign key(higher_pid, higher_uid) references post(pid, uid) on delete restrict on update cascade
);

create table if not exists initial_pay_scale(
	pid int not null,
	uid int not null,
	sid int not null,
	primary key(pid, uid, sid),
	foreign key(pid, uid) references post(pid, uid) on delete cascade on update cascade,
	foreign key(sid) references salary(sid) on delete cascade on update cascade
);

create table if not exists rates(
	date date not null,
	da_rate int not null,
	a_hra int not null,
	b_hra int not null,
	c_hra int not null,
	ma int not null,
	income_tax varchar(100) not null,
	interest_rate int not null,
	provident_fund int not null,
	gis int not null,
	primary key(date)
);

create table if not exists contract_payment(
	account_no varchar(11) not null,
	ifsc char(11) not null,
	date date not null,
	cid int not null,
	deductions int default 0,
	primary key(account_no, ifsc, date),
	foreign key(account_no, ifsc) references employee_account(account_no, ifsc) on delete restrict on update cascade,
	foreign key(cid) references contracts(cid) on delete restrict on update restrict
);
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: hrms
-- ------------------------------------------------------
-- Server version	5.7.17-log

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
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (1,'管理员');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can add user',2,'add_user'),(5,'Can change user',2,'change_user'),(6,'Can delete user',2,'delete_user'),(7,'Can add group',3,'add_group'),(8,'Can change group',3,'change_group'),(9,'Can delete group',3,'delete_group'),(10,'Can add permission',4,'add_permission'),(11,'Can change permission',4,'change_permission'),(12,'Can delete permission',4,'delete_permission'),(13,'Can add content type',5,'add_contenttype'),(14,'Can change content type',5,'change_contenttype'),(15,'Can delete content type',5,'delete_contenttype'),(16,'Can add session',6,'add_session'),(17,'Can change session',6,'change_session'),(18,'Can delete session',6,'delete_session');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$100000$D8ujunOaphfS$Nf4VAAI4P01U8E7u5dx/sGc/Z+gQuI7avcwfD1tc1YY=','2018-06-26 08:58:48.887308',1,'cxx','c','xx','921656591@qq.com',1,1,'2018-01-05 12:49:07.000000'),(2,'pbkdf2_sha256$100000$IFpPDFNAECRw$+wMZnXjOOerTiXWLqqdsLsmvSnjQ1I3Urum1kf0WayY=','2018-01-19 12:58:50.989028',0,'zhangli','','','',0,1,'2018-01-05 12:54:07.000000');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (1,1,1);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `charge_sheet`
--

LOCK TABLES `charge_sheet` WRITE;
/*!40000 ALTER TABLE `charge_sheet` DISABLE KEYS */;
/*!40000 ALTER TABLE `charge_sheet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `contract_based`
--

LOCK TABLES `contract_based` WRITE;
/*!40000 ALTER TABLE `contract_based` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_based` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `contract_payment`
--

LOCK TABLES `contract_payment` WRITE;
/*!40000 ALTER TABLE `contract_payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `demotion`
--

LOCK TABLES `demotion` WRITE;
/*!40000 ALTER TABLE `demotion` DISABLE KEYS */;
/*!40000 ALTER TABLE `demotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `dependents`
--

LOCK TABLES `dependents` WRITE;
/*!40000 ALTER TABLE `dependents` DISABLE KEYS */;
/*!40000 ALTER TABLE `dependents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2018-01-05 12:54:07.796586','2','zhangli',1,'[{\"added\": {}}]',2,1),(2,'2018-01-05 12:55:09.973592','2','zhangli',2,'[]',2,1),(3,'2018-01-05 13:34:17.115214','1','管理员',1,'[{\"added\": {}}]',3,1),(4,'2018-01-05 13:34:24.579270','1','管理员',2,'[]',3,1),(5,'2018-01-05 13:37:06.786950','1','cxx',2,'[{\"changed\": {\"fields\": [\"groups\"]}}]',2,1),(6,'2018-01-05 13:42:31.206952','1','cxx',2,'[{\"changed\": {\"fields\": [\"first_name\", \"last_name\"]}}]',2,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(4,'auth','permission'),(2,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2018-01-05 11:35:46.060594'),(2,'auth','0001_initial','2018-01-05 11:40:41.334166'),(3,'admin','0001_initial','2018-01-05 11:40:43.837685'),(4,'admin','0002_logentry_remove_auto_add','2018-01-05 11:40:43.908773'),(5,'contenttypes','0002_remove_content_type_name','2018-01-05 11:40:45.024085'),(6,'auth','0002_alter_permission_name_max_length','2018-01-05 11:40:45.852419'),(7,'auth','0003_alter_user_email_max_length','2018-01-05 11:40:46.839342'),(8,'auth','0004_alter_user_username_opts','2018-01-05 11:40:46.965429'),(9,'auth','0005_alter_user_last_login_null','2018-01-05 11:40:47.503624'),(10,'auth','0006_require_contenttypes_0002','2018-01-05 11:40:47.547915'),(11,'auth','0007_alter_validators_add_error_messages','2018-01-05 11:40:47.596183'),(12,'auth','0008_alter_user_username_max_length','2018-01-05 11:40:49.186387'),(13,'auth','0009_alter_user_last_name_max_length','2018-01-05 11:40:50.497197'),(14,'sessions','0001_initial','2018-01-05 11:40:51.200710');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('g1yndv3152fhif6urbdmeu9ihvmix9to','MDljNTM5MjIyYWJkZmQyNGZhY2Y4NDU4NjIzMDQ4YWQ5YzUxN2YzNDp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjEiLCJfYXV0aF91c2VyX2hhc2giOiI0YTFiMDgyMWI2ZTc5ODkzNDliNTJjYTk1MzhmMGRiYzU3ZTI0ZDg3In0=','2018-02-03 04:04:10.764635'),('p6gb7eqhzzsv2bd60m6eu2r9aifqq05z','NWQ3Mjc4ZWM4MTNlMjBiN2E2ZGVmMGIzNGI0YzMxYTJmMTAyYjQ1Yzp7fQ==','2018-02-02 12:58:50.894670'),('uxn6w312ohptlqqo76e4apnmij4j3bdr','NWQ3Mjc4ZWM4MTNlMjBiN2E2ZGVmMGIzNGI0YzMxYTJmMTAyYjQ1Yzp7fQ==','2018-01-19 13:03:04.971583'),('xo1s07sjv5g7ov6s8m1wq7tzzqpfhuhw','ZmUyNGMxOTYxYTU4NWE5MmI5ZjYwZDRhOGM2OGExNDQ1NTI0Y2FjNDp7Il9hdXRoX3VzZXJfaGFzaCI6IjRhMWIwODIxYjZlNzk4OTM0OWI1MmNhOTUzOGYwZGJjNTdlMjRkODciLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=','2018-07-10 08:58:48.971260'),('zoja0x99rslobmx3zfvh182rrsznch73','NWQ3Mjc4ZWM4MTNlMjBiN2E2ZGVmMGIzNGI0YzMxYTJmMTAyYjQ1Yzp7fQ==','2018-01-19 14:17:16.385565');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'cxx','shanghai',19,'f',NULL);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee_account`
--

LOCK TABLES `employee_account` WRITE;
/*!40000 ALTER TABLE `employee_account` DISABLE KEYS */;
INSERT INTO `employee_account` VALUES (1,'123456789','0');
/*!40000 ALTER TABLE `employee_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee_charges`
--

LOCK TABLES `employee_charges` WRITE;
/*!40000 ALTER TABLE `employee_charges` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_charges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee_loan`
--

LOCK TABLES `employee_loan` WRITE;
/*!40000 ALTER TABLE `employee_loan` DISABLE KEYS */;
INSERT INTO `employee_loan` VALUES (1,1);
/*!40000 ALTER TABLE `employee_loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee_login`
--

LOCK TABLES `employee_login` WRITE;
/*!40000 ALTER TABLE `employee_login` DISABLE KEYS */;
INSERT INTO `employee_login` VALUES (1,1);
/*!40000 ALTER TABLE `employee_login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee_phone`
--

LOCK TABLES `employee_phone` WRITE;
/*!40000 ALTER TABLE `employee_phone` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `employee_post`
--

LOCK TABLES `employee_post` WRITE;
/*!40000 ALTER TABLE `employee_post` DISABLE KEYS */;
INSERT INTO `employee_post` VALUES (1,1,1);
/*!40000 ALTER TABLE `employee_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `initial_pay_scale`
--

LOCK TABLES `initial_pay_scale` WRITE;
/*!40000 ALTER TABLE `initial_pay_scale` DISABLE KEYS */;
INSERT INTO `initial_pay_scale` VALUES (1,1,1),(1,2,2),(1,3,2),(2,1,3),(2,2,4),(2,3,4),(3,1,5),(4,1,5),(5,1,5),(3,2,6),(3,3,6),(4,2,6),(4,3,6),(5,2,6),(5,3,6),(6,1,7),(7,1,7),(8,1,7),(6,2,8),(6,3,8),(7,2,8),(7,3,8),(8,2,8),(8,3,8),(9,1,9),(9,2,10),(9,3,10),(10,1,11),(10,2,12),(10,3,12);
/*!40000 ALTER TABLE `initial_pay_scale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `leave_record`
--

LOCK TABLES `leave_record` WRITE;
/*!40000 ALTER TABLE `leave_record` DISABLE KEYS */;
INSERT INTO `leave_record` VALUES (1,'2018-01-30','Medical','Y'),(1,'2018-06-29','Casual','N');
/*!40000 ALTER TABLE `leave_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `loan`
--

LOCK TABLES `loan` WRITE;
/*!40000 ALTER TABLE `loan` DISABLE KEYS */;
INSERT INTO `loan` VALUES (1,1000,'2018-06-28',1,'Vehicle',0,'N',0);
/*!40000 ALTER TABLE `loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'abc','2018-01-19','Y'),(2,1,'computer','2018-06-28','N');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `orders_placed`
--

LOCK TABLES `orders_placed` WRITE;
/*!40000 ALTER TABLE `orders_placed` DISABLE KEYS */;
INSERT INTO `orders_placed` VALUES (1,1),(1,2);
/*!40000 ALTER TABLE `orders_placed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `pay_scale`
--

LOCK TABLES `pay_scale` WRITE;
/*!40000 ALTER TABLE `pay_scale` DISABLE KEYS */;
INSERT INTO `pay_scale` VALUES (1,1);
/*!40000 ALTER TABLE `pay_scale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES ('123456789','0',1,'2018-01-19',10),('123456789','0',1,'2018-05-19',10),('123456789','0',1,'2018-06-19',10);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `payment_loan`
--

LOCK TABLES `payment_loan` WRITE;
/*!40000 ALTER TABLE `payment_loan` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,1,'Executive Officer','Class A',1),(1,2,'Executive Officer','Class A',1),(1,3,'Executive Officer','Class A',1),(2,1,'Municipal Engineer','Class B',1),(2,2,'Municipal Engineer','Class B',1),(2,3,'Municipal Engineer','Class B',1),(3,1,'Secretary','Class C',1),(3,2,'Secretary','Class C',1),(3,3,'Secretary','Class C',1),(4,1,'Junior Engineer','Class C',1),(4,2,'Junior Engineer','Class C',1),(4,3,'Junior Engineer','Class C',1),(5,1,'Sanitary Inspector','Class C',1),(5,2,'Sanitary Inspector','Class C',1),(5,3,'Sanitary Inspector','Class C',1),(6,1,'Accountant','Class D',1),(6,2,'Accountant','Class D',1),(6,3,'Accountant','Class D',1),(7,1,'Superintendent','Class D',3),(7,2,'Superintendent','Class D',3),(7,3,'Superintendent','Class D',3),(8,1,'Assistant','Class D',4),(8,2,'Assistant','Class D',4),(8,3,'Assistant','Class D',4),(9,1,'Clerk','Class E',6),(9,2,'Clerk','Class E',6),(9,3,'Clerk','Class E',6),(10,1,'Peon','Class F',10),(10,2,'Peon','Class F',10),(10,3,'Peon','Class F',10);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `promotion`
--

LOCK TABLES `promotion` WRITE;
/*!40000 ALTER TABLE `promotion` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `rates`
--

LOCK TABLES `rates` WRITE;
/*!40000 ALTER TABLE `rates` DISABLE KEYS */;
INSERT INTO `rates` VALUES ('2017-10-14',5,30,20,10,500,'0:0+0:250000;250000:0+5:500000;500000:25000+20:1000000;1000000:125000+30:-1',9,10,10);
/*!40000 ALTER TABLE `rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `regularisation`
--

LOCK TABLES `regularisation` WRITE;
/*!40000 ALTER TABLE `regularisation` DISABLE KEYS */;
/*!40000 ALTER TABLE `regularisation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `resignation`
--

LOCK TABLES `resignation` WRITE;
/*!40000 ALTER TABLE `resignation` DISABLE KEYS */;
/*!40000 ALTER TABLE `resignation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `retirement`
--

LOCK TABLES `retirement` WRITE;
/*!40000 ALTER TABLE `retirement` DISABLE KEYS */;
/*!40000 ALTER TABLE `retirement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `salary`
--

LOCK TABLES `salary` WRITE;
/*!40000 ALTER TABLE `salary` DISABLE KEYS */;
INSERT INTO `salary` VALUES (1,39100,5400),(2,15600,5400),(3,34800,5400),(4,9300,5400),(5,34800,4600),(6,9300,4600),(7,34800,4200),(8,9300,4200),(9,20200,1800),(10,5200,1800),(11,7440,1300),(12,4440,1300);
/*!40000 ALTER TABLE `salary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `ulb`
--

LOCK TABLES `ulb` WRITE;
/*!40000 ALTER TABLE `ulb` DISABLE KEYS */;
INSERT INTO `ulb` VALUES (1,'Tongji CS Company','Corporation'),(2,'Tongji EE Company','Corporation'),(3,'Tongji A&D Company','Corporation');
/*!40000 ALTER TABLE `ulb` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-28 21:08:14
