set serveroutput on;
set verify off;

create or replace package p_layout as
	procedure add_layout(lid_ int, name_ varchar2, percent__ int, keys_ int);
	procedure remove_layout(lid_ in int);
	procedure view_layout(lid_ in int);
	procedure view_all_layouts;
end p_layout;
/

create or replace package body p_layout as
	procedure add_layout(lid_ int, name_ varchar2, percent__ int, keys_ int) IS
		site1 boolean := false;
		site2 boolean := false;
	BEGIN
		if percent__ < 80 then
			site1 := true;
		else
			site2 := true;
		end if;
	
		if site1 = true then
			insert into Layout1@site1 values(lid_, name_, percent__, keys_);
		end if;
		if site2 = true then
			insert into Layout2@site2 values(lid_, name_, percent__, keys_);
		end if;
	EXCEPTION
		when DUP_VAL_ON_INDEX then
			dbms_output.put_line('[Add] Id=' || lid_ || ' already exists. Ignored command.');
	END add_layout;
	
	procedure remove_layout(lid_ in int) IS
		site1 boolean := false;
		site2 boolean := false;
		percent__ int;
	BEGIN
		select percent_ into percent__ from (
			(select * from Layout1@site1) union (select * from Layout2@site2)
		) where (lid = lid_);
		
		if percent__ < 80 then
			site1 := true;
		else
			site2 := true;
		end if;
		
		if site1 = true then
			delete Layout1@site1 where (lid = lid_);
		end if;
		if site2 = true then
			delete Layout2@site2 where (lid = lid_);
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('Id=' || lid_ || ' does not exist.');
	END remove_layout;
	
	procedure view_layout(lid_ in int) IS
		f boolean := false;
	BEGIN
		for i in (
			select * from (
				(select * from Layout1@site1) union (select * from Layout2@site2)
			) where (lid = lid_)
		) loop
			dbms_output.put_line(chr(13));
			dbms_output.put_line('Layout id      : ' || i.lid);
			dbms_output.put_line('Layout name    : ' || i.name);
			dbms_output.put_line('Layout percent : ' || i.percent_);
			dbms_output.put_line('Layout keys    : ' || i.keys);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] Id=' || lid_ || ' does not exist.');
	END view_layout;
	
	procedure view_all_layouts IS
		f boolean := false;
	BEGIN
		for i in (
			select lid from (
				(select * from Layout1@site1) union (select * from Layout2@site2)
			)
		) loop
			view_layout(i.lid);
			f := true;
		end loop;
		if f = false then
			raise NO_DATA_FOUND;
		end if;
	EXCEPTION
		when NO_DATA_FOUND then
			dbms_output.put_line('[View] No layout exists.');
	END view_all_layouts;
end p_layout;
/

DECLARE
BEGIN
	dbms_output.put_line('p_layout package declaration');
	p_layout.add_layout(1, 'Full Size', 					100, 104);
	p_layout.add_layout(2, 'Compact Full Size', 	90,  99);
	p_layout.add_layout(3, 'Tenkeyless', 		 			80,  88);
	p_layout.add_layout(4, 'Compact Tenkeyless', 	75,  84);
	p_layout.add_layout(5, 'Sixty',  			 				60,  60);
	p_layout.add_layout(6, 'Half',  			 	 			50,  50);
	p_layout.view_all_layouts();
END;
/

commit;