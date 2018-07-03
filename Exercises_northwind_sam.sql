--Zadania nortwind samodzielnie
--1
select FirstName as Imie, LastName as Nazwisko
from Employees where LastName like '%o%o%';
--2
Select * from Customers 
where ContactName like '% L%'
--3
select FirstName, LastName, HireDate
from Employees
where HireDate between '1993-10-01' and '1994-03-01';
--4
select (TitleOfCourtesy+' '+ FirstName +' '+LastName+', '+Title) as Pracownicy
from Employees
--5
select Orders.OrderID, Orders.OrderDate, Customers.CustomerID
from Orders left join Customers 
on Orders.CustomerID = Customers.CustomerID 
where Customers.CustomerID = 'SAVEA'
AND Orders.OrderDate > '1997-06-01'
order by OrderDate;
--6
select Customers.CustomerID, Orders.OrderDate
from Orders left join Customers 
on Orders.CustomerID = Customers.CustomerID 
where Orders.OrderID between 10755 and 10847
order by Orders.OrderID;
--7
select Employees.EmployeeID, Orders.OrderDate
from Orders left join Employees
on Orders.EmployeeID = Employees.EmployeeID 
where Orders.CustomerID = 'SAVEA'
AND Employees.EmployeeID in (1,3,9);
--8
select Country, City, CompanyName
from Customers
where Country like '[A,B,C]%';
-----------------------------------------------------------------------2
--1
select Country, Count(CustomerID) as QuantityOFCustomers 
from Customers
group by Country
order by QuantityOFCustomers desc;
--2
select Year(OrderDate) as rok,
Month(OrderDate) as miesiac, Count(OrderID) as QuantityOrders
from Orders
group by Year(OrderDate), Month(OrderDate)
Order by QuantityOrders; 
--3
select Count(ProductID) as Ilosc, OrderID  
from [Order Details]
group by OrderID
having Count(ProductID) >= 5
--4
Select FirstName, LastName, HireDate
from Employees
where Year(HireDate) = 1993;
--5
select MAX(UnitPrice) as GreatesPrice, Count(ProductID) as AmountOfProduct, CategoryID
from Products
group by CategoryID
order by GreatesPrice
--6
Select FirstName, LastName, DATEDIFF(yyyy,HireDate, GETDATE()) as AgesinCompany
from Employees
--7
Select FirstName, LastName, DATEDIFF(yyyy,BirthDate, GETDATE()) as Age
from Employees
--8 
Select Distinct ShipCountry 
from Orders
where Year(ShippedDate) = 1997;
--9
Select CompanyName, ContactName, Phone, fax
from Customers
where fax is null;
--10
Select (CompanyName+', '+ContactName+', '+phone) as info
from Customers
--11
select CustomerID, MIN(OrderID) as FirstOrder, MIN(OrderDate) as Date
from Orders
group by CustomerID
------------------------------------------------Joiny
--12
select S.CompanyName, S.ContactName, S.Address, S.City, P.ProductName
from Suppliers S
left join Products P 
ON S.SupplierID = P.SupplierID
where P.ProductName = 'tofu';
--13
select COUNT(OrderID) as QuantityOfOrd, CustomerID
from Orders
Group by CustomerID
order by QuantityOfOrd desc
--14
Select Od.OrderID, COUNT(Od.Quantity) as QuantityOfProd, AVG(Od.UnitPrice) as AVGPrice, O.ShipCountry
from [Order Details] Od
left join Orders O
on Od.OrderID = O.OrderID
group by Od.OrderID, O.ShipCountry
HAVING Od.OrderID in(10250, 10657, 10710, 10901)
--14 with CTE
;with Jar () as
(
Select Od.OrderID, AVG(Od.UnitPrice) as AVGPrice, O.ShipCountry,
COUNT(Od.Quantity)OVER(Partition by Od.OrderID) as QuantityOfProd
from [Order Details] Od
left join Orders O
on Od.OrderID = O.OrderID
)
select OrderID, AVGPrice, ShipCountry from Jar where OrderID in (10250, 10657, 10710, 10901)
--15
select Month(Od.OrderDate) as Mon, SUM(Oro.Quantity * Oro.UnitPrice) as Suma
from Orders Od
right join [Order Details] Oro 
on Od.OrderID = Oro.OrderID 
Group by Month(Od.OrderDate)
Order by Suma desc
--16
select count(OrderID) as QuntOrdPerPerson, Employees.FirstName
from Employees
Left join Orders on 
Employees.EmployeeID = Orders.EmployeeID
Group by Employees.FirstName
order by QuntOrdPerPerson desc
--17
select count(OrderID) as QuntOrdPerPerson, Employees.FirstName, Year(Orders.OrderDate) as Rok
from Employees
Left join Orders on 
Employees.EmployeeID = Orders.EmployeeID
Group by Employees.FirstName, Year(Orders.OrderDate)
Having Year(Orders.OrderDate) = '1997'
order by QuntOrdPerPerson desc
--18
select count(*) from products
select * from Orders


