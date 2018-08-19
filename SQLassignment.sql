-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.

-- 2.1 SELECT
-- Task – Select all records from the Employee table.
	SELECT * FROM employee;

-- Task – Select all records from the Employee table where last name is King.
	SELECT * FROM employee
	WHERE lastname = 'King';

-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
	SELECT * FROM employee
	WHERE firstname = 'Andrew' AND reportsto is null;

-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
	SELECT * FROM album
	ORDER BY title DESC;

-- Task – Select first name from Customer and sort result set in ascending order by city
	SELECT firstname FROM customer
	ORDER BY city ASC;

-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
	INSERT INTO genre (genreid, name )
	VALUES( '26', 'Instrumental');

	INSERT INTO genre (genreid, name)
	VALUES('27','Metalcore');
-- Task – Insert two new records into Employee table
	INSERT INTO employee(employeeid,lastname,firstname,title,birthdate,hiredate,address,city,state,country,postalcode,phone,fax,email)
	VALUES('9', 'Bob','Billy', 'Sales Manager', '1990-01-01','2018-01-01', '145 Street Road', 'Chicago', 'Illinois','United States', '99999','999-999-9999','999-999-9999','email@email.com');

	INSERT INTO employee(employeeid,lastname,firstname,title,birthdate,hiredate,address,city,state,country,postalcode,phone,fax,email)
	VALUES('10', 'James','James', 'Sales Manager', '1991-01-01','2018-01-01', '142 Street Road', 'Chicago', 'Illinois','United States', '99999','111-999-9999','999-111-9999','email2@email.com');

-- Task – Insert two new records into Customer table
	INSERT INTO customer(customerid,firstname,lastname,company,address,city,state,country,postalcode,phone,fax,email,supportrepid)
	VALUES('60','Soul','Evans','Shibusen','111 Road Street','San Fransico', 'California', 'United States','99999','999-999-9999','999-999-9999','SoulEvans@email.com','3');

	INSERT INTO customer(customerid,firstname,lastname,company,address,city,state,country,postalcode,phone,fax,email,supportrepid)
	VALUES('61','Maka','Albern','Shibusen','112 Road Street','San Fransico', 'California', 'United States','99999','999-999-9990','999-999-9990','MakaAlbern@email.com','3');

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
	UPDATE customer
	SET firstname = 'Robert' , lastname = 'Walter'
	WHERE firstname = 'Aaron' AND lastname = 'Mitchell';

-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
	UPDATE artist
	SET name = 'CCR'
	WHERE name = 'Creedence Clearwater Revival';

-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
	SELECT * FROM invoice
	WHERE billingaddress LIKE 'T%';

-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
	SELECT *
	FROM invoice
	WHERE total BETWEEN 15 AND 50;

-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
	SELECT *
	FROM employee
	WHERE hiredate BETWEEN '2003-06-01' AND '2004-03-01';
	
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).

-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
	CREATE OR REPLACE FUNCTION mytime()
	RETURNS time as $$
	BEGIN
	RETURN current_time;
	END;
	$$ LANGUAGE plpgsql;

-- Task – create a function that returns the length of a mediatype from the mediatype table
	CREATE OR REPLACE FUNCTION FINDLENGTH()
	RETURNS INTEGER AS $$
	BEGIN
	RETURN length(name) FROM mediatype WHERE mediatype.mediatypeid = 1;
	END;
	$$ LANGUAGE plpgsql;

-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
	CREATE OR REPLACE FUNCTION AVGINVOICE()
	RETURNS INTEGER AS $$
	BEGIN
	RETURN AVG(invoice.total) FROM invoice;
	END;
	$$ LANGUAGE plpgsql;

-- Task – Create a function that returns the most expensive track
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
	CREATE OR REPLACE FUNCTION AVGPRICE()
	RETURNS INTEGER AS $$
	BEGIN
	RETURN AVG(invoiceline.unitprice) FROM invoiceline;
	END;
	$$ LANGUAGE plpgsql;

-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
	CREATE OR REPLACE FUNCTION BIRTHDAY2()
	RETURNS TABLE(
		
	first_name VARCHAR,
	last_name VARCHAR
		
	) AS $$
	BEGIN
	
	RETURN QUERY SELECT firstname,lastname FROM employee WHERE birthdate >= '1968-01-01 00:00:00';
	
	END;
	$$ LANGUAGE plpgsql;

-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
	CREATE OR REPLACE FUNCTION EMPLOYEENMMES()
	RETURNS TABLE(
		
	first_name VARCHAR,
	last_name VARCHAR
		
	) AS $$
	BEGIN
	
	RETURN QUERY SELECT firstname,lastname FROM employee;
	
	END;
	$$ LANGUAGE plpgsql;

