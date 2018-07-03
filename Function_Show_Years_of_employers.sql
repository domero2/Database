use TestBase
go
CREATE FUNCTION ShowYearBasedOnBirthdate (@EmpID int)  
RETURNS int
AS
BEGIN
declare @HowOld as int

		Return(Select DATEDIFF(yy, BirthDate, Getdate()) as HowOld1 from Employees
		 where EmployeeID = @EmpID)

return @HowOld
END

