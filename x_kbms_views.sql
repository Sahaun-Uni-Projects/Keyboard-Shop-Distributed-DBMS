create or replace view Kit as (
	(select * from Kit1@site1) union (select * from Kit2@site2)
);

create or replace view Layout as (
	(select * from Layout1@site1) union (select * from Layout2@site2)
);

create or replace view Keyboard as (
	(select * from Keyboard1@site1) union (select * from Keyboard2@site2)
);

create or replace view Switch as (
	select * from (
		(select Switch3.sid, colid, name, manufacturer, quantity from Switch1@site1 join Switch3@site1 on (Switch1.sid@site1 = Switch3.sid@site1))
		union
		(select Switch3.sid, colid, name, manufacturer, quantity from Switch2@site2 join Switch3@site1 on (Switch2.sid@site2 = Switch3.sid@site1))
	)
);

DECLARE
BEGIN
	dbms_output.put_line('Views created.');
END;
/

commit;