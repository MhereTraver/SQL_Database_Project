USE MASTER;
GO
CREATE DATABASE INVENTORYDB1
ON PRIMARY
(
   NAME='INVENTORYDB1File1',
   FILENAME='C:\SQLDATA\INVENTORYDB1File1.mdf',
   SIZE=100MB,
   MAXSIZE=10000MB,
   FILEGROWTH=20%
)
LOG ON
(
   NAME='INVENTORYDB1LOG1',
   FILENAME='C:\SQLLOG\INVENTORYDB1LOG1.ldf',
   SIZE=50MB,
   MAXSIZE=500MB,
   FILEGROWTH=10%
)
GO
--CREATING A SECONDARY FILE
USE master;
GO
ALTER DATABASE INVENTORYDB1
ADD FILEGROUP SECONDARY
ALTER DATABASE INVENTORYDB1
ADD FILE
(
   NAME='INVENTORYDB1FILEGROUP1',
   FILENAME='C:\SQLDATA\INVENTORYDB1FILEGROUP1.ndf',
   SIZE=40MB,
   MAXSIZE=200MB,
   FILEGROWTH=20%
)
TO FILEGROUP SECONDARY
GO

--CREATE LOGIN 
USE INVENTORYDB1;
GO
CREATE LOGIN TraverMhere 
WITH PASSWORD = 'LetsGetThisBread$';
GO

--(1) CREATE MASTER KEY
CREATE MASTER KEY
ENCRYPTION BY PASSWORD ='LetsGetThisBread$';
GO

--(2) CREATE CERTIFICATE
CREATE CERTIFICATE OwnerEntry
WITH SUBJECT = 'Entry check1'; 
GO 

--(3) CREATE SYMMETRIC KEY
CREATE SYMMETRIC KEY Symmetric1
WITH ALGORITHM = AES_256 
ENCRYPTION BY CERTIFICATE OwnerEntry; 
GO


---CREATING TABLES

USE INVENTORYDB1;
GO
CREATE TABLE Brand
(
  BrandID INT IDENTITY (00001,1) NOT NULL,
  BrandName VARCHAR(50)NOT NULL,
);

CREATE TABLE InventoryUser
(
  InventoryUserID INT IDENTITY (100,1),
  InventoryUserName VARCHAR (50) NOT NULL,
  InventoryUserPassword VARCHAR(25) NOT NULL,
  LastLogin TIMESTAMP,
  UserType VARCHAR(25),
  BrandID INT
);

CREATE TABLE Categories
(
  CategoryID INT IDENTITY(1,1),
  CategoryName VARCHAR(50) NOT NULL,
  CategoryDescription TEXT,
  CategoryPicture IMAGE,

);

CREATE TABLE Products
(
  ProductID INT IDENTITY (1,1), 
  ProductName VARCHAR(50) NOT NULL,
  ProductStockNumber VARCHAR(25) NOT NULL,
  PriceNumber VARCHAR(25) NOT NULL,
  AddedDate DATE,
  CategoryID INT,
  BrandID INT
);

CREATE TABLE Stores
(
   StoreID INT IDENTITY (1,1),
   StoreName VARCHAR(25) NOT NULL,
   StoreAddress VARCHAR(100) NOT NULL,
   StoreCity VARCHAR(50) NOT NULL,
   StoreRegion VARCHAR(25) NOT NULL,
   StorePostalCode VARCHAR(25),
   StoreCountry NVARCHAR(15) NOT NULL,
   StorePhone NVARCHAR(15)DEFAULT NULL,
   StoreEmail NVARCHAR(25),
   Fax NVARCHAR(15)
);

CREATE TABLE CustomerCart
(
  CustomerID INT IDENTITY (1,1),
  CustomerName VARCHAR(25) NOT NULL,
  CustomerMobleNumber VARCHAR(15) DEFAULT NULL,
  CustomerAddress  VARCHAR(70) NULL,
  CustomerCity VARCHAR(25)NULL,
  CustomerRegion VARCHAR(25)NULL,
  CustomerPostalCode NVARCHAR(25)NULL,
  CustomerFax NVARCHAR(25)NULL,
  CustomerEmail  VARCHAR(25)NULL,
);

CREATE TABLE Provides
(
   ProvidesID INT IDENTITY (1,1),
   BrandID INT,
   StoreID INT,
   DiscountNumber VARCHAR(25),
);

