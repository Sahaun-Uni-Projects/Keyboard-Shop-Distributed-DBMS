set serveroutput on;
set verify off;

create or replace package p_kit as
	procedure add_kit(kid_ in int, lid_ in int, name_ in varchar2, colid_ in int, manufacturer_ in varchar2, quantity_ in int);
	procedure remove_kit(kid_ in int);
	procedure decrease_kit(kid_ in int, quantity_ in int);
	procedure view_kit(kid_ in int);
	procedure view_all_kits;
end p_kit;
/

create or replace package body p_kit as
	procedure add_kit(kid_ in int, lid_ in int, name_ in varchar2, colid_ in int, manufacturer_ in varchar2, quantity_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
	BEGIN
		if colid_ = 1 or colid_ = 2 then
			site1 := true;
		else
			site2 := true;
		end if;
	
		if site1 = true then
			insert into Kit1@site1 values(kid_, lid_, name_, colid_, manufacturer_, quantity_);
		end if;
		if site2 = true then
			insert into Kit2@site2 values(kid_, lid_, name_, colid_, manufacturer_, quantity_);
		end if;
	EXCEPTION
		when DUP_VAL_ON_INDEX then
			if site1 = true then
				update Kit1@site1 set quantity=quantity+quantity_ where (kid = kid_);
			end if;
			if site2 = true then
				update Kit2@site2 set quantity=quantity+quantity_ where (kid = kid_);
			end if;
	END add_kit;
	
	procedure remove_kit(kid_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
		colid_ int;
	BEGIN
		select colid into colid_ from (
			(select * from Kit1@site1) union (select * from Kit2@site2)
		) where (kid = kid_);
		
		if colid_ = 1 or colid_ = 2 then
			site1 := true;
		else
			site2 := true;
		end if;
		  
		if site1 = true then
			delete Kit1@site1 where (kid = kid_);
		end if;
		if site2 = true then
			delete Kit2@site2 where (kid = kid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || kid_ || ' does not exist.');
	END remove_kit;
	
	procedure decrease_kit(kid_ in int, quantity_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
		colid_ int;
	BEGIN
		select colid into colid_ from (
			(select * from Kit1@site1) union (select * from Kit2@site2)
		) where (kid = kid_);
		
		if colid_ = 1 or colid_ = 2 then
			site1 := true;
		else
			site2 := true;
		end if;
		
		if site1 = true then
			update Kit1@site1 set quantity=quantity-quantity_ where (kid = kid_);
		end if;
		if site2 = true then
			update Kit2@site2 set quantity=quantity-quantity_ where (kid = kid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || kid_ || ' does not exist.');
	END decrease_kit;
	
	procedure view_kit(kid_ in int) IS
		f boolean := false;
	BEGIN
		for i in (
			select * from (
				(select * from Kit1@site1) union (select * from Kit2@site2)
			) where (kid = kid_)
		) loop
			dbms_output.put_line(chr(13));
			dbms_output.put_line('Kit id           : ' || i.kid);
			dbms_output.put_line('Kit layout       : ' || i.lid);
			dbms_output.put_line('Kit name         : ' || i.name);
			dbms_output.put_line('Kit color        : ' || i.colid);
			dbms_output.put_line('Kit manufacturer : ' || i.manufacturer);
			dbms_output.put_line('Kit quantity     : ' || i.quantity);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] Id=' || kid_ || ' does not exist.');
	END view_kit;
	
	procedure view_all_kits IS
		f boolean := false;
	BEGIN
		for i in (
			select kid from (
				(select * from Kit1@site1) union (select * from Kit2@site2)
			)
		) loop
			view_kit(i.kid);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] No kit exists.');
	END view_all_kits;
end p_kit;
/

DECLARE
BEGIN
	dbms_output.put_line('p_kit package declaration');
	p_kit.add_kit(1, 1, 'ALT', 1, 'DROP', 90);
	p_kit.add_kit(2, 1, 'ALT', 7, 'DROP', 112);
	p_kit.add_kit(3, 2, 'CTRL', 1, 'RK', 133);
	p_kit.add_kit(4, 2, 'CTRL', 7, 'RK', 154);
	p_kit.add_kit(5, 3, 'SHIFT', 1, 'Dragon', 215);
	p_kit.add_kit(6, 3, 'SHIFT', 7, 'Dragon', 416);
	p_kit.add_kit(7, 4, 'FUNC', 1, 'Dragon', 315);
	p_kit.add_kit(8, 4, 'FUNC', 7, 'Dragon', 116);
	p_kit.view_all_kits();
END;
/

commit;