--select * from Employees; 9
--select * from Customers; 91
--select * from Suppliers; 29
--select CompanyName, Address, City, Country from Suppliers;29
--select LastName, FirstName, Title from Employees; 9
--select CompanyName as Nazwa_Firmy, Address as Adres, City as Miasto, Country as Kraj from Suppliers;29
--select ProductName, QuantityPerUnit, 
/*Select SUM(CustomerID)from Orders
 where CustomerID = (select top 2 count(OrderId) as Ilosc_zamowien, CustomerID  
from Orders 
group by CustomerID 
order by Ilosc_zamowien desc);
*/
--10 zadanie
/*
SELECT 
 SUM(ilosc_zamowien) as suma_top2
FROM
(SELECT TOP 2 COUNT(CustomerID) AS ilosc_zamowien
FROM Orders
GROUP BY CustomerID
ORDER BY ilosc_zamowien desc) AS x;
*/
/*
--Join po Customer ID, wyciagamy zamówienia poszczególnych klientów
Select Orders.OrderID as Zamowienie, Customers.CompanyName as Nazwa_Firmy, Customers.CustomerID as ID_Klienta
from Orders 
inner join 
Customers on Customers.CustomerID = Orders.CustomerID;
*/
-- INNER JOIN zamowienia, informacje o kliencie, nazwa firmy, która wys³a³a zamówienie
/*
Select Orders.OrderID as Zamowienie, Customers.CompanyName as Nazwa_Firmy, 
Customers.CustomerID as ID_Klienta, Shippers.CompanyName as Firma_wysylkowa, 
Customers.City
from Orders 
inner join 
Customers on Customers.CustomerID = Orders.CustomerID
inner join Shippers on Shippers.ShipperID = Orders.ShipVia 
where ShipCountry = 'Germany' and City ='Berlin' Or City ='München'
Order By Nazwa_Firmy;
*/
--wszystkich klientów i ich zamowienia 
/*
Select Orders.OrderID as Zamowienie, Customers.CustomerID as ID_Klienta
from Customers 
Left join 
Orders on Customers.CustomerID = Orders.CustomerID
*/
/*
Select Orders.OrderID as Zamowienie, Customers.CustomerID as ID_Klienta
from Customers 
Left join 
Orders on Customers.CustomerID = Orders.CustomerID Where Orders.OrderID is Null;
*/
--eployees wsyscy oraz wszystkke zamowienia nr zamowienia, imie, nazwisko, którzy urodzili siê po 1955 roku i maja santowisko sales representative
/*
Select Orders.OrderID as Zamowienie, Employees.FirstName as Imie, Employees.LastName,
Employees.BirthDate, Employees.Title
from Orders 
Right join 
Employees on Employees.EmployeeID = Orders.EmployeeID 
where Employees.BirthDate > '1955' and Employees.Title like '%co%';
*/
--wszystkich klientow i wszystkie zamowienia
/*
Select Customers.CompanyName, Orders.OrderDate from Orders
Full JOIN Customers on Customers.CustomerID = Orders.CustomerID 
where Orders.OrderDate between '1996-04-07' and '1996-09-07';
*/
--12
/*
Select FirstName as Imie, LastName as Nazwisko, Title as Stanowisko, Country as Kraj 
from Employees 
where Country = 'USA'; 5
*/
--13
/*
Select * from Customers 
where CompanyName = 'Alfreds Futterkiste';
*/
--14
/*
Select Products.ProductName as product, Suppliers.CompanyName as dostawca  
from Suppliers 
inner Join Products ON Suppliers.SupplierID = Products.SupplierID 
where Products.ProductName like '%Chocola%';
*/

--16 Select count(Employees.EmployeeID) as Liczba_pracownikow from Employees; 9
--17 (69)
--Select UnitsInStock as Iloœæ from Products where Discontinued = '0'; 
--18 (2)
/*
Select Employees.FirstName as Imie, Employees.LastName as Nazwisko 
from Employees 
where Employees.LastName like 'D%';
*/
-- 19 (2)
/*
Select Products.UnitPrice from Products 
where UnitPrice >100;
*/
--20 (4)
/*
Select Products.UnitPrice from Products 
where UnitPrice between 50 and 100;
*/

