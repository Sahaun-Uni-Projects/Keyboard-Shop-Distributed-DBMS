create or replace trigger t_color_insert
after insert on Color1
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] New color inserted.');
END;
/

create or replace trigger t_layout_insert
after insert on Layout1
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] New layout inserted.');
END;
/

create or replace trigger t_kit_insert
after insert on Kit1
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] New kit inserted.');
END;
/
create or replace trigger t_kit_update
after update on Kit1 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] Kit updated : ' || :old.quantity || ' -> ' || :new.quantity || '.');
END;
/

create or replace trigger t_switch_insert
after insert on Switch1
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] New switch inserted.');
END;
/
create or replace trigger t_switch_update
after update on Switch3 for each row
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] Switch updated : ' || :old.quantity || ' -> ' || :new.quantity || '.');
END;
/

create or replace trigger t_keyboard_insert
after insert on Keyboard1
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] New keyboard inserted.');
END;
/

create or replace trigger t_customer_insert
after insert on Customer1
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] New customer inserted.');
END;
/

create or replace trigger t_order_insert
after insert on Order1
DECLARE
BEGIN
	dbms_output.put_line('[Site 1] New order inserted.');
END;
/

commit;