CREATE TABLE SelectPoduct
( 
  SelectPoductID INT IDENTITY(1,1),
  CustomerID INT,
   ProductID INT,
   QuantityNumber VARCHAR(50),
);

CREATE TABLE  Transactions 
(
   TransactionID INT IDENTITY (1,1),
   TotalAmountNumber VARCHAR(50),
   PaidNumber VARCHAR(50),
   DueNumber VARCHAR(50),
   GuestNumber VARCHAR(25),
   PaymentMethod VARCHAR(25),
   CustomerID INT,

);

CREATE TABLE Invoice
(
   InvoiceID INT IDENTITY (1,1),
   ProductName VARCHAR(50) NOT NULL,
   QuantityNumber VARCHAR(50),
   NetPriceNumber VARCHAR(25),
   TransactionID INT,
);
GO

--CREATING CONSTRAINTS
--PRIMARYKEY(1)
ALTER TABLE Brand
ADD CONSTRAINT PK_Brand
PRIMARY KEY(BrandID);
GO
--PRIMARYKEY(2)
ALTER TABLE Invoice
ADD CONSTRAINT PK_Invoice
PRIMARY KEY(InvoiceID);
GO
--PRIMARYKEY(3)
ALTER TABLE Transactions
ADD CONSTRAINT PK_Transaction
PRIMARY KEY(TransactionID);
GO
--PRIMARYKEY(4)
ALTER TABLE Products
ADD CONSTRAINT PK_ProductID
PRIMARY KEY(ProductID);
GO
--PRIMARYKEY(5)
ALTER TABLE Stores
ADD CONSTRAINT PK_StoreID
PRIMARY KEY(StoreID);
GO
--PRIMARYKEY(6)
ALTER TABLE Categories
ADD CONSTRAINT PK_CategoriesID
PRIMARY KEY(CategoryID);
GO
--PRIMARYKEY(7)
ALTER TABLE CustomerCart
ADD CONSTRAINT PK_CustomerID
PRIMARY KEY(CustomerID);
GO
--PRIMARYKEY(8)
ALTER TABLE Provides
ADD CONSTRAINT PK_Provides
PRIMARY KEY(ProvidesID);
GO
--PRIMARYKEY(9)
ALTER TABLE SelectProduct
ADD CONSTRAINT PK_SelectProductID
PRIMARY KEY(SelectProductID);
GO

--FOREIGN KEY(10)
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Brand
FOREIGN KEY(BrandID)References Brand(BrandID);
GO

--FOREIGN KEY(11)
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY(CategoryID)References Categories(CategoryID);
GO

--FOREIGN KEY(12)
ALTER TABLE SelectProducts
ADD CONSTRAINT FK_SelectProducts_CustomerID
FOREIGN KEY(CustomerID)References CustomerCart(CustomerID);
GO

--FOREIGN KEY(13)
ALTER TABLE SelectProducts
ADD CONSTRAINT FK_SelectProducts_ProductID
FOREIGN KEY(ProductID)References Products(ProductID);
GO
--FOREIGN KEY(14)
ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_CustomerID
FOREIGN KEY(CustomerID)References CustomerCart(CustomerID);
GO
--FOREIGN KEY(15)
ALTER TABLE Invoice
ADD CONSTRAINT FK_Invoice_TransactionID
FOREIGN KEY(TransactionID)References Transactions(TransactionID);
GO

--FOREIGN KEY(16)
ALTER TABLE Provides
ADD CONSTRAINT FK_Provides_BrandID
FOREIGN KEY(BrandID)References Brand(BrandID);
GO

--FOREIGN KEY(17)
ALTER TABLE Provides
ADD CONSTRAINT FK_Provides_StoreID
FOREIGN KEY(StoreID)References Stores(StoreID);
GO

--FOREIGN KEY(18)
ALTER TABLE InventoryUser
ADD CONSTRAINT FK_PInventoryUser_BrandID
FOREIGN KEY(BrandID)References Brand(BrandID);
GO

--FOREIGN KEY(19)
ALTER TABLE SelectProducts
ADD CONSTRAINT FK_SelectProducts_CustomerID
FOREIGN KEY(CustomerID)References CustomerCart(CustomerID);
GO
--FOREIGN KEY(20)
ALTER TABLE SelectProducts
ADD CONSTRAINT FK_SelectProducts_ProductsID
FOREIGN KEY(ProductsID)References Products(ProductsID);
GO