-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
	CREATE OR REPLACE FUNCTION NEWINFO(empid integer, newfirstname VARCHAR , newlastname VARCHAR, newaddress VARCHAR,
										  newcity VARCHAR, newstate VARCHAR, newcountry VARCHAR, newpostalcode VARCHAR, 
										  newphone VARCHAR, newfax VARCHAR)
										
	RETURNS VOID AS $$

	BEGIN
	
	UPDATE employee
	SET firstname = newfirstname, lastname = newlastname, 
	address = newaddress, city = newcity, state = newstate, country = newcountry,
	postalcode = newpostalcode, phone = newphone, fax = newfax
	
	WHERE
	employee.employeeid = empid;
	
	
	END;
	$$ LANGUAGE plpgsql;

-- Task – Create a stored procedure that returns the managers of an employee.
	CREATE OR REPLACE FUNCTION FINDMANAGER(eid integer)
	
										
	RETURNS integer AS $$
	BEGIN
	
	
	RETURN employee.reportsto FROM employee
	
	WHERE employee.employeeid = eid;
	
	
	END;
	$$ LANGUAGE plpgsql;

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
	CREATE OR REPLACE FUNCTION CUSTOMERINFO2(custid integer)
										
	RETURNS TABLE(
	
		first_name VARCHAR,
		last_name VARCHAR,
		company_name VARCHAR
	
	)AS $$
	
	BEGIN
	
	
	RETURN QUERY SELECT firstname, lastname, company FROM customer
	
	WHERE customer.customerid = custid;
	
	
	END;
	$$ LANGUAGE plpgsql;

-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).


-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
	CREATE OR REPLACE FUNCTION INSERTCUSTOMER(custid integer, newlastname VARCHAR, newfirstname VARCHAR, 
    											newcompany VARCHAR, newaddress VARCHAR, newcity VARCHAR, newstate VARCHAR, 
      											newcountry VARCHAR, newpostalcode VARCHAR, newphone VARCHAR, 
												newfax VARCHAR,newemail VARCHAR)
										
	RETURNS VOID AS $$
	
	BEGIN	
		INSERT INTO customer(customerid,lastname,firstname,company,address,city,state,country,postalcode,phone,fax,email)
  		VALUES(custid,newlastname,newfirstname,newcompany,newaddress,newcity,newstate,newcountry,
   		newpostalcode,newphone,newfax,newemail);
	END;
  	$$ LANGUAGE plpgsql;

-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
	CREATE OR REPLACE INSERTemployee()
	RETURNS TRIGGER AS $$
	RAISE NOTICE 'A New Employee Has Been Inserted!';
	END;
  	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER insert_employee
	AFTER INSERT 
	ON employee
	FOR EACH ROW
	EXECUTE PROCEDURE INSERTemployee;

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
 	CREATE OR REPLACE albumupdate()
	RETURNS TRIGGER AS $$
	RAISE NOTICE 'ALBUMs Have Been Updated!';
	END;
  	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER update_album
	AFTER UPDATE
	ON album
	FOR EACH ROW
	EXECUTE PROCEDURE albumupdate;

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
	CREATE OR REPLACE deleteCustomer()
	RETURNS TRIGGER AS $$
	RAISE NOTICE 'Customer has Been Deleted!';
	END;
  	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER delete_customer
	AFTER DELETE
	ON customer
	FOR EACH ROW
	EXECUTE PROCEDURE albumupdate;
-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.
   	CREATE OR REPLACE deleteInvoice()
	RETURNS TRIGGER AS $$
	RAISE NOTICE 'Invoice to be Deleted!';
	END;
  	$$ LANGUAGE plpgsql;
	
	CREATE TRIGGER delete_Invoice
	BEFORE DELETE
	ON invoice
	FOR EACH ROW
	WHERE invoice.total > 50;
	EXECUTE PROCEDURE deleteInvoice();

-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
	SELECT customer.firstname, customer.lastname, invoice.invoiceid
	FROM customer
	INNER JOIN invoice ON customer.customerid =  invoice.customerid ;

-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
	SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total
	FROM customer
	FULL OUTER JOIN invoice ON customer.customerid =  invoice.customerid ;

-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
	SELECT album.title, artist.name
	FROM album
	RIGHT JOIN artist ON album.artistid = artist.artistid;

-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
	SELECT * 
	FROM album
	CROSS JOIN artist
	ORDER BY artist.name ASC;

-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
	SELECT * 
	FROM employee a , employee b
	WHERE a.reportsto = b.reportsto;
	