--21
/*
Select
YEAR(Orders.OrderDate) as Rok,
MONTH(Orders.OrderDate) as Miesiac,
Orders.OrderID as NrZamowienia,
SUM([Order Details].UnitPrice) as WartoscZamowienia
From Orders
Inner Join [Order Details] ON Orders.OrderID = [Order Details].OrderID
Group By
YEAR(Orders.OrderDate) as Rok,
MONTH(Orders.OrderDate) as Miesiac,
Orders.OrderID 
HAVING
SUM([Order Details].UnitPrice) >100
Order By 
Rok desc, Miesiac desc;
*/


 --Select Year(O.orderDate), MONTH(O.OrderDate), O.OrderID from
--21 (141)
/*
Select Orders.OrderID, SUM([Order Details].UnitPrice), 
DATEPART(yyyy, Orders.OrderDate) as Rok,
DATEPART(mm, Orders.OrderDate) as Miesc
from [Order Details] inner Join Orders on [Order Details].OrderID = Orders.OrderID
Group by Orders.OrderID,
DATEPART(yyyy, Orders.OrderDate),
DATEPART(mm, Orders.OrderDate) 
HAVING SUM([Order Details].UnitPrice) > 100
Order by Rok, Miesc desc;
*/

--22
--Select 
--23 (100)
/*
Select top 1 Count(Orders.OrderID) as zamowienia, Shippers.CompanyName from Orders
Inner join Shippers on Shippers.ShipperID = Orders.ShipVia
Group by Shippers.CompanyName
Order by zamowienia desc;
*/
--------------------------------
/*
Select top 1 ([Order Details].UnitPrice*[Order Details].Quantity) as "Wartosc_zamowienia", Suppliers.CompanyName, Products.UnitsOnOrder from Suppliers
Inner join Products on Products.SupplierID = Suppliers.SupplierID  
Inner join [Order Details] on Products.ProductID = [Order Details].ProductID;
*/
--24
/*
Select MAX([Order Details].UnitPrice) as zamowienia, Shippers.CompanyName from [Order Details]
Inner Join Orders on Orders.OrderID = [Order Details].OrderID
Inner Join Shippers on Shippers.ShipperID = Orders.ShipVia
group by Shippers.CompanyName;
*/
-- 25 (15 810, 4.80)
/*
Select MAX([Order Details].UnitPrice*[Order Details].Quantity)as Minimal_order_value,
MIN([Order Details].UnitPrice*[Order Details].Quantity) as Maximal_order_Value from [Order Details];
*/
-----------------------------------
--1(2)
/* 
Select FirstName, LastName from Employees where LastName like '%o%o%';
*/
--2 (6 wyników)
/*
Select ContactName from Customers 
where ContactName like '% L%';
*/
--3 (3)
/*
Select HireDate from Employees 
where HireDate between '1993-10-01' and '1994-03-31';
*/
--4 (9)
/*
Select (TitleOfCourtesy +' '+ FirstName +' '+ LastName +' ' + Title) as Pracownicy 
from Employees;
*/

-- 5 (25)
/*
Select CustomerID, OrderDate 
from Orders
where CustomerID = 'SAVEA' and OrderDate >'1997-06-01';
*/
--6 (93)
/*
select CustomerID, OrderDate, OrderID 
from Orders 
where OrderID between '10755' and '10847'; 
*/
--7 (9)
/*
Select CustomerID, OrderDate 
from Orders
where CustomerID = 'SAVEA' and EmployeeID IN (1,3,9);
*/
--8 (16)
/*
select City, Country, CompanyName 
from Customers  
where Country like '[A-B]%';
*/