--CREATING INDEXES
-- NONClUSTERED INDEX(1)
USE INVENTORYDB1;
GO
CREATE NONCLUSTERED INDEX IX_CustomerName
ON CustomerCart
(CustomerName)
GO
--NON CLUSTERED INDEX (2)
USE INVENTORYDB1;
GO
CREATE NONCLUSTERED INDEX IX_BrandName
ON Brand
(BrandName)
GO
-- CLUSTERED INDEX (3)
USE INVENTORYDB1;
GO
CREATE NONCLUSTERED INDEX IX_Provides
ON Provides
(ProvidesID)
GO
--NON CLUSTERED INDEX COMPOSITE KEY (4)
USE INVENTORYDB1;
GO
CREATE NONCLUSTERED INDEX IX_InvoiceID
ON Invoice
(ProductName,QuantityNumber)
GO


--CREATING TRIGGERS
--Trigger (1)
USE INVENTORYDB1;
GO
CREATE TRIGGER BrandIntegrity
ON Brand AFTER INSERT, UPDATE
AS
IF UPDATE (BrandID)
BEGIN
IF(SELECT Brand.BrandID
  FROM Brand,INSERTED
  WHERE Brand.BrandID =INSERTED.BrandID ) IS NULL
  BEGIN
       ROLLBACK TRANSACTION
	   PRINT 'NO INSERTION/MODIFICATION OF THE ROW'
  END
  ELSE PRINT 'THE ROW INSERTED/MODIFIED'
  END
GO

--Trigger (2)
USE INVENTORYDB1;
GO
CREATE TRIGGER InventoryIntegrity
ON InventoryUser AFTER INSERT, UPDATE
AS
IF UPDATE (InventoryUserID)
BEGIN
IF(SELECT InventoryUser.InventoryUserID
  FROM InventoryUser,INSERTED
  WHERE InventoryUser.InventoryUserID =INSERTED.InventoryUserID ) IS NULL
  BEGIN
       ROLLBACK TRANSACTION
	   PRINT 'NO INSERTION/MODIFICATION OF THE ROW'
  END
  ELSE PRINT 'THE ROW INSERTED/MODIFIED'
  END
GO

--Trigger (3)
USE INVENTORYDB1;
GO
CREATE TRIGGER CategoriesIntgrity
ON Categories AFTER INSERT, UPDATE
AS
IF UPDATE (CategoryID)
BEGIN
IF(SELECT Categories.CategoryID
  FROM Categories,INSERTED
  WHERE Categories.CategoryID =INSERTED.CategoryID ) IS NULL
  BEGIN
       ROLLBACK TRANSACTION
	   PRINT 'NO INSERTION/MODIFICATION OF THE ROW'
  END
  ELSE PRINT 'THE ROW INSERTED/MODIFIED'
  END
GO

--Trigger (4)
USE INVENTORYDB1;
GO
CREATE TRIGGER BrandUpdate
ON Brand AFTER DELETE, UPDATE
AS
IF UPDATE (BrandID)
BEGIN
IF(SELECT COUNT(*)
  FROM Brand,DELETED
  WHERE Brand.BrandID =DELETED.BrandID) IS NULL
  BEGIN
       ROLLBACK TRANSACTION
	   PRINT 'NO DELETION/MODIFICATION OF THE ROW'
  END
  ELSE PRINT 'THE ROW IS DELETED/MODIFIED'
  END
GO

--TRIGGER SEQUENCE ORDERING
 EXECUTE sp_settriggerorder
 @TRIGGERNAME='BrandUpdate',
 @order ='first',
 @stmttype='update'
GO
USE INVENTORYDB1;
GO
--INSERTING DATA INTO TABLES
--INSERTING (1)
INSERT INTO BRAND 
       VALUES('Apple')
GO
INSERT INTO BRAND 
       VALUES('Samsung')
GO
INSERT INTO BRAND 
       VALUES('Huawei')
GO
INSERT INTO BRAND 
       VALUES('Sony')
GO
INSERT INTO BRAND 
       VALUES('Itel')
GO
INSERT INTO BRAND 
       VALUES('Puma')
GO
INSERT INTO BRAND 
       VALUES('Nike')
GO
INSERT INTO BRAND 
       VALUES('Adidas')
GO
INSERT INTO BRAND 
       VALUES('Telefunken')
GO
INSERT INTO BRAND 
       VALUES('Ecoh')
GO