----------------------------------------------------------------wyznacz 1 najdrozszy produkt w kazdej kategorii
;with prod as(
select P.ProductID, Od.Discount, P.CategoryID, P.ProductName, P.UnitPrice,
ROW_Number()OVER(partition by P.CategoryID order by P.UnitPrice desc) as SecondHi
from Products P 
join [Order Details] Od on P.ProductID = Od.ProductID
)
select ProductID, Discount, CategoryID, ProductName, UnitPrice, SecondHi
from prod
where SecondHi = 1
----------------------------------------------------------------wyznacz 2 najdrozszy produkt w kazdej kategorii
;with prod as(
select P.ProductID, Od.Discount, P.CategoryID, P.ProductName, P.UnitPrice,
Dense_Rank()OVER(partition by P.CategoryID order by P.UnitPrice desc) as SecondHi
from Products P 
join [Order Details] Od on P.ProductID = Od.ProductID
)
select ProductID, Discount, CategoryID, ProductName, UnitPrice, SecondHi
from prod
where SecondHi = 2

------------------- wybierz 2 najdro¿szy produkt 
;with produ as
(Select *, DENSE_RANK()OVER(order by UnitPrice desc) as SecondHighest
from [Order Details]
)
Select top 1 * from produ
where SecondHighest = 2;
----------------------------------Second Way
select top 1 UnitPrice
from(select distinct top 2 UnitPrice from [Order Details] order by UnitPrice desc)
result order by UnitPrice asc

-----------------------------------------------------------------CTE with Joins
WITH Sales_CTE  (SalesPersonID, NumberOfOrders, MaxDate)
AS
(
    SELECT top 5 SalesPersonID, COUNT(*) , MAX(OrderDate) 
    FROM Sales.SalesOrderHeader
    GROUP BY SalesPersonID
    ORDER BY 2 ASC
)
-- bezpoœrednio po definicji, kwerenda odwo³uj¹ca siê m.in do tego CTE
SELECT P.FirstName, P.LastName, c.NumberOfOrders, c.MaxDate
FROM Sales_CTE c left join Person.Person AS P
    ON c.SalesPersonID = P.BusinessEntityID


	
WITH T AS
(
SELECT *,
       DENSE_RANK() OVER (ORDER BY Extension desc) AS Rnk
FROM Employees
)
SELECT Extension, FirstName
FROM T
WHERE Rnk=2;
------------------------------------ 
select OrderID, UnitPrice, Quantity,
ROW_NUMBER()OVER(order by UnitPrice desc) as PriceOrder
from [Order Details]
Select distinct OrderID from [Order Details];

---------------- Pogrupuj i zlicz produkty wed³ug ID i posortuj wed³ug rabatu
select UnitPrice, Quantity, ProductID, Discount,
ROW_NUMBER()OVER(partition by ProductID order by Discount) as SUMA 
from [Order Details]
---------------------------second highest value
;with an as(
select *,
ROW_NUMBER() OVER(partition by UnitPrice order by OrderID desc) as SUMA 
from [Order Details])

select Distinct (OrderID) from an;


------------second highrst 

select 
    receiver, 
    usd_value,
    row_number() over (partition by receiver order by usd_value desc) as rn 
  from t 
------
  select 
  receiver, 
  sum(usd_value) 
from ( 
  select 
    receiver, 
    usd_value,
    row_number() over (partition by receiver order by usd_value desc) as rn 
  from t 
) t1
where rn <= 3 
group by receiver 
having sum(usd_value) >= 1024  
order by receiver  