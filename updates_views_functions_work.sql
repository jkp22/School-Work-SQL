
update tblCustomerQACS 
set LastName = CO.LastName, FirstName =CO.FirstName, Address = CO.Address, City = CO.City,
	State = CO.State, ZIP = CO.ZIP, Phone = CO.Phone, Email = CO.Email
from Customer_original as CO
Where tblcustomerQACS.CustomerID = CO.CustomerID

select * from Customer_original

update tblSale
set SaleDate = SO.SaleDate, Tax = SO.Tax, Subtotal = SO.SubTotal, Total = SO.Total, CustomerID =SO.CustomerID, EmployeeID = SO.EmployeeID
from Sale_original as SO
Where tblSale.SaleID = SO.SaleID

update tblitem 
set ItemDescription = I.ItemDescription, PurchaseDate = I.PurchaseDate, ItemCost = I.ItemCost, ItemPrice = I.ItemPrice, VendorID = I.VendorID
from Item_original as I
where tblitem.ItemID = I.ItemID

update Item_original
set ItemDescription = 'Desk Lamps'
where ItemDescription = 'Desk Lamp'


select * from tblItem
select * from Item_original
--1
Create Function dbo.ufnFullName (@FirstName nvarchar(100), @LastName nvarchar (100))
returns nvarchar(200)
As
Begin
Declare @fullname nvarchar(200)

Set @fullname = (@FirstName + '' + @LastName)
return @fullname
end

--2

Create Function dbo.ufnEmployeeRevenue (@EmployeeID int)
returns money
As
Begin

Declare @Total money

select @Total = SUM(s.Total)
from tblSale as s
where S.EmployeeID = @EmployeeID


Return @Total
end

--3
select * from tblCustomerQACS
select * from tblSale 
select * from tblSaleItem 
select * from tblitem
Alter view vueCustomerSaleSummaryView as
	select S.SaleID as SaleID,
	S.SaleDate as SaleDate,
	dbo.ufnFullName(Concat(Rtrim(C.FirstName), ' '), Rtrim(C.LastName)) as CustomerName,
	SI.SaleItemID as SaleItemID,
	SI.ItemID as ItemID,
	I.ItemDescription as ItemDescripton,
	I.ItemPrice
	from tblsale as S inner join tblCustomerQACS as C
		on S.CustomerID = C.CustomerID
			inner join tblSaleItem as SI
				on S.SaleID = SI.SaleID
					inner join tblItem as I
						on SI.ItemID = I.ItemID

select * from vueCustomerSaleSummaryView

--4

alter view vueCustomerSaleHistoryView as
	select distinct S.SaleID as SaleID,
	S.SaleDate as SaleDate,
	dbo.ufnFullName(Concat(Rtrim(C.FirstName), ' '), Rtrim(C.LastName)) as CustomerName,
	Sum(I.ItemPrice) as SumItemPrice,
	AVG(I.ItemPrice) as AverageItemPrice
	from tblsale as S inner join tblCustomerQACS as C
		on S.CustomerID = C.CustomerID
			inner join tblSaleItem as SI
				on S.SaleID = SI.SaleID
					inner join tblItem as I
						on SI.ItemID = I.ItemID
	group by C.LastName, C.FirstName, S.SaleDate, S.SaleID

select * from vueCustomerSaleHistoryView
select * from tblsale
--5
select * from tblSale
select * from tblSaleItem
select * from tblitem
create view vueCustomerSaleCheckView as
	select S.SaleID,
	S.SaleDate,
	S.SumItemPrice,
	A.subtotal,
	S.CustomerName
	from vueCustomerSaleHistoryView as S inner join tblSale as A
		on S.SaleID = A.SaleID
	where S.SumItemPrice <> A.Subtotal

select * from tblitem
select * from tblsaleitem 
select * from vueCustomerSaleCheckView

insert into tblItem(ItemDescription, PurchaseDate, ItemCost, ItemPrice,
VendorID) values ('Test item', '2016-01-01', 10000, 20000, 10);
DECLARE @itemID int;
SELECT @itemID=max(ItemID) from tblItem;
insert into tblSaleItem (SaleID, SaleItemID, ItemID, ItemPrice)
values (1,10, @itemID,20000);
Update tblSaleItem set ItemPrice=20001 where SaleID=1 and SaleItemID=10;
	
--6
Alter VIEW vueEmployeeRevenueView AS
    Select dbo.ufnFullName(Concat(Rtrim(E.FirstName), ' '), Rtrim(E.LastName)) as EmployeeName,
    dbo.ufnEmployeeRevenue(E.EmployeeID) as TotalRevenue
    from tblEmployee as E
    Where dbo.ufnEmployeeRevenue(E.EmployeeID) > 0

select * from vueEmployeeRevenueView

--trigger
Alter Trigger utrInsteadUpdateTblSCAMembership on tblSCAMembership
INSTEAD OF UPDATE
AS
BEGIN

DECLARE @NewPaidDate date;
DECLARE @OldPaidDate date;
DECLARE @MembershipNumber int;

SELECT @MembershipNumber= MembershipNumber from inserted

SELECT @OldPaidDate= MembershipFeePaidDate from deleted

SELECT @NewPaidDate= MembershipFeePaidDate from inserted

If @OldPaidDate is not null and @OldPaidDate < @NewPaidDate	
BEGIN

	
	UPDATE dbo.tblSCAMembership
	SET MembershipFeePaidDate = @NewPaidDate, isCurrentMember= 1
	where MembershipNumber = @MembershipNumber;
	PRINT concat('Membership Number ', @MembershipNumber, '; payment date is ', @NewPaidDate, '; prior payment date is ', @OldPaidDate) 
End

Else if @oldpaiddate is not null and @NewPaidDate < @OldPaidDate
Begin

	PRINT Concat('Membership Number ', @MembershipNumber, ' new payment date is ', @NewPaidDate, ' is earlier than prior payment date ', @OldPaidDate, '; No Change made')

end

Else If @OldPaidDate is null
Begin
UPDATE tblSCAMembership
SET MembershipFeePaidDate = @NewPaidDate, isCurrentMember= 1
where MembershipNumber = @MembershipNumber;
PRINT Concat('Membership Number ',@MembershipNumber, ' payment date is ',@NewpaidDate, '; no prior payment date')
End
End


Update tblSCAMembership
set MembershipFeePaidDate = '11/17/2017'
where MembershipID = 58

 Update tblSCAMembership set MembershipFeePaidDate =
'11/17/2017' where MembershipID = 56

Update tblSCAMembership set MembershipFeePaidDate =
'11/17/2017' where MembershipID = 62