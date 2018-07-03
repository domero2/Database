--------------------------------------when you want to show function you must add dbo. before Function name
Select dbo.ShowYearBasedOnBirthdate(1)

GO
CREATE PROCEDURE MonthlySales1
 @miesiac int 
 
 AS
IF (select max(MONTH(OrderDate)) from Orders) < @miesiac
BEGIN
SELECT o.OrderID,o.CustomerID, o.EmployeeID, o.OrderDate
  FROM Orders o
  Inner Join [Order Details] od
  ON o.OrderID = od.OrderID
  WHERE
  MONTH(OrderDate) = @miesiac
END
ELSE
    BEGIN
        SELECT 'BRAK danych'
    END
------------------------------------------------------------------------Practice trigger example
	select * from store
GO
create trigger TestTrig1 on Store after UPDATE,insert
as
 declare @OdID int; 
 declare @Producent varchar(50);
 declare @AmountOfProd varchar(50);
 
IF (UPDATE (Producent) OR update(AmountOfPRoduct)) 
begin
 select @OdID=s.Order_ID,@Producent=s.Producent,@AmountOfProd= s.AmountOfProduct from store s;
 insert into Store(Order_Id,Producent,AmountOfProduct) values(@OdID,@Producent,@AmountOfProd)
end

GO
create trigger TestTrig2 on Store after UPDATE
as
begin
 print 'Hello World'
end
select * from store