--Creating Tables
create table tblCustomerQACS(
CustomerID	int				not null Identity(1,1),
LastName	nvarchar(250)	null,
FirstName	nvarchar(250)	null,
Address		nvarchar(250)	null,
City		nvarchar(250)	null,
State		nvarchar(250)	null,
ZIP			nvarchar(250)	null,
Phone		nvarchar(250)	null,
Email		nvarchar(250)	null,
constraint	CustomerPK		primary	key(CustomerID),
constraint	CustomerAK1		unique(Email)
);

create table tblEmployee(
EmployeeID		int			not	null Identity(1,1),
LastName		nvarchar(250)	null,
FirstName		nvarchar(250)	null,
Phone			nvarchar(250)	null,
Email			nvarchar(250)	null,
constraint	EmployeePK		primary	key(EmployeeID),
constraint	EmployeeAK1		unique(Email)
);

create table tblSale(
SaleID			Int				not null identity(1,1),
SaleDate		Date			null,
Tax				nvarchar(250)	null,
Subtotal		nvarchar(250)	null,
Total			nvarchar(250)	null,
CustomerID		Int				null,
EmployeeID		Int				null,
Constraint		SalePK		primary key(SaleID),
Constraint		SaleFK1		Foreign key(CustomerID)
						REFERENCES tblCustomerQACS(CustomerID)
						On delete no action
						On update no action,
Constraint		SaleFK2		Foreign key(EmployeeID)
						REFERENCES tblEmployee(EmployeeID)
						On delete no action
						On update no action,
);

create table tblVendor(
VendorID			int				not null identity(1,1),
CompanyName			nvarchar(250)	null,
ContactLastName		nvarchar(250)	null,
ContactFirstName	nvarchar(250)	null,
Address				nvarchar(250)	null,
City				nvarchar(250)	null,
State				nvarchar(250)	null,
ZIP					nvarchar(250)	null,
FAX					nvarchar(250)	null,
Phone				nvarchar(250)	null,
Email				nvarchar(250)	null,
Constraint			VendorPk		primary key(VendorID),
Constraint			VendorAK1		unique(Email)
);


create table tblItem(
ItemID				int				not null identity(1,1),
ItemDescription		nvarchar(250)	null,
PurchaseDate		date			null,
ItemCost			nvarchar(250)	null,
ItemPrice			nvarchar(250)	null,
VendorID			int				null,
Constraint			ItemPk			primary key(ItemID),
Constraint			ItemFK			foreign key(VendorID)
							REFERENCES tblVendor(VendorID)
							On Delete Cascade
							On Update No action

);

create table tblSaleItem(
SaleID			Int				not null,
SaleItemID		INT				not null,
ItemID			INT				null,
ItemPrice		nvarchar(250)	null,
Constraint		SaleItemPK		primary key(SaleID,SaleItemID),
Constraint		SaleItemFK1		Foreign key(SaleID)
						REFERENCES tblSale(SaleID)
						On delete Cascade
						On update no action,
Constraint		SaleItemFK2		Foreign key(ItemID)
						REFERENCES tblItem(ItemID)
						On delete no action
						On update no action,					
);

--Insert DATA
insert into tblCustomerQACS (LastName,FirstName,Address,City,State,ZIP,Phone,Email)
select distinct *
from Customer_original

insert into tblEmployee(LastName,FirstName,Phone,Email)
select distinct *
from Employee_original


insert into tblVendor
(CompanyName,ContactLastName,ContactFirstName,Address,City,State,ZIP,FAX,Phone,Email)
select distinct *
from Vendor_original

insert into tblSale(CustomerID,EmployeeID,SaleDate,Subtotal,Tax,Total)
select distinct *
from Sale_original

insert into tblItem(ItemDescription,PurchaseDate,ItemCost,ItemPrice,VendorID)
select distinct ItemDescription,PurchaseDate,ItemCost,ItemPrice,VendorID
from Item_original

insert into tblSaleItem (SaleID,SaleItemID,ItemID,ItemPrice)
select distinct *
from saleitem_original
