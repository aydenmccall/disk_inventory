/***************************************************
-- Date			Programmer		Description
--
-- 3/4/2022		Ayden McCall	Initialization
-- 3/10/2022	Ayden McCall	Added Insertion Values to most tables
-- 3/11/2022	Ayden McCall	Finished Insertion Values
-- 3/16/2022	Ayden McCall	Changed diskType's 'type_name' to 'typeName'
									Changed dateTime displays to date only displays -- Done through CAST()
--									Added Select Statements to bottom of file, identify commonly used data
									VIEW ViewBorrowerNoLoans added
	3/28/2022	AydenMcCall		Added common Procedures to diskBorrowerLog Along with displayError Procedure
--
****************************************************/

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

-- CREATING TABLES

CREATE TABLE genre (
	genreID INT NOT NULL IDENTITY PRIMARY KEY,
	genreName VARCHAR(25) NOT NULL
)

CREATE TABLE diskType (
	diskTypeID INT NOT NULL IDENTITY PRIMARY KEY,
	typeName VARCHAR(25) NOT NULL
)

CREATE TABLE status (
	statusID INT NOT NULL IDENTITY PRIMARY KEY,
	description VARCHAR(25) NOT NULL
)

CREATE TABLE borrower (
	borrowerID INT NOT NULL IDENTITY PRIMARY KEY,
	firstName NVARCHAR(60),
	lastName NVARCHAR(60),
	phoneNum VARCHAR(20)
)

CREATE TABLE disk (
	diskID INT NOT NULL IDENTITY PRIMARY KEY,
	diskName CHAR(55) NOT NULL,
	releaseDate DATE NOT NULL,
	statusID INT NOT NULL REFERENCES status(statusID),
	genreID INT NOT NULL REFERENCES genre(genreID),
	diskTypeID INT NOT NULL REFERENCES diskType(diskTypeID)
)

CREATE TABLE diskBorrowLog (
	diskLogID INT NOT NULL IDENTITY PRIMARY KEY,
	diskID INT NOT NULL REFERENCES disk(diskID),
	borrowerID INT NOT NULL REFERENCES borrower(borrowerID),
	borrowedDate DATETIME2 NOT NULL,
	returnedDate DATETIME2 NULL
);

-- DATA INSERTION --

INSERT INTO genre 
VALUES('Rock')
INSERT INTO genre 
VALUES('Classical')
INSERT INTO genre 
VALUES('Jazz')
INSERT INTO genre 
VALUES('Funk')
INSERT INTO genre 
VALUES('Death Metal')
INSERT INTO genre 
VALUES('Country')
INSERT INTO genre 
VALUES('Orchestral')



INSERT INTO diskType 
VALUES('CD')
INSERT INTO diskType 
VALUES('Cassete')
INSERT INTO diskType  
VALUES('Vinyl')
INSERT INTO diskType 
VALUES('DVD')
INSERT INTO diskType 
VALUES('8Track')

INSERT INTO status
VALUES('Available')
INSERT INTO status 
VALUES('On loan')
INSERT INTO status 
VALUES('Damaged')
INSERT INTO status
VALUES('Missing')
INSERT INTO status 
VALUES('Unavaliable')

INSERT INTO borrower
	(firstName, lastName, PhoneNum)
VALUES
	('Beatrice', 'Ushiromiya', '(208) 301-4311'),

	('Leon', 'Gram', '(208) 731-2202'),

	('Rashid', 'Ubit', '(208) 002-6117'),

	('Vienna', 'Curt', '(208) 173-5555'),

	('Everet', 'Hanson', '(208) 329-2197'),

	('Quinn', 'Zorro', '(208) 101-0023'),

	('Xerath', 'Vue', '(208) 523-2323'),

	('Azir', 'Ren', '(208) 133-3112'),

	('Junko', 'Turtle', '(208) 111-5541'),

	('Benny', 'Boy', '(208) 172-0017'),

	('Akira', 'Hoshiguma', '(208) 912-5357'),

	('Mickey', 'Mouse', '(208) 921-7547'),

	('Minny', 'Mouse', '(208) 613-5613'),

	('Renata', 'Sanchez', '(208) 909-0122'),

	('Vincent', 'Mozart', '(208) 773-1417'),

	('Renald', 'Trishton', '(208) 121-5111'),

	('Ymir', 'Forn', '(208) 981-6671'),

	('Rudolf', 'Rein', '(208) 153-9912'),

	('Axl', 'Low', '(208) 121-5547'),

	('Millia', 'Ino', '(208) 121-5547'),

	('Millicent', 'Mirade', '(208) 321-5547');

DELETE FROM borrower WHERE borrowerID = 21;