--9 a (4)
/*
Select EmployeeID, FirstName, LastName, City, Country
from Employees 
where Country = 'UK';
*/
--9 b (5)
/*
Select EmployeeID, FirstName, LastName, City, Country
from Employees where City not in('London');
-- City <> 'London'
*/
--9 c (4)
/*
Select EmployeeID, FirstName, LastName, City, Country
from Employees where BirthDate > '1961-01-01'
*/
--9 d (1)
/*
Select EmployeeID, FirstName, TitleOfCourtesy
from Employees where TitleOfCourtesy in('Mrs.', 'Dr.');
*/
--10 a (184)
/*
Select OrderID, CustomerID, ShipCountry, ShippedDate 
from Orders 
Where ShippedDate between '1997-05-01' and '1997-10-15' 
*/
--10 b(218)
/*
Select OrderID, CustomerID, ShipCountry from Orders
Where ShipCountry IN('Germany', 'UK', 'Austria')
order by ShipCountry;
*/
--10 c (326)
/*
Select Orders.OrderID, Orders.CustomerID, Orders.ShipCountry, ShipVia
from Orders
Where ShipVia = 2;
*/
--10 d (271)
/*
Select OrderID, CustomerID, ShipCity from Orders
Where ShipCity Like '[A-D]%'
order by ShipCity;
*/
--11 a (5)
/*
Select ProductName, ProductID, CategoryID
from Products
Where CategoryID = 7;
*/
-- 11 b (51)
/*
Select ProductName, ProductID, UnitPrice
from Products
Where UnitPrice > 15;
*/
--11 c (18)
/*
Select ProductName, ProductID, UnitPrice
from Products
Where UnitPrice < 10 or UnitPrice > 50
order by UnitPrice;
*/
--11 d (5)
/*
Select ProductName, ProductID
from Products
Where ProductName like '_e%' 
order by ProductName;
*/
------------------------------2-------------------
--1 (21)
/*
Select Count(CustomerID) as LiczbaKlientow, Country from Customers
group by Country
order by LiczbaKlientow desc;
*/
--2 (23)
/*
Select Count(Orders.OrderID) as liczba_Zamowien, 
YEAR(Orders.OrderDate) as Rok, MONTH(Orders.OrderDate) as Miesiac
from Orders 
Group by 
YEAR(Orders.OrderDate), MONTH(Orders.OrderDate)
order by 
liczba_Zamowien;
*/
--3 (77)(37)
/*
Select Count([Order Details].ProductID) as liczba_Zamowien, OrderID
from [Order Details] 
Group by OrderID
HAVING Count([Order Details].OrderID) >= 5
order by 
liczba_Zamowien desc;
*/
--4 (3)
/*
Select HireDate 
from Employees
where HireDate between '1992-12-31' and '1993-12-31';
*/ 
--5 (8)
/*
Select MAX(UnitPrice) as MaxPrice, COUNT(ProductID) as Liczba_produktow, CategoryID 
from Products 
group by CategoryID
order by MaxPrice desc;
*/
--6(9)
/*
Select DATEDIFF(YYYY, BirthDate, Getdate())as wiek, FirstName, LastName from Employees
Order by wiek desc;
*/
--7 (4)
/*
Select AVG(DATEDIFF(year, BirthDate, Getdate()))as wiek, Title from Employees
group by Title;
*/
--8
/*
Select Distinct(ShipCountry)
from Orders 
where ShippedDate between '1997-01-01' and '1997-12-31';
*/
--9 (22)
/*
Select CompanyName, ContactName, Phone, Fax 
from Customers
where fax is null;
*/
--10
/*
Select CompanyName, ContactName, Phone, Fax 
from Customers
where country = 'UK'
*/
--11 do sprawdzenia
/*
select CustomerID, MIN(OrderDate), MIN(OrderID) 
from Orders
group by CustomerID
*/

