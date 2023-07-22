set serveroutput on;
set verify off;

create or replace package p_customer as
	procedure add_customer(cid_ in int, name_ in varchar2, email_ in varchar2, phone_ in varchar2, city_ in varchar2);
	procedure remove_customer(cid_ in int);
	procedure view_customer(cid_ in int);
	procedure view_all_customers;
end p_customer;
/

create or replace package body p_customer as
	procedure add_customer(cid_ in int, name_ in varchar2, email_ in varchar2, phone_ in varchar2, city_ in varchar2) IS
		site1 boolean := false;
		site2 boolean := false;
	BEGIN
		if city_ = 1 then
			site1 := true;
		else
			site2 := true;
		end if;
	
		if site1 = true then
			insert into Customer1@site1 values(cid_, name_, email_, phone_, city_);
		end if;
		if site2 = true then
			insert into Customer2@site2 values(cid_, name_, email_, phone_, city_);
		end if;
	EXCEPTION
		when DUP_VAL_ON_INDEX then
			dbms_output.put_line('[Add] Id=' || cid_ || ' already exists. Ignored command.');
	END add_customer;
	
	procedure remove_customer(cid_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
		city_ int;
	BEGIN
		select city into city_ from (
			(select * from Customer1@site1) union (select * from Customer2@site2)
		) where (cid = cid_);
		
		if city_ = 1 then
			site1 := true;
		else
			site2 := true;
		end if;
		  
		if site1 = true then
			delete Customer1@site1 where (cid = cid_);
		end if;
		if site2 = true then
			delete Customer2@site2 where (cid = cid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || cid_ || ' does not exist.');
	END remove_customer;
	
	procedure view_customer(cid_ in int) IS
		f boolean := false;
	BEGIN
		for i in (
			select * from (
				(select * from Customer1@site1) union (select * from Customer2@site2)
			) where (cid = cid_)
		) loop
			dbms_output.put_line(chr(13));
			dbms_output.put_line('Customer id    : ' || i.cid);
			dbms_output.put_line('Customer name  : ' || i.name);
			dbms_output.put_line('Customer email : ' || i.email);
			dbms_output.put_line('Customer phone : ' || i.phone);
			dbms_output.put_line('Customer city  : ' || i.city);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] Id=' || cid_ || ' does not exist.');
	END view_customer;
	
	procedure view_all_customers IS
		f boolean := false;
	BEGIN
		for i in (
			select cid from (
				(select * from Customer1@site1) union (select * from Customer2@site2)
			)
		) loop
			view_customer(i.cid);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] No customer exists.');
	END view_all_customers;
end p_customer;
/

DECLARE
BEGIN
	dbms_output.put_line('p_customer package declaration');
	p_customer.add_customer(1, 'Alice', 'alice@gmail.com', '01234567891', 1);
	p_customer.add_customer(2, 'Bob', 'bob@gmail.com', '01234567892', 1);
	p_customer.add_customer(3, 'Charles', 'charles@gmail.com', '01234567893', 2);
	p_customer.add_customer(4, 'Doe', 'doe@gmail.com', '01234567894', 2);
	p_customer.add_customer(5, 'Eva', 'eva@gmail.com', '01234567895', 1);
	p_customer.add_customer(6, 'Fred', 'fred@gmail.com', '01234567896', 2);
	p_customer.view_all_customers();
END;
/

commit;