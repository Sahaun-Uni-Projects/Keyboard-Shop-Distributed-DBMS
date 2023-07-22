set serveroutput on;
set verify off;

create or replace package p_color as
	procedure add_color(colid_ in int, name_ in varchar, val_ in int);
	procedure remove_color(colid_ in int);
	procedure view_color(colid_ in int);
	procedure view_all_colors;
end p_color;
/

create or replace package body p_color as
	procedure add_color(colid_ in int, name_ in varchar, val_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
	BEGIN
		if val_ = 0 or val_ = 16777215 then
			site1 := true;
		else
			site2 := true;
		end if;
	
		if site1 = true then
			insert into Color1@site1 values(colid_, name_, val_);
		end if;
		if site2 = true then
			insert into Color2@site2 values(colid_, name_, val_);
		end if;
	EXCEPTION
		when DUP_VAL_ON_INDEX then
			dbms_output.put_line('[Add] Id=' || colid_ || ' already exists. Ignored command.');
	END add_color;
	
	procedure remove_color(colid_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
		val_ int;
	BEGIN
		select val into val_ from (
			(select * from Color1@site1) union (select * from Color2@site2)
		) where (colid = colid_);
	
		if val_ = 0 or val_ = 16777215 then
			site1 := true;
		else
			site2 := true;
		end if;
		  
		if site1 = true then
			delete Color1@site1 where (colid = colid_);
		end if;
		if site2 = true then
			delete Color2@site2 where (colid = colid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || colid_ || ' does not exist.');
	END remove_color;
	
	procedure view_color(colid_ in int) IS
		f boolean := false;
	BEGIN
		for i in (
			select * from (
				(select * from Color1@site1) union (select * from Color2@site2)
			) where (colid = colid_)
		) loop
			dbms_output.put_line(chr(13));
			dbms_output.put_line('Color id   : ' || i.colid);
			dbms_output.put_line('Color name : ' || i.name);
			dbms_output.put_line('Color val  : ' || i.val);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] Id=' || colid_ || ' does not exist.');
	END view_color;
	
	procedure view_all_colors IS
		f boolean := false;
	BEGIN
		for i in (
			select colid from (
				(select * from Color1@site1) union (select * from Color2@site2)
			)
		) loop
			view_color(i.colid);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] No color exists.');
	END view_all_colors;
end p_color;
/

DECLARE
BEGIN
	dbms_output.put_line('p_color package declaration');
	p_color.add_color(1, 'Black', 0);
	p_color.add_color(2, 'White', 16777215);
	p_color.add_color(3, 'Red', 16711680);
	p_color.add_color(4, 'Green', 65280);
	p_color.add_color(5, 'Blue', 255);
	p_color.add_color(6, 'Brown', 9849600);
	p_color.add_color(7, 'Space Grey', 8421504);
	p_color.view_all_colors();
END;
/

commit;