-------------------joiny
--12
/*
Select Products.ProductName, Suppliers.CompanyName from Suppliers 
inner join 
Products on Products.SupplierID = Suppliers.SupplierID
where
ProductName = 'Tofu';
*/
--13
/*
Select Customers.CompanyName, COUNT(Orders.OrderID) as IloscZamowien 
from Orders
Right Join 
Customers On Customers.CustomerID = Orders.CustomerID
group by Customers.CompanyName
Order by IloscZamowien;
*/
--14
/*
Select COUNT([Order Details].Quantity) as IloscZamowien, Orders.ShipCountry
from Orders
inner Join [Order Details] 
on [Order Details].OrderID = Orders.OrderID
Where 
OrderID in (10250, 10657, 10710 , 10901);
*/
--15 sprzeda¿ w ka¿dym miesiacu 
/*
Select SUM(([Order Details].Quantity * [Order Details].UnitPrice)) as wartosc, 
MONTH(Orders.OrderDate)as Miesiac
from Orders 
inner join [Order Details] on [Order Details].OrderID = Orders.OrderID
where Year(Orders.OrderDate) = 1997
group by MONTH(Orders.OrderDate)
order by Miesiac;
*/
--16
/*
Select Count([Order Details].Quantity) as 'Liczba Zamowien', Orders.EmployeeID
from [Order Details]
inner join Orders on [Order Details].OrderID = Orders.OrderID
group by EmployeeID order by [Liczba Zamowien] desc;
*/
--17 wartoœæ zamowienia poszczegolnych pracownikow 
/*
select Sum(([Order Details].Quantity * [Order Details].UnitPrice)) as 'wartosc zamowienia', Orders.EmployeeID
from [Order Details]
inner join orders on [Order Details].OrderID = Orders.OrderID
where Year(Orders.OrderDate) = 1997
group by orders.EmployeeID
order by [wartosc zamowienia] desc;
*/
--18 produkty dostarczane przez dostawcow
/*
Select ProductName, Suppliers.CompanyName 
from products 
right join Suppliers on Products.SupplierID = Suppliers.SupplierID
group by Suppliers.CompanyName, Products.ProductName
*/
--19, 20 5 klientow z najwieksza wartoscia zamowienia
/*
select top 5 Sum(([Order Details].Quantity * [Order Details].UnitPrice)) as 'wartosc zamowienia',
 Orders.CustomerID
from [Order Details]
inner join orders on [Order Details].OrderID = Orders.OrderID
group by Orders.CustomerID
order by [wartosc zamowienia] desc;
*/
--21 
--------------------------------Level 3
--2 (46 rows)
/*
select OrderID
from Orders
where CustomerID in
(Select CustomerID from Customers where City = 'London');
*/
--3(678)
/*
Select CustomerID, OrderDate
from Orders
where OrderDate > '1996-12-31';
*/
--4
-------------------------------------------------------------------Modulo funtion 
/*
select OrderID
from orders
where OrderID between 10759 and 10924
AND OrderID % 2 = 0
And CustomerID in (Select CustomerID from Customers where Country = 'USA');
*/
--5 Union
select top 1 OrderID, CustomerID
from Orders
where CustomerID in (Select CustomerID from Customers where Country = 'Germany')
order by OrderID 
UNION 
select top 1 OrderID, CustomerID
from Orders
where CustomerID in (Select CustomerID from Customers where Country = 'Germany')
order by OrderID desc;

-- Niezle kombo
Select FIRST_VALUE(OrderID) OVER (partition by CustomerID order by OrderID) as first1,
LAST_VALUE(OrderID) OVER(partition by CustomerID order by OrderID) as last1 
from Orders
where CustomerID in (Select CustomerID from Customers where Country = 'Germany');
--6 (88)
/*
select Orders.OrderID, Employees.EmployeeID, Employees.Title as 'Stanowisko'
from Orders
inner join 
Employees on Orders.EmployeeID = Employees.EmployeeID
where CustomerID in (Select CustomerID from Customers where country = 'USA')
and Employees.EmployeeID in (Select EmployeeID from Employees where Title = 'Sales Representative');
*/
--7 (5)
/*
select SupplierID, ProductName
from Products 
where ProductID in (select ProductID from [Order Details] where OrderID = 10337);
*/
--8 (33)
/*
Select CustomerID, OrderID
from Orders
where OrderID in(Select OrderID from [Order Details] where ProductID = 28);
*/

