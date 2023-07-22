set serveroutput on;
set verify off;

create or replace package p_order as
	procedure add_order(oid_ in int, cid_ in int, kbid_ in int, quantity_ in int, price_ in int, date__ in date);
	procedure remove_order(oid_ in int);
	procedure view_order(oid_ in int);
	procedure view_all_orders;
end p_order;
/

create or replace package body p_order as
	procedure add_order(oid_ in int, cid_ in int, kbid_ in int, quantity_ in int, price_ in int, date__ in date) IS
		site1 boolean := true;
		site2 boolean := true;
	BEGIN
		if site1 = true then
			insert into Order1@site1 values(oid_, quantity_, price_);
		end if;
		if site2 = true then
			insert into Order2@site2 values(oid_, cid_, kbid_, date__);
		end if;
	EXCEPTION
		when DUP_VAL_ON_INDEX then
			dbms_output.put_line('[Add] Id=' || oid_ || ' already exists. Ignored command.');
	END add_order;
	
	procedure remove_order(oid_ in int) IS
		site1 boolean := true;
		site2 boolean := true;
	BEGIN
		if site1 = true then
			delete Order1@site1 where (oid = oid_);
		end if;
		if site2 = true then
			delete Order2@site2 where (oid = oid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || oid_ || ' does not exist.');
	END remove_order;
	
	procedure view_order(oid_ in int) IS
		f boolean := false;
	BEGIN
		for i in (
			select * from (
				Order1@site1 join Order2@site2 on Order1.oid@site1 = Order2.oid@site2
			) where (Order1.oid = oid_)
		) loop
			dbms_output.put_line(chr(13));
			dbms_output.put_line('Order id       : ' || oid_);
			dbms_output.put_line('Order customer : ' || i.cid);
			dbms_output.put_line('Order keyboard : ' || i.kbid);
			dbms_output.put_line('Order quantity : ' || i.quantity);
			dbms_output.put_line('Order price    : ' || i.price);
			dbms_output.put_line('Order date     : ' || i.date_);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] Id=' || oid_ || ' does not exist.');
	END view_order;
	
	procedure view_all_orders IS
		f boolean := false;
	BEGIN
		for i in (
			select Order1.oid from (
				Order1@site1 join Order2@site2 on Order1.oid@site1 = Order2.oid@site2
			)
		) loop
			view_order(i.oid);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] No order exists.');
	END view_all_orders;
end p_order;
/

select * from (
	Order1@site1 join Order2@site2 on Order1.oid@site1 = Order2.oid@site2
);
			
DECLARE
BEGIN
	dbms_output.put_line('p_order package declaration');
	p_order.add_order(1, 1, 2, 1, 1000, '13-FEB-2011');
	p_order.add_order(2, 1, 1, 2, 2000, '25-MAY-2000');
	p_order.add_order(3, 2, 2, 3, 3000, '04-JAN-2022');
	p_order.add_order(4, 3, 4, 4, 4000, '23-MAY-2022');
	p_order.add_order(5, 2, 4, 5, 5000, '15-NOV-2023');
	p_order.add_order(6, 1, 2, 6, 6000, '16-JUN-2007');
	p_order.view_all_orders();
END;
/

commit;