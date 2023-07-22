set serveroutput on;
set verify off;

create or replace package p_keyboard as
	procedure add_keyboard(kbid_ in int, name_ in varchar2, kid_ in int, sid_ in int, price_ in int);
	procedure remove_keyboard(kbid_ in int);
	procedure view_keyboard(kbid_ in int);
	procedure view_all_keyboards;
end p_keyboard;
/

create or replace package body p_keyboard as
	procedure add_keyboard(kbid_ in int, name_ in varchar2, kid_ in int, sid_ in int, price_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
	BEGIN
		if price_ > 8000 then
			site1 := true;
		else
			site2 := true;
		end if;
	
		if site1 = true then
			insert into Keyboard1@site1 values(kbid_, name_, kid_, sid_, price_);
		end if;
		if site2 = true then
			insert into Keyboard2@site2 values(kbid_, name_, kid_, sid_, price_);
		end if;
	EXCEPTION
		when DUP_VAL_ON_INDEX then
			dbms_output.put_line('[Add] Id=' || kbid_ || ' already exists. Ignored command.');
	END add_keyboard;
	
	procedure remove_keyboard(kbid_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
		price_ int;
	BEGIN
		select price into price_ from (
			(select * from Keyboard1@site1) union (select * from Keyboard2@site2)
		) where (kbid = kbid_);
		
		if price_ > 8000 then
			site1 := true;
		else
			site2 := true;
		end if;
		  
		if site1 = true then
			delete Keyboard1@site1 where (kbid = kbid_);
		end if;
		if site2 = true then
			delete Keyboard2@site2 where (kbid = kbid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || kbid_ || ' does not exist.');
	END remove_keyboard;
	
	procedure view_keyboard(kbid_ in int) IS
		f boolean := false;
	BEGIN
		for i in (
			select * from (
				(select * from Keyboard1@site1) union (select * from Keyboard2@site2)
			) where (kbid = kbid_)
		) loop
			dbms_output.put_line(chr(13));
			dbms_output.put_line('Keyboard id     : ' || i.kbid);
			dbms_output.put_line('Keyboard name   : ' || i.name);
			dbms_output.put_line('Keyboard kit    : ' || i.kid);
			dbms_output.put_line('Keyboard switch : ' || i.sid);
			dbms_output.put_line('Keyboard price  : ' || i.price);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] Id=' || kbid_ || ' does not exist.');
	END view_keyboard;
	
	procedure view_all_keyboards IS
		f boolean := false;
	BEGIN
		for i in (
			select kbid from (
				(select * from Keyboard1@site1) union (select * from Keyboard2@site2)
			)
		) loop
			view_keyboard(i.kbid);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] No keyboard exists.');
	END view_all_keyboards;
end p_keyboard;
/

DECLARE
BEGIN
	dbms_output.put_line('p_keyboard package declaration');
	p_keyboard.add_keyboard(1, 'Some Keyboard', 1, 2, 1000);
	p_keyboard.add_keyboard(2, 'Some Other Keyboard', 3, 2, 1200);
	p_keyboard.add_keyboard(3, 'Dummy Keyboard', 1, 3, 500);
	p_keyboard.add_keyboard(4, 'Another Keyboard', 2, 1, 2000);
	p_keyboard.view_all_keyboards();
END;
/

commit;