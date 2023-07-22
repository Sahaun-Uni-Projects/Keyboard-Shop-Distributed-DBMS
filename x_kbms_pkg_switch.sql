set serveroutput on;
set verify off;

create or replace package p_switch as
	procedure add_switch(sid_ in int, name_ in varchar2, colid_ in int, manufacturer_ in varchar2, quantity_ in int);
	procedure remove_switch(sid_ in int);
	procedure decrease_switch(sid_ in int, quantity_ in int);
	procedure view_switch(sid_ in int);
	procedure view_all_switches;
end p_switch;
/

create or replace package body p_switch as
	procedure add_switch(sid_ in int, name_ in varchar2, colid_ in int, manufacturer_ in varchar2, quantity_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
		site3 boolean := false;
	BEGIN
		if colid_ = 3 or colid_ = 6 then
			site1 := true;
		else
			site2 := true;
		end if;
		site3 := true;
	
		if site1 = true then
			insert into Switch1@site1 values(sid_, colid_);
		end if;
		if site2 = true then
			insert into Switch2@site2 values(sid_, colid_);
		end if;
		if site3 = true then
			insert into Switch3@site1 values(sid_, name_, manufacturer_, quantity_);
		end if;
	EXCEPTION
		when DUP_VAL_ON_INDEX then
			if site3 = true then
				update Switch3@site1 set quantity=quantity+quantity_ where (sid = sid_);
			end if;
	END add_switch;
	
	procedure remove_switch(sid_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
		site3 boolean := false;
		colid_ int;
	BEGIN
		select colid into colid_ from (
			(select * from Switch1@site1) union (select * from Switch2@site2)
		) where (sid = sid_);
	
		if colid_ = 3 or colid_ = 6 then
			site1 := true;
		else
			site2 := true;
		end if;
		site3 := true;
		
		if site1 = true then
			delete Switch1@site1 where (sid = sid_);
		end if;
		if site2 = true then
			delete Switch2@site2 where (sid = sid_);
		end if;
		if site3 = true then
			delete Switch3@site1 where (sid = sid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || sid_ || ' does not exist.');
	END remove_switch;
	
	procedure decrease_switch(sid_ in int, quantity_ in int) IS
		site3 boolean := false;
	BEGIN
		site3 := true;
		
		if site3 = true then
			update Switch3@site1 set quantity=quantity-quantity_ where (sid = sid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || sid_ || ' does not exist.');
	END decrease_switch;
	
	procedure view_switch(sid_ in int) IS
		f boolean := false;
	BEGIN
		for i in (
			select * from (
				(select Switch3.sid, colid, name, manufacturer, quantity from Switch1@site1 join Switch3@site1 on (Switch1.sid@site1 = Switch3.sid@site1))
				union
				(select Switch3.sid, colid, name, manufacturer, quantity from Switch2@site2 join Switch3@site1 on (Switch2.sid@site2 = Switch3.sid@site1))
			) where (sid = sid_)
		) loop
			dbms_output.put_line(chr(13));
			dbms_output.put_line('Switch id           : ' || sid_);
			dbms_output.put_line('Switch name         : ' || i.name);
			dbms_output.put_line('Switch color        : ' || i.colid);
			dbms_output.put_line('Switch manufacturer : ' || i.manufacturer);
			dbms_output.put_line('Switch quantity     : ' || i.quantity);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] Id=' || sid_ || ' does not exist.');
	END view_switch;
	
	procedure view_all_switches IS
		f boolean := false;
	BEGIN
		for i in (
			select sid from (
				(select * from Switch1@site1) union (select * from Switch2@site2)
			)
		) loop
			view_switch(i.sid);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] No switch exists.');
	END view_all_switches;
end p_switch;
/

DECLARE
BEGIN
	dbms_output.put_line('p_switch package declaration');
	p_switch.add_switch(1, 'CAPS', 1, 'DROP', 1024);
	p_switch.add_switch(2, 'NUM',  2, 'DROP', 2048);
	p_switch.add_switch(3, 'LOCK', 2, 'DROP', 3072);
	p_switch.add_switch(4, 'CERRY', 4, 'FRUIT', 1024);
	p_switch.add_switch(5, 'MANGO',  6, 'FRUIT', 2048);
	p_switch.add_switch(6, 'APPLE', 5, 'FRUIT', 3072);
	p_switch.add_switch(7, 'BLACK', 3, 'COLOR', 1024);
	p_switch.add_switch(8, 'WHITE',  6, 'COLOR', 2048);
	p_switch.add_switch(9, 'RED', 7, 'COLOR', 3072);
	p_switch.view_all_switches();
END;
/

commit;