INSERT INTO disk 
(diskName, releaseDate, statusID, genreID, diskTypeID)
VALUES
	('Crazy Train', '2/2/1997', 1, 2, 1),
	
	('Sketch no.19', '7/24/2018', 2, 3, 1),

	('Talk Is Cheap', '1/12/2015', 1, 4, 4),

	('Moonlight Arpegio', '3/28/2011', 3, 2, 3),

	('Choke on the Smoke', '7/24/2000', 2, 2, 2),

	('Give Heaven Some Hell', '7/24/2005', 5, 4, 5),
	
	('Don''t Make me Change', '7/24/2011', 1, 3, 1),

	('The Hole', '7/24/2019', 3, 3, 1),
	
	('Walkin', '7/24/2018', 3, 2, 2),
	
	('Off The Wall', '7/24/2008', 4, 5, 5),
	
	('When The Weak Go Marching In', '7/24/2010', 5, 5, 4),
	
	('Find Love', '11/9/2016', 1, 4, 2),
	
	('Midnight Train', '9/24/1999', 2, 2, 3),
	
	('My Summer Vacation', '1/20/1978', 5, 1, 1),
	
	('You Should Probably Leave', '7/21/2001', 4, 1, 1),
	
	('Family Ties', '2/4/2021', 2, 1, 2),
	
	('Cinnamon', '1/27/2018', 1, 2, 5),
	
	('Happiness of a Marionette', '5/14/2018', 2, 3, 5),
	
	('Dead Angle', '7/24/2018', 2, 3, 1),
	
	('She Swallowed Burning Coals', '7/24/2018', 2, 3, 1),
	
	('The Days When My Mother Was There', '7/24/2018', 2, 3, 1);

	UPDATE disk
	SET	diskName = 'Dirty Deeds Done Dirt Cheap'
	WHERE diskName = 'Crazy Train';

INSERT INTO diskBorrowLog
	(diskID, borrowerID, borrowedDate, returnedDate)
VALUES
	(1, 1, '1/15/2013', '2/2/2013'),

	(1, 5, '3/20/2014', '4/9/2014'),
	
	(2, 13, '4/10/2019', '5/16/2019'),

	(9, 1, '10/1/2019', '11/27/2019'),

	(8, 19, '11/13/2019', '12/17/2019'),

	(17, 13, '12/3/2018', '1/2/2019'),

	(3, 16, '4/19/2019', '6/19/2019'),

	(7, 16, '2/15/2019', '3/13/2019'),

	(1, 10, '7/2/2015', '8/22/2015'),

	(4, 12, '7/15/2011', '9/9/2011');

	
