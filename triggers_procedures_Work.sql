Create Trigger utrInsteadOfUpdatePayment on tblExerciseMembership
Instead Of Update
As
Begin

DECLARE @NewPaidDate date; 
DECLARE @OldPaidDate date; 
DECLARE @MembershipNumber int;

SELECT @MembershipNumber= MembershipNumber from inserted

SELECT @OldPaidDate= membershipFeePaidDate from deleted

SELECT @NewPaidDate= membershipFeePaidDate from inserted 


IF @OldPaidDate is null
BEGIN

	UPDATE tblExerciseMembership
	SET MembershipFeePaidDate= @NewPaidDate, IsCurrentMember=1
	PRINT concat(@membershipnumber ,' payment date is ', @newpaiddate,' ; no prior payment date')
	
END

IF @OldpaidDate is not null and @OldPaidDate < @NewPaidDate
BEGIN

	UPDATE tblSCAMembership
	SET MembershipFeePaidDate= @NewPaidDate, isCurrentMember= 1 
	Where MembershipNumber= @MembershipNumber;
	PRINT concat(@membershipnumber ,' payment date is', @newpaiddate,' ;prior payment date is',@OldPaidDate)

	 
END

IF @oldpaiddate is not null and @oldpaidDate > @newpaiddate
Begin

PRINT concat(@membershipnumber ,' new payment date is',@NewPaidDate,' is earlier than prior payment date',@oldpaiddate)
End

End

--Procedure






CREATE PROCEDURE dbo.uspCustomerPurchaseTransaction
(@saleID as INT, @employeeID as INT, @customerID as INT, @itemID as INT, @itemPrice as INT, @resultCode int OUTPUT, @message varchar(250) OUTPUT)

AS 
BEGIN
	PRINT 'INPUT VALUES'
	PRINT '------------------------------------'
	PRINT 'SALE ID: ' + CAST(@saleID as varchar(10));
	PRINT 'Employee ID: ' + CAST(@employeeID as varchar(10));
	PRINT 'Customer ID: ' + CAST(@customerID as varchar(10));
	PRINT 'Item ID: ' + CAST(@itemID as varchar(10));
	PRINT 'Item Price: ' + CAst(@itemPrice as varchar(50));
	PRINT '------------------------------------';

	SELECT * FROM tblItem WHERE ItemID = @itemID and ItemPrice = @itemPrice;


	Declare @count int;
	Set @count = @@ROWCOUNT
	IF @Count = 0
	Begin
		Set @resultCode = -1;
		Set @message = 'The ItemID and ItemPrice do not match';
		Return;
	End

	Begin Transaction

		Select * from tblsale where saleID = @saleID
		

		Set @count = @@ROWCOUNT
		IF @Count = 0
		Begin
			Begin try
				Insert into tblSale (SaleID, CustomerID, EmployeeID)
				VALUES (@saleID, @customerID, @employeeID)
			END TRY

			Begin Catch
				Set @resultCode = -2;
				Set @message = 'Issue in inserting into tblSale table';
				ROLLBACK TRANSACTION;
				RETURN;
			END CATCH
		END

		Declare @saleitemID int;
		Select @saleItemID=max(SaleItemID) from tblSaleItem where SaleID=@saleID
			IF @saleItemID is null
				SET @saleItemID = 1;
			ELSE
				SET @saleItemID = @saleItemID + 1;
		Begin try
		INSERT INTO tblSaleItem (SaleID, SaleItemID, ItemID, ItemPrice)
			VALUES (@saleID, @saleItemID, @itemID, @itemPrice)
		END TRY
		BEGIN CATCH
			SET @resultcode = -3;
			SET @message = 'Issue in inserting into tblSaleItem table';
			ROLLBACK TRANSACTION;
			RETURN;
		END CATCH
	
		PRINT 'Succeeded!';
		SET @resultcode = 1;
		SET @message = 'Succeeded';
		COMMIT TRANSACTION;

END 
			


DECLARE @resultCode int, @message varchar(250)
--Parameters: @saleID, @employeeID, @customerID, @itemID, @itemPrice
EXECUTE dbo.uspCustomerPurchaseTransaction 16, 5, 2, 29, 2000, @resultCode OUTPUT, @message OUTPUT
SELECT @resultCode, @message;

DECLARE @resultCode int, @message varchar(250)
EXECUTE dbo.uspCustomerPurchaseTransaction 15, 5, 2, 23, 800, @resultCode OUTPUT, @message OUTPUT 
SELECT @resultCode, @message;

DECLARE @resultCode int, @message varchar(250)
EXECUTE dbo.uspCustomerPurchaseTransaction 16, 5, 2, 23, 800, @resultCode OUTPUT, @message OUTPUT
SELECT @resultCode, @message;