--INSERTING (2)
INSERT INTO Categories
VALUES('Electronics','Usage on Electrical Power, a must have','NULL')
GO
INSERT INTO Categories
VALUES('Clothing','For Smart People, keeping up with fashion','NULL')
GO
INSERT INTO Categories
VALUES('Grocey','The underneath your mouth programme','NULL')
GO
INSERT INTO Categories
VALUES('Shoes','The Smart introduction','NULL')
GO
INSERT INTO Categories
VALUES('Hardrives','Storage disticts','NULL')
GO
INSERT INTO Categories
VALUES('Fridges','Cooling the Universe','NULL')
GO
INSERT INTO Categories
VALUES('Routers','Connecting the network the unique way','NULL')
GO
INSERT INTO Categories
VALUES('Switches','Network conjuction Tech gurus','NULL')
GO
--INSERTING (3)
INSERT INTO Stores
VALUES('Drogo','SuperSaints','Harare','SADC',0891,'ZIM','0789865641','Drogo@master.com','6758998900')
GO
INSERT INTO Stores
VALUES('Jetskie','Waverley','Pretoria','SADC',0182,'SA','07854345677','Jetskie@master.com','65476777')
GO
INSERT INTO Stores
VALUES('Compact','Gezina','Pretoria','SADC',0121,'LA','+45678883738','Compact@master.com','675899484755')
GO
INSERT INTO Stores
VALUES('Internet','Pta Central','Limpopo','Limpopo South',0986,'SA','5678907654','Internet@master.com','675899484755')
GO
INSERT INTO Stores
VALUES('ClothZee','Shangai North','Southly Side','China',0012,'CH','5611112334','ClothZee@master.com','5434345657')
GO
INSERT INTO Stores
VALUES('Connector','Codonia','Gezina','Gauteng',0186,'GP','6789809987','Connector@master.com','0980760895')
GO
INSERT INTO Stores
VALUES('JeeThrone','Mbare','Harare','Zim',0012,'ZW','454645678990','JeeThrone@master.com','5434345657')
GO

--INSERTING (4)
INSERT INTO Products
VALUES('Iphone X',100,'R15000','12-03-2022',1,1)
GO
INSERT INTO Products
VALUES('Preditor',101,'R3000','12-03-2022',2,2)
GO
INSERT INTO Products
VALUES('SmartWart',102,'R4000','12-03-2022',3,2)
GO
INSERT INTO Products
VALUES('Laptop',103,'R12000','13-03-2022',4,2)
GO
INSERT INTO Products
VALUES('SubHoofer',104,'R17000','13-03-2022',5,2)
GO
INSERT INTO Products
VALUES('Smart HD TV',105,'R25000','13-03-2022',6,2)
GO
INSERT INTO Products
VALUES('Shoes',106,'R2000','13-03-2022',7,2)
GO
INSERT INTO Products
VALUES('Cables',107,'R250','13-03-2022',8,2)
GO
---INSERTING (5)
INSERT INTO CustomerCart
VALUES('Traver','0781234567','758 Parktown','Capetown','Western Cape','0128','765430987','Traver@gmail.com')
GO
INSERT INTO CustomerCart
VALUES('Lee','0654234567','233 Dakota','Pretoria','Gauteng','0186','098776554','Lee@gmail.com')
GO
INSERT INTO CustomerCart
VALUES('Major','0665432679','W189 Retreat Park','Waterfalls','Mashonaland','0263','NULL','Major@gmail.com')
GO
INSERT INTO CustomerCart
VALUES('Sandra','0234569870','54 Creset Street','Kwekwe','Midlands','0876','NULL','Sandra@gmail.com')
GO
INSERT INTO CustomerCart
VALUES('Taps','091569870','78 Rakajani','Honolulu','NorthWest','0879','794432220','Taps@hotmail.com')
GO
INSERT INTO CustomerCart
VALUES('Prince','0547890987','900 codonia Av','Pretoria','Gauteng','0186','987609879','Prince@gmail.com')
GO
INSERT INTO CustomerCart
VALUES('Yanko','0980765123','7689 Main street','New York','North-East','+44','8987609876','Yanko@Cranch.com')
GO

--INSERTING (6)
INSERT INTO Provides
VALUES(2,2,5)
GO
INSERT INTO Provides
VALUES(5,6,7)
GO
INSERT INTO Provides
VALUES(9,7,1)
GO
INSERT INTO Provides
VALUES(0,4,1)
GO
INSERT INTO Provides
VALUES(9,3,9)
GO

