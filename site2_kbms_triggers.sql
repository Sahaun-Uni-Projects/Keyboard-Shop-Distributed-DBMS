set serveroutput on;
set verify off;

create or replace trigger t_color_insert
after insert on Color2 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 2] New color inserted.');
END t_color_insert;
/

create or replace trigger t_layout_insert
after insert on Layout2 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 2] New layout inserted.');
END;
/

create or replace trigger t_kit_insert
after insert on Kit2 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 2] New kit inserted.');
END;
/
create or replace trigger t_kit_update
after update on Kit2 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 2] Kit updated : ' || :old.quantity || ' -> ' || :new.quantity || '.');
END;
/

create or replace trigger t_switch_insert
after insert on Switch2 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 2] New switch inserted.');
END;
/

create or replace trigger t_keyboard_insert
after insert on Keyboard2 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 2] New keyboard inserted.');
END;
/

create or replace trigger t_customer_insert
after insert on Customer2 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 2] New customer inserted.');
END;
/

create or replace trigger t_order_insert
after insert on Order2 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 2] New order inserted.');
END;
/

commit;