INSERT INTO diskBorrowLog
	(diskID, borrowerID, borrowedDate, returnedDate)
	VALUES
	(6, 10, '1/5/2013', '2/1/2013'),

	(1, 1, '2/25/2017', '4/1/2017'),

	(7, 9, '6/30/2019', '10/4/2019'),

	(18, 14, '9/21/2019', '11/5/2019'),

	(11, 15, '1/15/2018', '4/13/2018'),

	(3, 4, '6/15/2021', '7/13/2021'),

	(9, 8, '4/30/2019', '8/5/2019'),

	(1, 7, '5/13/2019', '8/2/2019'),

	(2, 11, '11/15/2018', '1/9/2019'),

	(15, 4, '9/11/2015', '12/12/2015');

	INSERT INTO diskBorrowLog

		(diskID, borrowerID, borrowedDate)
	VALUES
	(5, 1, '3/9/2022'),

	(15, 4, '11/21/2015'),

	(3, 11, '1/16/2013');

	-- LIST UN-RETURNED DISKS AND THEIR borrowers --
	SELECT diskName, diskBorrowLog.diskID, borrower.firstName + ' ' + borrower.lastName as borrower, diskBorrowLog.borrowerID, CAST(borrowedDate as date) as BorrowDate, 
		'Unreturned' as 'Return Date'
	FROM diskBorrowLog 
	JOIN borrower
		ON diskBorrowLog.borrowerID = borrower.borrowerID
	JOIN disk 
		ON disk.diskID = diskBorrowLog.diskID
	WHERE returnedDate IS NULL
	ORDER BY borrowedDate ASC;

	/* -- FIND UNUSED BORROWERS --
		SELECT borrower.borrowerID as 'unused borrowerID'
		FROM borrower 
		LEFT JOIN diskBorrowLog
			ON borrower.borrowerID = diskBorrowLog.borrowerID
		WHERE diskBorrowLog.borrowerID IS NULL; 

		-- FIND UNUSED DISKS --
		SELECT disk.diskID as 'unused diskID'
		FROM disk
		LEFT JOIN diskBorrowLog
			ON disk.diskID = diskBorrowLog.diskID
		WHERE diskBorrowLog.diskID IS NULL
		ORDER BY disk.diskID;

		-- FIND MULTI-USED BORROWERS --
		SELECT borrowerID, COUNT(borrowerID) as 'uses'
		FROM diskBorrowLog 
		GROUP BY borrowerID
			HAVING count(borrowerID) > 1
		ORDER BY borrowerID;

	 -- FIND MULTI-USED DISKS --
		SELECT diskID, COUNT(diskID) as 'uses'
		FROM diskBorrowLog 
		GROUP BY diskID
			HAVING count(diskID) > 1
		ORDER BY diskID;
	*/

	-- SHOW ALL DISKS, TYPE, and STATUS
	SELECT diskName, releaseDate, genreName, diskType.typeName, status.description 
	FROM disk, diskType, status, genre
	WHERE disk.diskTypeID = diskType.diskTypeID 
		AND status.statusID = disk.statusID 
		AND genre.genreID = disk.genreID
	ORDER BY diskName, description, genreName, releaseDate

	-- SHOW ALL BORROWED DISKS
	SELECT lastName, firstName, diskName, CAST(borrowedDate as date) as BorrowDate, CAST(ReturnedDate as date) as ReturnDate
		-- IIF(returnedDate IS NULL, CAST(ReturnedDate as date), 'Unreturned') as ReturnDate	/**** Cast Malfunctions inside Conditional Operands? ****/
	FROM borrower, diskBorrowLog log, disk
	WHERE borrower.borrowerID = log.borrowerID 
		AND disk.diskID = log.diskID
	ORDER BY lastName, firstName, diskName, borrowedDate, ReturnedDate;

	-- SHOW DISKS BORROWED MORE THAN ONCE
	SELECT diskName, COUNT(log.diskID) as 'uses'
	FROM diskBorrowLog log, disk
	WHERE disk.diskID = log.diskID
	GROUP BY diskName
		HAVING count(log.diskID) > 1
	ORDER BY count(log.diskID) DESC, diskName;

	-- SHOW DISK ON LOAN
	SELECT diskName, Cast(borrowedDate as date) as BorrowDate, 'Unreturned' as ReturnDate, LastName, FirstName 
	FROM disk, borrower, diskBorrowLog log
	WHERE disk.diskID = log.diskID 
		AND borrower.borrowerID = log.borrowerID 
		AND log.returnedDate IS NULL
	ORDER BY borrowedDate, diskName, LastName, FirstName;
	go
	-- CREATE VIEW SHOWING BORROWERS WHO HAVE NOT BORROWED 
	CREATE VIEW ViewBorrowerNoLoans 
	as
	SELECT borrowerID, lastName, firstName 
	FROM borrower b
	WHERE NOT EXISTS (
		SELECT 1 
		FROM diskBorrowLog log
		WHERE log.borrowerID = b.borrowerID
		)
	go
	-- Display borrowers without borrow record
	SELECT lastName, firstName
	FROM ViewBorrowerNoLoans 
	ORDER BY lastName;

	-- Show borrowers with borrow records > 1
	SELECT lastName, firstName, COUNT(log.borrowerID) as 'Disks Borrowed'
		FROM diskBorrowLog log, borrower 
		WHERE borrower.borrowerID = log.borrowerID
		GROUP BY lastName, firstName
			HAVING count(log.borrowerID) > 1
		ORDER BY COUNT(log.borrowerID) DESC, lastName, firstName

		USE disk_inventoryAM;
go

drop proc if exists DisplayError;
go
create proc DisplayError 
	@errorMessage varchar(255)
AS
	PRINT @errorMessage;
go

drop proc if exists InsertLog;
go

create proc InsertLog 
	@diskID int,
	@borrowerID int,
	@borrowedDate date,
	@returnedDate date = null
AS
	BEGIN TRY
		INSERT INTO diskBorrowLog
			(diskID, borrowerID, borrowedDate, returnedDate)
		VALUES
			(@diskID, @borrowerID, @borrowedDate, @returnedDate);
	END TRY
	BEGIN CATCH
		execute DisplayError 'Error inserting record, please try again.';
	END CATCH
go

InsertLog 3, 2, '3/28/2022';
EXECUTE InsertLog 300, 2, '3/28/2025'; -- THROWS ERROR

drop proc if exists sp_upd_diskBorrowLog;
go
create proc sp_upd_diskBorrowLog
	@logID int,
	@diskID int,
	@borrowerID int,
	@borrowedDate date,
	@returnedDate date = null
AS
	BEGIN TRY
		UPDATE diskBorrowLog 
		SET diskID = @diskID, borrowerID = @borrowerID, borrowedDate = @borrowedDate, returnedDate = @returnedDate
		WHERE diskLogID = @logID;
	END TRY
	BEGIN CATCH
		execute DisplayError 'Error updating record, please try again.';
	END CATCH
go

GRANT EXEC ON sp_upd_diskBorrowLog TO diskUseram;
go

declare @id int = 13;
execute sp_upd_diskBorrowLog @id, 11, 11, '3/26/2022', '3/28/2022';
execute sp_upd_diskBorrowLog @id, 0, -9999, '3/26/2022', '3/28/2022'; -- THROWS ERROR