
/*use TestBase
go
create table Store (
Id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Order_Id BIGINT NOT NULL,
ProuctCategory Varchar(100) Null,
ProductName Varchar(100) Not Null,
Producent Varchar(100) Null,
AmountOfProduct INT null,
);
select * from Store
Insert into Store(
Order_Id,
ProuctCategory,
ProductName,
Producent,
AmountOfProduct) values (4,'Decoration','MOON','TGH',60);

set @ID = Count(*) from
create procedure Temp
begin 
update Store 
set AmountOfProduct = AmountOfProduct + 10
where id in() 
end

DECLARE @liczba int = 5
declare @liczba2 int = 1;
while @liczba2 < @liczba
begin
Update Store
set AmountOfProduct += 10 where id = @liczba2
set @liczba2 += 1
end

select * from store
-------------------------------create table
USE TestBase
GO
Create Table Orders (
Order_Id BIGINT NOT NULL Primary KEY,
ProductAmount INT not null,
);
--------------------------------------------simple insert
Insert into Orders values (0, 30);

Insert into Store(
Order_Id,
ProuctCategory,
ProductName,
Producent,
AmountOfProduct) values (1,'Tools','Hummer','Sthil',50);
---------------------------------------------------------------------Drop primary key
alter table orders drop constraint [PK__Orders__F1E4607BA8F816BC]

Update Orders SET Id = 0 where Order_Id = 0;
ALTER TABLE Orders ADD ID2 int;
update Orders set ID2 = 1 where ID = 0;
*/
/*
declare 

Insert into Orders 

DECLARE @first AS INT = 1
DECLARE @last AS INT = 300

WHILE(@first <= @last)
BEGIN
    INSERT INTO tblFoo VALUES(@first)
    SET @first += 1
END
--------------------------------------------------------------Insert primary Key (nie dzia³a)
ALTER TABLE tbl_name alter column column_name int NOT NULL
ALTER TABLE tbl_name ADD PRIMARY KEY (column_name)
Create table Orders (
ID int not null Primary Key,
Order_ID BIGINT not null,
);
*/
alter table Orders1 add primary key (ID);
 use TestBase
 GO
 create table transactions (
sent_from varchar not null,
receiver varchar not null,
date date not null,
usd_value integer not null);

insert into transactions values('Mitchel', 'Williamson', '01-01-2005 12:34:09', 200);
select * from store
GO
CREATE PROCEDURE uspGetContact 
AS 
SELECT TOP 1 ProuctCategory
FROM Store

Exec uspGetContact

select * from store
GO
alter PROCEDURE uspGetContact 
AS 
SELECT TOP 1 ProuctCategory
FROM Store
--Zastosowanie procedur
--https://msdn.microsoft.com/pl-pl/library/encyklopedia-sql--tworzenie-procedur-bazodanowych--create-procedure.aspx

--Procedura sprawdzaj¹ca czy dane nie s¹ nullem oraz dodaj¹c kolejny wiersz w tabeli
select * from Store
GO
CREATE PROCEDURE AddData

@Order_ID int = Null, 
@Category VARCHAR(100) = NULL,
@ProductName VARCHAR(100) = NULL,
@Producent VARCHAR(100) = NULL,
@AmountOfProduct VARCHAR(100) = NULL
 
AS
 
DECLARE @blad AS NVARCHAR(500);
 
IF @Order_ID IS NULL OR @Category IS NULL OR @ProductName IS NULL OR @Producent IS NULL OR 
@AmountOfProduct IS NULL
BEGIN
     SET @blad = 'B³êdne dane!';
     RAISERROR(@blad, 16,1);
     RETURN;
END
 
INSERT Store(Order_ID, ProuctCategory, ProductName, Producent, AmountOfProduct)
VALUES (@Order_ID, @Category, @ProductName, @Producent, @AmountOfProduct);
 
GO

Exec AddData '5','Decoration', 'Chair', 'AgataMeble', '5'
Exec AddData '6','Tools', 'Spirit Level', 'Topex', '24'
