set serveroutput on;
set verify off;

create or replace procedure sell_keyboard(kb in int, od in int, cs in int)
IS 
	id_kit int;
	id_switch int;
	cnt_kit int;
	cnt_switch int;
	req_switch int;
	kb_price int;
BEGIN
	select price into kb_price from Keyboard where (kbid = kb);

	select kid, quantity into id_kit, cnt_kit from (
		select Kit.* from (
			Keyboard@site2 join Kit on (Keyboard.kid@site2 = Kit.kid)
		) where (Keyboard.kbid = kb)
	);
	
	select Switch2.sid, Switch3.quantity into id_switch, cnt_switch from (
		Keyboard@site2 join
			(Switch2@site2 join Switch3@site1 on Switch2.sid@site2 = Switch3.sid@site1)
			on Keyboard.sid@site2 = Switch2.sid
	) where (Keyboard.kbid = kb);
	
	select Layout.keys into req_switch from (
		Keyboard
			join Kit on (Keyboard.kid = Kit.kid)
			join Layout on (Kit.lid = Layout.lid)
	) where (Keyboard.kbid = kb);
	
	if (cnt_kit > 0) and (cnt_switch >= req_switch) then 
		p_kit.decrease_kit(id_kit, 1);
		p_switch.decrease_switch(id_switch, req_switch);
		dbms_output.put_line('Order ' || od || ' : sold keyboard ' || kb || ' to customer ' || cs || '.');
		p_order.add_order(od, cs, kb, 1, kb_price, sysdate);
	else
		raise NO_DATA_FOUND;
	end if;
EXCEPTION
	when NO_DATA_FOUND then
		dbms_output.put_line('Kits for keyboard ' || kb || ' unavaiable.');
END;
/

accept x prompt "Enter keyboard id: ";
accept y prompt "Enter order id: ";
accept z prompt "Enter customer id: ";

declare
begin 
	sell_keyboard(&x, &y, &z);
end;
/

commit;