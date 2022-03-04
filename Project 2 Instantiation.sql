/***************************************************/
-- Date			Programmer		Description
--
-- 3/4/2022		Ayden McCall	Initialization
--
/****************************************************/

USE master;
go
DROP DATABASE IF EXISTS disk_inventoryAM;
go
CREATE DATABASE disk_inventoryAM;
go
IF SUSER_ID('diskUserAM') IS NULL
	CREATE LOGIN diskUserAM
	WITH PASSWORD = 'Pa$$w0rd', DEFAULT_DATABASE = disk_inventoryAM;
go

use disk_inventoryAM; -- SWITH FROM MASTER TO DISK_INVENTORY
go
IF USER_ID('diskUserAM') IS NULL
	CREATE USER diskUserAM;
go
-- GRANT READ-ONLY TO USER
ALTER ROLE db_datareader 
	ADD MEMBER diskUserAM;
go



CREATE TABLE genre (
	genre_id INT NOT NULL IDENTITY PRIMARY KEY,
	genre_name VARCHAR(25) NOT NULL
)

CREATE TABLE disk_type (
	disk_type_id INT NOT NULL IDENTITY PRIMARY KEY,
	type_name VARCHAR(25) NOT NULL
)

CREATE TABLE status (
	status_id INT NOT NULL IDENTITY PRIMARY KEY,
	description VARCHAR(25) NOT NULL
)

CREATE TABLE borrower (
	borrower_id INT NOT NULL IDENTITY PRIMARY KEY,
	first_name NVARCHAR(60),
	last_name NVARCHAR(60),
	borrower_phone VARCHAR(20)
)

CREATE TABLE disk (
	disk_id INT NOT NULL IDENTITY PRIMARY KEY,
	disk_name CHAR(25) NOT NULL,
	release_date DATE NOT NULL,
	status_id INT NOT NULL REFERENCES status(status_id),
	genre_id INT NOT NULL REFERENCES genre(genre_id),
	disk_type_id INT NOT NULL REFERENCES disk_type(disk_type_id)
)

CREATE TABLE disk_borrow_log (
	disk_borrow_log_id INT NOT NULL IDENTITY PRIMARY KEY,
	disk_id INT NOT NULL REFERENCES disk(disk_id),
	borrower INT NOT NULL REFERENCES borrower(borrower_id),
	borrowed_date DATETIME2 NOT NULL,
	returned_date DATETIME2 NULL
);