--INSERTING (7)
INSERT INTO Transactions
VALUES('R25000','15000','10000','5','CREDITCARD','1')
GO
INSERT INTO Transactions
VALUES('R5000','4000','1000','2','CREDITCARD','2')
GO
INSERT INTO Transactions
VALUES('R75000','50000','15000','10','CASH','3')
GO
INSERT INTO Transactions
VALUES('R8000','8000','0','3','CASH','4')
GO
INSERT INTO Transactions
VALUES('R200000','150000','50000','25','CARD','5')
GO


--CREATING CURSORS
-- CURSOR (1)
USE INVENTORYDB1;
GO
DECLARE @CategoryID INT,
        @CategoryName VARCHAR(50),
		@BrandName VARCHAR(50)
BEGIN
DECLARE  crsCatCheck CURSOR FOR
SELECT  Categories.CategoryID,Categories.CategoryName,Brand.BrandName
FROM Categories
CROSS JOIN Brand;
OPEN crsCatCheck
FETCH NEXT FROM crsCatCheck INTO @CategoryID, @CategoryName,@BrandName;
WHILE @@FETCH_STATUS=0
BEGIN
PRINT '********************************************************************************************';
PRINT 'CategoryID:'+'@CategoryID';
PRINT 'CategoryName:'+'@CategoryName';
PRINT 'BrandName:'+'@BrandName'
PRINT '*********************************************************************************************';
FETCH NEXT FROM crsCatCheck INTO @CategoryID, @CategoryName,@BrandName;
END
CLOSE crsCatCheck;
DEALLOCATE crsCatCheck;
END
GO

-- CURSOR (2)
USE INVENTORYDB1;
GO
DECLARE @InventoryUserID INT,
        @InventoryUserName VARCHAR(50),
		@LastLogin TIMESTAMP,
		@StoreName VARCHAR(25),
		@StoreCountry NVARCHAR(15)
BEGIN
DECLARE  crsUserCheck CURSOR FOR
SELECT  InventoryUserID,InventoryUserName,LastLogin,StoreName,StoreCountry
FROM InventoryUser
CROSS JOIN Stores;
OPEN crsUserCheck
FETCH NEXT FROM crsUserCheck INTO @InventoryUserID, @InventoryUserName,@LastLogin,@StoreName,@StoreCountry;
WHILE @@FETCH_STATUS=0
BEGIN
PRINT '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$';
PRINT 'InventoryUserID:'+'@InventoryUserID';
PRINT 'InventoryUserName:'+'@InventoryUserName';
PRINT 'LastLogin:'+'@LastLogin';
PRINT 'StoreName:'+'@StoreName';
PRINT 'StoreCountry:'+'@StoreCountry';
PRINT '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$';
FETCH NEXT FROM crsUserCheckk INTO @InventoryUserID, @InventoryUserName,@LastLogin,@StoreName,@StoreCountry;
END
CLOSE crsUserCheck;
DEALLOCATE crsUserCheck;
END
GO
--CREATING VIEW (1)
USE INVENTORYDB1;
GO
CREATE VIEW vCustomerCart
AS
SELECT CustomerCart.CustomerName,CustomerCart.CustomerMobleNumber,CustomerCart.CustomerEmail,Brand.BrandName
FROM CustomerCart
CROSS JOIN Brand
WHERE CustomerCart.CustomerMobleNumber IS NOT NULL
GO

--VIEW (2)
USE INVENTORYDB1;
GO
CREATE VIEW [dbo].[CheckInventory] AS
SELECT ProductID,ProductName,ProductStockNumber,
       CASE WHEN ProductStockNumber  >=1000 THEN 'THE STOCK IS ENOUGH, CHECK THE BRANDS'
	         WHEN ProductStockNumber  BETWEEN 300 AND 800 THEN 'STOCK IS MODERATE, CHECK THE BRANDS'
			 WHEN ProductStockNumber BETWEEN 100 AND 150 THEN 'STOCK IS ABOUT TO GO BELOW PROPER LEVEL'
			 ELSE 'STOCK IS LOW' END AS 'STOCK NOTICE' 
			 FROM Products
			 
GO
--CREATING PROCEDURES

CREATE PROC [dbo].[GetProducts]
         (@CategoryID INT)
		 AS
		 SELECT Products.ProductID,Products.ProductName, Brand.BrandName
		 FROM  Products
		 CROSS JOIN Brand
		 WHERE CategoryID=@CategoryID
GO


--ALTERING PROCEDURES
USE INVENTORYDB1;
GO
EXECUTE sp_rename
@objname = 'GetProducts', @newname = 'GraspProducts', 
@objtype = 'object'
GO

