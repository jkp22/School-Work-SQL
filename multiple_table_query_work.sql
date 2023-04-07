--Question 1
select productID, Productname, Warehouse.WarehouseID, WarehouseCity, WarehouseState
from Products inner join Warehouse
on products.WarehouseID = Warehouse.WarehouseID
where Warehouse.WarehouseCity = 'Boston' or Warehouse.WarehouseCity='Westboro'

--Question 2
select  productID, ProductName, warehouse.WarehouseID, warehouseCity, warehousestate
from products inner join Warehouse
on Products.WarehouseID = warehouse.WarehouseID
where WarehouseCity not in ('Boston', 'Westboro')

--Question 3
select productName + 'is in a warehouse in ' + WarehouseCity as ProductLoacation
from Products inner join Warehouse
on products.WarehouseID = Warehouse.WarehouseID

--Question 4

select productID, ProductName, WarehouseID
from Products
where WarehouseID in
(select WarehouseID
from Warehouse
where ManagerName='Margaret Peacock')

--Question 5
select productID, productName, warehouseCity
from products join Warehouse
on products.WarehouseID = Warehouse.WarehouseID
where ManagerName = 'Anne Dodsworth'

--Question 6
select productID, productName, warehouseCity
from products, Warehouse
where products.WarehouseID = Warehouse.WarehouseID and
ManagerName = 'Anne Dodsworth'

--Question 7
--Because the coloum that connects the two is warehouseID. So if you were to sub qurey you would not be able
-- to show warehouseCity when you execute.

--Question 8
select WarehouseID, sum(UnitsInStock) as TotalUnitsInStock, AVG(UnitsOnOrder) as AverageUnitsOnOrder
from Products
where WarehouseID in
(select WarehouseID
from Warehouse
where ManagerName = 'Robert King')
group by WarehouseID

--Question 9
select products.WarehouseID, sum(UnitsInStock) as TotalUnitsInStock, AVG(UnitsOnOrder) as AverageUnitsOnOrder
from products join Warehouse
on products.WarehouseID = Warehouse.WarehouseID
where ManagerName = 'Robert King'
group by products.WarehouseID

--Question 10
select Warehouse.WarehouseID, WarehouseCity, SUM(UnitsInStock) as TotalProductsInStock, SUM(UnitsOnOrder) as TotalProductsOnOrder
from products join Warehouse
on products.WarehouseID = Warehouse.WarehouseID
group by warehouse.WarehouseID, WarehouseCity
order by WarehouseID ASC

--Question 11
select *
from Warehouse
left outer join Products on Warehouse.WarehouseID = products.WarehouseID

--Question 12
select *
from Warehouse
left outer join Products on Warehouse.WarehouseID = products.WarehouseID
where ProductID is null


-- Question 13
select distinct products.ProductID, ProductName
from products, OrderDetails
where products.ProductID not in
(select OrderDetails.ProductID
from OrderDetails)

--Question 14
Select Orders.OrderID, OrderDate, Count(*) As NumberOfProducts From Orders
inner Join OrderDetails ON OrderDetails.OrderID = Orders.OrderID
Group By Orders.OrderID, OrderDate
Having Count(*) > 3
Order By Count(*) Desc

--Question 15
select distinct IndividualCustomers.lastname, 
IndividualCustomers.firstname,
IndividualCustomers.address,
IndividualCustomers.city,
IndividualCustomers.Postalcode,
IndividualCustomers.country,
IndividualCustomers.phone
from IndividualCustomers, Employees

--Question 16
select distinct IndividualCustomers.lastname, 
IndividualCustomers.firstname,
IndividualCustomers.address,
IndividualCustomers.city,
IndividualCustomers.Postalcode,
IndividualCustomers.country,
IndividualCustomers.phone
from IndividualCustomers inner join employees
 on individualCustomers.customerID = employees.employeeID
 
 --Question 17
 select lastname, firstname, address, city, postalcode, country, phone
 from IndividualCustomers
 where CustomerID not in
 (select employeeID
 from Employees)