---------------------------------------------------Pêtla T-SQL
/*
DECLARE @liczba int = 1;
DECLARE @liczba2 int = 1;

WHILE @liczba2 <5
    BEGIN
        print 'Pêtla "zewnêtrzna" wykona³a siê '+ CAST(@liczba2 AS VARCHAR) + ' razy'
        WHILE @liczba <6
            BEGIN
                print 'To jest wiersz '+ CAST(@liczba AS VARCHAR)
                SET @liczba += 1 
            END
        SET @liczba = 1
        SET @liczba2 += 1            
    END
	

---------------------------------------------------------------Instrukcja CASE
SELECT OrderDate, ShippedDate,
CASE
     WHEN OrderID < 10270 THEN 'M³odsze zamówienia'
     WHEN OrderID > 10270 THEN 'Starsze zamówienia'
     ELSE 'Zamówienie numer 10270'
END
FROM Orders;
*/
--------------------------------------------------------------------------------How to use OVER
/*USE AdventureWorks2008
GO
 
select SalesOrderId, ProductID, SalesOrderDetailId as DetailId, LineTotal ,
 
-- okreœlamy okna – wszystkie elementy danego zamówienia – PARTITION BY 
-- oraz ramkê. Dla ka¿dego elementu bêd¹ to wiersze od pocz¹tku przedzia³u 
-- do current row, bior¹c pod uwagê wartoœæ sortowan¹ SalesOrderDetailId
 
SUM(LineTotal) OVER(partition by SalesOrderId order by SalesOrderDetailId) as RunningSUM,
COUNT(LineTotal) OVER(partition by SalesOrderId order by SalesOrderDetailId) as QtyFrameEl,
 
-- w SQL Server 2005-2008 R2 brak mo¿liwoœci stosowania ORDER BY w OVER() 
-- w przypadku uzycia z funkcjami agreguj¹cymi np. SUM, AVG, MAX, MIN etc
-- mogliœmy wyznaczyæ agregat tylko w ramach ca³ej partycji np. TotalValue
 
	SUM(LineTotal) OVER(partition by SalesOrderId ) as TotalValue,
	COUNT(LineTotal) OVER(partition by SalesOrderId ) as QtyWindowEl
 
from Sales.SalesOrderDetail 
where SalesOrderId IN (43666,43664)
*/
--- Stored Procedure
/*
CREATE PROCEDURE Sales_Quater
(
	@FirstName	VARCHAR(50),
	@LastName	VARCHAR(50)
)
AS
SELECT sp.SalesLastYear 
 FROM Sales.SalesPerson AS sp
 INNER JOIN HumanResources.Employee AS e
  ON sp.SalesPersonID = e.EmployeeID
 INNER JOIN Person.Contact AS c
  ON e.ContactID = c.ContactID
 WHERE c.FirstName = @FirstName AND c.LastName = @LastName
GO
EXEC Sales_Quater ‘Jose’, ‘Saraiva’
*/

Select * from Employees

Select * from Orders
----------9898
GO
CREATE PROCEDURE Si
(
	@EmployeeID	VARCHAR(50)
)
AS
SELECT o.EmployeeID
 FROM Orders AS o
 INNER JOIN Employees AS e
  ON o.EmployeeID = e.EmployeeID
 WHERE o.EmployeeID = @EmployeeID 
GO

Exec Si '1'
---Stored Procedure wchich return Summarize value of orders
GO
CREATE PROCEDURE SumOrders
(
	@EmployeeID	VARCHAR(50)
)
AS
SELECT o.EmployeeID, SUM(od.UnitPrice*od.Quantity) as SumOrderDet
 FROM Orders AS o
 INNER JOIN Employees AS e
  ON o.EmployeeID = e.EmployeeID
  Inner Join [Order Details] od
  ON od.OrderID = o.OrderID
  Group by o.EmployeeID
  Having o.EmployeeID = @EmployeeID 
GO

Exec SumOrders '1'